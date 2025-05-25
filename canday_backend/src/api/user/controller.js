const {
  registerUser,
  findUserEmail,
  loginUser,
  findUserData,
} = require("./repository");
const jwt = require("../../middleware/jwt");
const crypto = require("crypto");
const { StatusCodes, ReasonPhrases } = require("http-status-codes");

// 회원가입
exports.register = async (req, res) => {
  const { userEmailAdress, userPassword, userNickname, userBirth } = req.body;

  // 이메일 중복 확인 함수
  let count = await findUserEmail(userEmailAdress);

  if (count > 0) {
    return res.status(StatusCodes.CONFLICT).json({
      code: StatusCodes.CONFLICT,
      httpStatus: ReasonPhrases.CONFLICT,
      message: "Duplicated Email Adress",
    });
  }

  // 비밀번호 암호화
  const result = await crypto.pbkdf2Sync(
    userPassword,
    process.env.SALT_KEY,
    50,
    100,
    "sha512"
  );

  // 회원가입 함수
  const { affectedRows, insertId } = await registerUser(
    userEmailAdress,
    result.toString("base64"),
    userNickname,
    userBirth
  );

  // 회원가입을 성공적으로 완료했을 때
  if (affectedRows > 0) {
    const token = await jwt.jwtSign({ userEmailAdress });

    const data = {
      userEmailAdress: userEmailAdress,
      userNickname: userNickname,
      userBirth: userBirth,
    };

    return res.status(StatusCodes.CREATED).json({
      code: StatusCodes.CREATED,
      httpStatus: ReasonPhrases.CREATED,
      message: "Register Successful",
      token: token,
      data: data,
    });
  } else {
    return res.send({ result: "fail" });
  }
};

// 로그인
exports.login = async (req, res) => {
  const { userEmailAdress, userPassword } = req.body;

  // 비밀번호 암호화
  let result = crypto.pbkdf2Sync(
    userPassword,
    process.env.SALT_KEY,
    50,
    100,
    "sha512"
  );

  // 로그인 함수
  let loginResult = await loginUser(userEmailAdress, result.toString("base64"));

  // 존재하는 이메일인지 확인
  let findEmail = await findUserEmail(userEmailAdress);

  if (findEmail > 0) {
    if (loginResult == null) {
      return res.status(StatusCodes.UNAUTHORIZED).json({
        code: StatusCodes.UNAUTHORIZED,
        httpStatus: ReasonPhrases.UNAUTHORIZED,
        message: "Invalid Password",
      });
    } else {
      const userData = await findUserData(userEmailAdress);
      let token = await jwt.jwtSign({ userEmailAdress });

      const data = {
        userEmailAdress: userData.userEmailAdress,
        userNickname: userData.userNickname,
        userBirth: userData.userBirth,
      };
      return res.status(StatusCodes.OK).json({
        code: StatusCodes.OK,
        httpStatus: ReasonPhrases.OK,
        message: "Login Successful",
        token: token,
        data: data,
      });
    }
  } else {
    return res.status(StatusCodes.NOT_FOUND).json({
      code: StatusCodes.NOT_FOUND,
      httpStatus: ReasonPhrases.NOT_FOUND,
      message: "Email Address Not Found",
    });
  }
};
