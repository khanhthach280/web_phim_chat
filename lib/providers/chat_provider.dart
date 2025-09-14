import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/ai_service.dart';

class ChatProvider with ChangeNotifier {
  List<Message> _messages = [];
  bool _isLoading = false;
  String _error = '';

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String get error => _error;

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  void updateMessage(String messageId, Message updatedMessage) {
    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      _messages[index] = updatedMessage;
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Thêm tin nhắn của user
    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    addMessage(userMessage);

    // Thêm tin nhắn loading của AI
    final loadingMessage = Message(
      id: 'loading_${DateTime.now().millisecondsSinceEpoch}',
      content: '',
      isUser: false,
      timestamp: DateTime.now(),
      isLoading: true,
    );
    addMessage(loadingMessage);

    setLoading(true);
    clearError();

    try {
      print('======= khanh 1');
      // Gọi AI service
      final aiResponse = await AIService.generateResponse(content);
      
      // Cập nhật tin nhắn loading thành phản hồi thực
      final aiMessage = Message(
        id: loadingMessage.id,
        content: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
        isLoading: false,
      );
      updateMessage(loadingMessage.id, aiMessage);
    } catch (e) {
      // Xử lý lỗi
      final errorMessage = Message(
        id: loadingMessage.id,
        content: 'Xin lỗi, có lỗi xảy ra khi xử lý tin nhắn của bạn. Vui lòng thử lại.',
        isUser: false,
        timestamp: DateTime.now(),
        isLoading: false,
      );
      updateMessage(loadingMessage.id, errorMessage);
      setError(e.toString());
    } finally {
      setLoading(false);
    }

    print('======= khanh 2');
  }

  void clearChat() {
    _messages.clear();
    _error = '';
    notifyListeners();
  }
}
