import 'package:canday_frontend/shared/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final GetStorage _getStorage = GetStorage();

// 회원 통신에 관한 클래스
class UserConnect extends GetConnect {
  @override
  void onInit() {
    allowAutoSignedCert = true;
    httpClient.baseUrl = Global.apiRoot;
    httpClient.addRequestModifier<void>((request) {
      request.headers['Accept'] = 'application/json';
      return request;
    });
    super.onInit();
  }

  // 회원가입 통신
  Future sendRegister(String userEmailAdress, String userPassword,
      String userNickname, String userBirth) async {
    Response<dynamic> response = await post('/auth/register', {
      'userEmailAdress': userEmailAdress,
      'userPassword': userPassword,
      'userNickname': userNickname,
      'userBirth': userBirth
    });
    print('body: ${response.body} ');

    Map<String, dynamic> body = response.body;

    if (body['code'] == 201) {
      return body['token']; // 회원가입 성공 시 토큰 반환
    } else if (body['code'] == 403) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('이메일이 중복되었습니다.'),
        ),
      );
    } else {
      throw Exception(body['code']);
    }
  }

  // 로그인 통신
  Future sendLogin(String userEmailAdress, String userPassword) async {
    Response<dynamic> response = await post('/auth/login', {
      'userEmailAdress': userEmailAdress,
      'userPassword': userPassword,
    });
    print('body: ${response.body} ');

    Map<String, dynamic> body = response.body;

    if (body['code'] == 200) {
      return body['token']; // 로그인 성공 시 토큰 반환
    } else if (body['code'] == 404) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('존재하지 않는 이메일입니다.'),
        ),
      );
    } else if (body['code'] == 401) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('올바르지 않는 비밀번호입니다.'),
        ),
      );
    } else {
      throw Exception(body['code']);
    }
  }
}
