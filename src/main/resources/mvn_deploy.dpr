program mvn_deploy;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  pom in 'pom.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
