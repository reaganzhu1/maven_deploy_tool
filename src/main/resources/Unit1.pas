unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, shellapi, pom, RxStrUtils, Mask, {ToolEdit, Placemnt,}
  rxPlacemnt, rxToolEdit, mvnDeploy,mvnDeployUtil;

type
  TForm1 = class(TForm)
    Button2: TButton;
    Button4: TButton;
    libraryPathEdit: TDirectoryEdit;
    groupidEdit: TEdit;
    FormStorage1: TFormStorage;
    Label1: TLabel;
    Label2: TLabel;
    Button7: TButton;
    Label3: TLabel;
    repositoryUrlEdit: TEdit;
    Label4: TLabel;
    repositoryIdEdit: TEdit;
    Button1: TButton;
    ftpRadio: TRadioButton;
    NexusRadio: TRadioButton;
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var

  Form1: TForm1;

implementation

{$R *.dfm}




procedure TForm1.Button4Click(Sender: TObject);
var F1: TMavenDeploy;
  F: TMavenDeployMode;
begin
  if ftpRadio.Checked then F := mdFtp else F := mdNexus;
  F1 := TMavenDeploy.CreateEx(F, libraryPathEdit.Text, groupIdEdit.Text, repositoryIdEdit.Text, repositoryUrlEdit.Text);
  try
    F1.mvnDeploy(false);
  finally
    F1.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var F1: TMavenDeploy;
  F: TMavenDeployMode;
begin
  if ftpRadio.Checked then F := mdFtp else F := mdNexus;
  F1 := TMavenDeploy.CreateEx(F, libraryPathEdit.Text, groupIdEdit.Text, repositoryIdEdit.Text, repositoryUrlEdit.Text);
  try
    F1.mvnDeploy(true);
  finally
    F1.Free;
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  MessageDlg('first created in 2009'+#13#10+'published in 2020'+#13#10+'by zhukun2007@gmail.com', mtInformation, [mbOK], 0);
end;

end.

