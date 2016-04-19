var mysql  = require('mysql'); 
var connection = mysql.createConnection({    
host     : 'localhost',  
user     : 'root',       
password :'zz25',        
port: '3306',  
database:'myssmsdb' ,          
});
connection.connect(function(err){
if(err){       
console.log('[query] - :'+err);
return;
}
console.log('[connection connect]  succeed!');
}); 
connection.query('SELECT password from account', function(err, rows, fields) {
if (err) {
console.log('[query] - :'+err);
return;
}
console.log('The solution is: ', rows[0]); 
}); 
//关闭connection
connection.end(function(err){
if(err){       
return;
}
console.log('[connection end] succeed!');
});
