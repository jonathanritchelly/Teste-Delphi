unit unitFuncoes;

interface

uses
  Vcl.Dialogs, System.SysUtils, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client,
  Vcl.Forms, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.Controls;

const
  breakLine = #13 + #10;

Procedure MsgErro(Msg: String);
Procedure MsgAlerta(Msg: String);
Procedure MsgInformacao(Msg: String);
Function MsgYesNo(Msg: String): boolean;
function fRetiraNumerosString(Texto: String): string;
procedure pBuscaPedido(vNumeroPedido: integer);

function fBuscaProduto(out Descricao: string; out PrecoSugerido: currency;
  CodigoProduto: integer): String;

implementation

uses unitDmDados, unitPedidoVenda;

Function MsgYesNo(Msg: String): boolean;
Begin

  if MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0, mbNo) <> mrYes then
    Result := false
  else
    Result := true;
End;

Procedure MsgErro(Msg: String);
Begin
  MessageDlg(Msg, mtError, [mbOK], 0);
End;

Procedure MsgAlerta(Msg: String);
Begin
  MessageDlg(Msg, mtWarning, [mbOK], 0);
End;

Procedure MsgInformacao(Msg: String);
Begin
  MessageDlg(Msg, mtInformation, [mbOK], 0);
End;

function fBuscaProduto(out Descricao: string; out PrecoSugerido: Currency;
  CodigoProduto: Integer): String;
var
  qry: TFDQuery;
begin
  qry := dmdados.pCriaQuery(qry);

  try
    qry.SQL.Add('SELECT * FROM Produtos WHERE Codigo = :Codigo');
    qry.ParamByName('Codigo').AsInteger := CodigoProduto;

    try
      qry.Open;
    except
      on E: Exception do
      begin
        MsgErro('Falha ao consultar produto!' + breakLine + E.Message);
        Exit;
      end;
    end;

    if not qry.IsEmpty then
    begin
      Descricao := qry.FieldByName('Descricao').AsString;
      PrecoSugerido := qry.FieldByName('preco_de_venda').AsCurrency;
      Result := 'Produto encontrado';
    end
    else
    begin
      Result := 'Produto n�o encontrado';
      Descricao := '';
      PrecoSugerido := 0;
    end;

  finally
    qry.Close;
    FreeAndNil(qry);
  end;
end;


function fRetiraNumerosString(Texto: String): string;
var
  nI: Integer;
  TextoLimpo: String;
begin
  TextoLimpo := '';
  for nI := 1 to Length(Texto)  do
  begin
    if Texto[nI] in ['0'..'9'] then
      TextoLimpo := TextoLimpo + Texto[nI];
  end;
  Result := TextoLimpo;
end;


procedure pBuscaPedido(vNumeroPedido: Integer);
var
  qry: TFDQuery;
begin
  qry := dmdados.pCriaQuery(qry);

  try
    qry.SQL.Text := 'SELECT P.*, nome FROM pedidos_dados_gerais P ' +
                    'INNER JOIN clientes ON codigo = codigo_cliente ' +
                    'WHERE numero_pedido = :numeroPedido';
    qry.ParamByName('numeroPedido').AsInteger := vNumeroPedido;
    qry.Open;

    if qry.RecordCount = 0 then
    begin
      MsgErro('Pedido n�o encontrado!');
      frmPedidoVenda.lblNumeroPedido.Visible := false;
      exit;
    end;

    frmPedidoVenda.vClienteID := qry.FieldByName('codigo_cliente').AsInteger;
    frmPedidoVenda.vClienteNome := qry.FieldByName('nome').AsString;
    frmPedidoVenda.txtCliente.Text := frmPedidoVenda.vClienteNome;

    frmPedidoVenda.lblNumeroPedido.Caption := 'Visualizando pedido N� ' +
      qry.FieldByName('numero_pedido').AsString;

    frmPedidoVenda.lblNumeroPedido.Visible := true;

    dmdados.pLimpaQuery(qry);

    qry.SQL.Text := 'SELECT P.*, descricao FROM teste_delphi.pedidos_produtos P ' +
                    'INNER JOIN teste_delphi.produtos ON codigo = codigo_produto ' +
                    'WHERE numero_pedido = :numeroPedido';
    qry.ParamByName('numeroPedido').AsInteger := vNumeroPedido;
    qry.Open;

    with frmPedidoVenda.cdsItens do
    begin
      EmptyDataSet;

      while not qry.Eof do
      begin
        Append;
        FieldByName('codigo').AsInteger := qry.FieldByName('codigo_produto').AsInteger;
        FieldByName('Descricao').AsString := qry.FieldByName('descricao').AsString;
        FieldByName('ValorUnitario').AsCurrency := qry.FieldByName('valor_unitario').AsCurrency;
        FieldByName('Quantidade').AsInteger := qry.FieldByName('quantidade').AsInteger;
        FieldByName('idClient').AsInteger := RecordCount + 1;
        Post;
        qry.Next;
      end;
    end;

  finally
    qry.Close;
    FreeAndNil(qry);
  end;
end;


end.
