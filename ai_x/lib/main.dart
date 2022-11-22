import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final viewModel = MainViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            viewModel.isLoading
                ? const CircularProgressIndicator()
                : Container(),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  viewModel.isLoading = true;
                });

                final bytes =
                    await rootBundle.load('assets/1111111111111111.jpeg');
                await viewModel.uploadImage(bytes.buffer.asUint8List());

                setState(() {
                  viewModel.isLoading = false;
                });
              },
              child: const Text('업로드 파일'),
            ),
          ],
        ),
      ),
    );
  }
}

class FileApi {
  final _dio = Dio();

  Future<Response> uploadImage(
    Uint8List image,
  ) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(image.buffer.asUint8List(),
          filename: '1111111111111111.jpeg'),
    });

    final response = await _dio.post(
      'http://192.168.0.70:5001/fileUpload',
      data: formData,
    );

    return response;
  }
}

class FileRepository {
  final _fileApi = FileApi();

  Future<bool> uploadImage(Uint8List image) async {
    try {
      await _fileApi.uploadImage(image);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}

class MainViewModel {
  final _repository = FileRepository();

  var isLoading = false;

  Future uploadImage(Uint8List image) async {
    await _repository.uploadImage(image);
  }
}
