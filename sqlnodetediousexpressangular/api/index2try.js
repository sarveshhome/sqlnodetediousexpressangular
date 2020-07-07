var Connection = require('tedious').Connection
var Request = require('tedious').Request

var config = {
  server: '.',
  authentication: {
    type: 'default',
    options: {
        port:1433,
      userName: 'sa', // update me
      password: 'password@123' // update me
    }
  }
}

var connection = new Connection(config)

connection.on('connect', function (err) {
  if (err) {
    console.log(err)
  } else {
    executeStatement()
  }
})

function executeStatement () {
    request = new Request("select 123, 'hello world'", function (err, rowCount) {
      if (err) {
        console.log(err)
      } else {
        console.log(rowCount + ' rows')
      }
      connection.close()
    })
  
    request.on('row', function (columns) {
      columns.forEach(function (column) {
        if (column.value === null) {
          console.log('NULL')
        } else {
          console.log(column.value)
        }
      })
    })
  
    connection.execSql(request)
  }