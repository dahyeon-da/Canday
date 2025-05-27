const { query } = require("../../data/index");

/**
 * 일기 작성 처리 함수
 *
 * @param {Date} diaryDate - 일기 작성 날짜 ex)YYYY-MM-DD
 * @param {string} diaryContent - 일기 내용
 * @param {int} emotionNum - 감정 번호
 * @param {int} diaryImageNum - 일기에 첨부한 사진 번호 - NULL 가능
 */

exports.writeDiary = async (
  diaryDate,
  diaryContent,
  emotionNum,
  diaryImageNum
) => {
  const sql = `INSERT INTO diaryTable(diaryDate, diaryContent, emotionNum, diaryImageNum) VALUES (?, ?, ?, ?)`;
  return await query(sql, [diaryDate, diaryContent, emotionNum, diaryImageNum]);
};

/**
 * 일기 삭제 처리 함수
 * 
 * @param {int} diaryNum - 일기 식별번호
 */

exports.deleteDiary = async (diaryNum) => {
  const sql = `DELETE FROM diaryTable WHERE diaryNum = ?`;
  let result = await query(sql, [diaryNum]);
  return result.affectedRows;
}