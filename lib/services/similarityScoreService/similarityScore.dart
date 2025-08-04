import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class SimilarityScoreService {
  final String apiUrl = 'https://2344-2404-3100-104a-bf31-98af-44a2-5dcd-bbe4.ngrok-free.app';

  Future<double?> getMatchScore({
    required File resumeFile,
    required String jobDescription,
  }) async {
    try {
      final uri = Uri.parse('$apiUrl/');

      final fileExtension = extension(resumeFile.path).toLowerCase();
      MediaType? contentType;

      switch (fileExtension) {
        case '.pdf':
          contentType = MediaType('application', 'pdf');
          break;
        case '.doc':
          contentType = MediaType('application', 'msword');
          break;
        case '.docx':
          contentType = MediaType('application', 'vnd.openxmlformats-officedocument.wordprocessingml.document');
          break;
        case '.txt':
          contentType = MediaType('text', 'plain');
          break;
        default:
          throw Exception('Unsupported file format: $fileExtension');
      }

      final request = http.MultipartRequest('POST', uri)
        ..fields['job_description'] = jobDescription
        ..files.add(await http.MultipartFile.fromPath(
          'resume',
          resumeFile.path,
          filename: basename(resumeFile.path),
          contentType: contentType,
        ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['similarity_score'] as num).toDouble();
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        print('Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }
}
