unit unitPedidoVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.Buttons;

type
  TfrmPedidoVenda = class(TForm)
    Label1: TLabel;
    txtCodigo: TEdit;
    Label2: TLabel;
    txtProduto: TEdit;
    Label3: TLabel;
    txtValorUnitario: TEdit;
    Label4: TLabel;
    txtQuantidade: TEdit;
    Label5: TLabel;
    txtTotal: TEdit;
    btConfirmar: TButton;
    grdItens: TDBGrid;
    cdsItens: TClientDataSet;
    cdsItensCodigo: TIntegerField;
    cdsItensDescricao: TStringField;
    cdsItensQuantidade: TIntegerField;
    cdsItensValorUnitario: TCurrencyField;
    dsItens: TDataSource;
    stBar: TStatusBar;
    cdsItensidClient: TIntegerField;
    lblEditando: TLabel;
    cdsItensagTotalGeral: TAggregateField;
    cdsItensTotal: TCurrencyField;
    btGravar: TButton;
    Label6: TLabel;
    txtCliente: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    btBuscaCliente: TButton;
    btBuscarPedido: TButton;
    lblNumeroPedido: TLabel;
    btCancelarPedido: TButton;
    btNovo: TButton;
    procedure txtCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure txtCodigoChange(Sender: TObject);
    procedure txtCodigoExit(Sender: TObject);
    procedure txtQuantidadeChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btConfirmarClick(Sender: TObject);
    procedure cdsItensCalcFields(DataSet: TDataSet);
    procedure txtValorUnitarioChange(Sender: TObject);
    procedure grdItensKeyPress(Sender: TObject; var Key: Char);
    procedure grdItensKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cdsItensAfterPost(DataSet: TDataSet);
    procedure btGravarClick(Sender: TObject);
    procedure btBuscaClienteClick(Sender: TObject);
    procedure btBuscarPedidoClick(Sender: TObject);
    procedure btNovoClick(Sender: TObject);
    procedure btCancelarPedidoClick(Sender: TObject);
    procedure cdsItensAfterDelete(DataSet: TDataSet);
    procedure txtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
  private
    procedure pBuscaProduto;
    procedure pCalculaTotal;
    procedure pAtualizaTotal;
    function ValidaPedido: Boolean;
    function GravaPedido: Boolean;

  var
    idEdicao: integer;

    { Private declarations }
  public
    { Public declarations }
    procedure LimpaPedido;

  var
    vClienteID: integer;
    vClienteNome: string;
  end;

var
  frmPedidoVenda: TfrmPedidoVenda;

implementation

{$R *.dfm}

uses unitFuncoes, unitDmDados, unitBuscarCliente;

procedure TfrmPedidoVenda.txtCodigoChange(Sender: TObject);
var
  i: integer;
begin
  if not TryStrToInt(txtCodigo.Text, i) then
  begin
    txtCodigo.Text := Copy(txtCodigo.Text, 1, Length(txtCodigo.Text) - 1);
    txtCodigo.SelStart := Length(txtCodigo.Text);
  end;
end;

procedure TfrmPedidoVenda.txtCodigoExit(Sender: TObject);
begin
  if txtCodigo.Text <> '' then
    pBuscaProduto;
end;

procedure TfrmPedidoVenda.txtCodigoKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['0' .. '9', Char(VK_BACK), #13]) then
    Key := #0
  else if (Key = #13) and (txtCodigo.Text <> '') then
    pBuscaProduto;
end;

procedure TfrmPedidoVenda.txtQuantidadeChange(Sender: TObject);
begin
  pCalculaTotal;
end;

procedure TfrmPedidoVenda.txtValorUnitarioChange(Sender: TObject);
begin
  pCalculaTotal;
end;

procedure TfrmPedidoVenda.txtValorUnitarioKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not(Key in ['0' .. '9', Char(VK_BACK), #13, ',']) then
    Key := #0
end;

procedure TfrmPedidoVenda.pCalculaTotal();
begin
  if txtQuantidade.Text = '' then
    txtQuantidade.Text := '1';

  try
    txtTotal.Text := FormatCurr('#,##0.00', StrtoInt(txtQuantidade.Text) *
      StrToFloat(txtValorUnitario.Text));
  except

  end;

end;

procedure TfrmPedidoVenda.btBuscaClienteClick(Sender: TObject);
begin
  if not Assigned(FrmBuscarCliente) then
    Application.CreateForm(TFrmBuscarCliente, FrmBuscarCliente);

  try
    FrmBuscarCliente.ShowModal;
  finally
    FreeAndNil(FrmBuscarCliente);
  end;

  txtCliente.Text := vClienteNome;
  btBuscarPedido.Enabled := (vClienteID = 0);
  btNovo.Enabled := not(vClienteID = 0);
end;

procedure TfrmPedidoVenda.btBuscarPedidoClick(Sender: TObject);
var
  vNumeroPedido: string;
begin

  InputQuery('Buscar pedido', 'Digite o n�mero do pedido', vNumeroPedido);

  if fRetiraNumerosString(vNumeroPedido) = '' then
    Exit;

  pBuscaPedido(StrtoInt(fRetiraNumerosString(vNumeroPedido)));

  if lblNumeroPedido.Visible then
  begin
    btBuscaCliente.Enabled := False;
    btGravar.Enabled := False;
    btCancelarPedido.Visible := True;
    btNovo.Enabled := True;
    btConfirmar.Enabled := False;
    txtCodigo.Enabled := false;
  end;
end;

procedure TfrmPedidoVenda.btCancelarPedidoClick(Sender: TObject);
begin
  if not msgYesNo('Deseja cancelar o pedido n� ' + fRetiraNumerosString
    (lblNumeroPedido.Caption) + '?') then
    Exit;

  if dmDados.pCancelaPedido
    (StrtoInt(fRetiraNumerosString(lblNumeroPedido.Caption))) then
    LimpaPedido;
end;

procedure TfrmPedidoVenda.btConfirmarClick(Sender: TObject);
begin
  if (txtProduto.Text = '') or (txtCodigo.Text = '') then
    Exit;

  if idEdicao = 0 then
  begin
    cdsItens.Append;
    cdsItensidClient.AsInteger := cdsItens.RecordCount + 1;
  end
  else
    cdsItens.Edit;

  cdsItensCodigo.AsInteger := StrtoInt(txtCodigo.Text);
  cdsItensValorUnitario.AsFloat := StrToCurr(txtValorUnitario.Text);
  cdsItensDescricao.AsString := txtProduto.Text;
  cdsItensQuantidade.AsInteger := StrtoInt(txtQuantidade.Text);
  cdsItens.Post;

  lblEditando.Visible := False;
  idEdicao := 0;

  txtProduto.Clear;
  txtValorUnitario.Text := '0,00';
  txtQuantidade.Text := '0';
  txtCodigo.Clear;
  txtCodigo.SetFocus;
end;

function TfrmPedidoVenda.ValidaPedido: Boolean;
begin
  Result := False;

  if vClienteID = 0 then
  begin
    MsgErro('Selecione o cliente!');
    Exit;
  end;


  if cdsItens.RecordCount = 0 then
  begin
    MsgErro('Insira ao menos 1 item no pedido!');
    Exit;
  end;

  if not msgYesNo('Deseja gravar o pedido?') then
    Exit;

  Result := True;
end;

function TfrmPedidoVenda.GravaPedido: Boolean;
var
  vNumeroPedido: integer;
begin
  Result := False;

  vNumeroPedido := dmDados.fInserePedido(vClienteID, cdsItensagTotalGeral.Value,
    cdsItens);

  if vNumeroPedido <= 0 then
    Exit;

  MsgInformacao('Pedido N� ' + vNumeroPedido.ToString +
    ' inserido com sucesso!');
  Result := True;
end;

procedure TfrmPedidoVenda.btGravarClick(Sender: TObject);
var
  vNumeroPedido: integer;
begin

  if not(ValidaPedido) then
    Exit;

  vNumeroPedido := dmDados.fInserePedido(vClienteID, cdsItensagTotalGeral.Value,
    cdsItens);

  if vNumeroPedido <= 0 then
    Exit;

  LimpaPedido;

  MsgInformacao('Pedido N� ' + vNumeroPedido.ToString +
    ' inserido com sucesso!');

end;

procedure TfrmPedidoVenda.btNovoClick(Sender: TObject);
begin
  LimpaPedido;
end;

procedure TfrmPedidoVenda.LimpaPedido();
begin
  vClienteID := 0;
  vClienteNome := '';
  idEdicao := 0;
  txtCodigo.Clear;
  txtCliente.Clear;
  txtProduto.Clear;
  txtValorUnitario.Text := '0,00';
  txtTotal.Text := '0,00';
  txtQuantidade.Text := '0';
  lblEditando.Visible := False;
  cdsItens.EmptyDataSet;
  btBuscarPedido.Enabled := True;
  btBuscaCliente.Enabled := True;
  btConfirmar.Enabled := True;
  btNovo.Enabled := False;
  btCancelarPedido.Visible := False;
  lblNumeroPedido.Visible := False;
  btGravar.Enabled := True;
  stBar.Panels[1].Text := '0,00';
  txtCodigo.Enabled := true;

  btBuscaCliente.SetFocus;
end;

procedure TfrmPedidoVenda.cdsItensAfterDelete(DataSet: TDataSet);
begin
  pAtualizaTotal;
end;

procedure TfrmPedidoVenda.cdsItensAfterPost(DataSet: TDataSet);
begin
  pAtualizaTotal;
end;

procedure TfrmPedidoVenda.pAtualizaTotal();
begin
  if cdsItensagTotalGeral.IsNull then
    stBar.Panels[1].Text := FormatCurr('R$ #,##0.00', 0)
  else
    stBar.Panels[1].Text := FormatCurr('R$ #,##0.00',
      cdsItens.FieldByName('agTotalGeral').Value);
end;

procedure TfrmPedidoVenda.cdsItensCalcFields(DataSet: TDataSet);
begin
  cdsItensTotal.AsCurrency := cdsItensQuantidade.AsInteger *
    cdsItensValorUnitario.AsCurrency;
end;

procedure TfrmPedidoVenda.FormShow(Sender: TObject);
begin
  cdsItens.CreateDataSet;
  cdsItens.EmptyDataSet;
end;

procedure TfrmPedidoVenda.grdItensKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and (cdsItens.RecordCount > 0) then
  begin
    if msgYesNo('Deseja excluir o produto?') = True then
      cdsItens.Delete;
  end
  else if (Key = VK_TAB) and (btGravar.Enabled) then
    btGravar.SetFocus;
end;

procedure TfrmPedidoVenda.grdItensKeyPress(Sender: TObject; var Key: Char);
begin

  if (Key = #13) and (cdsItens.RecordCount > 0) then
  begin
    idEdicao := cdsItensidClient.AsInteger;
    txtCodigo.Text := cdsItensCodigo.AsInteger.ToString;
    txtProduto.Text := cdsItensDescricao.AsString;
    txtQuantidade.Text := cdsItensQuantidade.AsInteger.ToString;
    txtValorUnitario.Text := cdsItensValorUnitario.AsFloat.ToString;
    txtTotal.Text := cdsItensTotal.AsFloat.ToString;
    lblEditando.Visible := True;
  end;

end;

procedure TfrmPedidoVenda.pBuscaProduto();
var
  vProduto: string;
  vPreco: currency;
begin
  fBuscaProduto(vProduto, vPreco, StrtoInt(txtCodigo.Text));

  if vProduto = '' then
  begin
    MsgAlerta('Produto n�o encontrado!');
    txtProduto.Clear;
    txtValorUnitario.Text := '0,00';
    txtQuantidade.Text := '0';;
  end
  else
  begin
    txtProduto.Text := vProduto;
    txtValorUnitario.Text := stringReplace(vPreco.ToString, 'R$ ', '',
      [rfReplaceAll]);
    txtQuantidade.Text := '1';
  end;

end;

end.
