import 'dart:async';
import 'package:ai_x/Model/price.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<Price> getPrice() async {
  final response = await http.get(Uri.parse('http://192.168.50.219:5001/printed'));
  print(response.body);
  if (response.statusCode == 200) {
    return Price.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('예외');
  }
}