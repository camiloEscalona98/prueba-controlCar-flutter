import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatGPTService {
  final String? apiKey = dotenv.env['KEY_CHAT_GPT'];

  Future<String> sendPrompt(List<int> numeros) async {
    final String? apiUrl = dotenv.env['API_CHAT_GPT'];

    String prompt = """
You are a Pokémon expert and a world champion. I will send you a list of Pokémon IDs from the first generation. Please provide a very brief text in Spanish que destaque las fortalezas específicas y únicas de los Pokémon en el equipo, mencionando sus habilidades o roles. No menciones los IDs ni uses encabezados.

Here is the list of IDs: ${numeros.join(", ")}

""";

    final Map<String, dynamic> requestBody = {
      "model": "gpt-4o-mini",
      "messages": [
        {"role": "user", "content": prompt}
      ],
      "max_tokens": 7000,
      "temperature": 0,
      "top_p": 1,
      "n": 1,
      "stream": false,
    };

    // Encabezados
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey"
    };

    // Hacer la solicitud POST
    final response = await http.post(
      Uri.parse(apiUrl!),
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Obtener el texto de la respuesta
      final String chatResponse =
          responseData['choices'][0]['message']['content'];
      String textoCorregido = utf8.decode(chatResponse.runes.toList());
      return textoCorregido;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }
}
