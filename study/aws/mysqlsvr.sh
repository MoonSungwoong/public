rm -rf init-scripts

mkdir init-scripts

cat <<EOF > $(pwd)/init-scripts/init-user.sql
CREATE USER 'user'@'%' IDENTIFIED BY 'userpwd';
GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' WITH GRANT OPTION;
CREATE DATABASE Test;
USE Test;
CREATE TABLE InfoItem (itemId int, itemName varchar(30));
INSERT INTO InfoItem (itemId, itemName) values (1, 'Apple');
INSERT INTO InfoItem (itemId, itemName) values (2, 'Orange');
INSERT INTO InfoItem (itemId, itemName) values (3, 'Grape');
EOF

docker run -d --rm --name mysqlsvr -e MYSQL_ROOT_PASSWORD=rootpwd -v $(pwd)/init-scripts:/docker-entrypoint-initdb.d -p 3306:3306 mysql:latest