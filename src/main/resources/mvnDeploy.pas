unit mvnDeploy;

interface

//todo add check artifactid on repository
//todo add auto get groupid by artifactid from http://mvnrepository.com/
//todo read settings.xml to get repo_id

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, shellapi, pom, RxStrUtils, Mask, 
  rxPlacemnt, rxToolEdit, mvnDeployUtil;

type

  TMavenDeployMode = (mdFtp, mdNexus);

  ICmdGenerator = interface
    function gen(filename, repositoryUrl, repositoryId: string): string;
  end;

  TFtpCmdGenerator = class(TInterfacedObject, ICmdGenerator)
  public
    function gen(filename, repositoryUrl, repositoryId: string): string;
  end;

  TNexusCmdGenerator = class(TInterfacedObject, ICmdGenerator)
  public
    function gen(filename, repositoryUrl, repositoryId: string): string;
  end;

  TCmdGeneratorFactory = class(TComponent)
  private
    FMode: TMavenDeployMode;
  public
    constructor CreateEx(mode: TMavenDeployMode);
    function getCmdGenerator: ICmdGenerator;
  end;

  TMavenDeploy = class(TComponent)
  private
    FLibraryPath: string;
    FGroupId: string;
    FRepositoryId: string;
    FRepositoryUrl: string;
    FCmdGeneratorFactory: TCmdGeneratorFactory;
  protected
    procedure generateBatFile(runbat: boolean);
    function checkAll: boolean;
  public
    constructor CreateEx(mode: TMavenDeployMode; libraryPath, groupId, repositoryId, repositoryUrl: string);
    destructor Destroy; override;
    procedure mvnDeploy(runbat: boolean);
  end;



implementation


constructor TMavenDeploy.CreateEx(mode: TMavenDeployMode; libraryPath, groupId, repositoryId, repositoryUrl: string);
begin
  inherited Create(nil);
  FGroupId := groupId;
  FLibraryPath := libraryPath;
  FRepositoryId := repositoryId;
  FRepositoryUrl := repositoryUrl;
  FCmdGeneratorFactory := TCmdGeneratorFactory.CreateEx(mode);
end;

destructor TMavenDeploy.Destroy;
begin
  FCmdGeneratorFactory.Free;
  inherited Destroy;
end;

procedure TMavenDeploy.generateBatFile(runbat: boolean);
const
  pom_str: string = '<?xml version="1.0" encoding="UTF-8"?>  ' + #13#10 +
  '<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">  ' + #13#10 +
    '  <modelVersion>4.0.0</modelVersion>  ' + #13#10 +
    '  ' + #13#10 +
    '  <groupId>:groupId</groupId>  ' + #13#10 +
    '  <artifactId>:artifactId</artifactId>  ' + #13#10 +
    '  <version>:version</version>  ' + #13#10 +
    '  <packaging>jar</packaging>' + #13#10 +
    '' + #13#10 +
    '    <build>' + #13#10 +
    '        <extensions>' + #13#10 +
    '            <extension>' + #13#10 +
    '                <groupId>org.apache.maven.wagon</groupId>' + #13#10 +
    '                <artifactId>wagon-ftp</artifactId>' + #13#10 +
    '                <version>1.0-alpha-6</version>' + #13#10 +
    '            </extension>' + #13#10 +
    '        </extensions>' + #13#10 +
    '		<plugins> ' + #13#10 +
    '		 <plugin> ' + #13#10 +
    '		  <groupId>org.apache.maven.plugins</groupId>' + #13#10 +
    '		  <artifactId>maven-deploy-plugin</artifactId>' + #13#10 +
    '		  <version>2.7</version> ' + #13#10 +
    '		 </plugin> ' + #13#10 +
    '		</plugins>' + #13#10 +
    '  </build>    ' + #13#10 +
    '</project>';

var
  F1: IXMLXml;
  i: integer;
  artifactid, version, jar_filename, cmd, pom, tmp_path, cmd1: string;
  libpath: string;
  I1: ICmdGenerator;
begin
  libpath := FLibraryPath + '\';
  F1 := Loadxml(FLibraryPath + '\' + 'dependencies.xml');

  I1 := FCmdGeneratorFactory.getCmdGenerator;

  cmd1 := '';
  for i := 0 to F1.Dependencies.Count - 1 do
  begin
    artifactid := F1.Dependencies[i].ArtifactId;
    version := F1.Dependencies[i].Version;
    jar_filename := artifactid + '-' + version + '.jar';

    tmp_path := libpath + artifactid + '-' + version + '\';
    mkdir(tmp_path);
    MoveFile(pchar(libpath + jar_filename), pchar(tmp_path + jar_filename));

    cmd := I1.gen(jar_filename, FRepositoryUrl, FRepositoryId);


    pom := StringReplace(pom_str, ':groupId', FGroupId, [rfReplaceAll]);
    pom := StringReplace(pom, ':artifactId', artifactid, [rfReplaceAll]);
    pom := StringReplace(pom, ':version', version, [rfReplaceAll]);

    saveFile(tmp_path + artifactid + '.bat', cmd);
    saveFile(tmp_path + 'pom.xml', pom);
    cmd1 := cmd1 + #13#10 + 'cd ' + tmp_path;
    cmd1 := cmd1 + #13#10 + 'call ' + tmp_path + artifactid + '.bat';
  end;

  saveFile(libpath + 'deploy.bat', cmd1);

  if runbat then
    ShellExecute(Application.Handle, nil, Pchar(libpath + 'deploy.bat'), nil, Pchar(libpath), SW_SHOWNORMAL)
  else
    showmessage('deploy.bat已经生成在--' + libpath + '目录下，请手工执行。');
end;


procedure TMavenDeploy.mvnDeploy(runbat: boolean);
var st: tstringlist;
  havedir: boolean;
begin
  havedir := false;

  if checkAll then
  begin
    DeleteFile(FLibraryPath + '\dependencies.xml');
    DeleteFile(FLibraryPath + '\deploy.bat');

    arrangeFileList(FLibraryPath, '.jar');

    st := MakeFileList(FLibraryPath + '\', '.jar', havedir);
    if havedir then
      showmessage('请先删除子目录!请注意，最好把lib目录复制一份，在副本目录操作，以避免风险。')
    else
    try
      createXml(FLibraryPath + '\', FGroupId, st);
      generateBatFile(runbat);
    finally
      st.Free;
    end;
  end else Showmessage('请检查输入的各项参数是否为空！');
end;

function TMavenDeploy.checkAll: boolean;
var tmpResult: boolean;
begin
  tmpResult := true;

  if (trim(FLibraryPath) = '') or (trim(FGroupId) = '') or (trim(FRepositoryUrl) = '') or (trim(FRepositoryId) = '') then
  begin
    tmpResult := false;
  end;

  Result := tmpResult;
end;


function TFtpCmdGenerator.gen(filename, repositoryUrl, repositoryId: string): string;
const
  cmd_str: string = 'mvn deploy:deploy-file -Dfile=:filename -Durl=:ftpIp -DrepositoryId=:repositoryId -DpomFile=pom.xml -DuniqueVersion=false';
var cmd: string;
begin
  cmd := StringReplace(cmd_str, ':filename', filename, [rfReplaceAll]);
  cmd := StringReplace(cmd, ':ftpIp', repositoryUrl, [rfReplaceAll]);
  cmd := StringReplace(cmd, ':repositoryId', repositoryId, [rfReplaceAll]);
  Result := cmd;
end;

function TNexusCmdGenerator.gen(filename, repositoryUrl, repositoryId: string): string;
const
  cmd_str: string = 'mvn deploy:deploy-file -Dfile=:filename -Durl=:nexusUrl -DrepositoryId=:repositoryId -DpomFile=pom.xml -DuniqueVersion=false -DgeneratePom=false';
var cmd: string;
begin
  cmd := StringReplace(cmd_str, ':filename', filename, [rfReplaceAll]);
  cmd := StringReplace(cmd, ':nexusUrl', repositoryUrl, [rfReplaceAll]);
  cmd := StringReplace(cmd, ':repositoryId', repositoryId, [rfReplaceAll]);
  Result := cmd;
end;

constructor TCmdGeneratorFactory.CreateEx(mode: TMavenDeployMode);
begin
  FMode := mode;
end;

function TCmdGeneratorFactory.getCmdGenerator: ICmdGenerator;
begin
  if Fmode = mdFtp then
    Result := TFtpCmdGenerator.Create
  else
    Result := TNexusCmdGenerator.Create;
end;

end.

