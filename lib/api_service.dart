import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Alamat IP Ubuntu kamu yang terbaru
  static const String baseUrl = "http://192.168.18.7/api/style";

  static Future<Map<String, dynamic>> analyzeFace({
    required File imageFile,
    required String gender,
    required bool isHijab,
    required String userId,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/analyze"));

      // Kirim file gambar
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      // Kirim data pendukung
      request.fields['user_id'] = userId;
      request.fields['gender'] = gender;
      request.fields['is_hijab'] = isHijab.toString();

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"status": "error", "message": "Server Ubuntu error (${response.statusCode})"};
      }
    } catch (e) {
      return {"status": "error", "message": "Koneksi Gagal: $e"};
    }
  }
}