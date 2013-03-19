program calllog_asterisk;

{$R *.dres}

uses
  Forms,
  mainform in 'mainform.pas' {main},
  tools in 'tools.pas',
  vars in 'vars.pas',
  loginform in 'loginform.pas' {login},
  descriptionform in 'descriptionform.pas' {form_description},
  stringhash in 'stringhash.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.ShowMainForm := False;
  Application.Title := 'CallLog';
  Application.CreateForm(Tmain, main);
  Application.CreateForm(Tform_description, form_description);
  Application.Run;
end.
