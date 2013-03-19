unit loginform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, ExtCtrls;

type
  Tlogin = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    panel_exten: TPanel;
    edit_exten: TLabeledEdit;
    panel_server: TPanel;
    edit_server: TLabeledEdit;
    edit_port: TLabeledEdit;
    edit_login: TLabeledEdit;
    edit_password: TLabeledEdit;
    edit_queuelist: TLabeledEdit;
    Button1: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure edit_queuelistChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  login: Tlogin;

implementation
uses mainform;
{$R *.dfm}

procedure Tlogin.BitBtn1Click(Sender: TObject);
begin
  ModalResult:=1;
end;

procedure Tlogin.BitBtn2Click(Sender: TObject);
begin
  ModalResult:=2;
end;

procedure Tlogin.Button1Click(Sender: TObject);
begin
  height:=panel_server.Top + panel_server.Height+30;
end;

procedure Tlogin.edit_queuelistChange(Sender: TObject);
var
  i:integer;
  s:string;
begin
{  s:=TLabeledEdit(Sender).Text;
  for i := 1 to Length(s) do
  begin
    if not (
    ((Copy(s, i, 1)>='0') and (Copy(s, i, 1)<='9'))
    or (Copy(s, i, 1)='A')
    or (Copy(s, i, 1)='M')
    or (Copy(s, i, 1)='P')
    or (Copy(s, i, 1)=' ')
    or (Copy(s, i, 1)=',')
    or (Copy(s, i, 1)='/')
    )
    then
      delete(s, i, 1);
  end;
  TLabeledEdit(Sender).Text:=s;}
end;

procedure Tlogin.FormActivate(Sender: TObject);
begin
  edit_exten.SetFocus;
end;

procedure Tlogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  main.Show;
  if (ModalResult <> 1) then
    ModalResult:=2;
end;

procedure Tlogin.FormCreate(Sender: TObject);
begin
  height:=panel_server.Top+22;
end;

procedure Tlogin.FormShow(Sender: TObject);
begin
  main.Hide;
end;

end.
