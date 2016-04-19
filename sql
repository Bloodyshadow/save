var config=require("../conf/config.js").config();
var mysql=require("mysql");
var connection=mysql.createConnection({
host:config.db.host,
user:config.db.user,
password:config.db.password,
port:config.db.port,
database:config.db.dbName
})


function query (sql,callback){
connection.query(sql,function(err,res,fields){//fields :catalog等信息无需返回
if (err) {
connection.rollback(function() {
throw err;
});
}
callback(err,res);
});
//connection.end();//关闭conn
}


function insert(sql,param,callback){
connection.query(sql, param, function(err, result) {
if (err) throw err;
connection.commit(function(err) {
if (err) {
connection.rollback(function() {
throw err;
});
}
callback(err,result);//res返回数据
});
});
}


function update(sql,arr,callback){
connection.query(sql,arr,function(err,result){
if (err) throw err;
connection.commit(function(err) {
if (err) {
connection.rollback(function() {
throw err;
});
}
callback(err,result);//res返回数据
});
});
}


function deleteB(sql,param,callback){
connection.query(sql, param, function(err, result) {
if (err) throw err;
connection.commit(function(err) {
if (err) {
connection.rollback(function() {
throw err;
});
}
//result.affectedRows
callback(err,result);//res返回数据
});
});
}

exports.query=query;
exports.insert=insert;
exports.update=update;
exports.delete=deleteB;

下面是支持pool方法的，用于查询：以及解决中文乱码问题
ps:严重的bugs啊，纠结了那么久，下面的query虽然解决了编码的转化问题，但是插入那里就始终支持不了，也暂时不支持，期待有更好的处理方法。目前所以的编码都改成utf8,所有的问题就已经解决。mark一下，身心疲惫。
var config=require("../conf/config.js").config();
var mysql=require("mysql");
var iconv = require('iconv-lite');
var pool = mysql.createPool({
host: config.db.host,
user: config.db.user,
password: config.db.password,
port: config.db.port,
database: config.db.dbName,
// charset: 'UTF8',//BIG5_CHINESE_CI default: UTF8_GENERAL_CI
typeCast: false
}
);




query=function (sql,callback){
pool.getConnection(function(err, connection) {
// Use the connection
connection.query({sql:sql,typeCast: function (field,next) {
//var_string blob long datetime
if(field.type =='VAR_STRING'||field.type=='BLOB'){
//console.log(iconv.decode(field.buffer(),'gbk'));
return iconv.decode(field.buffer(),'gbk');
}
return next();
}},function(err, rows,fields) {
// And done with the connection.
if (err) {
connection.rollback(function() {
// throw err;
callback(err,null);
});
}
callback(null,rows);
connection.release();
return ;
// Don't use the connection here, it has been returned to the pool.//返回池当中
});
});
}

coQuery=function(sql){
return function(callback) {
query(sql,callback);
};
}


function insert(sql,param,callback){
pool.getConnection(function(err, connection) {
// Use the connection
//pool.escape防sql注入
connection.query(pool.escape(sql),param, function(err, rows) {
// And done with the connection.
if (err) {
connection.rollback(function() {
// throw err;
callback(err,null);
});
}
connection.commit(function(err) {
if (err) {
connection.rollback(function() {
callback(err,null);
});
}
callback(null,rows);//res返回数据
connection.release();
return ;
});

// Don't use the connection here, it has been returned to the pool.//返回池当中
});
});
}
coInsert=function(sql,param){
return function(callback){
insert(sql,param._callback);
}
}


function update(sql,arr,callback){
pool.getConnection(function(err, connection) {
// Use the connection
connection.query(pool.escape(sql),arr, function(err, rows) {
// And done with the connection.
if (err) {
connection.rollback(function() {
// throw err;
callback(err,null);
});
}
connection.commit(function(err) {
if (err) {
connection.rollback(function() {
callback(err,null);
});
}
callback(err,rows);//res返回数据
connection.release();
return ;
});
// Don't use the connection here, it has been returned to the pool.//返回池当中
});
});

}

coUpdate=function(sql,arr){
return function(callback){
update(sql,arr,callback);
}
}


function deleteB(sql,param,callback){
pool.getConnection(function(err, connection) {
// Use the connection
connection.query(sql,param, function(err, rows) {
// And done with the connection.
if (err) {
connection.rollback(function() {
// throw err;
callback(err,null);
});
}
connection.commit(function(err) {
if (err) {
connection.rollback(function() {
throw err;
});
}
//result.affectedRows
callback(err,rows);//res返回数据
connection.release();
return ;
});
// Don't use the connection here, it has been returned to the pool.//返回池当中
});
});
}

coDelete =function(sql,param){
return function(callback){
deleteB(sql,param,callback);
}
}

exports.coQuery=coQuery;
exports.coInsert=coInsert;
exports.coUpdate=coUpdate;
exports.coDelete=coDelete;
这里面如何使用呢，可用co(function *(){
 var rest=DB.coQuery(xx);
var result=yield rest;//这里返回的是obj
})
