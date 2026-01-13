const {
  registerUser,
  findUserEmail,
  findUserData,
  findByUserEmail,
} = require("./repository");
const jwt = require("../../middleware/jwt");
const crypto = require("crypto");
const { StatusCodes, ReasonPhrases } = require("http-status-codes");

// 비밀번호 암호화 함수
function hashPassword(password, salt) {
  return crypto
    .pbkdf2Sync(password, salt, 100000, 64, "sha512")
    .toString("hex");
}

// 회원가입 메소드
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
  const salt = crypto.randomBytes(16).toString("hex");
  const hashed = hashPassword(userPassword, salt);

  // 회원가입 함수
  const { affectedRows, insertId } = await registerUser(
    userEmailAdress,
    hashed,
    userNickname,
    userBirth,
    salt
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

// 로그인 메소드
exports.login = async (req, res) => {
  const { userEmailAdress, userPassword } = req.body;

  // 존재하는 이메일인지 확인
  let findEmail = await findUserEmail(userEmailAdress);

  if (findEmail > 0) {
    // 해당 회원의 비밀번호를 불러오는 함수
    const user = await findByUserEmail(userEmailAdress);
    const hashed = hashPassword(userPassword, user.userSalt);
    const originPassword = user.userPassword;

    if (hashed !== originPassword) {
      return res.status(StatusCodes.UNAUTHORIZED).json({
        code: StatusCodes.UNAUTHORIZED,
        httpStatus: ReasonPhrases.UNAUTHORIZED,
        message: "Invalid Password",
      });
    } else {
      const userData = await findUserData(userEmailAdress);
      let token = await jwt.jwtSign({
        userEmailAdress: userEmailAdress,
        userNum: userData.userNum,
      });

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

// 회원 정보 변경 메소드
exports.updateProfile = async (req, res) => {
  const { userPassword } = req.body;
};