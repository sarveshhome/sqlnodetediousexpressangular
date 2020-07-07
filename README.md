# sqlnodetediousexpressangular
sql + node+ tedious + express + angular



Run => cmd => ipconfig => IP 

https://github.com/tediousjs/tedious/blob/master/examples/parameters.js

https://debugmode.net/2017/03/03/step-by-step-building-node-js-based-rest-api-to-perform-crud-operations-on-mongodb/

https://stackoverflow.com/questions/25577248/node-js-mssql-tedius-connectionerror-failed-to-connect-to-localhost1433-conn

https://stackoverflow.com/questions/39883243/how-to-make-json-from-sql-query-in-ms-sql-2014

https://github.com/tediousjs/tedious/issues/931






`create FUNCTION [dbo].[udf-Str-JSON] (@IncludeHead int,@ToLowerCase int,@XML xml)
Returns varchar(max)
AS
Begin
    Declare @Head varchar(max) = '',@JSON varchar(max) = ''
    ; with cteEAV as (Select RowNr=Row_Number() over (Order By (Select NULL))
                            ,Entity    = xRow.value('@*[1]','varchar(100)')
                            ,Attribute = xAtt.value('local-name(.)','varchar(100)')
                            ,Value     = xAtt.value('.','varchar(max)') 
                       From  @XML.nodes('/row') As R(xRow) 
                       Cross Apply R.xRow.nodes('./@*') As A(xAtt) )
          ,cteSum as (Select Records=count(Distinct Entity)
                            ,Head = IIF(@IncludeHead=0,IIF(count(Distinct Entity)<=1,'[getResults]','[[getResults]]'),Concat('{"status":{"successful":"true","timestamp":"',Format(GetUTCDate(),'yyyy-MM-dd hh:mm:ss '),'GMT','","rows":"',count(Distinct Entity),'"},"results":[[getResults]]}') ) 
                       From  cteEAV)
          ,cteBld as (Select *
                            ,NewRow=IIF(Lag(Entity,1)  over (Partition By Entity Order By (Select NULL))=Entity,'',',{')
                            ,EndRow=IIF(Lead(Entity,1) over (Partition By Entity Order By (Select NULL))=Entity,',','}')
                            ,JSON=Concat('"',IIF(@ToLowerCase=1,Lower(Attribute),Attribute),'":','"',Value,'"') 
                       From  cteEAV )
    Select @JSON = @JSON+NewRow+JSON+EndRow,@Head = Head From cteBld, cteSum
    Return Replace(@Head,'[getResults]',Stuff(@JSON,1,1,''))
End
`
