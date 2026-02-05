const { StatusCodes, ReasonPhrases } = require("http-status-codes");
const { fileUpload, filePreview, oneImagePreview } = require("./repository");
const path = require("path");

// 사진 업로드 메소드
exports.upload = async (req, res) => {
  const files = req.files;
  let { diaryNum } = req.params;

  if (!files || files.length === 0) {
    return res.status(StatusCodes.BAD_REQUEST).json({
      message: "No File Uploded",
    });
  }

  try {
    const data = [];

    for (const file of files) {
      const { affectedRows, insertId } = await fileUpload(
        file.filename,
        diaryNum,
        file.path,
        file.size,
      );

      if (affectedRows > 0) {
        data.push({
          imageFileID: file.filename,
          diaryNum,
          filePath: file.path,
          fileSize: file.size,
        });
      }
    }

    return res.status(StatusCodes.CREATED).json({
      code: StatusCodes.CREATED,
      httpStatus: ReasonPhrases.CREATED,
      message: "Images Upload Successful",
      data: data,
    });
  } catch (err) {
    console.error(err);
    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
      message: "Image Upload Error",
    });
  }
};

// 사진 프리뷰 메소드
exports.preview = async (req, res) => {
  let { diaryNum } = req.params;

  try {
    const images = await filePreview(diaryNum);
    console.log(images);

    // 이미지가 없는 경우
    if (!images || images.length === 0) {
      return res.status(StatusCodes.OK).json({
        code: StatusCodes.OK,
        httpStatus: ReasonPhrases.OK,
        message: "No Image",
        data: [],
      });
    }

    const data = images.map((image) => ({
      imageFileID: image.imageFileID,
      previewUrl: `/api/file/preview/image/${image.imageFileID}`,
      fileSize: image.fileSize,
    }));

    console.log(data);

    return res.status(StatusCodes.OK).json({
      code: StatusCodes.OK,
      httpStatus: ReasonPhrases.OK,
      message: "Preview Available",
      data,
    });
  } catch (err) {
    console.error(err);
    return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
      code: StatusCodes.INTERNAL_SERVER_ERROR,
      httpStatus: ReasonPhrases.INTERNAL_SERVER_ERROR,
      message: "Preview List Error",
    });
  }
};

// 단일 이미지 프리뷰 메소드
exports.previewImage = async (req, res) => {
  const { imageFileID } = req.params;

  const result = await oneImagePreview(imageFileID);

  const row = Array.isArray(result) ? result[0] : result;

  if (!row || !row.filePath) {
    return res.status(StatusCodes.NOT_FOUND).json({
      code: StatusCodes.NOT_FOUND,
      httpStatus: ReasonPhrases.NOT_FOUND,
      message: "Image Not Found",
    });
  }

  return res.sendFile(path.resolve(row.filePath));
};