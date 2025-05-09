const express = require('express'); 
const app = express(); 
const port = process.env.PORT || 3000; 
app.get('/', (req, res) => { 
    res.send('Hello World'); 
}); 

// 웹 서버 구동 및 포트번호 확인 문구
app.listen(port, () => { 
    console.log(`웹서버 구동... ${port}`); 
});
