import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easytrip/utils/theme.dart';
import 'package:easytrip/data/provider/server/gemini_service.dart';
import 'package:easytrip/presentation/widgets/chat_message.dart';

class ChatBotScreen extends StatefulWidget {
  final String initialMessage;
  const ChatBotScreen({Key? key, required this.initialMessage})
    : super(key: key);
  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessageModel> _messages = [];
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage.isNotEmpty) {
      _messages.add(
        ChatMessageModel(
          id: UniqueKey().toString(),
          conversationId: 'default',
          content: widget.initialMessage,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    } else {
      _messages.add(
        ChatMessageModel(
          id: UniqueKey().toString(),
          conversationId: 'default',
          content:
              "Hi! I'm your EasyTrip Assistant. How can I help you plan your trip?",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    }
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessageModel(
          id: UniqueKey().toString(),
          conversationId: 'default',
          content: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _controller.clear();
      _hasText = false;
      _isLoading = true;
    });

    try {
      final gemini = GeminiService();
      final aiResponse = await gemini.sendMessage(text, _messages);
      setState(() {
        _messages.add(
          ChatMessageModel(
            id: UniqueKey().toString(),
            conversationId: 'default',
            content: aiResponse.content,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
      // Optionally scroll to bottom
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to get response: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Row(
          children: [
            Icon(Icons.travel_explore, color: theme.colorScheme.onPrimary),
            const SizedBox(width: 10),
            Text(
              'EasyTrip Assistant',
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    DateFormat('MMMM dd, yyyy').format(DateTime.now()),
                    style: TextStyle(
                      color:
                          theme.textTheme.bodyLarge?.color?.withOpacity(0.7) ??
                          Colors.black.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  _messages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.travel_explore,
                                size: 60,
                                color: theme.primaryColor.withOpacity(0.7),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Welcome to EasyTrip Assistant',
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ask me anything about your trip or itinerary!',
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color
                                      ?.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            return _buildMessageBubble(message, theme);
                          },
                        ),
                  if (_isLoading)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 8,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.cardColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text('EasyTrip is thinking...'),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _buildInputArea(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
              ),
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: theme.primaryColor),
            onPressed: _hasText ? _sendMessage : null,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageModel message, ThemeData theme) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? theme.primaryColor : theme.cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isUser
                ? theme.colorScheme.onPrimary
                : theme.textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}
