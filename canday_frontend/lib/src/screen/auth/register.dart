import 'package:canday_frontend/src/controller/userController.dart';
import 'package:canday_frontend/src/screen/diary/diaryMain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final userController = Get.put(UserController());

  final TextEditingController _userEmailAdressController =
      TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _userPasswordCheckController =
      TextEditingController();
  final TextEditingController _userNicknameController = TextEditingController();
  final TextEditingController _userBirthController = TextEditingController();

  // '일기 쓰러가기' 즉 회원가입 버튼을 눌렀을 때 실행되는 함수
  _submitForm() async {
    final String userEmailAdress = _userEmailAdressController.text;
    final String userPassword = _userPasswordController.text;
    final String userPasswordCheck = _userPasswordCheckController.text;
    final String userNickname = _userNicknameController.text;
    final String userBirth = _userBirthController.text;

    if (userPassword != userPasswordCheck) {
      const message = "비밀번호가 서로 달라요";
    }

    // 회원가입 통신 로직
    bool result = await userController.register(
        userEmailAdress, userPassword, userNickname, userBirth);

    // 회원가입 성공 시 다음 화면으로 이동처리
    if (result) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Diarymain()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
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
          )),
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
                hintStyle: TextStyle(
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
              obscureText: true,
              decoration: InputDecoration(
                hintText: "비밀번호",
                hintStyle: TextStyle(
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

          // 비밀번호 확인 입력창
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: TextFormField(
              controller: _userPasswordCheckController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "비밀번호 확인",
                hintStyle: TextStyle(
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

          // 이름 입력창
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: TextFormField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                hintText: "이름",
                hintStyle: TextStyle(
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

          // 생일 입력창
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: TextFormField(
              controller: _userBirthController,
              decoration: InputDecoration(
                hintText: "생일",
                hintStyle: TextStyle(
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

          // 회원가입 완료 버튼 (일기 쓰러가기)
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
          Container(height: 20)
        ],
      ),
    );
  }
}

