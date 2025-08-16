import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; // Import the Gemini package
import 'package:flutter_application_1/utils/app_colors.dart'; // Assuming AppColors is in this path
import 'package:firebase_auth/firebase_auth.dart'; // Keeping import for reference

// Simple class to represent a chat message (Defined here for completeness)
class ChatMessage {
  final String text;
  final bool isUser; // true for user messages, false for Gemini messages
  final bool isSuggestion; // Added flag for suggestion items

  ChatMessage({required this.text, required this.isUser, this.isSuggestion = false});
}

class GeminiChatScreen extends StatefulWidget {
  final String? userName;
  const GeminiChatScreen({Key? key, this.userName}) : super(key: key);

  @override
  State<GeminiChatScreen> createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  static const String _apiKey = "AIzaSyCt7kbyrr4b5ZJQi76gxTRZn2s0hZZxjAY"; 

  late final GenerativeModel _model;
  late final ChatSession _chat;

  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  final List<String> _suggestedQuestions = [
    "Suggest a beginner workout plan.",
    "What are good exercises for weight loss?",
    "Healthy meal ideas for muscle gain?",
    "How often should I do cardio?",
    "Tips for staying motivated?",
    "Explain the benefits of stretching.",
  ];

  List<ChatMessage> _buildInitialMessages() {
    List<ChatMessage> initialMessages = [];
    initialMessages.add(ChatMessage(text: "Hello Ahmed Iam ready to assist you! How can I help you with your fitness goals today?", isUser: false));

     initialMessages.add(
        ChatMessage(
          text: widget.userName != null && widget.userName!.isNotEmpty ? "Hi ${widget.userName}! Try asking:" : "Try asking:",
          isUser: false, // Treat this intro text as non-user message
          isSuggestion: true, // Flag it as a suggestion intro
        ),
      );


    initialMessages.addAll(_suggestedQuestions.map((question) => ChatMessage(
      text: question,
      isUser: false, // Treat suggestions as non-user items for layout
      isSuggestion: true, // Flag it as a suggestion
    )));


    return initialMessages;
  }


  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: _apiKey);

    // Initialize the chat session with initial context
    _chat = _model.startChat(history: [
      Content.text(
          "You are a friendly AI fitness coach. Your name is FitBuddy. "
          "${widget.userName != null && widget.userName!.isNotEmpty ? "The user's name is ${widget.userName}. Address the user as ${widget.userName}." : ""}"
          "Always provide helpful and encouraging fitness advice. "
          "Keep responses relatively concise and easy to understand. "
          "Focus on fitness, nutrition, and wellness."),
      Content.model([
        TextPart("Okay, I understand. I am ready to assist! How can I help you with your fitness goals today?"),
      ]),
    ]);

     _messages.addAll(_buildInitialMessages());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage({String? initialText}) async {
    final String message = initialText ?? _textController.text.trim();
    if (message.isEmpty) {
      return;
    }

    if (initialText == null) {
       _textController.clear();
    }

     if (_messages.any((msg) => msg.isSuggestion)) {
        setState(() {
           _messages.removeWhere((msg) => msg.isSuggestion);
        });
     }


    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isLoading = true;
    });

    try {
      final response = await _chat.sendMessage(Content.text(message));
      final String geminiResponse = response.text ?? "Could not get a response.";

      setState(() {
        _messages.add(ChatMessage(text: geminiResponse, isUser: false));
      });
    } catch (e) {
      print("Error sending message to Gemini: $e");
      setState(() {
        _messages.add(
          ChatMessage(text: "Error: Could not get a response.", isUser: false),
        );
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSuggestedQuestionTap(String question) {
     _sendMessage(initialText: question);
  }

  Widget _buildMessageBubble(ChatMessage message) {
    if (message.isSuggestion) {
       if (_suggestedQuestions.contains(message.text) == false) {
          return Align(
             alignment: Alignment.centerLeft,
             child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Text(
                   message.text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor.withOpacity(0.8),
                    ),
                ),
             ),
          );
       }
       return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
             child: ActionChip(
                label: Text(message.text),
                labelStyle: TextStyle(color: AppColors.blackColor),
                backgroundColor: AppColors.lightGrayColor,
                onPressed: () => _onSuggestedQuestionTap(message.text),
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide.none
                ),
             ),
          ),
       );
    }


    // Original message bubble logic for user and AI messages
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 12.0,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        decoration: BoxDecoration(
          color:
              message.isUser
                  ? AppColors.primaryColor1.withOpacity(0.8)
                  : AppColors.lightGrayColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              message.isUser ? 16.0 : 4.0,
            ),
            topRight: Radius.circular(
              message.isUser ? 4.0 : 16.0,
            ),
            bottomLeft: const Radius.circular(16.0),
            bottomRight: const Radius.circular(16.0),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color:
                message.isUser
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: const Text(
          "AI coach Assistant",
          style: TextStyle(color: AppColors.blackColor),
        ),
        backgroundColor: AppColors.whiteColor,
        elevation: 0.5,
        iconTheme: const IconThemeData(
          color: AppColors.blackColor,
        ),
      ),
      // Standard chat layout: Column with Expanded message list and fixed input area
      body: Column(
        children: [
          // Chat messages area - Takes up the remaining space
          Expanded(
            child: ListView.builder(
              // Removed SingleChildScrollView here
              // Removed shrinkWrap: true
              reverse: false, // Display latest messages at the bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                // Use the modified _buildMessageBubble to handle suggestions
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Loading indicator
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: AppColors.primaryColor1,
              ),
            ),

          // Input area - This area is fixed at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Ask me anything about fitness...",
                      hintStyle: TextStyle(
                        color: AppColors.grayColor.withOpacity(0.7),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGrayColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 14.0,
                      ),
                    ),
                    style: TextStyle(color: AppColors.blackColor),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12.0),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.primaryG,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: AppColors.whiteColor,
                    ),
                    onPressed: _isLoading ? null : _sendMessage,
                    padding: const EdgeInsets.all(
                      14.0,
                    ),
                    splashRadius: 24.0,
                  ),
                ),
              ],
            ),
          ),
           // Add bottom padding to ensure input field is above keyboard
           // This is often handled automatically by Scaffold's resizeToAvoidBottomInset: true (default)
           // but explicitly adding it here can sometimes help in complex layouts.
           // Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
        ],
      ),
    );
  }
}