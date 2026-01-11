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
};

/**
 * 일기 수정 처리 함수
 *
 * @param {int} diaryNum - 일기 식별번호
 * @param {Date} diaryDate - 일기 작성 날짜 ex) YYYY-MM-DD
 * @param {String} diaryContent - 일기 내용
 * @param {int} emotionNum - 감정 번호
 * @param {int} diaryImageNum - 일기에 첨부한 사진 번호 - NULL 가능
 */

exports.modifyDiary = async (
  diaryNum,
  diaryDate,
  diaryContent,
  emotionNum,
  diaryImageNum
) => {
  const sql = `UPDATE diaryTable SET diaryContent = ?, emotionNum = ?,
  diaryImageNum = ? WHERE diaryNum = ?;
  `;
  return await query(sql, [diaryContent, emotionNum, diaryImageNum, diaryNum]);
};

/**
 * 일기 수정 시 존재하는 일기인지 확인하는 함수
 * 
 * @param {int} diaryNum - 일기 식별번호
 */

exports.checkDiary = async (
  diaryNum
) => {
  const sql = `SELECT EXISTS(SELECT 1 FROM diaryTable WHERE diaryNum = ?) AS isExist;
  `;
  return await query(sql, [diaryNum]);
};

/**
 * 일기에 대한 모든 정보 불러오는 함수
 * 
 * @param {int} diaryNum - 일기 식별번호
 */

exports.showDiary = async(
  diaryNum
) => {
  const sql = `SELECT d.diaryNum, d.diaryDate, d.diaryContent, d.diaryImageNum, e.emotionImage, e.emotionColorCode, e.emotionKorean FROM diarytable d INNER JOIN emotiontable e ON d.emotionNum = e.emotionNum WHERE d.diaryNum = ?;`;

  const rows = await query(sql, [diaryNum]);

  return await rows[0];
}