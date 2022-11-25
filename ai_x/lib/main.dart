import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(7.5, 15),
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final picker = ImagePicker();
  XFile? image;
  String fileUploadUrl = 'http://192.168.50.219:5001/fileUpload';
  bool isUplode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: image != null
            ? Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: 6.0.w,
                    height: 6.0.h,
                    child: Image.file(
                      File(image!.path),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                isUplode == false
                    ? const Center(child: CircularProgressIndicator())
                    : Container(),
              ],
            )
            : DottedBorder(
                child: SizedBox(
                  width: 6.0.w,
                  height: 6.0.w,
                  child: const Center(child: Text('이미지를 업로드해주세요.')),
                ),
                dashPattern: const [5, 3],
                color: Colors.black,
                borderType: BorderType.RRect,
                radius: const Radius.circular(10.0),
              ),
      ),
      floatingActionButton: image != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    getImageFromGallery(ImageSource.gallery);
                  },
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () async {
                    ImagePost(image!);
                    await Future.delayed(const Duration(seconds: 5));
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return NextPage();
                    }));
                  },
                  child: const Icon(Icons.send),
                ),
              ],
            )
          : FloatingActionButton(
              onPressed: () {
                getImageFromGallery(ImageSource.gallery);
              },
              child: const Icon(Icons.camera_alt_sharp),
            ),
    );
  }

  Future<dynamic> ImagePost(XFile input) async {
    setState(() {
      isUplode = false;
    });
    print("사진을 서버에 업로드 합니다.");
    var dio = Dio();
    var formData =
        FormData.fromMap({'file': await MultipartFile.fromFile(input.path)});
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;
      var response = await dio.post(
        fileUploadUrl,
        data: formData,
      );
      print('성공적으로 업로드했습니다');
      setState(() {
        isUplode = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future getImageFromGallery(ImageSource imageSource) async {
    final pickedFile =
        await picker.getImage(source: imageSource, imageQuality: 100);
    setState(() {
      image = XFile(pickedFile!.path);
    });
  }
}

class NextPage extends StatelessWidget {
  NextPage({Key? key}) : super(key: key);

  var what = {
    0: '긁힌 부분',
    1: '이격된 부분',
    2: '찌그러진 부분',
    3: '파손된 부분',
  };

  String getWhat(int index) {
    String wWwWhat = what[index]!;
    return wWwWhat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PageView.builder(
            controller: PageController(
              initialPage: 0,
            ),
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(getWhat(index)),
                  Image.network(
                    'http://192.168.50.219:5001/static/images/${index}_image.png',
                  ),
                ],
              );
            }),
      ),
    );
  }
}
