object login: Tlogin
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = #1042#1093#1086#1076
  ClientHeight = 246
  ClientWidth = 266
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 70
    Top = 79
    Width = 75
    Height = 25
    Caption = #1042#1093#1086#1076
    Default = True
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 151
    Top = 79
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = BitBtn2Click
  end
  object panel_exten: TPanel
    Left = 8
    Top = 4
    Width = 249
    Height = 69
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object edit_exten: TLabeledEdit
      Left = 120
      Top = 12
      Width = 121
      Height = 21
      EditLabel.Width = 93
      EditLabel.Height = 13
      EditLabel.Caption = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1085#1086#1084#1077#1088
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object edit_queuelist: TLabeledEdit
      Left = 120
      Top = 39
      Width = 121
      Height = 21
      EditLabel.Width = 87
      EditLabel.Height = 13
      EditLabel.Caption = #1040#1076#1088#1077#1089' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
      Enabled = False
      LabelPosition = lpLeft
      TabOrder = 1
      OnChange = edit_queuelistChange
    end
  end
  object panel_server: TPanel
    Left = 8
    Top = 110
    Width = 249
    Height = 122
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Locked = True
    TabOrder = 3
    object edit_server: TLabeledEdit
      Left = 120
      Top = 11
      Width = 121
      Height = 21
      EditLabel.Width = 75
      EditLabel.Height = 13
      EditLabel.Caption = #1040#1076#1088#1077#1089' '#1089#1077#1088#1074#1077#1088#1072
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object edit_port: TLabeledEdit
      Left = 120
      Top = 38
      Width = 121
      Height = 21
      EditLabel.Width = 25
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1086#1088#1090
      LabelPosition = lpLeft
      NumbersOnly = True
      TabOrder = 1
    end
    object edit_login: TLabeledEdit
      Left = 120
      Top = 65
      Width = 121
      Height = 21
      EditLabel.Width = 93
      EditLabel.Height = 13
      EditLabel.Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
      LabelPosition = lpLeft
      TabOrder = 2
    end
    object edit_password: TLabeledEdit
      Left = 120
      Top = 92
      Width = 121
      Height = 21
      BevelEdges = [beLeft]
      EditLabel.Width = 37
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1072#1088#1086#1083#1100
      LabelPosition = lpLeft
      PasswordChar = '*'
      TabOrder = 3
    end
  end
  object Button1: TButton
    Left = 232
    Top = 79
    Width = 28
    Height = 25
    Caption = '...'
    Enabled = False
    TabOrder = 4
    OnClick = Button1Click
  end
end
