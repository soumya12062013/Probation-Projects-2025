import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';


import 'auth_screen.dart';

class ServiceScreen {
  static const String baseUrl = 'https://agrisense-gno8.onrender.com/api/v1';

  final AuthService _auth = AuthService();

  Future<Map<dynamic, dynamic>> fieldsegment({
    required File plant_image,
    required File mask_image,
  }) async {
    try {
      final String? token = await _auth.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'User not authenticated. Please log in.',
        };
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/inference/segment'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(
        await http.MultipartFile.fromPath('plant_image', plant_image.path),
      );
      request.files.add(
        await http.MultipartFile.fromPath('mask_imgage', mask_image.path),
      );
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message':
              'Image upload failed. Status: ${response.statusCode}, Body: ${response.body}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }




  Future<Map<dynamic, dynamic>> disease({required File image}) async {
    try {
      final String? token = await _auth.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'User not authenticated. Please log in.',
        };
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/inference/disease'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message':
              'Image upload failed. Status: ${response.statusCode}, Body: ${response.body}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  Future<Map<dynamic,dynamic>> yieldPrediction({
    required String cropType,
    required String diseaseClass,
    required double healthyArea,
    required double weedArea,
    required double soilArea,
  }) async {
    try {
      final String? token = await _auth.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'User not authenticated. Please log in.',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/inference/yield'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'crop_type': cropType,
          'disease_class': diseaseClass,
          'healthy_area': healthyArea,
          'weed_area': weedArea,
          'soil_area': soilArea,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message':
              'Yield prediction failed. Status: ${response.statusCode}, Body: ${response.body}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}
