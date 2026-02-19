/**
 * "diaryNum": "2",
 * "diaryDate": "2002-07-20",
 * "emotionImage" : "excited",
 * "emotionColorCode" : "FFD1DC",
 * "emotionKorean" : "행복",
 * "userNum" : 1
 */
class DiaryListModel {
  int? diaryNum;
  DateTime? diaryDate;
  int? userNum;
  String? emotionImage;
  String? emotionColorCode;
  String? emotionKorean;

  DiaryListModel.fromJson(Map m) {
    diaryNum = m['diaryNum'];
    diaryDate = DateTime.parse(m['diaryDate']);
    userNum = m['userNum'];
    emotionImage = m['emotionImage'];
    emotionColorCode = m['emotionColorCode'];
    emotionKorean = m['emotionKorean'];
  }
}
