unit pauseform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  Tform_pause = class(TForm)
    reason_index: TRadioGroup;
    reason_text: TMemo;
    Button1: TButton;
    Button2: TButton;
    queue_name: TEdit;
    Label1: TLabel;
    procedure reason_indexClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure reason_textChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_pause: Tform_pause;

implementation
uses mainform;
{$R *.dfm}


procedure Tform_pause.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not (reason_text.Enabled) then
    reason_text.text:='';
  main.Show;
  if (ModalResult <> mrOk) then
  begin
    ModalResult:=mrCancel;
  end;
end;

procedure Tform_pause.FormShow(Sender: TObject);
begin
  main.Hide;
end;

procedure Tform_pause.reason_indexClick(Sender: TObject);
begin
  reason_text.Enabled:=reason_index.ItemIndex in [3,5];
  button1.Enabled := reason_index.ItemIndex>=0;
  if (reason_index.ItemIndex in [3,5]) then
    button1.Enabled := length(reason_text.text)>0;
  if (reason_index.ItemIndex = 1) then
  begin//Запретить выбирать курение
    button1.Enabled := false;
    reason_index.ItemIndex := -1;
  end;
end;

procedure Tform_pause.reason_textChange(Sender: TObject);
begin
  if (reason_index.ItemIndex in [3,5]) then
    button1.Enabled := length(reason_text.text)>0;
end;

end.
