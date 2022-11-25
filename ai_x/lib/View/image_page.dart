import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_x/View/result_page.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 7.5.w,
              height: 10.0.h,
              child: PageView.builder(
                controller:
                PageController(initialPage: 0, viewportFraction: 0.8),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getWhat(index),
                        style: TextStyle(fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          'http://192.168.50.219:5001/static/images/${index}_image.png',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              width: 7.0.w,
              height: 1.0.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ResultPage();
                  }));
                },
                child: Text('견적 알아보러 가기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
