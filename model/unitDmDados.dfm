object dmDados: TdmDados
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object Conn: TFDConnection
    Params.Strings = (
      'Database=teste_delphi'
      'User_Name=root'
      'Password=123456'
      'Server=localhost'
      'DriverID=MySQL')
    Left = 184
    Top = 160
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'D:\Teste Delphi\executavel\libmysql.dll'
    Left = 280
    Top = 176
  end
  object qryClientes: TFDQuery
    Connection = Conn
    SQL.Strings = (
      'SELECT  * FROM teste_delphi.Clientes LIMIT 50;')
    Left = 184
    Top = 280
  end
  object dsClientes: TDataSource
    DataSet = qryClientes
    Left = 184
    Top = 352
  end
  object qryExec: TFDQuery
    Connection = Conn
    Left = 368
    Top = 352
  end
end
