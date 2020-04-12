unit mvnDeployUtil;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, shellapi, pom, RxStrUtils, Mask, xmlDoc,
  rxPlacemnt, rxToolEdit;


procedure saveFile(filename, content: string);
function rightStr1(s: string; i: integer): string;
function rightStr2(s: string; i: integer): string;
function leftStr1(s: string; i: integer): string;
function leftStr2(s: string; i: integer): string;
procedure arrangeFileList(Path, FileExt: string);
function MakeFileList(Path, FileExt: string; var havedir: boolean): TStringList;
procedure createXml(libpath, groupid: string; St: TStringList);
function MakeFileList1(Path, FileExt: string): TStringList;
function getFirstMinus(s: string): integer;
function getSnapShot(s: string): boolean;
function getVersionII(filename: string; var artifactId: string): string;
function FormatJarFileName(s1: string): string;
function ExeOrDllPath: string;

function checkSt(s: string): boolean;

var St1: TStringList;

implementation

function checkSt(s: string): boolean;
begin
  St1.CaseSensitive := false;
  if St1.IndexOf(s) >= 0 then
    Result := true
  else
    Result := false;
end;

function ExeOrDllPath: string;
var
  Path: array[0..MAX_PATH - 1] of Char;
begin
  if IsLibrary then
    SetString(Result, Path, GetModuleFileName(HInstance, Path, SizeOf(Path)))
  else
    Result := ParamStr(0);
end;

procedure saveFile(filename, content: string);
var St: TStringList;
begin
  St := TStringList.Create;
  try
    St.Clear;
    St.Add(content);
    St.SaveToFile(filename);
  finally
    St.Free;
  end;
end;


function rightStr1(s: string; i: integer): string;
var s1: string;
begin
  s1 := copy(s, length(s) - i + 1, i);
  result := s1;
end;

function rightStr2(s: string; i: integer): string;
var s1: string;
begin
  s1 := copy(s, i, length(s) - i + 1);
  s1 := StringReplace(s1, '-', '', [rfReplaceAll]);
  s1 := StringReplace(s1, '.jar', '', [rfReplaceAll]);
  result := s1;
end;

function leftStr1(s: string; i: integer): string;
var s1: string;
begin
  s1 := copy(s, 0, length(s) - i);
  result := s1;
end;

function leftStr2(s: string; i: integer): string;
var s1: string;
begin
  s1 := copy(s, 0, i - 1);
  result := s1;
end;

function MakeFileList(Path, FileExt: string; var havedir: boolean): TStringList;
var
  sch: TSearchrec;
begin
  Result := TStringlist.Create;

  if rightStr1(trim(Path), 1) <> '\' then
    Path := trim(Path) + '\'
  else
    Path := trim(Path);

  if not DirectoryExists(Path) then
  begin
    Result.Clear;
    exit;
  end;

  if FindFirst(Path + '*', faAnyfile, sch) = 0 then
  begin
    repeat
      Application.ProcessMessages;
      if ((sch.Name = '.') or (sch.Name = '..')) then Continue;
      if DirectoryExists(Path + sch.Name) then
      begin
        havedir := true;
      end
      else
      begin
        if (UpperCase(extractfileext(Path + sch.Name)) = UpperCase(FileExt)) or (FileExt = '.*') then

          Result.Add(Path + sch.Name);
      end;
    until FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
  end;
end;

procedure arrangeFileList(Path, FileExt: string);
var
  sch: TSearchrec;
  tmpname: string;
begin

  if rightStr1(trim(Path), 1) <> '\' then
    Path := trim(Path) + '\'
  else
    Path := trim(Path);

  if not DirectoryExists(Path) then
  begin
    exit;
  end;

  if FindFirst(Path + '*', faAnyfile, sch) = 0 then
  begin
    repeat
      Application.ProcessMessages;
      if ((sch.Name = '.') or (sch.Name = '..')) then Continue;
      if (not DirectoryExists(Path + sch.Name)) and ((UpperCase(extractfileext(Path + sch.Name)) = UpperCase(FileExt)) or (FileExt = '.*')) then
      begin
        tmpname := FormatJarFileName(sch.Name);
        MoveFile(pchar(path + sch.Name), pchar(path + tmpname));
      end;
    until FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
  end;
end;

function MakeFileList1(Path, FileExt: string): TStringList;
var
  sch: TSearchrec;
begin
  Result := TStringlist.Create;

  if rightStr1(trim(Path), 1) <> '\' then
    Path := trim(Path) + '\'
  else
    Path := trim(Path);

  if not DirectoryExists(Path) then
  begin
    Result.Clear;
    exit;
  end;

  if FindFirst(Path + '*', faAnyfile, sch) = 0 then
  begin
    repeat
      Application.ProcessMessages;
      if ((sch.Name = '.') or (sch.Name = '..')) then Continue;
      if DirectoryExists(Path + sch.Name) then
      begin
        Result.AddStrings(MakeFileList1(Path + sch.Name, FileExt));
      end else begin
        if (UpperCase(extractfileext(Path + sch.Name)) = UpperCase(FileExt)) or (FileExt = '.*') then
          Result.Add(sch.Name);
      end;
    until FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
  end;
end;


procedure createXml(libpath, groupid: string; St: TStringList);
var F: IXMLDependencies;
  F1: IXMLDependency;
  artifactid, version, s1, s2: string;
  i: integer;
  st1: TstringList;
begin
  F := Newxml.Dependencies;
  for i := 0 to st.Count - 1 do
  begin
    s1 := StringReplace(st[i], libpath, '', [rfReplaceAll]);

    version := getVersionII(s1, artifactid);

    F1 := F.Add;
    F1.GroupId := groupid;
    F1.ArtifactId := artifactid;
    F1.Version := version;
  end;



  s2 :=
    '<xml version="1.0" encoding="UTF-8" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="D:\test1\ddd\a.xsd">'
    + xmlDoc.FormatXMLData(F.XML)
    + '</xml>';

  st1 := TStringList.Create;
  try
    St1.Clear;
    st1.Add(s2);
    st1.SaveToFile(libpath + '\dependencies.xml');
  finally
    St1.Free;
  end;

end;

function getSnapShot(s: string): boolean;
var pos1: integer;
  s1: string;
begin
  pos1 := getFirstMinus(s);
  s1 := trim(lowercase(rightstr2(s, pos1)));
  if s1 = 'snapshot' then
    Result := true
  else
    Result := false;
end;


function getFirstMinus(s: string): integer;
var i, pos: integer;
begin
  pos := -1;
  for i := length(s) - 1 downto 0 do
  begin
    if s[i] = '-' then
    begin
      pos := i;
      break;
    end;
  end;
  result := pos;
end;


function FormatJarFileName(s1: string): string;
var i, t1, pos1, pos2, len, pos_r, pos4: integer;
  v1: array of string;
  tmpResult, s: string;
begin
  s := StringReplace(s1, '+', '', [rfReplaceAll]);
  s := StringReplace(s, '_', '-', [rfReplaceAll]);
  tmpResult := s;

  setlength(v1, length(s));
  for i := 0 to length(s) - 1 do
  begin
    v1[i] := copy(s, i + 1, 1);
  end;

  //查找数字位置
  pos1 := -1;
  for i := 0 to length(v1) - 1 do
  begin
    t1 := StrToIntDef(v1[i], -1);
    if t1 >= 0 then begin
      pos1 := i;
      break;
    end;
  end;

  //查找数字前面的-位置
  pos2 := -1;
  for i := pos1 downto 0 do
  begin
    if (v1[i] = '-') then begin
      pos2 := i;
      break;
    end;
  end;

  //查找数字后面的-位置
  pos4 := -1;
  if pos1 > 0 then begin
    for i := pos1 to length(s) - 1 do
    begin
      if (v1[i] = '-') then begin
        pos4 := i;
        break;
      end;
    end;
  end;

  len := length(s);
  //如果前面有数字，但是后面有-，那么也暂不处理，以免误伤c3p0-1.0.0.jar或者t2sdk-1.0.0.jar
  //如果在config.txt中配置了artifactid，这样类似 cms-core-db-1.0.2SP8_20120927_jdk1.4.jar 才能得到正确处理
  //类似c3p0之类的artifactid需要在config.txt中进行配置


  if (pos4 > 0) and (pos1 > 0) and checkSt(copy(s, 0, pos4)) then begin
    tmpResult := s;
  end else if (pos2 = -1) and (pos1 > 0) then //如果有数字，但是前面没有-，那么给数字和前面部分中间加一个-
  begin
    //如果含有jdk字样，那么在jdk前面加-
    pos_r := pos('jdk', lowercase(copy(s, 1, pos1)));
    if pos_r > 0 then
    begin
      tmpResult := copy(s, 1, pos_r) + '-' + copy(s, pos_r + 1, len - pos_r);
    end else begin
      if (copy(s, pos1 + 1, 1) <> '4') then begin
        //如果有数字，但是前面没有-，那么给数字和前面部分中间加一个-
        tmpResult := copy(s, 1, pos1) + '-' + copy(s, pos1 + 1, len - pos1);
      end else begin
        //为了处理log4j之类的字串，用占位符代替
        tmpResult := StringReplace(s, '4', 'MavenDeployTmpTag', []);
        tmpResult := FormatJarFileName(tmpResult);
        tmpResult := StringReplace(tmpResult, 'MavenDeployTmpTag', '4', []);
      end;
    end;
  end else if (pos1 = -1) then begin
    tmpResult := copy(s, 1, len - 4) + '-1.0.0' + copy(s, len - 3, 4);
  end else if (pos1 > 0) and (pos2 > 0) and (pos4 = -1) and (pos1-pos2>2)  then //如果数字前面有-，后面没有- eg.bocom-netsing1.8
  begin
    tmpResult := copy(s, 1, pos1) + '-' + copy(s, pos1 + 1, len - pos1);
  end;

  setlength(v1, 0);

  Result := tmpResult;
end;

function getVersionII(filename: string; var artifactId: string): string;
var i, t1, pos1, pos2, pos3, pos4: integer;
  v1: array of string;
  s1, s, tmp_version: string;
begin
  if lowercase(ExtractFileExt(filename)) = '.jar' then
    s := copy(filename, 1, length(filename) - 4)
  else
    s := filename;

  setlength(v1, length(s));
  for i := 0 to length(s) - 1 do
  begin
    v1[i] := copy(s, i + 1, 1);
  end;

  //查找数字位置
  pos1 := -1;
  for i := 0 to length(v1) - 1 do
  begin
    t1 := StrToIntDef(v1[i], -1);
    if t1 >= 0 then begin
      pos1 := i;
      break;
    end;
  end;

  //查找数字前面的-位置
  pos2 := -1;
  for i := pos1 downto 0 do
  begin
    if (v1[i] = '-') then begin
      pos2 := i;
      break;
    end;
  end;

  //查找数字后面的-位置
  pos4 := -1;
  if pos1 > 0 then begin
    for i := pos1 to length(s) - 1 do
    begin
      if (v1[i] = '-') then begin
        pos4 := i;
        break;
      end;
    end;
  end;

  pos3 := length(s);

  //有数字，数字后面有-，则用-前面的做artifactid,后面的做version，如果在config.txt中配置了artifactid
  if (pos4 > 0) and (pos1 > 0) and checkSt(copy(s, 0, pos4)) then begin
    s1 := copy(s, pos4 + 2, pos3 - pos4 - 1);
    artifactId := copy(s, 0, pos4);
  end else if (pos2 = -1) and (pos1 > 0) and (pos3 > 0) then //有数字，但是前面没有-
  begin
    //取数字和后面部分作为version，数字前面部分为artifactid
    if (copy(s, pos1 + 1, 1) <> '4') then begin
      s1 := copy(s, pos1 + 1, pos3 - pos1);
      artifactId := copy(s, 0, pos1);
    end else begin
      //如果有log4j之类的字串，要保留原样，t2sdk之类的就只能手工处理了。
      s := StringReplace(s, '4', 'MavenDeployTmpTag', []);
      s1 := getVersionII(s, artifactid);
      artifactid := StringReplace(artifactid, 'MavenDeployTmpTag', '4', []);
    end;
  //如果有数字，前面也有-，那么取-前面的作为artifactid,-后面的作为version
  end else if (pos2 > 0) and (pos1 > 0) then begin
    //如果version中含有类似log4j的字串，那么要取后面-后面的部分作为version
    if (copy(s, pos1 + 1, 1) = '4') and ((StrToIntDef(copy(s, pos1 + 2, 1), -1)) = -1) and
      ((pos('-', copy(s, pos2 + 2, pos3 - pos2 - 1))) > 0) then begin
      tmp_version := copy(s, pos2 + 2, pos3 - pos2 - 1);
      pos4 := pos('-', tmp_version);
      s1 := copy(tmp_version, pos4 + 1, length(tmp_version) - pos4);
      artifactId := copy(s, 0, pos2 + pos4);
    end else begin
      s1 := copy(s, pos2 + 2, pos3 - pos2 - 1);
      artifactId := copy(s, 0, pos2);
    end;
  end;

  setlength(v1, 0);

  Result := s1;
end;

initialization

  St1 := TStringList.Create;
  if FileExists(ExtractFilePath(ExeOrDllPath) + 'config.txt') then
    St1.LoadFromFile(ExtractFilePath(ExeOrDllPath) + 'config.txt');

finalization

  St1.Clear;
  St1.Free;

end.

