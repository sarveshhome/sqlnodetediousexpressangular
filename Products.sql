USE [Products]
GO
/****** Object:  UserDefinedFunction [dbo].[udf-Str-JSON]    Script Date: 7/7/2020 1:20:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[udf-Str-JSON] (@IncludeHead int,@ToLowerCase int,@XML xml)
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
-- Parameter 1: @IncludeHead 1/0
-- Parameter 2: @ToLowerCase 1/0 (converts field name to lowercase
-- Parameter 3: (Select * From ... for XML RAW)

GO
/****** Object:  Table [dbo].[BONUS]    Script Date: 7/7/2020 1:20:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BONUS](
	[ENAME] [varchar](10) NULL,
	[JOB] [varchar](9) NULL,
	[SAL] [numeric](18, 0) NULL,
	[COMM] [numeric](18, 0) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DEPT]    Script Date: 7/7/2020 1:20:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DEPT](
	[DEPTNO] [numeric](2, 0) NULL,
	[DNAME] [varchar](14) NULL,
	[LOC] [varchar](13) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EMP]    Script Date: 7/7/2020 1:20:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EMP](
	[EMPNO] [numeric](4, 0) NOT NULL,
	[ENAME] [varchar](10) NULL,
	[JOB] [varchar](9) NULL,
	[MGR] [numeric](4, 0) NULL,
	[HIREDATE] [datetime] NULL,
	[SAL] [numeric](7, 2) NULL,
	[COMM] [numeric](7, 2) NULL,
	[DEPTNO] [numeric](2, 0) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SALGRADE]    Script Date: 7/7/2020 1:20:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SALGRADE](
	[GRADE] [numeric](18, 0) NULL,
	[LOSAL] [numeric](18, 0) NULL,
	[HISAL] [numeric](18, 0) NULL
) ON [PRIMARY]

GO
INSERT [dbo].[DEPT] ([DEPTNO], [DNAME], [LOC]) VALUES (CAST(10 AS Numeric(2, 0)), N'ACCOUNTING', N'NEW YORK')
INSERT [dbo].[DEPT] ([DEPTNO], [DNAME], [LOC]) VALUES (CAST(20 AS Numeric(2, 0)), N'RESEARCH', N'DALLAS')
INSERT [dbo].[DEPT] ([DEPTNO], [DNAME], [LOC]) VALUES (CAST(30 AS Numeric(2, 0)), N'SALES', N'CHICAGO')
INSERT [dbo].[DEPT] ([DEPTNO], [DNAME], [LOC]) VALUES (CAST(40 AS Numeric(2, 0)), N'OPERATIONS', N'BOSTON')
INSERT [dbo].[EMP] ([EMPNO], [ENAME], [JOB], [MGR], [HIREDATE], [SAL], [COMM], [DEPTNO]) VALUES (CAST(7499 AS Numeric(4, 0)), N'ALLEN', N'SALESMAN', CAST(7698 AS Numeric(4, 0)), CAST(N'1981-02-20 00:00:00.000' AS DateTime), CAST(1600.00 AS Numeric(7, 2)), CAST(300.00 AS Numeric(7, 2)), CAST(30 AS Numeric(2, 0)))
INSERT [dbo].[EMP] ([EMPNO], [ENAME], [JOB], [MGR], [HIREDATE], [SAL], [COMM], [DEPTNO]) VALUES (CAST(7521 AS Numeric(4, 0)), N'WARD', N'SALESMAN', CAST(7698 AS Numeric(4, 0)), CAST(N'1981-02-22 00:00:00.000' AS DateTime), CAST(1250.00 AS Numeric(7, 2)), CAST(500.00 AS Numeric(7, 2)), CAST(30 AS Numeric(2, 0)))
INSERT [dbo].[EMP] ([EMPNO], [ENAME], [JOB], [MGR], [HIREDATE], [SAL], [COMM], [DEPTNO]) VALUES (CAST(7566 AS Numeric(4, 0)), N'JONES', N'MANAGER', CAST(7839 AS Numeric(4, 0)), CAST(N'1981-04-02 00:00:00.000' AS DateTime), CAST(2975.00 AS Numeric(7, 2)), NULL, CAST(20 AS Numeric(2, 0)))
INSERT [dbo].[EMP] ([EMPNO], [ENAME], [JOB], [MGR], [HIREDATE], [SAL], [COMM], [DEPTNO]) VALUES (CAST(7654 AS Numeric(4, 0)), N'MARTIN', N'SALESMAN', CAST(7698 AS Numeric(4, 0)), CAST(N'1981-09-28 00:00:00.000' AS DateTime), CAST(1250.00 AS Numeric(7, 2)), CAST(1400.00 AS Numeric(7, 2)), CAST(30 AS Numeric(2, 0)))
INSERT [dbo].[EMP] ([EMPNO], [ENAME], [JOB], [MGR], [HIREDATE], [SAL], [COMM], [DEPTNO]) VALUES (CAST(7698 AS Numeric(4, 0)), N'BLAKE', N'MANAGER', CAST(7839 AS Numeric(4, 0)), CAST(N'1981-05-01 00:00:00.000' AS DateTime), CAST(2850.00 AS Numeric(7, 2)), NULL, CAST(30 AS Numeric(2, 0)))
INSERT [dbo].[EMP] ([EMPNO], [ENAME], [JOB], [MGR], [HIREDATE], [SAL], [COMM], [DEPTNO]) VALUES (CAST(7782 AS Numeric(4, 0)), N'CLARK', N'MANAGER', CAST(7839 AS Numeric(4, 0)), CAST(N'1981-06-09 00:00:00.000' AS DateTime), CAST(2450.00 AS Numeric(7, 2)), NULL, CAST(10 AS Numeric(2, 0)))
INSERT [dbo].[EMP] ([EMPNO], [ENAME], [JOB], [MGR], [HIREDATE], [SAL], [COMM], [DEPTNO]) VALUES (CAST(7788 AS Numeric(4, 0)), N'SCOTT', N'ANALYST', CAST(7566 AS Numeric(4, 0)), CAST(N'1982-12-09 00:00:00.000' AS DateTime), CAST(3000.00 AS Numeric(7, 2)), NULL, CAST(20 AS Numeric(2, 0)))
INSERT [dbo].[EMP] ([EMPNO], [ENAME], [JOB], [MGR], [HIREDATE], [SAL], [COMM], [DEPTNO]) VALUES (CAST(7839 AS Numeric(4, 0)), N'KING', N'PRESIDENT', NULL, CAST(N'1981-11-17 00:00:00.000' AS DateTime), CAST(5000.00 AS Numeric(7, 2)), NULL, CAST(10 AS Numeric(2, 0)))
INSERT [dbo].[EMP] ([EMPNO], [ENAME], [JOB], [MGR], [HIREDATE], [SAL], [COMM], [DEPTNO]) VALUES (CAST(7844 AS Numeric(4, 0)), N'TURNER', N'SALESMAN', CAST(7698 AS Numeric(4, 0)), CAST(N'1981-09-08 00:00:00.000' AS DateTime), CAST(1500.00 AS Numeric(7, 2)), CAST(0.00 AS Numeric(7, 2)), CAST(30 AS Numeric(2, 0)))
INSERT [dbo].[EMP] ([EMPNO], [ENAME], [JOB], [MGR], [HIREDATE], [SAL], [COMM], [DEPTNO]) VALUES (CAST(7876 AS Numeric(4, 0)), N'ADAMS', N'CLERK', CAST(7788 AS Numeric(4, 0)), CAST(N'1983-01-12 00:00:00.000' AS DateTime), CAST(1100.00 AS Numeric(7, 2)), NULL, CAST(20 AS Numeric(2, 0)))
INSERT [dbo].[EMP] ([EMPNO], [ENAME], [JOB], [MGR], [HIREDATE], [SAL], [COMM], [DEPTNO]) VALUES (CAST(7900 AS Numeric(4, 0)), N'JAMES', N'CLERK', CAST(7698 AS Numeric(4, 0)), CAST(N'1981-12-03 00:00:00.000' AS DateTime), CAST(950.00 AS Numeric(7, 2)), NULL, CAST(30 AS Numeric(2, 0)))
INSERT [dbo].[EMP] ([EMPNO], [ENAME], [JOB], [MGR], [HIREDATE], [SAL], [COMM], [DEPTNO]) VALUES (CAST(7902 AS Numeric(4, 0)), N'FORD', N'ANALYST', CAST(7566 AS Numeric(4, 0)), CAST(N'1981-12-03 00:00:00.000' AS DateTime), CAST(3000.00 AS Numeric(7, 2)), NULL, CAST(20 AS Numeric(2, 0)))
INSERT [dbo].[EMP] ([EMPNO], [ENAME], [JOB], [MGR], [HIREDATE], [SAL], [COMM], [DEPTNO]) VALUES (CAST(7934 AS Numeric(4, 0)), N'MILLER', N'CLERK', CAST(7782 AS Numeric(4, 0)), CAST(N'1982-01-23 00:00:00.000' AS DateTime), CAST(1300.00 AS Numeric(7, 2)), NULL, CAST(10 AS Numeric(2, 0)))
INSERT [dbo].[SALGRADE] ([GRADE], [LOSAL], [HISAL]) VALUES (CAST(1 AS Numeric(18, 0)), CAST(700 AS Numeric(18, 0)), CAST(1200 AS Numeric(18, 0)))
INSERT [dbo].[SALGRADE] ([GRADE], [LOSAL], [HISAL]) VALUES (CAST(2 AS Numeric(18, 0)), CAST(1201 AS Numeric(18, 0)), CAST(1400 AS Numeric(18, 0)))
INSERT [dbo].[SALGRADE] ([GRADE], [LOSAL], [HISAL]) VALUES (CAST(3 AS Numeric(18, 0)), CAST(1401 AS Numeric(18, 0)), CAST(2000 AS Numeric(18, 0)))
INSERT [dbo].[SALGRADE] ([GRADE], [LOSAL], [HISAL]) VALUES (CAST(4 AS Numeric(18, 0)), CAST(2001 AS Numeric(18, 0)), CAST(3000 AS Numeric(18, 0)))
INSERT [dbo].[SALGRADE] ([GRADE], [LOSAL], [HISAL]) VALUES (CAST(5 AS Numeric(18, 0)), CAST(3001 AS Numeric(18, 0)), CAST(9999 AS Numeric(18, 0)))


USE [Products]
GO
/****** Object:  Table [dbo].[emp_details]    Script Date: 7/9/2020 8:14:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[emp_details](
	[id] [bigint] NULL,
	[homecity] [varchar](50) NULL,
	[homecountry] [varchar](50) NULL,
	[homestate] [varchar](50) NULL,
	[fathername] [varchar](50) NULL,
	[basicsal] [numeric](18, 0) NULL,
	[totalexp] [bigint] NULL,
	[spousename] [varchar](50) NULL,
	[havekids] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[emp_details] ([id], [homecity], [homecountry], [homestate], [fathername], [basicsal], [totalexp], [spousename], [havekids]) VALUES (7521, N'delhi', N'delhi', N'delhi', N'A.R.singh', CAST(10000 AS Numeric(18, 0)), 9, N'A.Singh', 1)
INSERT [dbo].[emp_details] ([id], [homecity], [homecountry], [homestate], [fathername], [basicsal], [totalexp], [spousename], [havekids]) VALUES (7499, N'delhi', N'delhi', N'delhi', N'P.R.Singh', CAST(5000 AS Numeric(18, 0)), 7, N'P.singh', 1)
