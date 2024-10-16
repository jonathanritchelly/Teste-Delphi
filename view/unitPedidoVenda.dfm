object frmPedidoVenda: TfrmPedidoVenda
  Left = 0
  Top = 0
  Caption = 'Pedido de venda'
  ClientHeight = 663
  ClientWidth = 933
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnShow = FormShow
  DesignSize = (
    933
    663)
  TextHeight = 20
  object Label1: TLabel
    Left = 24
    Top = 88
    Width = 196
    Height = 20
    Hint = 'Digite apenas n'#250'meros e pressione ENTER para buscar'
    Caption = 'Informe o c'#243'digo do produto'
    ParentShowHint = False
    ShowHint = True
  end
  object Label2: TLabel
    Left = 24
    Top = 181
    Width = 126
    Height = 20
    Caption = 'Produto localizado'
  end
  object Label3: TLabel
    Left = 24
    Top = 245
    Width = 110
    Height = 20
    Caption = 'Valor unit'#225'rio R$'
  end
  object Label4: TLabel
    Left = 175
    Top = 245
    Width = 78
    Height = 20
    Caption = 'Quantidade'
  end
  object Label5: TLabel
    Left = 258
    Top = 245
    Width = 54
    Height = 20
    Caption = 'Total R$'
  end
  object lblEditando: TLabel
    Left = 24
    Top = 153
    Width = 134
    Height = 20
    Caption = '** Editando produto'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label6: TLabel
    Left = 24
    Top = 6
    Width = 46
    Height = 20
    Caption = 'Cliente'
  end
  object Label7: TLabel
    Left = 8
    Top = 86
    Width = 7
    Height = 23
    Caption = '*'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -17
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label8: TLabel
    Left = 13
    Top = 5
    Width = 7
    Height = 23
    Caption = '*'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -17
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object lblNumeroPedido: TLabel
    Left = 479
    Top = 88
    Width = 169
    Height = 20
    Caption = 'Visualizando pedido N'#186' 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object txtCodigo: TEdit
    Left = 24
    Top = 114
    Width = 161
    Height = 28
    Hint = 'Digite apenas n'#250'meros e pressione ENTER para buscar'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnChange = txtCodigoChange
    OnExit = txtCodigoExit
    OnKeyPress = txtCodigoKeyPress
  end
  object txtProduto: TEdit
    Left = 24
    Top = 207
    Width = 449
    Height = 28
    Enabled = False
    TabOrder = 5
  end
  object txtValorUnitario: TEdit
    Left = 24
    Top = 271
    Width = 145
    Height = 28
    TabOrder = 6
    OnChange = txtValorUnitarioChange
    OnKeyPress = txtValorUnitarioKeyPress
  end
  object txtQuantidade: TEdit
    Left = 175
    Top = 271
    Width = 78
    Height = 28
    TabOrder = 7
    OnChange = txtQuantidadeChange
  end
  object txtTotal: TEdit
    Left = 258
    Top = 271
    Width = 145
    Height = 28
    ReadOnly = True
    TabOrder = 8
  end
  object btConfirmar: TButton
    Left = 409
    Top = 261
    Width = 145
    Height = 49
    Caption = 'Confirmar produto'
    TabOrder = 9
    OnClick = btConfirmarClick
  end
  object grdItens: TDBGrid
    Left = 24
    Top = 328
    Width = 878
    Height = 237
    Anchors = [akLeft, akTop, akRight]
    DataSource = dsItens
    ReadOnly = True
    TabOrder = 10
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -15
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnKeyDown = grdItensKeyDown
    OnKeyPress = grdItensKeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'Codigo'
        Title.Caption = 'C'#243'digo'
        Width = 85
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Descricao'
        Title.Caption = 'Descri'#231#227'o'
        Width = 292
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ValorUnitario'
        Title.Caption = 'Valor unit'#225'rio R$'
        Width = 121
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Quantidade'
        Width = 102
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Total'
        Title.Caption = 'Total R$'
        Width = 159
        Visible = True
      end>
  end
  object stBar: TStatusBar
    Left = 0
    Top = 633
    Width = 933
    Height = 30
    Panels = <
      item
        Text = 'Total do pedido:'
        Width = 150
      end
      item
        Text = '0,00'
        Width = 100
      end>
    ExplicitWidth = 871
  end
  object btGravar: TButton
    Left = 757
    Top = 571
    Width = 145
    Height = 49
    Caption = 'Gravar pedido'
    TabOrder = 11
    OnClick = btGravarClick
  end
  object txtCliente: TEdit
    Left = 24
    Top = 32
    Width = 449
    Height = 28
    Enabled = False
    TabOrder = 12
  end
  object btBuscaCliente: TButton
    Left = 479
    Top = 22
    Width = 145
    Height = 49
    Caption = 'Buscar cliente'
    TabOrder = 0
    OnClick = btBuscaClienteClick
  end
  object btBuscarPedido: TButton
    Left = 630
    Top = 22
    Width = 145
    Height = 49
    Caption = 'Buscar pedido'
    TabOrder = 1
    OnClick = btBuscarPedidoClick
  end
  object btCancelarPedido: TButton
    Left = 479
    Top = 114
    Width = 145
    Height = 49
    Caption = 'Cancelar pedido'
    TabOrder = 4
    Visible = False
    OnClick = btCancelarPedidoClick
  end
  object btNovo: TButton
    Left = 781
    Top = 22
    Width = 145
    Height = 49
    Caption = 'Novo pedido'
    Enabled = False
    TabOrder = 2
    OnClick = btNovoClick
  end
  object cdsItens: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    Params = <>
    AfterPost = cdsItensAfterPost
    AfterDelete = cdsItensAfterDelete
    OnCalcFields = cdsItensCalcFields
    Left = 736
    Top = 281
    object cdsItensCodigo: TIntegerField
      FieldName = 'Codigo'
    end
    object cdsItensDescricao: TStringField
      FieldName = 'Descricao'
      Size = 150
    end
    object cdsItensValorUnitario: TCurrencyField
      FieldName = 'ValorUnitario'
    end
    object cdsItensQuantidade: TIntegerField
      FieldName = 'Quantidade'
    end
    object cdsItensidClient: TIntegerField
      FieldName = 'idClient'
    end
    object cdsItensTotal: TCurrencyField
      FieldKind = fkInternalCalc
      FieldName = 'Total'
    end
    object cdsItensagTotalGeral: TAggregateField
      FieldName = 'agTotalGeral'
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'SUM(Total)'
    end
  end
  object dsItens: TDataSource
    DataSet = cdsItens
    Left = 744
    Top = 345
  end
end
