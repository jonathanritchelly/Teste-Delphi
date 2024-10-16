unit unitBuscarCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrmBuscarCliente = class(TForm)
    pnBusca: TPanel;
    shp_pesquisa: TShape;
    spb_pesquisa: TSpeedButton;
    txtBusca: TEdit;
    grdClientes: TDBGrid;
    Label1: TLabel;
    procedure txtBuscaKeyPress(Sender: TObject; var Key: Char);
    procedure txtBuscaChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdClientesDblClick(Sender: TObject);
    procedure grdClientesKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmBuscarCliente: TFrmBuscarCliente;

implementation

{$R *.dfm}

uses unitDmDados, unitPedidoVenda, unitFuncoes;

procedure TFrmBuscarCliente.FormShow(Sender: TObject);
begin
  dmdados.pBuscaCliente('');
  txtBusca.SetFocus;
end;

procedure TFrmBuscarCliente.grdClientesDblClick(Sender: TObject);
begin
  if dmdados.qryClientes.RecordCount > 0 then
  begin
    if MsgYesNo('Confirmar a escolha de: ' + dmdados.qryClientes.FieldByName('nome').AsString + '?') = false then
      exit;

    frmPedidoVenda.vClienteID := dmdados.qryClientes.FieldByName('codigo').AsInteger;
    frmPedidoVenda.vClienteNome := dmdados.qryClientes.FieldByName('nome').AsString;
    Close;

  end;
end;

procedure TFrmBuscarCliente.grdClientesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    grdClientesDblClick(grdClientes);
end;

procedure TFrmBuscarCliente.txtBuscaChange(Sender: TObject);
begin
  if txtBusca.Text = '' then
    dmdados.pBuscaCliente(txtBusca.Text);
end;

procedure TFrmBuscarCliente.txtBuscaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    dmdados.pBuscaCliente(txtBusca.Text);
end;

end.
