const express = require('express');
const router = express.Router();

const userController = require('./api/user/controller');

router.get('/', (req, res) => {
  res.send('Home');
});

router.post('/auth/register', userController.register);
router.post('/auth/login', userController.login);

module.exports = router;