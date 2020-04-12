object Form1: TForm1
  Left = 389
  Top = 151
  BorderStyle = bsDialog
  Caption = 'maven deploy tool (by zhukun2007@gmail.com)'
  ClientHeight = 383
  ClientWidth = 540
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 39
    Top = 98
    Width = 58
    Height = 16
    Caption = 'groupid'#65306
  end
  object Label2: TLabel
    Left = 39
    Top = 49
    Width = 35
    Height = 16
    Caption = 'lib dir:'
  end
  object Label3: TLabel
    Left = 39
    Top = 145
    Width = 60
    Height = 16
    Caption = 'repo Url'#65306
  end
  object Label4: TLabel
    Left = 39
    Top = 186
    Width = 54
    Height = 16
    Caption = 'repo Id'#65306
  end
  object Button2: TButton
    Left = 49
    Top = 423
    Width = 93
    Height = 31
    Caption = 'arrangeFile'
    TabOrder = 0
    Visible = False
  end
  object Button4: TButton
    Left = 98
    Top = 305
    Width = 112
    Height = 31
    Caption = 'generate bat'
    TabOrder = 1
    OnClick = Button4Click
  end
  object libraryPathEdit: TDirectoryEdit
    Left = 108
    Top = 39
    Width = 352
    Height = 24
    DialogKind = dkWin32
    NumGlyphs = 1
    ButtonWidth = 26
    TabOrder = 2
  end
  object groupidEdit: TEdit
    Left = 108
    Top = 89
    Width = 352
    Height = 24
    TabOrder = 3
    Text = 'com.hundsun.fund.ets'
  end
  object Button7: TButton
    Left = 414
    Top = 305
    Width = 92
    Height = 31
    Caption = 'about'
    TabOrder = 4
    OnClick = Button7Click
  end
  object repositoryUrlEdit: TEdit
    Left = 108
    Top = 138
    Width = 352
    Height = 24
    TabOrder = 5
    Text = '192.168.1.1'
  end
  object repositoryIdEdit: TEdit
    Left = 108
    Top = 177
    Width = 352
    Height = 24
    TabOrder = 6
    Text = 'hundsun-nexus'
  end
  object Button1: TButton
    Left = 236
    Top = 305
    Width = 159
    Height = 31
    Caption = 'generate and  run bat'
    TabOrder = 7
    OnClick = Button1Click
  end
  object ftpRadio: TRadioButton
    Left = 49
    Top = 226
    Width = 139
    Height = 41
    Caption = 'Ftp'
    Checked = True
    TabOrder = 8
    TabStop = True
  end
  object NexusRadio: TRadioButton
    Left = 217
    Top = 226
    Width = 139
    Height = 41
    Caption = 'Nexus'
    TabOrder = 9
  end
  object FormStorage1: TFormStorage
    Options = [fpState, fpPosition, fpActiveControl]
    StoredProps.Strings = (
      'groupidEdit.Text'
      'libraryPathEdit.Text'
      'NexusRadio.Checked'
      'repositoryIdEdit.Text'
      'repositoryUrlEdit.Text'
      'ftpRadio.Checked')
    StoredValues = <>
    Left = 16
    Top = 248
  end
end
