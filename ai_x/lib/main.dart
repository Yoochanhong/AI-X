import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            postApi();
          },
          child: Text('버튼'),
        ),
      ),
    );
  }
}

Future<dynamic> postApi(dynamic input) async {
  var dio = new Dio();
  try {
    dio.options.contentType = 'multipart/form-data';
    dio.options.maxRedirects.isFinite;
    var response = await dio.patch(
      'http://192.168.0.70:5001/fileUpload',
      data: input,
    );
    print('성공적으로 업로드했습니다');
    return response.data;
  } catch (e) {
    print(e);
  }
}
