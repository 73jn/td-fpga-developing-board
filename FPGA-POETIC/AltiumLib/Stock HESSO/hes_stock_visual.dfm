object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Hes-so//Valais Components checker       V1.1 (sarto / 01-2017)'
  ClientHeight = 300
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = Form1Create
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 18
    Top = 15
    Width = 250
    Height = 16
    Caption = 'Controls for missing stock components'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 26
    Top = 267
    Width = 324
    Height = 13
    Caption = 
      'If parameter "Supplier 1" is defined in a component, this compon' +
      'ent'
  end
  object Label3: TLabel
    Left = 26
    Top = 282
    Width = 149
    Height = 13
    Caption = 'will be considered as "in stock".'
  end
  object Label4: TLabel
    Left = 18
    Top = 39
    Width = 86
    Height = 13
    Caption = 'Access Database:'
  end
  object Shape1: TShape
    Left = 20
    Top = 192
    Width = 360
    Height = 1
  end
  object Shape2: TShape
    Left = 20
    Top = 144
    Width = 360
    Height = 1
  end
  object Label6: TLabel
    Left = 18
    Top = 115
    Width = 248
    Height = 13
    Caption = 'If really necessary, you can choose another one ...'
  end
  object Label7: TLabel
    Left = 18
    Top = 99
    Width = 265
    Height = 13
    Caption = 'Call them to update this Database is the better choice !'
  end
  object Label8: TLabel
    Left = 18
    Top = 83
    Width = 339
    Height = 13
    Caption = 
      'This database in maintained by the "Electronics Workshop Team" o' +
      'nly !'
  end
  object cbResistors: TCheckBox
    Left = 41
    Top = 149
    Width = 97
    Height = 17
    Caption = 'Check resistors'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = cbResistorsClick
  end
  object cbCapacitors: TCheckBox
    Left = 40
    Top = 168
    Width = 112
    Height = 17
    Caption = 'Check capacitors'
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = cbCapacitorsClick
  end
  object cbOthers: TCheckBox
    Left = 193
    Top = 168
    Width = 135
    Height = 17
    Caption = 'Check all components'
    TabOrder = 2
    OnClick = cbOthersClick
  end
  object btOk: TButton
    Left = 25
    Top = 230
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 3
    OnClick = btOkClick
  end
  object btCancel: TButton
    Left = 305
    Top = 230
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btCancelClick
  end
  object lblDatabase: TEdit
    Left = 13
    Top = 52
    Width = 371
    Height = 21
    Enabled = False
    TabOrder = 5
    Text = 'unknow'
  end
  object cbTBD: TCheckBox
    Left = 41
    Top = 203
    Width = 207
    Height = 17
    Caption = 'Exclude "TBD" values from check'
    TabOrder = 6
  end
  object cbInductors: TCheckBox
    Left = 193
    Top = 149
    Width = 97
    Height = 17
    Caption = 'Check inductors'
    Checked = True
    State = cbChecked
    TabOrder = 7
    OnClick = cbInductorsClick
  end
  object btOpenDialog: TButton
    Left = 304
    Top = 103
    Width = 79
    Height = 25
    Caption = 'Change DB'
    TabOrder = 8
    OnClick = btOpenDialogClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'DBFile|*.accdb'
    Title = 'Select database file...'
    Left = 352
    Top = 16
  end
end
