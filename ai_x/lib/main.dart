import 'dart:async';
import 'dart:io';

import 'package:ai_x/View/image_page.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
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
  String intValueUploadUrl = 'http://192.168.50.219:5001/intUpload/';
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
                          ? Center(
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text('??????'),
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
                          const Text('??????'),
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
                          const Text('??????'),
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
                          const Text('??????'),
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      '50cm ????????? ???????????? 1????????? ????????? ????????? ??? ???????????? ?????????!',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  DottedBorder(
                    child: SizedBox(
                      width: 6.0.w,
                      height: 6.0.w,
                      child: const Center(child: Text('???????????? ?????????????????????.')),
                    ),
                    dashPattern: const [5, 3],
                    color: Colors.black,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10.0),
                  ),
                ],
              ),
      ),
      floatingActionButton: image != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'gallery retry',
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  heroTag: 'send',
                  onPressed: () async {
                    await textPost();
                    await imagePost(image!);
                    Future.delayed(Duration(milliseconds: 200));
                    await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return NextPage();
                    }));
                  },
                  child: const Icon(Icons.send),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'camera',
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                  child: const Icon(Icons.camera_alt_sharp),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  heroTag: 'gallery',
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  child: const Icon(Icons.photo),
                ),
              ],
            ),
    );
  }

  Future<dynamic> textPost() async {
    setState(() {
      isUplode = false;
    });
    print('???????????? ????????? ????????? ?????????.');
    print(getEnumIndex(carSize));
    var responseQuery =
        await http.get(Uri.parse(intValueUploadUrl + getEnumIndex(carSize)));
  }

  Future<dynamic> imagePost(XFile input) async {
    print("????????? ????????? ????????? ?????????.");
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
      setState(() {
        isUplode = true;
      });
      print('??????????????? ?????????????????????');
    } catch (e) {
      print(e);
    }
  }

  Future<void> getImage(ImageSource imageSource) async {
    final pickedFile =
        await picker.getImage(source: imageSource, imageQuality: 100);
    setState(() {
      image = XFile(pickedFile!.path);
    });
  }
}
