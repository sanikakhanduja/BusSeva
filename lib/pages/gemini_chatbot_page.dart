// lib/pages/gemini_chatbot_page.dart
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class GeminiChatbotPage extends StatefulWidget {
  const GeminiChatbotPage({super.key});

  @override
  State<GeminiChatbotPage> createState() => _GeminiChatbotPageState();
}

class _GeminiChatbotPageState extends State<GeminiChatbotPage> {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  // Replace with your actual API key
  static const String _apiKey = 'AIzaSyA2nOLO-DKOjaQvjHb7suimrtftPeECrhA';

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  void _initializeModel() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 1,
        topP: 1,
        maxOutputTokens: 2048,
      ),
    );

    // Initialize chat with context about your app
    _chatSession = _model.startChat(
      history: [
        Content.text('''
You are a helpful assistant for a driver/transportation mobile app. Your role is to help users navigate and understand the app's features.
Here are the main sections of the app:
- Home: Main dashboard with overview
- Driver Home: Driver-specific dashboard and controls
- Trip: Current and past trip information
- Shift: Manage driving shifts and schedules
- Report: Generate and view reports
- Settings: App preferences and configurations
- Diagnostics: System diagnostics and troubleshooting
- Selfie Verification: Identity verification process
- Login/Sign Up: Authentication pages

When users ask about navigation or features, guide them clearly and suggest specific actions they can take.
Keep responses concise and helpful. Focus on driver-related features and transportation functionality.
If they ask about completing trips, managing shifts, or navigating the app, provide step-by-step guidance.
'''),
      ],
    );

    // Add welcome message
    _messages.add(
      ChatMessage(
        text:
            "🚗 Hi! I'm your driving assistant. I can help you navigate the app, manage your trips, shifts, and answer questions about using the driver features. How can I help you today?",
        isUser: false,
      ),
    );
  }

  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });

    _textController.clear();
    _scrollToBottom();

    try {
      final content = Content.text(text);
      final response = await _chatSession.sendMessage(content);

      setState(() {
        _messages.add(
          ChatMessage(
            text: response.text ?? 'Sorry, I couldn\'t generate a response.',
            isUser: false,
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: 'Sorry, there was an error: ${e.toString()}',
            isUser: false,
          ),
        );
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildQuickActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildActionChip(
                '🏠 Go Home',
                () => _sendQuickMessage('Take me to home page'),
              ),
              _buildActionChip(
                '🚗 Driver Dashboard',
                () => _sendQuickMessage('Open driver home'),
              ),
              _buildActionChip(
                '🛣️ My Trips',
                () => _sendQuickMessage('Show my trips'),
              ),
              _buildActionChip(
                '⏰ Shift Info',
                () => _sendQuickMessage('Tell me about shifts'),
              ),
              _buildActionChip(
                '📊 Reports',
                () => _sendQuickMessage('How do I generate reports?'),
              ),
              _buildActionChip(
                '⚙️ Settings',
                () => _sendQuickMessage('Open settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onTap,
      backgroundColor: Colors.blue.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _sendQuickMessage(String message) {
    _textController.text = message;
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Assistant'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.smart_toy,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Thinking...'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: message.isUser
                            ? Colors.green
                            : Colors.blue,
                        child: Icon(
                          message.isUser ? Icons.person : Icons.smart_toy,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          color: message.isUser
                              ? Colors.green.shade50
                              : Colors.blue.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: message.isUser
                                ? Text(message.text)
                                : MarkdownBody(data: message.text),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildQuickActionButtons(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Ask me about the app features...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _isLoading ? null : _sendMessage,
                  mini: true,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
