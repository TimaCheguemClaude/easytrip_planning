import 'dart:io';
import 'dart:developer';
import 'dart:convert';
import 'package:easytrip/data/provider/server/gemini_service.dart';
import 'package:easytrip/presentation/widgets/chat_message.dart';
import 'package:easytrip/presentation/widgets/sliding_menu.dart';
import 'package:flutter/material.dart';
import 'package:easytrip/utils/theme.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

// Trip Planning Assessment Data Model
class TripAssessment {
  final String id;
  final DateTime startDate;
  DateTime? endDate;
  bool isCompleted;
  int currentStep;
  String? finalItinerary;

  Map<String, dynamic> tripData;
  Map<String, String> responses;
  List<String> recommendations;

  TripAssessment({
    required this.id,
    required this.startDate,
    this.endDate,
    this.isCompleted = false,
    this.currentStep = 0,
    this.finalItinerary,
    Map<String, dynamic>? tripData,
    Map<String, String>? responses,
    List<String>? recommendations,
  }) : 
    tripData = tripData ?? {},
    responses = responses ?? {},
    recommendations = recommendations ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'currentStep': currentStep,
      'finalItinerary': finalItinerary,
      'tripData': tripData,
      'responses': responses,
      'recommendations': recommendations,
    };
  }

  factory TripAssessment.fromJson(Map<String, dynamic> json) {
    return TripAssessment(
      id: json['id'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCompleted: json['isCompleted'] ?? false,
      currentStep: json['currentStep'] ?? 0,
      finalItinerary: json['finalItinerary'],
      tripData: Map<String, dynamic>.from(json['tripData'] ?? {}),
      responses: Map<String, String>.from(json['responses'] ?? {}),
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }

  void updateData(String key, dynamic value) {
    tripData[key] = value;
  }

  void addResponse(String stepId, String response) {
    responses[stepId] = response;
  }

  double get completionPercentage {
    const totalSteps = 5;
    return (currentStep / totalSteps).clamp(0.0, 1.0);
  }
}

class ChatBotScreen extends StatefulWidget {
  final String initialMessage;

  const ChatBotScreen({
    super.key,
    this.initialMessage = '',
  });

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GeminiService _geminiService = GeminiService();
  final ImagePicker _imagePicker = ImagePicker();

  List<ChatMessageModel> _messages = [];
  bool _isAiSpeaking = false;
  bool _hasText = false;
  String _currentStreamingMessage = '';
  String? _userProfileImage;

  TripAssessment? _currentAssessment;
  bool _isAssessmentMode = true;

  // Trip planning steps
  final List<String> _tripSteps = [
    'destinations',
    'travel_details',
    'budget_preferences',
    'interests_activities',
    'summary'
  ];

  // Animation controllers
  late AnimationController _typingAnimationController;
  late List<AnimationController> _typingDotsControllers;
  late List<Animation<double>> _typingDotsAnimations;

  late String _conversationId;

  @override
  void initState() {
    super.initState();
    log('Initializing Smart Trip Planner ChatBot', name: 'tripPlannerBot');

    _conversationId = DateTime.now().millisecondsSinceEpoch.toString();
    _controller.addListener(_updateTextState);
    _setupAnimations();
    _initializeChat();
  }

  void _setupAnimations() {
    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();

    _typingDotsControllers = List.generate(
      3,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300 + (index * 100)),
      )..repeat(reverse: true),
    );

    _typingDotsAnimations = _typingDotsControllers.map((controller) {
      return Tween<double>(begin: 0, end: 6).animate(controller);
    }).toList();
  }

  Future<void> _initializeChat() async {
    try {
      await _loadUserProfileImage();
      await _loadAssessmentData();
      await _loadChatHistory();

      if (_currentAssessment == null && _messages.isEmpty) {
        await _startNewAssessment();
      } else if (_currentAssessment != null && !_currentAssessment!.isCompleted) {
        await _continueAssessment();
      }

      if (widget.initialMessage.isNotEmpty && _messages.isEmpty) {
        _addUserMessage(widget.initialMessage);
        await _processUserResponse(widget.initialMessage);
      }
    } catch (e) {
      log('Error initializing trip planner chat: $e', name: 'tripPlannerBot');
    }
  }

  Future<void> _startNewAssessment() async {
    _currentAssessment = TripAssessment(
      id: _conversationId,
      startDate: DateTime.now(),
    );

    await _saveAssessmentData();
    await Future.delayed(const Duration(milliseconds: 500));
    _addAiMessage(_getWelcomeMessage());
    await Future.delayed(const Duration(milliseconds: 1000));
    await _askNextQuestion();
  }

  Future<void> _continueAssessment() async {
    if (_currentAssessment != null && !_currentAssessment!.isCompleted) {
      await _askNextQuestion();
    }
  }

  String _getWelcomeMessage() {
    return """Hello! I'm TripBot, your AI Smart Trip Planner! ✈️

I'm here to help you plan the perfect trip tailored to your preferences, budget, and interests.

I'll help you with:
• Destination recommendations based on your interests
• Budget planning and optimization
• Activity and attraction suggestions
• Accommodation recommendations
• Creating a personalized itinerary

Let's start planning your amazing adventure!""";
  }

  Future<void> _askNextQuestion() async {
    if (_currentAssessment == null || _currentAssessment!.currentStep >= _tripSteps.length) {
      return;
    }

    final currentStep = _tripSteps[_currentAssessment!.currentStep];
    String question = _getQuestionForStep(currentStep);

    setState(() {
      _isAiSpeaking = true;
      _currentStreamingMessage = '';
    });

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isAiSpeaking = false;
    });

    _addAiMessage(question);
  }

  String _getQuestionForStep(String step) {
    switch (step) {
      case 'destinations':
        return """**Step 1: Travel Destinations**

Let's plan your perfect trip! First, tell me about your destinations:

Please provide:
• Starting location (where you'll depart from)
• Destination(s) you want to visit
• Any specific cities or regions you're interested in
• Are you open to suggestions for nearby attractions?

Example: "Starting from Paris, want to visit Rome and Barcelona, interested in historical sites"

This helps me understand your travel scope and preferences.""";

      case 'travel_details':
        return """**Step 2: Travel Details**

Now let's get the specifics of your trip:

Please tell me:
• How many people are traveling? (solo, couple, family, group)
• Preferred travel dates or duration
• Type of trip (leisure, business, adventure, cultural, etc.)
• Any special occasions or events?

Example: "Couple traveling for 10 days in June, romantic getaway for anniversary"

This information helps me tailor the experience to your group.""";

      case 'budget_preferences':
        return """**Step 3: Budget & Preferences**

Help me understand your budget and preferences:

Budget information:
• What's your approximate total budget?
• Budget breakdown priorities (accommodation, food, activities, transport)
• Preferred accommodation type (hotel, Airbnb, hostel, luxury resort)

Example: "Budget around €3000 total, prefer mid-range hotels, willing to spend more on unique experiences"

This ensures recommendations fit your financial comfort zone.""";

      case 'interests_activities':
        return """**Step 4: Interests & Activities**

What are you most interested in during your trip?

Please share your interests:
• Types of activities (museums, outdoor adventures, nightlife, shopping, food tours)
• Cultural preferences (historical sites, local experiences, art galleries)
• Activity level (relaxed, moderate, very active)
• Any must-see attractions or experiences?

Example: "Love food tours and cooking classes, interested in history, moderate activity level, want to see famous landmarks"

This helps me suggest the perfect activities for you.""";

      case 'summary':
        return """**Trip Planning Complete! 🎉**

Thank you for providing all the details! I'm now analyzing your preferences to create your personalized trip plan.

I'll process this information and provide you with:
• Customized itinerary suggestions
• Activity recommendations based on your interests
• Accommodation options within your budget
• Transportation and logistics planning
• Local tips and hidden gems

Please wait while I create your perfect trip plan...""";

      default:
        return "Let's continue with your trip planning. Please provide any additional information you think is relevant.";
    }
  }

  Future<void> _processUserResponse(String response) async {
    if (_currentAssessment == null) return;

    final currentStep = _tripSteps[_currentAssessment!.currentStep];
    _currentAssessment!.addResponse(currentStep, response);

    await _analyzeResponse(currentStep, response);
    _currentAssessment!.currentStep++;

    if (_currentAssessment!.currentStep >= _tripSteps.length) {
      await _completeAssessment();
    } else {
      await Future.delayed(const Duration(milliseconds: 1500));
      await _askNextQuestion();
    }

    await _saveAssessmentData();
  }

  Future<void> _analyzeResponse(String step, String response) async {
    setState(() {
      _isAiSpeaking = true;
      _currentStreamingMessage = '';
    });

    try {
      String analysisPrompt = _getAnalysisPrompt(step, response);

      String accumulatedResponse = '';
      await for (final chunk in _geminiService.sendMessageStream(analysisPrompt, _messages)) {
        accumulatedResponse += chunk;

        if (mounted) {
          setState(() {
            _currentStreamingMessage = accumulatedResponse;
          });
        }

        await Future.delayed(const Duration(milliseconds: 30));
      }

      if (accumulatedResponse.isNotEmpty) {
        _addAiMessage(accumulatedResponse);
        _extractKeyInformation(step, response, accumulatedResponse);
      }
    } catch (e) {
      log('Error analyzing response: $e', name: 'tripPlannerBot');
      _addAiMessage("Thank you for that information. Let me process this and continue with the next question.");
    } finally {
      setState(() {
        _isAiSpeaking = false;
        _currentStreamingMessage = '';
      });
    }
  }

  String _getAnalysisPrompt(String step, String response) {
    return """As TripBot, analyze this user response for the $step phase:

User Response: "$response"

Provide a brief, empathetic acknowledgment (2-3 sentences) that:
1. Shows you understood their response
2. Highlights any interesting or exciting points
3. Reassures them about the planning process

Keep it conversational and enthusiastic. Don't ask new questions - just acknowledge and transition.

Your response:""";
  }

  void _extractKeyInformation(String step, String userResponse, String aiAnalysis) {
    if (_currentAssessment == null) return;

    _currentAssessment!.updateData('${step}_processed', {
      'userResponse': userResponse,
      'aiAnalysis': aiAnalysis,
      'timestamp': DateTime.now().toIso8601String(),
    });

    switch (step) {
      case 'destinations':
        _extractDestinationInfo(userResponse);
        break;
      case 'travel_details':
        _extractTravelDetails(userResponse);
        break;
      case 'budget_preferences':
        _extractBudgetInfo(userResponse);
        break;
      case 'interests_activities':
        _extractInterests(userResponse);
        break;
    }
  }

  void _extractDestinationInfo(String response) {
    _currentAssessment!.updateData('destinations', {
      'raw_response': response,
      'extracted_at': DateTime.now().toIso8601String(),
    });
  }

  void _extractTravelDetails(String response) {
    _currentAssessment!.updateData('travelDetails', {
      'details': response,
      'processed_at': DateTime.now().toIso8601String(),
    });
  }

  void _extractBudgetInfo(String response) {
    _currentAssessment!.updateData('budget', {
      'details': response,
      'processed_at': DateTime.now().toIso8601String(),
    });
  }

  void _extractInterests(String response) {
    final interests = <String>[];
    final lowercaseResponse = response.toLowerCase();
    
    final interestKeywords = [
      'museum', 'history', 'culture', 'food', 'adventure', 'nature',
      'beach', 'mountain', 'city', 'nightlife', 'shopping', 'art',
      'architecture', 'local experience', 'photography', 'hiking'
    ];
    
    for (final keyword in interestKeywords) {
      if (lowercaseResponse.contains(keyword)) {
        interests.add(keyword);
      }
    }
    
    _currentAssessment!.updateData('interests', interests);
    _currentAssessment!.updateData('interests_raw', response);
  }

  Future<void> _completeAssessment() async {
    _currentAssessment!.isCompleted = true;
    _currentAssessment!.endDate = DateTime.now();

    await _saveAssessmentData();
    await _generateTripPlan();

    setState(() {
      _isAssessmentMode = false;
    });
  }

  Future<void> _generateTripPlan() async {
    setState(() {
      _isAiSpeaking = true;
      _currentStreamingMessage = '';
    });

    try {
      String planPrompt = _buildPlanPrompt();

      String accumulatedPlan = '';
      await for (final chunk in _geminiService.sendMessageStream(planPrompt, [])) {
        accumulatedPlan += chunk;

        if (mounted) {
          setState(() {
            _currentStreamingMessage = accumulatedPlan;
          });
        }

        await Future.delayed(const Duration(milliseconds: 40));
      }

      if (accumulatedPlan.isNotEmpty) {
        _currentAssessment!.finalItinerary = accumulatedPlan;
        await _saveAssessmentData();
        _addAiMessage(accumulatedPlan);

        await Future.delayed(const Duration(milliseconds: 1000));
        _addAiMessage("""**✈️ Your Trip Plan is Complete!**

I've created a personalized itinerary based on your preferences. You can:

• Review the detailed plan above
• Ask me questions about specific recommendations
• Request modifications to the itinerary
• Get additional tips for your destinations

Feel free to ask me anything about your trip!""");
      }
    } catch (e) {
      log('Error generating trip plan: $e', name: 'tripPlannerBot');
      _addAiMessage("I've completed analyzing your trip preferences. Let me provide you with some recommendations!");
    } finally {
      setState(() {
        _isAiSpeaking = false;
        _currentStreamingMessage = '';
      });
    }
  }

  String _buildPlanPrompt() {
    final assessment = _currentAssessment!;
    
    return """As TripBot, create a comprehensive trip plan based on the following information:

**Trip Planning Data:**
${assessment.tripData.entries.map((e) => "${e.key}: ${e.value}").join('\n')}

**User Responses:**
${assessment.responses.entries.map((e) => "${e.key}: ${e.value}").join('\n')}

**Planning Period:** ${DateFormat('MMM dd, yyyy').format(assessment.startDate)} to ${DateFormat('MMM dd, yyyy').format(assessment.endDate ?? DateTime.now())}

Create a detailed travel itinerary with:
- Day-by-day schedule recommendations
- Accommodation suggestions within budget
- Restaurant and dining recommendations
- Activity and attraction suggestions
- Transportation options
- Budget breakdown
- Local tips and cultural insights
- Packing recommendations
- Important travel information

Make it comprehensive, practical, and exciting for the traveler!""";
  }

  // Data persistence methods
  Future<void> _loadAssessmentData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final assessmentJson = prefs.getString('trip_assessment_$_conversationId');

      if (assessmentJson != null) {
        final assessmentData = jsonDecode(assessmentJson);
        _currentAssessment = TripAssessment.fromJson(assessmentData);
      }
    } catch (e) {
      log('Error loading assessment data: $e', name: 'tripPlannerBot');
    }
  }

  Future<void> _saveAssessmentData() async {
    if (_currentAssessment == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final assessmentJson = jsonEncode(_currentAssessment!.toJson());
      await prefs.setString('trip_assessment_$_conversationId', assessmentJson);
    } catch (e) {
      log('Error saving assessment data: $e', name: 'tripPlannerBot');
    }
  }

  Future<void> _loadUserProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileImagePath = prefs.getString('user_profile_image');

      if (profileImagePath != null && mounted) {
        setState(() {
          _userProfileImage = profileImagePath;
        });
      }
    } catch (e) {
      log('Error loading user profile image: $e', name: 'tripPlannerBot');
    }
  }

  Future<void> _loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final chatHistoryJson = prefs.getString('trip_chat_history_$_conversationId');

      if (chatHistoryJson != null) {
        final List<dynamic> messagesList = jsonDecode(chatHistoryJson);
        final messages = messagesList.map((json) => ChatMessageModel.fromJson(json)).toList();

        if (mounted) {
          setState(() {
            _messages = messages;
          });
          _scrollToBottom();
        }
      }
    } catch (e) {
      log('Error loading chat history: $e', name: 'tripPlannerBot');
    }
  }

  Future<void> _saveChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = jsonEncode(_messages.map((msg) => msg.toJson()).toList());
      await prefs.setString('trip_chat_history_$_conversationId', messagesJson);
    } catch (e) {
      log('Error saving chat history: $e', name: 'tripPlannerBot');
    }
  }

  // UI Helper methods
  void _updateTextState() {
    setState(() {
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  void _addUserMessage(String message, {String? imagePath, String? filePath, String? fileName}) {
    final userMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: _conversationId,
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
      imageUrl: imagePath,
      fileUrl: filePath,
      fileName: fileName,
    );

    setState(() {
      _messages.add(userMessage);
    });

    _saveChatHistory();
    _scrollToBottom();
  }

  void _addAiMessage(String message) {
    final aiMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString() + "_ai",
      conversationId: _conversationId,
      content: message,
      isUser: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(aiMessage);
    });

    _saveChatHistory();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients && mounted) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend() {
    if (_controller.text.trim().isNotEmpty) {
      String message = _controller.text.trim();
      _controller.clear();

      _addUserMessage(message);

      if (_isAssessmentMode && _currentAssessment != null && !_currentAssessment!.isCompleted) {
        _processUserResponse(message);
      } else {
        _handleFreeChat(message);
      }
    }
  }

  Future<void> _handleFreeChat(String message) async {
    setState(() {
      _isAiSpeaking = true;
      _currentStreamingMessage = '';
    });

    try {
      String chatPrompt = """As TripBot, respond to this follow-up question about their trip:

User Question: "$message"

${_currentAssessment != null ? 'Previous Trip Plan Summary: ${_currentAssessment!.finalItinerary}' : ''}

Provide a helpful response while staying in character as a travel planning assistant.""";

      String accumulatedResponse = '';
      await for (final chunk in _geminiService.sendMessageStream(chatPrompt, _messages)) {
        accumulatedResponse += chunk;

        if (mounted) {
          setState(() {
            _currentStreamingMessage = accumulatedResponse;
          });
        }

        await Future.delayed(const Duration(milliseconds: 50));
      }

      if (accumulatedResponse.isNotEmpty) {
        _addAiMessage(accumulatedResponse);
      }
    } catch (e) {
      log('Error in free chat: $e', name: 'tripPlannerBot');
      _addAiMessage("I'm here to help with any travel questions. Could you please rephrase your question?");
    } finally {
      setState(() {
        _isAiSpeaking = false;
        _currentStreamingMessage = '';
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateTextState);
    _controller.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();

    for (var controller in _typingDotsControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  // UI Build methods
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Provider.of<UiProvider>(context); // ensure rebuild on theme change
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildAssessmentProgress(),
            _buildDateHeader(),
            Expanded(
              child: _messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
            ),
            _buildTypingIndicator(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return AppBar(
      backgroundColor: theme.primaryColor,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary,
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.onPrimary, width: 2),
            ),
            child: Icon(
              Icons.flight_takeoff_rounded,
              color: theme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aiAssistant,
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  _isAiSpeaking ? l10n.loading : l10n.aiAssistant,
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (_currentAssessment?.isCompleted == true)
          IconButton(
            icon: Icon(Icons.download, color: theme.colorScheme.onPrimary),
            onPressed: _exportTripPlan,
            tooltip: 'Export Trip Plan',
          ),
        IconButton(
          icon: Icon(Icons.more_vert, color: theme.colorScheme.onPrimary),
          onPressed: _showOptionsMenu,
        ),
      ],
    );
  }

  Widget _buildAssessmentProgress() {
    if (_currentAssessment == null) return const SizedBox.shrink();
    
    final theme = Theme.of(context);

    final progress = _currentAssessment!.isCompleted
        ? 1.0
        : _currentAssessment!.currentStep / _tripSteps.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: theme.primaryColor.withOpacity(0.2)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                _currentAssessment!.isCompleted ? Icons.check_circle : Icons.flight_takeoff_rounded,
                color: theme.primaryColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _currentAssessment!.isCompleted
                      ? 'Trip Planning Complete'
                      : 'Trip Planning in Progress',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surface,
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _currentAssessment!.isCompleted
                      ? 'Itinerary Generated'
                      : 'Step ${_currentAssessment!.currentStep + 1} of ${_tripSteps.length}',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            DateFormat('MMMM dd, yyyy').format(DateTime.now()),
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.flight_takeoff_rounded,
              size: 60,
              color: theme.primaryColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.welcomeToEasyTrip,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.howCanIHelp,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    if (!_isAiSpeaking && _currentStreamingMessage.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.flight_takeoff_rounded,
              color: theme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _currentStreamingMessage.isNotEmpty
                  ? MarkdownBody(
                      data: _currentStreamingMessage + "▋",
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        return AnimatedBuilder(
                          animation: _typingDotsControllers[index],
                          builder: (context, child) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              transform: Matrix4.translationValues(
                                0,
                                -_typingDotsAnimations[index].value,
                                0,
                              ),
                            );
                          },
                        );
                      }),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: _showInputOptions,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: theme.primaryColor,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.secondary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                constraints: const BoxConstraints(
                  minHeight: 36,
                  maxHeight: 100,
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: _isAssessmentMode
                        ? l10n.typeMessage
                        : l10n.typeMessage,
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _handleSend();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _hasText
                    ? theme.primaryColor
                    : theme.colorScheme.secondary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _hasText ? Icons.send : Icons.camera_alt,
                  color: _hasText ? theme.colorScheme.onPrimary : theme.primaryColor,
                  size: 18,
                ),
                padding: EdgeInsets.zero,
                onPressed: _hasText
                    ? _handleSend
                    : () => _handleImageCapture(ImageSource.camera),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageModel message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser)
            Builder(
              builder: (context) {
                final theme = Theme.of(context);
                return Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.flight_takeoff_rounded,
                    color: theme.primaryColor,
                    size: 20,
                  ),
                );
              },
            ),
          Flexible(
            child: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                return Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: message.isUser ? theme.primaryColor : theme.colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: message.isUser ? const Radius.circular(20) : const Radius.circular(5),
                      bottomRight: message.isUser ? const Radius.circular(5) : const Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.imageUrl != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: theme.colorScheme.surfaceVariant,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(message.imageUrl!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(Icons.image_not_supported, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ),
                  if (message.fileUrl != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? theme.colorScheme.onPrimary.withOpacity(0.2)
                            : theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.description,
                            size: 16,
                            color: message.isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              message.fileName ?? 'File',
                              style: TextStyle(
                                fontSize: 12,
                                color: message.isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (message.content.isNotEmpty)
                    message.isUser
                        ? Text(
                            message.content,
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 16,
                            ),
                          )
                        : MarkdownBody(
                            data: message.content,
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface,
                              ),
                              code: TextStyle(
                                backgroundColor: theme.colorScheme.secondary.withOpacity(0.3),
                                fontFamily: 'monospace',
                                fontSize: 12,
                                color: theme.colorScheme.onSurface,
                              ),
                              h1: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                              h2: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                              h3: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(message.timestamp),
                        style: TextStyle(
                          color: message.isUser
                              ? theme.colorScheme.onPrimary.withOpacity(0.7)
                              : theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                      if (message.isUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 14,
                          color: theme.colorScheme.onPrimary.withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ],
                  ),
                );
              },
            ),
          ),
          if (message.isUser)
            Builder(
              builder: (context) {
                final theme = Theme.of(context);
                return Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: _userProfileImage != null
                        ? Image.file(
                            File(_userProfileImage!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              color: theme.colorScheme.onSecondary,
                              size: 20,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            color: theme.colorScheme.onSecondary,
                            size: 20,
                          ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // Additional helper methods
  void _showInputOptions() {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Travel Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined, color: theme.primaryColor),
              title: Text('Take Photo', style: TextStyle(color: theme.colorScheme.onSurface)),
              subtitle: Text('Capture travel inspiration', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7))),
              onTap: () {
                Navigator.pop(context);
                _handleImageCapture(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: theme.primaryColor),
              title: Text('Choose from Gallery', style: TextStyle(color: theme.colorScheme.onSurface)),
              subtitle: Text('Select travel photos', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7))),
              onTap: () {
                Navigator.pop(context);
                _handleImageCapture(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.description_outlined, color: theme.primaryColor),
              title: Text('Upload Document', style: TextStyle(color: theme.colorScheme.onSurface)),
              subtitle: Text('Add travel documents', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7))),
              onTap: () {
                Navigator.pop(context);
                _handleFileUpload();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleImageCapture(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        _addUserMessage("I've attached an image for my trip planning", imagePath: image.path);

        if (_isAssessmentMode) {
          await _processUserResponse("Image provided for trip planning");
        } else {
          await _handleFreeChat("Please analyze this image for my trip");
        }
      }
    } catch (e) {
      log('Error picking image: $e', name: 'tripPlannerBot');
      if (mounted) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error accessing camera or gallery'),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _handleFileUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        _addUserMessage(
          "I've uploaded a document: ${file.name}",
          filePath: file.path!,
          fileName: file.name,
        );

        if (_isAssessmentMode) {
          await _processUserResponse("Document: ${file.name} uploaded for trip planning");
        } else {
          await _handleFreeChat("Please analyze this document: ${file.name}");
        }
      }
    } catch (e) {
      log('Error picking file: $e', name: 'tripPlannerBot');
      if (mounted) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting file'),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    }
  }

  void _exportTripPlan() {
    if (_currentAssessment?.finalItinerary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No completed trip plan to export'),
          backgroundColor: Colors.orange, // Warning color - keeping as orange is appropriate
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Trip Plan'),
        content: const Text('Choose how you would like to export your trip plan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _shareResults();
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _shareResults() async {
    if (_currentAssessment?.finalItinerary == null) return;

    try {
      await Share.share(
        'Smart Trip Planner Results\n\n${_currentAssessment!.finalItinerary}',
        subject: 'My Trip Plan - ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
      );
    } catch (e) {
      final theme = Theme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing trip plan: $e'),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    }
  }

  void _showOptionsMenu() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: theme.colorScheme.shadow.withOpacity(0.3),
      builder: (context) => SlidingMenu(
        title: 'Smart Trip Planner Options',
        version: 'TripBot v1.0.0',
        menuOptions: [
          if (_currentAssessment?.isCompleted == true)
            MenuOption(
              icon: Icons.download,
              title: 'Export Trip Plan',
              onTap: () {
                Navigator.pop(context);
                _exportTripPlan();
              },
            ),
          MenuOption(
            icon: Icons.refresh_outlined,
            title: 'Start New Trip Planning',
            onTap: () {
              Navigator.pop(context);
              _showNewPlanningConfirmation();
            },
          ),
          MenuOption(
            icon: Icons.history,
            title: 'Trip History',
            onTap: () {
              Navigator.pop(context);
              _showTripHistory();
            },
          ),
          MenuOption(
            icon: Icons.help_outline,
            title: 'About Trip Planner',
            onTap: () {
              Navigator.pop(context);
              _showPlannerInfo();
            },
          ),
        ],
      ),
    );
  }

  void _showNewPlanningConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start New Trip Planning'),
        content: const Text(
            'This will start a new trip planning session. Your current trip data will be saved. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewAssessment();
            },
            child: const Text('Start New'),
          ),
        ],
      ),
    );
  }

  void _showTripHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trip history feature coming soon')),
    );
  }

  void _showPlannerInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Smart Trip Planner'),
        content: const SingleChildScrollView(
          child: Text(
            'This AI-powered trip planner helps you:\n\n'
            '• Plan personalized itineraries\n'
            '• Find activities matching your interests\n'
            '• Optimize your budget and time\n'
            '• Discover local recommendations\n'
            '• Create memorable travel experiences\n\n'
            'Let TripBot help you plan your perfect adventure!',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}










