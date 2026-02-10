import 'dart:async';

import 'package:canday_frontend/src/screen/auth/login.dart';
import 'package:canday_frontend/src/screen/auth/register.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  int currentPage = 0;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  List itemList = ["1", "2", "3", "4", "5", "6", "7"];

  @override
  void initState() {
    super.initState();
    itemList.shuffle();

    Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (currentPage < itemList.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              pageSnapping: true,
              controller: _pageController,
              itemCount: itemList.length,
              onPageChanged: (value) {},
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: 500,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Image.asset(
                    'assets/introImage' + itemList[index] + '.jpg',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(width: 10),
                  Text(
                    "‘사탕조각에 오신것을 환영합니다",
                    style: TextStyle(
                      fontSize: 23,
                      fontFamily: "handWritten1",
                    ),
                  ),
                ],
              ),
              Container(height: 3),
              Row(
                children: [
                  Container(width: 10),
                  Text(
                    "사탕조각과 함께 하루하루의 일기를 모아보세요’",
                    style: TextStyle(fontSize: 23, fontFamily: "handWritten1"),
                  ),
                ],
              )
            ],
          ),
          Container(height: 20),
          Container(
            height: 50,
            width: double.infinity,
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(90, 209, 144, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Register()));
                },
                child: Text(
                  "사탕 모으러가기",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: "handWritten2",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll(Colors.transparent)),
            child: Text(
              '기존 계정으로 로그인하기',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontFamily: "handWritten2",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
