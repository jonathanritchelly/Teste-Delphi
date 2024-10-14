unit unitDmDados;

interface

uses
  System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  System.SysUtils, Vcl.Forms, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TdmDados = class(TDataModule)
    Conn: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    qryClientes: TFDQuery;
    dsClientes: TDataSource;
    qryExec: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private

    { Private declarations }
  public
    function pCriaQuery(qry: TFDQuery; Mode: Integer = 0): TFDQuery;
    procedure pLimpaQuery(Query: TFDQuery);
    function fInserePedido(vCodigoCliente: Integer;
      vValorTotal: currency): Integer;
    procedure pInsereItenPedido(vNumeroPedido, vCodigoProduto,
      vQuantidade: Integer; vValorUnitario, vValorTotal: currency);
    procedure pBuscaCliente(ValorBusca: string);
    function pCancelaPedido(vNumeroPedido: Integer): boolean;
    { Public declarations }
  end;

var
  dmDados: TdmDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses unitFuncoes;
{$R *.dfm}

procedure TdmDados.DataModuleCreate(Sender: TObject);
var
  vListaBD: TStringList;
var
  vBanco, vUsuario, vSenha, vPorta, vServidor, vLib: String;
begin

  try
    vListaBD := TStringList.Create;

    if not(FileExists(ExtractFilePath(Application.ExeName) + '\strCon.ini'))
    then
    begin
      MsgErro('Arquivo de conex�o com a base n�o encontrado!');
      Application.Terminate;
      exit;
    end;

    vListaBD.LoadFromFile(ExtractFilePath(Application.ExeName) + '\strCon.ini');

    try
      vBanco := vListaBD[0];
      vUsuario := vListaBD[1];
      vPorta := vListaBD[2];
      vSenha := vListaBD[3];
      vLib := ExtractFilePath(Application.ExeName) + '\' + vListaBD[4];
      vServidor := vListaBD[5];

      Conn.Params.Clear;
      Conn.DriverName := 'MySQL';
      Conn.Params.Database := vBanco;
      Conn.Params.UserName := vUsuario;
      Conn.Params.Password := vSenha;
      Conn.Params.Add('Server=' + vServidor);
      Conn.Params.Add('Port=' + vPorta);
      Conn.LoginPrompt := False;
      FDPhysMySQLDriverLink1.VendorLib := vLib;

      try
        Conn.Connected := true;
      except
        on E: exception do
        begin
          MsgErro('N�o foi poss�vel conectar com o banco de dados!' + breakLine
            + E.Message);
          Application.Terminate;
          exit;
        end;
      end;

    except
      on E: exception do
      begin
        MsgErro('Falha ao carregar arquivo de conex�o!' + breakLine +
          E.Message);
        Application.Terminate;
        exit;
      end;

    end;

  finally
    vListaBD.Free;
  end;

end;

function TdmDados.pCriaQuery(qry: TFDQuery; Mode: Integer = 0): TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dmDados.Conn;

  if Mode = 0 then
    qry.FetchOptions.RecordCountMode := cmTotal;

  pLimpaQuery(qry);
  Result := qry;
end;

procedure TdmDados.pLimpaQuery(Query: TFDQuery);
begin
  Query.Filtered := False;
  Query.Filter := '';
  Query.Close;
  Query.SQL.Clear;
end;

Function TdmDados.fInserePedido(vCodigoCliente: Integer;
  vValorTotal: currency): Integer;
var
  qry: TFDQuery;
begin

  qry := pCriaQuery(qry);

  Conn.StartTransaction;
  try

    try
      qry.SQL.Text :=
        'INSERT INTO pedidos_dados_gerais (data_emissao, codigo_cliente, valor_total) Values(NOW(), :codCliente, :valorTotal)';
      qry.ParamByName('codCliente').AsInteger := vCodigoCliente;
      qry.ParamByName('valorTotal').AsCurrency := vValorTotal;

      qry.ExecSQL;
      Conn.Commit;

      pLimpaQuery(qry);

      qry.SQL.Text := 'SELECT LAST_INSERT_ID()';
      qry.Open;
      Result := qry.Fields[0].AsInteger;

    except
      on E: exception do
      begin
        Conn.Rollback;
        MsgErro('Erro ao inserir registro: ' + E.Message);
      end;

    end;

  finally
    pLimpaQuery(qry);
    freeandnil(qry);
  end;
end;

procedure TdmDados.pInsereItenPedido(vNumeroPedido, vCodigoProduto,
  vQuantidade: Integer; vValorUnitario, vValorTotal: currency);
var
  qry: TFDQuery;
begin

  qry := pCriaQuery(qry);

  Conn.StartTransaction;
  try

    try
      qry.SQL.Text :=
        'INSERT INTO pedidos_produtos (numero_pedido, codigo_produto, quantidade, valor_unitario, valor_total) '
        + 'Values(:numeroPedido, :codigoProduto, :quantidade, :valorUnitario, :valorTotal)';

      qry.ParamByName('numeroPedido').AsInteger := vNumeroPedido;
      qry.ParamByName('codigoProduto').AsCurrency := vCodigoProduto;
      qry.ParamByName('quantidade').AsInteger := vQuantidade;
      qry.ParamByName('valorUnitario').AsCurrency := vValorUnitario;
      qry.ParamByName('valorTotal').AsCurrency := vValorTotal;

      qry.ExecSQL;
      Conn.Commit;

      pLimpaQuery(qry);

    except
      on E: exception do
      begin
        Conn.Rollback;
        MsgErro('Erro ao inserir registro: ' + E.Message);
      end;

    end;

  finally
    pLimpaQuery(qry);
    freeandnil(qry);
  end;
end;

procedure TdmDados.pBuscaCliente(ValorBusca: string);
begin
  pLimpaQuery(qryClientes);
  qryClientes.SQL.Add('SELECT  * FROM teste_delphi.Clientes ');

  if ValorBusca <> '' then
  begin
    qryClientes.SQL.Add('Where nome like ' + QuotedStr('%' + ValorBusca + '%'));
    if fRetiraNumerosString(ValorBusca) <> '' then
      qryClientes.SQL.Add('OR codigo like ' +
        QuotedStr('%' + fRetiraNumerosString(ValorBusca) + '%'));
  end;

  qryClientes.SQL.Add('Order by Nome');
  qryClientes.Open();
end;

function TdmDados.pCancelaPedido(vNumeroPedido: Integer): boolean;
var
  qry: TFDQuery;
begin

  qry := pCriaQuery(qry);

  Conn.StartTransaction;
  try

    try
      // deleta os itens
      qry.SQL.Text :=
        'Delete from pedidos_produtos where numero_pedido= :numeroPedido';

      qry.ParamByName('numeroPedido').AsInteger := vNumeroPedido;

      qry.ExecSQL;

      pLimpaQuery(qry);

      // deleta o pedido
      qry.SQL.Text :=
        'Delete from pedidos_dados_gerais where numero_pedido= :numeroPedido';

      qry.ParamByName('numeroPedido').AsInteger := vNumeroPedido;

      qry.ExecSQL;

      Conn.Commit;

      pLimpaQuery(qry);

      MsgInformacao('Pedido exclu�do com sucesso!');
      Result := true;

    except
      on E: exception do
      begin
        Conn.Rollback;
        MsgErro('Erro ao inserir registro: ' + E.Message);
        Result := False;
      end;

    end;

  finally
    pLimpaQuery(qry);
    freeandnil(qry);
  end;
end;

end.
