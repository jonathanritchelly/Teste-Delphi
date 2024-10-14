program PDV;

uses
  Vcl.Forms,
  unitDmDados in 'model\unitDmDados.pas' {dmDados: TDataModule},
  unitPedidoVenda in 'view\unitPedidoVenda.pas' {frmPedidoVenda},
  unitFuncoes in 'control\unitFuncoes.pas',
  unitBuscarCliente in 'view\unitBuscarCliente.pas' {FrmBuscarCliente};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmDados, dmDados);
  Application.CreateForm(TfrmPedidoVenda, frmPedidoVenda);
  Application.CreateForm(TFrmBuscarCliente, FrmBuscarCliente);
  Application.Run;
end.
