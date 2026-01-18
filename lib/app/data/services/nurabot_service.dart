import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/models/message_models/bot_message_model.dart';

class NuraBotService {
  static NuraBotService get instance => Get.find();

  final String baseUrl = dotenv.env['AI_URL']!;

  // Future<Map<String, String>> _getHeaders(User? user) async {
  //   final token = await user?.getIdToken(true);
  //   return {
  //     if (token != null) 'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json',
  //     'Accept': '*/*',
  //   };
  // }

  Future<BotMessageModel> sendChatMessage({
    required String threadId,
    required String query,
    File? file,
  }) async{
    final url = Uri.parse('$baseUrl/chat');
    if(file != null){
      var request = http.MultipartRequest('POST',url);
      request.fields['thread_id'] = threadId;
      request.fields['message'] = query.trim();
      request.files.add(
        await http.MultipartFile.fromPath('document_file', file.path));

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if(streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        final data = jsonDecode(responseBody);
        return BotMessageModel.fromJson(data);
      }else{
        throw Exception('Failed to send query: ${streamedResponse.statusCode}');
      }
    }else{
      final response = await http.post(url,
      body: jsonEncode({
        'thread_id':threadId,
        'message':query.trim(),
      }),
      );

      if(response.statusCode == 200 || response.statusCode ==201){
        final data = jsonDecode(response.body);
        return BotMessageModel.fromJson(data);
      }else{
        throw Exception('Failed to send query: ${response.statusCode}');
      }
    }
  }
}
