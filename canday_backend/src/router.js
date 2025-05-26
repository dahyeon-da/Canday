const express = require('express');
const router = express.Router();
const verify = require("./middleware/jwtVerify");

const userController = require("./api/user/controller");
const diaryController = require("./api/diary/controller");

router.get("/", (req, res) => {
  res.send("Home");
});

router.post("/auth/register", userController.register);
router.post("/auth/login", userController.login);

router.post("/diary/write", verify, diaryController.diaryWrite);
// router.post("/diary/delete");

module.exports = router;