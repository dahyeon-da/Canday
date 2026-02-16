// 다이어리 동작에 관련된 클래스
import 'package:canday_frontend/src/connect/diaryConnect.dart';
import 'package:canday_frontend/src/model/diaryModel.dart';
import 'package:get/get.dart';

class DiaryController extends GetxController {
  // DiaryConnect 객체 생성
  final diaryConnect = Get.put(DiaryConnect());

  // 다이어리 목록 불러오기를 시도하는 함수
  Future<Map<String, dynamic>> diaryShow(int userNum) async {
    try {
      Map<String, dynamic> results = await diaryConnect.showDiaryList(userNum);
      List<dynamic> diarys = results['body'];
      List<DiaryListModel> diary = [];
      for (var result in diarys) {
        diary.add(DiaryListModel.fromJson(result));
      }

      results = {"diaryList": diary};
      print(results);
      return results;
    } catch (e) {
      print('error $e');
      return {"diaryList": []};
    }
  }
}
