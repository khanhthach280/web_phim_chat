import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // Ollama Configuration
  static const String _ollamaBaseUrl = 'http://localhost:11434/api';
  static const String _model = 'llama3.2:1b-instruct-fp16';
  
  static Future<String> generateResponse(String userMessage) async {
    
    print('====== khnh 1');
    try {
      final response = await http.post(
        Uri.parse('$_ollamaBaseUrl/generate'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'prompt': 'Bạn là một trợ lý AI thân thiện và hữu ích. Hãy trả lời bằng tiếng Việt một cách tự nhiên và dễ hiểu.\n\nCâu hỏi: $userMessage',
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        print('====== khanh success');
        final data = jsonDecode(response.body);
        return data['response'] ?? 'Không thể tạo phản hồi.';
      } else {
        throw Exception('Lỗi Ollama API: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback response nếu API không hoạt động
      return _getFallbackResponse(userMessage);
    }
  }
  
  static String _getFallbackResponse(String userMessage) {
    // Một số phản hồi mẫu khi API không khả dụng
    final responses = [
      'Xin chào! Tôi là trợ lý AI của bạn. Tôi có thể giúp gì cho bạn?',
      'Cảm ơn bạn đã tin tưởng! Tôi đang ở đây để hỗ trợ bạn.',
      'Đó là một câu hỏi thú vị! Tôi sẽ cố gắng trả lời tốt nhất có thể.',
      'Tôi hiểu bạn đang quan tâm đến chủ đề này. Hãy để tôi suy nghĩ...',
      'Rất vui được trò chuyện với bạn! Bạn có muốn thảo luận thêm về điều gì không?',
    ];
    
    // Trả về phản hồi dựa trên nội dung tin nhắn
    if (userMessage.toLowerCase().contains('xin chào') || 
        userMessage.toLowerCase().contains('hello')) {
      return responses[0];
    } else if (userMessage.toLowerCase().contains('cảm ơn') || 
               userMessage.toLowerCase().contains('thank')) {
      return responses[1];
    } else if (userMessage.toLowerCase().contains('?')) {
      return responses[2];
    } else {
      return responses[responses.length - 1];
    }
  }
}
