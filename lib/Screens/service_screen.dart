import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:image_picker/image_picker.dart'; 
import 'dart:io';

class ServiceScreen {
  static const String baseUrl = 'https://agrisense-gno8.onrender.com/api/v1';

  Future<Map<dynamic, dynamic>> fieldsegment({
    required File plant_image, 
    required File mask_image,  
  }) async {
    try {
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/inference/segment'),
      );

      
      request.files.add(
        await http.MultipartFile.fromPath(
          'plant_img', 
          plant_image.path,
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'mask_img', 
          mask_image.path,
        ),
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
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
  Future<Map<dynamic,dynamic>> disease({
    required File plant_img,
    

  })
}