const jwt = require('jsonwebtoken');

/**
 * JWT 토큰 생성 함수
 * 
 * @param {object} payload - 토큰에 담을 사용자 정보
 * @returns {Promise<string>} - 생성된 JWT 토큰 반환
 */

exports.jwtSign = (payload) => {
  return new Promise((resolve, reject) => {
    jwt.sign(payload, process.env.JWT_KEY,
      { expiresIn: '1h' },
      (err, token) => {
        if (err) {
          return reject(err);
        }
        resolve(token);
      }
    )
  })
}