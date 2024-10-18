unit unitDmDados;

interface

uses
  System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  System.SysUtils, Vcl.Forms, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Datasnap.DBClient;

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
    function fInserePedido(vCodigoCliente: Integer; vValorTotal: currency;
      vcdsItens: TClientDataSet): Integer;
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
  vBanco, vUsuario, vSenha, vPorta, vServidor, vLib: String;
begin
  try
    vListaBD := TStringList.Create;

    if not(FileExists(ExtractFilePath(Application.ExeName) + '\strCon.ini')) then
    begin
      MsgErro('Arquivo de conexão com a base não encontrado!');
      Application.Terminate;
      Exit;
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
        Conn.Connected := True;
      except
        on E: Exception do
        begin
          MsgErro('Não foi possível conectar com o banco de dados!' + breakLine +
            E.Message);
          Application.Terminate;
          Exit;
        end;
      end;

    except
      on E: Exception do
      begin
        MsgErro('Falha ao carregar arquivo de conexão!' + breakLine +
          E.Message);
        Application.Terminate;
        Exit;
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

function TdmDados.fInserePedido(vCodigoCliente: Integer; vValorTotal: Currency;
  vcdsItens: TClientDataSet): Integer;
var
  qry: TFDQuery;
  i, vPedidoID: Integer;
begin
  qry := pCriaQuery(qry);
  Conn.StartTransaction;

  try
    try
      qry.SQL.Text :=
        'INSERT INTO pedidos_dados_gerais (data_emissao, codigo_cliente, valor_total) ' +
        'Values(NOW(), :codCliente, :valorTotal)';
      qry.ParamByName('codCliente').AsInteger := vCodigoCliente;
      qry.ParamByName('valorTotal').AsCurrency := vValorTotal;

      qry.ExecSQL;

      qry.SQL.Text := 'SELECT LAST_INSERT_ID()';
      qry.Open;
      vPedidoID := qry.Fields[0].AsInteger;

      pLimpaQuery(qry);

      // Insere os itens do pedido
      try
        qry.SQL.Text :=
          'INSERT INTO pedidos_produtos (numero_pedido, codigo_produto, quantidade, valor_unitario, valor_total) ' +
          'Values(:numeroPedido, :codigoProduto, :quantidade, :valorUnitario, :valorTotal)';

        for i := 0 to vcdsItens.RecordCount - 1 do
        begin
          qry.ParamByName('numeroPedido').AsInteger := vPedidoID;
          qry.ParamByName('codigoProduto').AsInteger := vcdsItens.FieldByName('Codigo').AsInteger;
          qry.ParamByName('quantidade').AsInteger := vcdsItens.FieldByName('Quantidade').AsInteger;
          qry.ParamByName('valorUnitario').AsCurrency := vcdsItens.FieldByName('ValorUnitario').AsCurrency;
          qry.ParamByName('valorTotal').AsCurrency := vcdsItens.FieldByName('Total').AsCurrency;

          qry.ExecSQL;
          vcdsItens.Next;
        end;

        Conn.Commit; // Se tudo der certo, commit

      except
        on E: Exception do
        begin
          Conn.Rollback; // Em caso de erro, rollback
          MsgErro('Erro ao inserir itens do pedido: ' + E.Message);
        end;
      end;

      pLimpaQuery(qry);
      Result := vPedidoID;

    except
      on E: Exception do
      begin
        Conn.Rollback;
        MsgErro('Erro ao inserir registro: ' + E.Message);
      end;

    end;

  finally
    pLimpaQuery(qry);
    FreeAndNil(qry);
  end;
end;



procedure TdmDados.pBuscaCliente(ValorBusca: string);
begin
  pLimpaQuery(qryClientes);
  qryClientes.SQL.Clear; // Limpa a consulta antes de adicionar novas instruções
  qryClientes.SQL.Add('SELECT * FROM teste_delphi.Clientes');

  if ValorBusca <> '' then
  begin
    qryClientes.SQL.Add(' WHERE nome LIKE ' + QuotedStr('%' + ValorBusca + '%'));

    if fRetiraNumerosString(ValorBusca) <> '' then
      qryClientes.SQL.Add(' OR codigo LIKE ' + QuotedStr('%' + fRetiraNumerosString(ValorBusca) + '%'));
  end;

  qryClientes.SQL.Add(' ORDER BY Nome');
  qryClientes.Open;
end;


function TdmDados.pCancelaPedido(vNumeroPedido: Integer): Boolean;
var
  qry: TFDQuery;
begin
  qry := pCriaQuery(qry);
  Conn.StartTransaction;
  try
    try
      // Deleta os itens do pedido
      qry.SQL.Text := 'DELETE FROM pedidos_produtos WHERE numero_pedido = :numeroPedido';
      qry.ParamByName('numeroPedido').AsInteger := vNumeroPedido;
      qry.ExecSQL;

      pLimpaQuery(qry);

      // Deleta o pedido
      qry.SQL.Text := 'DELETE FROM pedidos_dados_gerais WHERE numero_pedido = :numeroPedido';
      qry.ParamByName('numeroPedido').AsInteger := vNumeroPedido;
      qry.ExecSQL;

      Conn.Commit;

      pLimpaQuery(qry);
      MsgInformacao('Pedido excluído com sucesso!');
      Result := True;

    except
      on E: Exception do
      begin
        Conn.Rollback;
        MsgErro('Erro ao excluir registro: ' + E.Message);
        Result := False;
      end;
    end;

  finally
    pLimpaQuery(qry);
    FreeAndNil(qry);
  end;
end;


end.
