import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiAIService {
  final apiKey = dotenv.env['IA_KEY']??"";

  Future<String> sendMessage(String message) async {
    // [START text_gen_text_only_prompt]

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );

    final response = await model.generateContent([Content.text(message)]);
    return response.text ?? "";
    print(response.text);
    // [END text_gen_text_only_prompt]
  }
}
