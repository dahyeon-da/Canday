// 다이어리 동작에 관련된 클래스
import 'package:canday_frontend/src/connect/diaryConnect.dart';
import 'package:canday_frontend/src/model/diaryModel.dart';
import 'package:get/get.dart';

class DiaryController extends GetxController {
  // DiaryConnect 객체 생성
  final diaryConnect = Get.put(DiaryConnect());

  // 다이어리 목록 불러오기를 시도하는 함수
  Future<List<DiaryListModel>> diaryShow(int userNum) async {
    try {
      Map<String, dynamic> response = await diaryConnect.showDiaryList(userNum);

      List<dynamic> diarys = response['data'];

      return diarys.map((e) => DiaryListModel.fromJson(e)).toList();
    } catch (e) {
      print('error $e');
      return [];
    }
  }

  // 다이어리 상세정보 불러오기를 시도하는 함수
  Future<Map<String, dynamic>> diaryDetailShow(int diaryNum) async {
    try {
      Map<String, dynamic> response =
          await diaryConnect.showDiaryDetail(diaryNum);

      Map<String, dynamic> data = response['data'];

      print('detail: $data');
      return data;
    } catch (e) {
      return {};
    }
  }
}
