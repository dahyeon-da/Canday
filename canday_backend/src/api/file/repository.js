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

  const reqult = await query(sql, [imageFileID, diaryNum, dilePath]);
  return result;
};
