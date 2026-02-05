const express = require('express');
const router = express.Router();
const verify = require("./middleware/jwtVerify");
const multer = require("multer");
const path = require("path");
const { v4: uuidv4 } = require("uuid");

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "storage/");
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname); // 🔥 .png
    cb(null, `${uuidv4()}${ext}`);
  },
});

const upload = multer({ storage });

const userController = require("./api/user/controller");
const diaryController = require("./api/diary/controller");
const fileController = require("./api/file/controller");

router.get("/", (req, res) => {
  res.send("Home");
});

router.post("/auth/register", userController.register);
router.post("/auth/login", userController.login);
router.patch("/auth/change/password", verify, userController.updatePassword);
router.patch("/auth/update/profile", verify, userController.updateProfile);
router.post("/auth/check/password", verify, userController.checkPassword);

router.post("/diary/write", verify, diaryController.diaryWrite);
router.delete("/diary/delete/:diaryNum", verify, diaryController.diaryDelete);
router.patch("/diary/modify/:diaryNum", verify, diaryController.diaryModify);
router.get("/diary/show/:diaryNum", verify, diaryController.diaryShow);
router.get("/diary/user/show/:userNum", verify, diaryController.showMyDiary);

router.post(
  "/api/file/:diaryNum",
  upload.array("image", 10),
  fileController.upload,
);
router.get("/api/file/:diaryNum", fileController.preview);
router.get("/api/file/preview/image/:imageFileID", fileController.previewImage);

module.exports = router;