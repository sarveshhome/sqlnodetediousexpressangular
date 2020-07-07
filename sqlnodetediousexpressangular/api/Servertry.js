var express = require('express');
var bodyParser = require('body-parser');
 var Connection = require('tedious').Connection,
 Request = require('tedious').Request,
 TYPES = require('tedious').TYPES;
var async = require('async');
var cors = require('cors');
var app = express();
var mongoose = require('mongoose');
//var product = require('./product');
 
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
var port = process.env.PORT || 8090;
var router = express.Router();
app.use(cors());
// all other code will go here 

var config = {
	server: '192.168.56.1',
	authentication: {
            type: 'default',
            options: {
                        userName: 'sa',
                        password: 'password@123'
                    }
  },
  options: {
    port:1433,
    database: 'Products',
    encrypt: false,
    },
};


var connection = new Connection({
	server: '192.168.56.1',
	authentication: {
            type: 'default',
            options: {
                        userName: 'sa',
                        password: 'password@123'
                    }
  },
  options: {
    port:1433,
    database: 'Products',
    encrypt: false,
    },
});

connection.on('connect', function (err) {
    if (err) {
      console.log(err);
    } else {
      console.log('hi');
    }
  });


  app.use(function(req,res,next){
      req.sql =new Connection(config);
      next();
  });

  router.get('/employees',function(req,res){
      req.sql("Select JSON=[dbo].[udf-Str-JSON](0,1,(SELECT [EMPNO],[ENAME],[JOB],[MGR],[SAL],[COMM],dname,loc FROM [dbo].[EMP] inner join dbo.dept on dbo.emp.DEPTNO = dbo.dept.deptno for XML RAW))").into(res);
  });


 

app.use('/api', router);
app.listen(port);
console.log('REST API is runnning at ' + port);