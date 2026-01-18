const { query } = require("../../data/index");

/**
 * 회원가입 처리 함수
 *
 * @param {string} userEmailAdress - 사용자의 이메일
 * @param {string} userPassword - 사용자의 비밀번호
 * @param {string} userNickname - 사용자의 닉네임
 * @param {Date} userBirth - 사용자의 생년월일 ex) YYYY-MM-DD
 */

exports.registerUser = async (
  userEmailAdress,
  userPassword,
  userNickname,
  userBirth,
  userSalt
) => {
  const sql = `INSERT INTO userTable(userEmailAdress, userPassword, userNickname, userBirth, userSalt) VALUES(?, ?, ?, ?, ?)`;
  return await query(sql, [
    userEmailAdress,
    userPassword,
    userNickname,
    userBirth,
    userSalt,
  ]);
};

/**
 * 회원가입 또는 회원정보 변경 시 이메일 중복 확인 함수
 *
 * @param {string} userEmailAdress - 사용자의 이메일
 *
 * return 이메일 중복 발견 시 null 값 반환
 */

exports.findUserEmail = async (userEmailAdress) => {
  const sql = `SELECT COUNT(*) AS count FROM userTable where userEmailAdress=?`;
  let result = await query(sql, [userEmailAdress]);
  return result.length === 0 ? null : result[0].count;
};

// /**
//  * 로그인 처리 함수
//  *
//  * @param {string} userEmailAdress - 사용자의 이메일
//  * @param {string} userPassword - 사용자의 비밀번호
//  *
//  * 로그인 실패 시 null 값 반환
//  */

// exports.loginUser = async (userEmailAdress, userPassword) => {
//   const sql = `SELECT * FROM userTable WHERE userEmailAdress=? AND userPassword=?`;
//   let result = await query(sql, [userEmailAdress, userPassword]);
//   return (result.length === 0) ? null : result[0];
// }

/**
 * 로그인 후 회원 정보 반납 함수
 *
 * @param {string} userEmailAdress - 사용자의 이메일
 */

exports.findUserData = async (userEmailAdress) => {
  const sql = `SELECT * FROM userTable WHERE userEmailAdress=?`;
  let result = await query(sql, [userEmailAdress]);
  return result.length === 0 ? null : result[0];
};

/**
 * 비밀번호 확인을 위한 유저 정보를 가져오는 함수
 *
 * @param {string} userEmailAdress - 사용자의 이메일
 */

exports.findByUserEmail = async (userEmailAdress) => {
  const sql = `SELECT userNum, userPassword, userSalt FROM usertable WHERE userEmailAdress =?`;

  const [rows] = await query(sql, [userEmailAdress]);
  return rows;
};

/**
 * 비밀번호 변경 함수
 *
 * @param {string} newPassword - 새로운 비밀번호
 * @param {string} salt - 새로운 암호화값
 * @param {string} userEmailAdress - 사용자의 이메일 주소
 */

exports.passwordUpdate = async (newPassword, newSalt, userEmailAdress) => {
  const sql = ` UPDATE usertable SET userPassword = ?, userSalt = ? WHERE userEmailAdress = ?;`;

  return await query(sql, [newPassword, newSalt, userEmailAdress]);
};

/**
 * 회원정보 변경 함수
 *
 * @param {string} userEmailAdress - 사용자의 이메일 주소
 * @param {string} userNickname - 사용자의 닉네임
 * @param {date} userBirth - 사용자의 생년월일
 */

exports.profileUpdate = async (
  userEmailAdress,
  userNickname,
  userBirth,
  recentEmailAdress
) => {
  const sql = `update usertable set userEmailAdress = ?, userNickname = ?, userBirth = ? where userEmailAdress = ?;`;

  return await query(sql, [
    userEmailAdress,
    userNickname,
    userBirth,
    recentEmailAdress,
  ]);
};
