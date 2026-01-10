const {
  writeDiary,
  deleteDiary,
  modifyDiary,
  checkDiary,
} = require("./repository");
const { StatusCodes, ReasonPhrases } = require("http-status-codes");

// 일기 작성
exports.diaryWrite = async (req, res) => {
  const { diaryDate, diaryContent, emotionNum, diaryImageNum } = req.body;

  // 일기 작성 함수
  const { affectedRows, insertId } = await writeDiary(
    diaryDate,
    diaryContent,
    emotionNum,
    diaryImageNum
  );

  // 일기 작성을 성공적으로 완료했을 때
  if (affectedRows > 0) {
    const data = {
      diaryDate: diaryDate,
      diaryContent: diaryContent,
      emotionNum: emotionNum,
      diaryImageNum: diaryImageNum,
    };

    return res.status(StatusCodes.CREATED).json({
      code: StatusCodes.CREATED,
      httpStatus: ReasonPhrases.CREATED,
      message: "Diary Upload Successful",
      data: data,
    });
  } else {
    return res.status(StatusCodes.BAD_REQUEST).json({
      code: StatusCodes.BAD_REQUEST,
      httpStatus: ReasonPhrases.BAD_REQUEST,
      message: "Invalid Information",
    });
  }
};

// 일기 삭제
exports.diaryDelete = async (req, res) => {
  let diaryNum = req.params.diaryNum;
  console.log("🧪 req.body:", req.params.diaryNum);

  // 일기 삭제 함수
  const affectedRows = await deleteDiary(diaryNum);

  // 일기 삭제를 정상적으로 완료했을 때
  if (affectedRows > 0) {
    return res.status(StatusCodes.OK).json({
      code: StatusCodes.OK,
      httpStatus: ReasonPhrases.OK,
      message: "Delete Successful",
    });
  } else {
    return res.status(StatusCodes.NOT_FOUND).json({
      code: StatusCodes.NOT_FOUND,
      httpStatus: ReasonPhrases.NOT_FOUND,
      message: "A Non-Existent Post",
    });
  }
};

// 일기 수정
exports.diaryModify = async (req, res) => {
  let diaryNum = req.params.diaryNum;
  const { diaryDate, diaryContent, emotionNum, diaryImageNum } = req.body;

  // 일기 수정 함수
  const { affectedRows, inserId } = await modifyDiary(
    diaryNum,
    diaryDate,
    diaryContent,
    emotionNum,
    diaryImageNum
  );

  // 일기가 존재하는지 확인하는 함수
  const rows = await checkDiary(diaryNum);
  const check = rows[0].isExist;
  console.log(check);

  if (check < 1) {
    // 일기가 존재하지 않을때
    return res.status(StatusCodes.NOT_FOUND).json({
      code: StatusCodes.NOT_FOUND,
      httpStatus: ReasonPhrases.NOT_FOUND,
      message: "A Non-Existent Post",
    });
  } else {
    if (affectedRows > 0) {
      // 일기 수정이 성공했을 때
      const data = {
        diaryNum: diaryNum,
        diaryDate: diaryDate,
        diaryContent: diaryContent,
        emotionNum: emotionNum,
        diaryImageNum: diaryImageNum,
      };

      return res.status(StatusCodes.OK).json({
        code: StatusCodes.OK,
        httpStatus: ReasonPhrases.OK,
        message: "Modify Successful",
        data: data,
      });
    } else {
      return res.status(StatusCodes.UNAUTHORIZED).json({
        code: StatusCodes.UNAUTHORIZED,
        httpStatus: ReasonPhrases.UNAUTHORIZED,
        message: "Invalid Token",
      });
    }
  }
};
