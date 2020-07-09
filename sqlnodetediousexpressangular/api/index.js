var express = require('express');
var Connection = require('express4-tedious');
var Request = require('tedious').Request;
var TYPES = require('tedious').TYPES;
var app = express();
var cors = require('cors');

var port = process.env.PORT || 8091;
var router = express.Router();
app.use(cors());

// Create connection to database
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
var connection = new Connection(config);

app.use(function(req,res,next){
  req.sql =Connection(config);
  next();
});

router.get('/employees',function(req,res){
  req.sql("Select JSON=[dbo].[udf-Str-JSON](0,1,(SELECT [EMPNO],[ENAME],[JOB],[MGR],[SAL],[COMM],dname,loc FROM [dbo].[EMP] inner join dbo.dept on dbo.emp.DEPTNO = dbo.dept.deptno for XML RAW))").into(res);
});


router.get('/employees/:id',function(req,res){
  let idtosearch = req.params.id;
  console.log(idtosearch);  
  req.sql("Select JSON=[dbo].[udf-Str-JSON](0,1,(SELECT [EMPNO],[ENAME] ,[JOB],[MGR],[HIREDATE],[SAL],[COMM],[DEPTNO],homecity,homecountry,fathername,homestate,basicsal,totalexp,spousename,havekids FROM [Products].[dbo].[EMP] inner join emp_Details   on emp.EMPNO = emp_details.id  where emp.EMPNO = @id for XML RAW))")
  .param('id',req.params.id,TYPES.Int)
  .into(res);
});




app.use('/api', router);
app.listen(port);
console.log('REST API is runnning at ' + port);