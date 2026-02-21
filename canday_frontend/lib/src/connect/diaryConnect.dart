// 일기 통신에 대한 클래스

import 'package:canday_frontend/shared/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final GetStorage _storage = GetStorage();

class DiaryConnect extends GetConnect {
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

  // 토큰 받아오기
  get getToken async {
    return _storage.read("token");
  }

  // 일기 목록 불러오기 통신
  Future showDiaryList(int userNum) async {
    try {
      Response<dynamic> response = await get('/diary/user/show/${userNum}',
          headers: {'Authorization': await getToken});

      Map<String, dynamic> body = response.body;

      print('listData: $body');

      if (body['code'] == 200) {
        return body;
      } else if (body['code'] == 404) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('존재하지 않는 회원입니다.'),
          ),
        );
      }
    } catch (e) {
      print('error: $e');
    }
  }

  // 일기 상세정보 불러오기 통신
  Future showDiaryDetail(int diaryNum) async {
    try {
      Response<dynamic> response = await get('/diary/show/$diaryNum',
          headers: {'Authorization': await getToken});

      Map<String, dynamic> body = response.body;

      print('response: $body');

      if (body['code'] == 200) {
        return body;
      } else if (body['code'] == 404) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('존재하지 않는 일기입니다.'),
          ),
        );
      }
    } catch (e) {
      print('error: $e');
    }
  }
}
