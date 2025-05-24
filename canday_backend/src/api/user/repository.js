const { query } = require('../../data/index');

/**
 * 회원가입 처리 함수
 * 
 * @param {string} userEmailAdress - 사용자의 이메일
 * @param {string} userPassword - 사용자의 비밀번호
 * @param {string} userNickname - 사용자의 닉네임
 * @param {Date} userBirth - 사용자의 생년월일 ex) YYYY-MM-DD
 */

exports.registerUser = async (userEmailAdress, userPassword, userNickname, userBirth) => {
  const sql = `INSERT INTO userTable(userEmailAdress, userPassword, userNickname, userBirth) VALUES(?, ?, ?, ?)`;
  return await query(sql, [userEmailAdress, userPassword, userNickname, userBirth]);
}

/**
 * 회원가입 시 이메일 중복 확인 함수
 * 
 * @param {string} userEmailAdress - 사용자의 이메일
 * 
 * return 이메일 중복 발견 시 null 값 반환
 */

exports.findUserEmail = async (userEmailAdress) => {
  const sql = `SELECT COUNT(*) AS count FROM userTable where userEmailAdress=?`;
  let result = await query(sql, [userEmailAdress]);
  return (result.length === 0) ? null : result[0].count;
}

/**
 * 로그인 처리 함수
 * 
 * @param {string} userEmailAdress - 사용자의 이메일
 * @param {string} userPassword - 사용자의 비밀번호
 * 
 * 로그인 실패 시 null 값 반환
 */

exports.loginUser = async (userEmailAdress, userPassword) => {
  const sql = `SELECT * FROM userTable WHERE userEmailAdress=? AND userPassword=?`;
  let result = await query(sql, [userEmailAdress, userPassword]);
  return (result.length === 0) ? null : result[0];
}

/**
 * 로그인 후 회원 정보 반납 함수
 * 
 * @param {string} userEmailAdress - 사용자의 이메일
 */

exports.findUserData = async (userEmailAdress) => {
  const sql = `SELECT * FROM userTable WHERE userEmailAdress=?`;
  let result = await query(sql, [userEmailAdress]);
  return (result.length === 0) ? null : result[0];
}