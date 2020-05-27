USE InsuranceDB

GO
sp_configure 'show advanced options', 1
GO
RECONFIGURE WITH OverRide
GO
sp_configure 'Ad Hoc Distributed Queries', 1
GO
RECONFIGURE WITH OverRide
GO
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' ,  N'AllowInProcess' ,  1
GO
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' ,  N'DynamicParameters' ,  1
GO


SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=E:\Учеба\Базы данных\Курсач\TablesExcel\TestClient.xls', [Sheet1$])
