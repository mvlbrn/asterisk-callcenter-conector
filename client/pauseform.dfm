object form_pause: Tform_pause
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1088#1080#1095#1080#1085#1072' '#1087#1077#1088#1077#1088#1099#1074#1072
  ClientHeight = 298
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 203
    Width = 100
    Height = 13
    Caption = #1055#1088#1080#1095#1080#1085#1072' '#1087#1077#1088#1077#1088#1099#1074#1072':'
  end
  object reason_index: TRadioGroup
    Left = 8
    Top = 28
    Width = 233
    Height = 169
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077'...'
    Items.Strings = (
      #1051#1080#1095#1085#1086#1077
      #1050#1091#1088#1077#1085#1080#1077
      #1054#1073#1077#1076
      #1055#1086#1088#1091#1095#1077#1085#1080#1077' ('#1091#1082#1072#1079#1072#1090#1100')'
      #1050#1086#1085#1090#1088#1086#1083#1100
      #1044#1088#1091#1075#1086#1077' ('#1091#1082#1072#1079#1072#1090#1100')')
    TabOrder = 0
    OnClick = reason_indexClick
  end
  object reason_text: TMemo
    Left = 8
    Top = 218
    Width = 233
    Height = 47
    Enabled = False
    TabOrder = 1
    OnChange = reason_textChange
  end
  object Button1: TButton
    Left = 85
    Top = 271
    Width = 75
    Height = 25
    Caption = 'OK'
    Enabled = False
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 166
    Top = 271
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object queue_name: TEdit
    Left = 76
    Top = 4
    Width = 105
    Height = 18
    Alignment = taCenter
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clMenu
    TabOrder = 4
  end
end
