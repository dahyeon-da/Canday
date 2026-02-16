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
  String? emotionImage;
  String? emotionColorCode;
  String? emotionKorean;
  int? userNum;

  DiaryListModel.fromJson(Map m) {
    diaryNum = m['diaryNum'];
    diaryDate = m['diaryDate'];
    emotionImage = m['emotionImage'];
    emotionColorCode = m['emotionColorCode'];
    emotionKorean = m['emotionKorean'];
    userNum = m['userNum'];
  }
}
