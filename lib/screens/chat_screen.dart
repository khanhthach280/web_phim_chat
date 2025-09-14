import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(
                Icons.smart_toy,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            const Text('AI Chat Assistant'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return IconButton(
                onPressed: chatProvider.messages.isNotEmpty
                    ? () => _showClearDialog(context, chatProvider)
                    : null,
                icon: const Icon(Icons.clear_all),
                tooltip: 'Xóa cuộc trò chuyện',
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Error banner
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.error.isNotEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          chatProvider.error,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => chatProvider.clearError(),
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ).animate().slideY(
                  begin: -1,
                  end: 0,
                  duration: 300.ms,
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
          // Messages list
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.messages.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return MessageBubble(message: message);
                  },
                );
              },
            ),
          ),
          
          // Chat input
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return ChatInput(
                onSendMessage: (message) {
                  chatProvider.sendMessage(message);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _scrollToBottom();
                  });
                },
                isLoading: chatProvider.isLoading,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Chào mừng đến với AI Chat!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy bắt đầu cuộc trò chuyện với trợ lý AI của bạn',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '💡 Gợi ý: Hỏi về bất kỳ chủ đề nào bạn quan tâm!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.0, 1.0),
      duration: 600.ms,
      curve: Curves.easeOut,
    );
  }

  void _showClearDialog(BuildContext context, ChatProvider chatProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa cuộc trò chuyện'),
          content: const Text('Bạn có chắc chắn muốn xóa toàn bộ cuộc trò chuyện?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                chatProvider.clearChat();
                Navigator.of(context).pop();
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
