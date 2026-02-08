import 'package:canday_frontend/src/screen/auth/login.dart';
import 'package:canday_frontend/src/screen/auth/register.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 500,
            margin: EdgeInsets.only(bottom: 20),
            child: Image.asset(
              'assets/introImage1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(width: 15),
                  Text(
                    "‘사탕조각에 오신것을 환영합니다",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
              Container(height: 7),
              Row(
                children: [
                  Container(width: 15),
                  Text(
                    "사탕조각과 함께 하루하루의 일기를 모아보세요’",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              )
            ],
          ),
          Container(height: 30),
          Container(
            height: 50,
            width: double.infinity,
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(95, 215, 149, 100),
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
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
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
                fontSize: 9,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
