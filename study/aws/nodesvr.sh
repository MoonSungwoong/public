rm -rf node
mkdir node
cat <<EOF > $(pwd)/node/app.js
const express = require('express');
const mysql = require('mysql');
const app = express();
const port = 3000; // 원하는 포트 번호로 변경 가능

// MySQL 데이터베이스 연결 설정
const connection = mysql.createConnection({
  host: '10.0.0.26', // MySQL 서버 호스트
  user: 'user', // MySQL 사용자 이름
  password: 'userpwd', // MySQL 비밀번호
  database: 'Test', // 사용할 데이터베이스 이름
});

// MySQL 연결
connection.connect((err) => {
  if (err) throw err;
  console.log('Connected to MySQL database!');
});

// 웹페이지 렌더링을 위한 view engine 설정 (ejs 사용)
app.set('view engine', 'ejs');

// '/' 경로로 요청이 들어왔을 때 InfoTest 테이블 데이터를 가져와 웹페이지 렌더링
app.get('/', (req, res) => {
  const query = 'SELECT * FROM InfoItem';

  connection.query(query, (err, results) => {
    if (err) throw err;

    // InfoTest 테이블의 데이터를 results로 받아와 'index.ejs' 뷰를 렌더링
    res.render('index', { data: results });
  });
});

// 서버 시작
app.listen(port, () => {
  console.log(\`Server is running on http://localhost:${port}\`);
});
EOF

mkdir node/views
cat <<EOF > $(pwd)/node/views/index.ejs
<!DOCTYPE html>
<html>
<head>
  <title>Test Data</title>
</head>
<body>
  <h1>InfoTest Table Data</h1>
  <ul>
    <% data.forEach(item => { %>
      <li>itemId: <%= item.itemId %>, itemName: <%= item.itemName %></li>
    <% }); %>
  </ul>
</body>
</html>
EOF


cd node
yum install npm
npm install mysql express ejs
cd ..

docker run -d --rm --name nodesvr -p 3000:3000 -v ~/node:/usr/src/app -w /usr/src/app node:14 node app.js
