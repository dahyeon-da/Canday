import 'package:canday_frontend/src/controller/userController.dart';
import 'package:canday_frontend/src/screen/auth/register.dart';
import 'package:canday_frontend/src/screen/diary/diaryMainPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
final userController = Get.put(UserController());

  final TextEditingController _userEmailAdressController =
      TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();

  // '일기 쓰러가기' 즉 로그인 버튼을 눌렀을 때 실행되는 함수
  _submitForm() async {
    final String userEmailAdress = _userEmailAdressController.text;
    final String userPassword = _userPasswordController.text;

    // 로그인 통신 로직
    Map<String, dynamic> result =
        await userController.login(userEmailAdress, userPassword);

    // 로그인 성공 시 다음 화면으로 이동처리
    if (result.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Diarymain(userNum: result['userNum'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          toolbarHeight: 80,
          title: Row(
            children: [
              Container(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 5),
                  Text(
                    "‘오늘의 마음을 기록해보세요",
                    style: TextStyle(fontSize: 23, fontFamily: "handWritten1"),
                  ),
                  Text(
                    "당신만의 작은 공간 “사탕조각” ’",
                    style: TextStyle(fontSize: 23, fontFamily: "handWritten1"),
                  )
                ],
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 이메일 입력창
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: TextFormField(
                controller: _userEmailAdressController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "이메일",
                  hintStyle:
                      TextStyle(
                    color: Color.fromRGBO(184, 194, 176, 100),
                    fontFamily: "handWritten2",
                    fontWeight: FontWeight.w300,
                    fontSize: 21,
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(206, 250, 163, 1), width: 1)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(132, 219, 46, 1), width: 2)),
                ),
              ),
            ),

            // 비밀번호 입력창
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: TextFormField(
                controller: _userPasswordController,
                keyboardType: TextInputType.visiblePassword,
                // obscureText: true,
                decoration: InputDecoration(
                  hintText: "비밀번호",
                  hintStyle:
                      TextStyle(
                    color: Color.fromRGBO(184, 194, 176, 100),
                    fontFamily: "handWritten2",
                    fontWeight: FontWeight.w300,
                    fontSize: 21,
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(206, 250, 163, 1), width: 1)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(132, 219, 46, 1), width: 2)),
                ),
              ),
            ),
            Container(height: 25),

            // 로그인 완료 버튼 (일기 쓰러가기)
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Container(
                  child: Text(
                    "일기 쓰러가기",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: "handWritten2"),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 13, 0, 13),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(193, 240, 147, 1),
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register()));
              },
              style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(Colors.transparent)),
              child: Text(
                '처음이에요',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: "handWritten2",
                ),
              ),
            ),

            Container(height: 20)
          ],
        ));
  }
}
