const { StatusCodes, ReasonPhrases } = require("http-status-codes");
const { fileUpload } = require("./repository");

// 사진 업로드 메소드
exports.upload = async (req, res) => {
  const file = req.file;
  let { diaryNum } = req.params;

  // 사진 업로드 함수
  const { affectedRows, insertId } = await fileUpload(
    file.originalname,
    diaryNum,
    file.path,
    file.size,
  );

  if (affectedRows > 0) {
    const data = {
      imageFileID: file.originalname,
      diaryNum: diaryNum,
      filePath: file.path,
      fileSize: file.size,
    };

    return res.status(StatusCodes.CREATED).json({
      code: StatusCodes.CREATED,
      httpStatus: ReasonPhrases.CREATED,
      message: "Image Upload Successful",
      data: data,
    });
  } else {
    return res.status(StatusCodes.NOT_FOUND).json({
      code: StatusCodes.NOT_FOUND,
      httpStatus: ReasonPhrases.NOT_FOUND,
      message: "Image Upload Fail",
    });
  }
};
