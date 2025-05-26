const jwt = require('jsonwebtoken');
const { StatusCodes, ReasonPhrases } = require('http-status-codes');

/**
 * JWT 검증 미들웨어
 * 
 * 헤더에 있는 Authorization 내용을 검증하고, 유효한 JWT일 경우 rea.user에 디코딩된 정보를 저장한다.
 */

module.exports = (req, res, next) => {
  const token = req.headers["authorization"];

  if (!token) {
    return res.status(StatusCodes.UNAUTHORIZED).json({
      code: StatusCodes.UNAUTHORIZED,
      httpStatus: ReasonPhrases.UNAUTHORIZED,
      message: 'Token not provided',
    });
  }

  jwt.verify(token, process.env.JWT_KEY, (err, decoded) => {
    if (err) {
      return res.status(StatusCodes.UNAUTHORIZED).json({
        code: StatusCodes.UNAUTHORIZED,
        httpStatus: ReasonPhrases.UNAUTHORIZED,
        message: 'Invalid token',
        error: err,
      });
    }

    req.user = decoded;
    next();
  });
}