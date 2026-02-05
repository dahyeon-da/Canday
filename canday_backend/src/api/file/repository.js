const { query } = require("../../data/index");

/**
 *
 * 이미지 업로드 처리 함수
 *
 * @param {string} imageFileID - 이미지의 원본 파일의 이름
 * @param {int} diaryNum - 해당 사진이 업로드 되는 일기 식별번호
 * @param {string} filePath - 사진의 경로
 * @param {int} fileSize - 사진의 크기
 */
exports.fileUpload = async (imageFileID, diaryNum, filePath, fileSize) => {
  const sql = `INSERT INTO imagetable(imageFileID, diaryNum, filePath, fileSize) VALUES (?, ?, ?, ?);`;

  const result = await query(sql, [imageFileID, diaryNum, filePath, fileSize]);
  return result;
};

/**
 * 
 * 이미지 프리뷰 처리 함수
 * 
 * @param {int} diaryNum - 해당 사진이 업로드 되는 일기 식별번호
 */

exports.filePreview = async (diaryNum) => {
  const sql = `SELECT imageFileID, filePath, fileSize FROM imagetable WHERE diaryNum = ?;`;

  const [rows] = await query(sql, [diaryNum]);
  return rows;
};

/**
 * 단일 이미지 프리뷰 처리 함수
 * 
 * @param {string} imageFileID - 파일 아이디
 */

exports.oneImagePreview = async(imageFileID) => {
  const sql = `SELECT filePath FROM imagetable WHERE imageFileID = ?;`;
  const rows = await query(sql, [imageFileID]);

  return Array.isArray(rows) ? rows[0] : rows;
};