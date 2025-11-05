import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ServiceScreen{
  static const String baseUrl = 'https://agrisense-gno8.onrender.com/api/v1';
  Future <Map<dynamic, dynamic>> fieldsegment{
      File plant_img ;
      File mask_img ;


  }
}