const express = require('express');
const router = express.Router();
const verify = require("./middleware/jwtVerify");
const multer = require("multer");

const upload = multer({ dest: "storage/" });

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

// 이미지 파일 업로드
router.post(
  "/api/file/:diaryNum",
  upload.single("file"),
  fileController.upload,
);

module.exports = router;