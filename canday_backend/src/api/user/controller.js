const {
  registerUser,
  findUserEmail,
  findUserData,
  findByUserEmail,
  passwordUpdate,
  profileUpdate,
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

// 비밀번호 변경 메소드
exports.updatePassword = async (req, res) => {
  const { originPassword, newPassword } = req.body;
  const userEmailAdress = req.user.userEmailAdress;

  // 기존 비밀번호 암호화를 위한 기존 salt 값 찾기
  const user = await findByUserEmail(userEmailAdress);

  // 비밀번호 암호화
  const hashed = hashPassword(originPassword, user.userSalt);

  if (hashed !== user.userPassword) {
    return res.status(StatusCodes.UNAUTHORIZED).json({
      code: StatusCodes.UNAUTHORIZED,
      httpStatus: ReasonPhrases.UNAUTHORIZED,
      message: "Invalid Password",
    });
  } else {
    // 새 비밀번호 암호화
    const newSalt = crypto.randomBytes(16).toString("hex");
    const newHashed = hashPassword(newPassword, newSalt);

    const { affectedRows, insertId } = await passwordUpdate(
      newHashed,
      newSalt,
      userEmailAdress
    );
    if (affectedRows > 0) {
      return res.status(StatusCodes.OK).json({
        code: StatusCodes.OK,
        httpStatus: ReasonPhrases.OK,
        message: "Change Password Successful",
      });
    } else {
      return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
        code: StatusCodes.INTERNAL_SERVER_ERROR,
        httpStatus: ReasonPhrases.INTERNAL_SERVER_ERROR,
        message: "Failed To Update Password",
      });
    }
  }
};

// 비밀번호 인증 메소드
exports.checkPassword = async (req, res) => {
  const { userPassword } = req.body;

  const userEmailAdress = req.user.userEmailAdress;

  // 기존 비밀번호 암호화를 위한 기존 salt 값 찾기
  const user = await findByUserEmail(userEmailAdress);

  console.log(userEmailAdress);

  // 비밀번호 암호화
  const hashed = hashPassword(userPassword, user.userSalt);

  if (hashed !== user.userPassword) {
    return res.status(StatusCodes.UNAUTHORIZED).json({
      code: StatusCodes.UNAUTHORIZED,
      httpStatus: ReasonPhrases.UNAUTHORIZED,
      message: "Invalid Password",
    });
  } else {
    return res.status(StatusCodes.OK).json({
      code: StatusCodes.OK,
      httpStatus: ReasonPhrases.OK,
      message: "Correct Password",
      data: true,
    });
  }
};

// 회원정보 변경 메소드
exports.updateProfile = async (req, res) => {
  const { userEmailAdress, userNickname, userBirth } = req.body;
  const recentEmailAdress = req.user.userEmailAdress;

  // 존재하는 이메일인지 확인
  let findEmail = await findUserEmail(userEmailAdress);

  if (
    (findEmail > 0 && recentEmailAdress === userEmailAdress) ||
    findEmail === 0
  ) {
    // 회원정보 수정 함수
    const { affectedRows, insertId } = await profileUpdate(
      userEmailAdress,
      userNickname,
      userBirth,
      recentEmailAdress
    );

    if (affectedRows > 0) {
      // 회원정보 수정이 성공했을 때
      const data = {
        userEmailAdress: userEmailAdress,
        userBirth: userBirth,
        userNickname: userNickname,
      };

      return res.status(StatusCodes.OK).json({
        code: StatusCodes.OK,
        httpStatus: ReasonPhrases.OK,
        message: "Update Successful",
        data: data,
      });
    } else {
      return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
        code: StatusCodes.INTERNAL_SERVER_ERROR,
        httpStatus: ReasonPhrases.INTERNAL_SERVER_ERROR,
        message: "Failed To Update Profile",
      });
    }
  } else if (findEmail > 0 && recentEmailAdress !== userEmailAdress) {
    return res.status(StatusCodes.CONFLICT).json({
      code: StatusCodes.CONFLICT,
      httpStatus: ReasonPhrases.CONFLICT,
      message: "Duplicated Imail Adress",
    });
  }
};