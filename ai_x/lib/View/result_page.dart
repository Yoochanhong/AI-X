import 'package:ai_x/Model/price.dart';
import 'package:ai_x/ViewModel/get_price.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Future<Price>? priceData;

  @override
  void initState() {
    super.initState();
    priceData = getPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: FutureBuilder(
          future: priceData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('요청하신 데이터를 받아오지 못했어요 ㅠ'));
            }
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('XX한 면적 : ' +snapshot.data!.crushed!.area.toString()),
                  Text('XX한 면적의 예상가격 : ' + snapshot.data!.crushed!.price.toString()),
                  Text('XX한 면적 : ' + snapshot.data!.damaged!.area.toString()),
                  Text('XX한 면적의 예상가격 : ' + snapshot.data!.damaged!.price.toString()),
                  Text('XX한 면적 : ' + snapshot.data!.scratched!.area.toString()),
                  Text('XX한 면적의 예상가격 : ' + snapshot.data!.scratched!.price.toString()),
                  Text('XX한 면적 : ' + snapshot.data!.seperationed!.area.toString()),
                  Text('XX한 면적의 예상가격 : ' + snapshot.data!.seperationed!.price.toString()),
                  Text('총 가격 : ' + snapshot.data!.totalPrice.toString()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
