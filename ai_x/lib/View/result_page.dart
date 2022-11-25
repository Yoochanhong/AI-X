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
                child: Text(snapshot.data!.totalPrice.toString() + '원'));
          },
        ),
      ),
    );
  }
}
