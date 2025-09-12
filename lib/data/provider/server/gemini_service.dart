import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:easytrip/presentation/widgets/chat_message.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  // Get API key from environment variables
  static final String apiKey = 'AIzaSyAzCajM6XYSU3yYZmme8SyNUQlmNFMvJRQ';

  // Analyze plant image and get structured response
  static Future<Map<String, dynamic>> analyzePlantImage(File imageFile) async {
    log('Starting plant image analysis', name: 'geminiService');

    try {
      log('Reading image file: ${imageFile.path}', name: 'geminiService');

      // Convert image to base64
      final List<int> imageBytes = await imageFile.readAsBytes();
      log(
        'Image file read successfully, size: ${imageBytes.length} bytes',
        name: 'geminiService',
      );

      final String base64Image = base64Encode(imageBytes);
      log(
        'Image converted to base64, length: ${base64Image.length}',
        name: 'geminiService',
      );

      // Create prompt instructing Gemini to format as JSON
      final String prompt = """
      Analyze this plant or herb image and identify it.
      Return ONLY a valid JSON object with no explanation text before or after, using exactly this format:
      {
        "name": "Full plant name (Scientific name)",
        "confidence": 0.95,
        "description": "Brief description of the plant",
        "benefits": [
          "Health benefit 1",
          "Health benefit 2",
          "Health benefit 3",
          "Health benefit 4",
          "Health benefit 5"
        ],
        "usage": "How this plant can be used medicinally or in cooking",
        "caution": "Any warnings or cautions about using this plant"
      }
      
      If you cannot identify the plant, set confidence to 0.0.
      Ensure the response is valid JSON that can be parsed.
      """;

      log('Prompt created for plant analysis', name: 'geminiService');

      // Construct request payload
      final Map<String, dynamic> requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt},
              {
                'inline_data': {'mime_type': 'image/jpeg', 'data': base64Image},
              },
            ],
          },
        ],
        'generationConfig': {'temperature': 0.2, 'topK': 32, 'topP': 0.95},
      };

      log(
        'Request payload constructed for plant analysis',
        name: 'geminiService',
      );

      // Send request to Gemini API
      log(
        'Sending request to Gemini API for plant analysis',
        name: 'geminiService',
      );

      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      log(
        'Received response from Gemini API, status: ${response.statusCode}',
        name: 'geminiService',
      );

      if (response.statusCode == 200) {
        log(
          'API response successful, parsing response body',
          name: 'geminiService',
        );

        final responseData = jsonDecode(response.body);
        log('Response body parsed successfully', name: 'geminiService');

        final contentText =
            responseData['candidates'][0]['content']['parts'][0]['text'];

        log(
          'Content text extracted: ${contentText.substring(0, contentText.length > 100 ? 100 : contentText.length)}...',
          name: 'geminiService',
        );

        // Extract and parse the JSON from the response
        try {
          log('Attempting to parse JSON response', name: 'geminiService');

          // Clean the text in case there are extra markdown characters
          final cleanText = contentText
              .replaceAll('```json', '')
              .replaceAll('```', '')
              .trim();

          log('Text cleaned for JSON parsing', name: 'geminiService');

          final parsedResult = jsonDecode(cleanText);
          log(
            'JSON parsed successfully for plant analysis',
            name: 'geminiService',
          );

          return parsedResult;
        } catch (e) {
          log('Failed to parse JSON response: $e', name: 'geminiService');
          return _createErrorResponse('Failed to parse AI response: $e');
        }
      } else {
        log(
          'API request failed with status: ${response.statusCode}, body: ${response.body}',
          name: 'geminiService',
        );
        return _createErrorResponse(
          'API request failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Error in plant image analysis: $e', name: 'geminiService');
      return _createErrorResponse('Error: $e');
    }
  }

  // Create error response with proper format
  static Map<String, dynamic> _createErrorResponse(String errorMessage) {
    log('Creating error response: $errorMessage', name: 'geminiService');

    return {
      'name': 'Analysis Error',
      'confidence': 0.0,
      'description': 'Unable to analyze the image.',
      'benefits': ['No benefits could be determined due to an error.'],
      'usage': 'Unable to provide usage information.',
      'caution':
          'Error details: $errorMessage. Please try again with a clearer image.',
    };
  }

  // Send message with conversation history and return stream
  Stream<String> sendMessageStream(
    String message,
    List<ChatMessageModel> conversationHistory,
  ) async* {
    log(
      'Starting message stream for message: ${message.substring(0, message.length > 50 ? 50 : message.length)}...',
      name: 'geminiService',
    );

    try {
      // Build conversation context with last 3 messages
      final List<Map<String, dynamic>> contents = [];

      log('Building conversation context', name: 'geminiService');

      // Add system prompt for travel assistant
      contents.add({
        'parts': [
          {'text': _buildTravelPrompt()},
        ],
        'role': 'user',
      });
      contents.add({
        'parts': [
          {
            'text':
                'I understand. I am EasyTrip, your travel assistant. How can I help you plan your trip today?',
          },
        ],
        'role': 'model',
      });

      log(
        'Travel system prompt added to conversation context',
        name: 'geminiService',
      );

      // Add last 3 messages from conversation history
      final recentMessages = conversationHistory.length > 6
          ? conversationHistory.sublist(conversationHistory.length - 6)
          : conversationHistory;

      log(
        'Adding ${recentMessages.length} recent messages to context',
        name: 'geminiService',
      );

      for (final msg in recentMessages) {
        contents.add({
          'parts': [
            {'text': msg.content},
          ],
          'role': msg.isUser ? 'user' : 'model',
        });
      }

      // Add current message
      contents.add({
        'parts': [
          {'text': message},
        ],
        'role': 'user',
      });

      log(
        'Current message added to context, total contents: ${contents.length}',
        name: 'geminiService',
      );

      // Construct request payload for streaming
      final Map<String, dynamic> requestBody = {
        'contents': contents,
        'generationConfig': {
          'temperature': 0.7,
          'topK': 32,
          'topP': 0.95,
          'maxOutputTokens': 2048,
        },
      };

      log('Request payload constructed for streaming', name: 'geminiService');

      // Send request to Gemini API with streaming
      final request = http.Request(
        'POST',
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:streamGenerateContent?key=$apiKey',
        ),
      );

      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(requestBody);

      log('Sending streaming request to Gemini API', name: 'geminiService');

      final streamedResponse = await request.send();

      log(
        'Received streaming response, status: ${streamedResponse.statusCode}',
        name: 'geminiService',
      );

      if (streamedResponse.statusCode == 200) {
        log(
          'Streaming response successful, starting to process chunks',
          name: 'geminiService',
        );

        String buffer = '';
        int chunkCount = 0;
        int totalTextLength = 0;

        await for (final chunk in streamedResponse.stream.transform(
          utf8.decoder,
        )) {
          chunkCount++;
          buffer += chunk;
          log(
            'Processing chunk $chunkCount, chunk size: ${chunk.length}, buffer size: ${buffer.length}',
            name: 'geminiService',
          );

          // Look for complete JSON objects in the buffer
          List<String> jsonObjects = [];
          int startIndex = 0;

          while (startIndex < buffer.length) {
            int openBraces = 0;
            int currentIndex = startIndex;
            bool inString = false;
            bool escapeNext = false;
            int objectStart = -1;

            // Find the start of a JSON object
            while (currentIndex < buffer.length && objectStart == -1) {
              final char = buffer[currentIndex];
              if (char == '{' && !inString) {
                objectStart = currentIndex;
                break;
              }
              currentIndex++;
            }

            if (objectStart == -1) break;

            // Parse from the start of the JSON object
            currentIndex = objectStart;
            while (currentIndex < buffer.length) {
              final char = buffer[currentIndex];

              if (escapeNext) {
                escapeNext = false;
              } else if (char == '\\' && inString) {
                escapeNext = true;
              } else if (char == '"' && !escapeNext) {
                inString = !inString;
              } else if (!inString) {
                if (char == '{') {
                  openBraces++;
                } else if (char == '}') {
                  openBraces--;
                  if (openBraces == 0) {
                    // Found complete JSON object
                    final jsonStr = buffer.substring(
                      objectStart,
                      currentIndex + 1,
                    );
                    jsonObjects.add(jsonStr);
                    startIndex = currentIndex + 1;
                    break;
                  }
                }
              }
              currentIndex++;
            }

            if (currentIndex >= buffer.length && openBraces > 0) {
              // Incomplete JSON object, keep it in buffer
              buffer = buffer.substring(objectStart);
              break;
            }

            if (openBraces == 0) {
              // Remove processed part from buffer
              buffer = buffer.substring(currentIndex + 1);
              startIndex = 0;
            } else {
              break;
            }
          }

          // Process each complete JSON object
          for (final jsonStr in jsonObjects) {
            try {
              log(
                'Attempting to parse complete JSON object, length: ${jsonStr.length}',
                name: 'geminiService',
              );

              final jsonData = jsonDecode(jsonStr);
              if (jsonData['candidates'] != null &&
                  jsonData['candidates'].isNotEmpty &&
                  jsonData['candidates'][0]['content'] != null &&
                  jsonData['candidates'][0]['content']['parts'] != null &&
                  jsonData['candidates'][0]['content']['parts'].isNotEmpty) {
                final text =
                    jsonData['candidates'][0]['content']['parts'][0]['text'];
                if (text != null && text.toString().isNotEmpty) {
                  totalTextLength += text.toString().length;
                  log(
                    'Yielding text chunk: ${text.toString().length} characters, total so far: $totalTextLength',
                    name: 'geminiService',
                  );
                  yield text.toString();
                }
              }
            } catch (e) {
              log(
                'Failed to parse JSON object: $e\nJSON: ${jsonStr.length > 200 ? jsonStr.substring(0, 200) + "..." : jsonStr}',
                name: 'geminiService',
              );
              continue;
            }
          }
        }

        log(
          'Finished processing all chunks, total chunks: $chunkCount, total text yielded: $totalTextLength characters',
          name: 'geminiService',
        );
      } else {
        log(
          'Streaming request failed with status: ${streamedResponse.statusCode}',
          name: 'geminiService',
        );
        yield 'Sorry, I encountered an error. Please try again.';
      }
    } catch (e) {
      log('Error in message stream: $e', name: 'geminiService');
      yield 'I apologize, but I\'m having trouble connecting right now. Please try again.';
    }
  }

  // Non-streaming version for backwards compatibility
  Future<ChatResponse> sendMessage(
    String message,
    List<ChatMessageModel> conversationHistory,
  ) async {
    log(
      'Starting non-streaming message for: ${message.substring(0, message.length > 50 ? 50 : message.length)}...',
      name: 'geminiService',
    );

    try {
      String fullResponse = '';
      int chunkCount = 0;

      await for (final chunk in sendMessageStream(
        message,
        conversationHistory,
      )) {
        chunkCount++;
        fullResponse += chunk;
        log(
          'Accumulated chunk $chunkCount, total response length: ${fullResponse.length}',
          name: 'geminiService',
        );
      }

      log(
        'Non-streaming response completed, final length: ${fullResponse.length}',
        name: 'geminiService',
      );
      return ChatResponse(content: fullResponse);
    } catch (e) {
      log('Error in non-streaming message: $e', name: 'geminiService');
      return ChatResponse(
        content:
            "I'm sorry, I'm having trouble responding right now. Please try again.",
        isError: true,
      );
    }
  }

  Future<ChatResponse> analyzeImageWithText(
    String imagePath,
    String text,
    List<ChatMessageModel> conversationHistory,
  ) async {
    log(
      'Starting image analysis with text, image: $imagePath, text: ${text.substring(0, text.length > 50 ? 50 : text.length)}...',
      name: 'geminiService',
    );

    try {
      // Convert image to base64
      log('Reading image file for analysis: $imagePath', name: 'geminiService');

      final File imageFile = File(imagePath);
      final List<int> imageBytes = await imageFile.readAsBytes();
      log(
        'Image file read, size: ${imageBytes.length} bytes',
        name: 'geminiService',
      );

      final String base64Image = base64Encode(imageBytes);
      log(
        'Image converted to base64, length: ${base64Image.length}',
        name: 'geminiService',
      );

      // Build conversation context
      final List<Map<String, dynamic>> contents = [];

      log(
        'Building conversation context for image analysis',
        name: 'geminiService',
      );

      // Add system prompt
      contents.add({
        'parts': [
          {'text': _buildTravelPrompt()},
        ],
        'role': 'user',
      });

      // Add recent conversation history
      final recentMessages = conversationHistory.length > 4
          ? conversationHistory.sublist(conversationHistory.length - 4)
          : conversationHistory;

      log(
        'Adding ${recentMessages.length} recent messages to context',
        name: 'geminiService',
      );

      for (final msg in recentMessages) {
        contents.add({
          'parts': [
            {'text': msg.content},
          ],
          'role': msg.isUser ? 'user' : 'model',
        });
      }

      // Add current message with image
      contents.add({
        'parts': [
          {
            'text': text.isEmpty
                ? 'Analyze this image and provide health-related insights.'
                : text,
          },
          {
            'inline_data': {'mime_type': 'image/jpeg', 'data': base64Image},
          },
        ],
        'role': 'user',
      });

      log(
        'Image and text added to context, total contents: ${contents.length}',
        name: 'geminiService',
      );

      final Map<String, dynamic> requestBody = {
        'contents': contents,
        'generationConfig': {'temperature': 0.7, 'topK': 32, 'topP': 0.95},
      };

      log(
        'Sending image analysis request to Gemini API',
        name: 'geminiService',
      );

      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      log(
        'Received image analysis response, status: ${response.statusCode}',
        name: 'geminiService',
      );

      if (response.statusCode == 200) {
        log(
          'Image analysis response successful, parsing content',
          name: 'geminiService',
        );

        final responseData = jsonDecode(response.body);
        final contentText =
            responseData['candidates'][0]['content']['parts'][0]['text'];

        log(
          'Image analysis completed successfully, response length: ${contentText.length}',
          name: 'geminiService',
        );

        return ChatResponse(content: contentText);
      } else {
        log(
          'Image analysis request failed with status: ${response.statusCode}, body: ${response.body}',
          name: 'geminiService',
        );
        return ChatResponse(
          content: "I'm having trouble analyzing this image. Please try again.",
          isError: true,
        );
      }
    } catch (e) {
      log('Error in image analysis with text: $e', name: 'geminiService');
      return ChatResponse(
        content: "I'm having trouble analyzing this image. Please try again.",
        isError: true,
      );
    }
  }

  static String _buildTravelPrompt() {
    log('Building travel prompt', name: 'geminiService');
    return """
You are EasyTrip, a friendly and knowledgeable travel assistant. Help users plan trips, suggest destinations, build itineraries, recommend activities, and answer travel-related questions.

Your capabilities include:
- Recommending travel destinations and attractions
- Helping users build and organize their trip itineraries
- Suggesting activities, restaurants, and local experiences
- Providing travel tips, packing advice, and safety information
- Answering questions about transportation, weather, and budgeting
- Offering guidance for solo, group, or family travel

Guidelines:
- Always be helpful, positive, and concise
- Focus only on travel, trip planning, and itinerary topics
- If asked about unrelated topics, politely say you can only help with travel
- Use a warm, encouraging tone
- Keep responses clear and actionable

Remember: You are a supportive travel companion, not a replacement for professional travel agents.""";
  }
}
