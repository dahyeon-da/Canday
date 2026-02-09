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
    httpClient.addRequestModifier<void>((request) {
      print('👉 REQUEST URL: ${request.url}');
      print('👉 METHOD: ${request.method}');
      print('👉 HEADERS: ${request.headers}');
      return request;
    });
    print('🔥 REGISTER REQUEST PATH: /auth/register');
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
}
