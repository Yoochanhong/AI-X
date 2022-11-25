import 'dart:async';
import 'dart:io';

import 'package:ai_x/View/image_page.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

enum CarSize { LightCar, CompectCar, MiddleCar, LargeCar }

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
  String intValueUploadUrl = 'http://192.168.50.219:5001/intUpload';
  bool isUplode = true;
  CarSize? carSize = CarSize.LightCar;

  Map<Enum, String> carValueInt = {
    CarSize.LightCar: '0',
    CarSize.CompectCar: '1',
    CarSize.MiddleCar: '2',
    CarSize.LargeCar: '3',
  };

  String getEnumIndex(Enum? index) {
    String enumIndex = carValueInt[index]!;
    return enumIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: image != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
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
                          ? Center(child: CircularProgressIndicator())
                          : Container(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('경차'),
                          Radio<CarSize>(
                              value: CarSize.LightCar,
                              groupValue: carSize,
                              onChanged: (CarSize? value) {
                                setState(() {
                                  carSize = value;
                                });
                              }),
                        ],
                      ),
                      Column(
                        children: [
                          Text('소형'),
                          Radio<CarSize>(
                              value: CarSize.CompectCar,
                              groupValue: carSize,
                              onChanged: (CarSize? value) {
                                setState(() {
                                  carSize = value;
                                });
                              }),
                        ],
                      ),
                      Column(
                        children: [
                          Text('중형'),
                          Radio<CarSize>(
                              value: CarSize.MiddleCar,
                              groupValue: carSize,
                              onChanged: (CarSize? value) {
                                setState(() {
                                  carSize = value;
                                });
                              }),
                        ],
                      ),
                      Column(
                        children: [
                          Text('대형'),
                          Radio<CarSize>(
                              value: CarSize.LargeCar,
                              groupValue: carSize,
                              onChanged: (CarSize? value) {
                                setState(() {
                                  carSize = value;
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
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
                  heroTag: 'gallery retry',
                  onPressed: () {
                    getImageFromGallery(ImageSource.gallery);
                  },
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  heroTag: 'send',
                  onPressed: () async {
                    ImagePost(image!);
                    await Future.delayed(const Duration(seconds: 4));
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
              heroTag: 'gallery',
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
    var dioInt = Dio();
    var formData =
        FormData.fromMap({'file': await MultipartFile.fromFile(input.path)});
    var formDataInt = FormData.fromMap({'num': getEnumIndex(carSize)});
    print(getEnumIndex(carSize));
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;
      var response = await dio.post(
        fileUploadUrl,
        data: formData,
      );
    } catch (e) {
      print(e);
    }
    setState(() {
      isUplode = true;
    });
    try {
      dioInt.options.contentType = 'text/plain';
      var responseInt = await dioInt.post(
        intValueUploadUrl,
        data: formDataInt,
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
