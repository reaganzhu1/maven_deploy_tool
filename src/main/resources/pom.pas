
{********************************************}
{                                            }
{              XML Data Binding              }
{                                            }
{         Generated on: 2009-3-19 8:59:45    }
{       Generated from: D:\test1\ddd\a.xsd   }
{   Settings stored in: D:\test1\ddd\a.xdb   }
{                                            }
{********************************************}

unit pom;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLXml = interface;
  IXMLDependencies = interface;
  IXMLDependency = interface;

{ IXMLXml }

  IXMLXml = interface(IXMLNode)
    ['{F2911B45-5FAB-430E-8B5F-D7A9A580DEE0}']
    { Property Accessors }
    function Get_Version: WideString;
    function Get_Encoding: WideString;
    function Get_Dependencies: IXMLDependencies;
    procedure Set_Version(Value: WideString);
    procedure Set_Encoding(Value: WideString);
    { Methods & Properties }
    property Version: WideString read Get_Version write Set_Version;
    property Encoding: WideString read Get_Encoding write Set_Encoding;
    property Dependencies: IXMLDependencies read Get_Dependencies;
  end;

{ IXMLDependencies }

  IXMLDependencies = interface(IXMLNodeCollection)
    ['{0EC703ED-3C3A-4478-BEE0-03F08C6F6E2D}']
    { Property Accessors }
    function Get_Dependency(Index: Integer): IXMLDependency;
    { Methods & Properties }
    function Add: IXMLDependency;
    function Insert(const Index: Integer): IXMLDependency;
    property Dependency[Index: Integer]: IXMLDependency read Get_Dependency; default;
  end;

{ IXMLDependency }

  IXMLDependency = interface(IXMLNode)
    ['{7D8EACF1-CD08-4433-86FC-E04A5D86A7CF}']
    { Property Accessors }
    function Get_GroupId: WideString;
    function Get_ArtifactId: WideString;
    function Get_Version: WideString;
    procedure Set_GroupId(Value: WideString);
    procedure Set_ArtifactId(Value: WideString);
    procedure Set_Version(Value: WideString);
    { Methods & Properties }
    property GroupId: WideString read Get_GroupId write Set_GroupId;
    property ArtifactId: WideString read Get_ArtifactId write Set_ArtifactId;
    property Version: WideString read Get_Version write Set_Version;
  end;

{ Forward Decls }

  TXMLXml = class;
  TXMLDependencies = class;
  TXMLDependency = class;

{ TXMLXml }

  TXMLXml = class(TXMLNode, IXMLXml)
  protected
    { IXMLXml }
    function Get_Version: WideString;
    function Get_Encoding: WideString;
    function Get_Dependencies: IXMLDependencies;
    procedure Set_Version(Value: WideString);
    procedure Set_Encoding(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDependencies }

  TXMLDependencies = class(TXMLNodeCollection, IXMLDependencies)
  protected
    { IXMLDependencies }
    function Get_Dependency(Index: Integer): IXMLDependency;
    function Add: IXMLDependency;
    function Insert(const Index: Integer): IXMLDependency;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDependency }

  TXMLDependency = class(TXMLNode, IXMLDependency)
  protected
    { IXMLDependency }
    function Get_GroupId: WideString;
    function Get_ArtifactId: WideString;
    function Get_Version: WideString;
    procedure Set_GroupId(Value: WideString);
    procedure Set_ArtifactId(Value: WideString);
    procedure Set_Version(Value: WideString);
  end;

{ Global Functions }

function Getxml(Doc: IXMLDocument): IXMLXml;
function Loadxml(const FileName: WideString): IXMLXml;
function Newxml: IXMLXml;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function Getxml(Doc: IXMLDocument): IXMLXml;
begin
  Result := Doc.GetDocBinding('xml', TXMLXml, TargetNamespace) as IXMLXml;
end;

function Loadxml(const FileName: WideString): IXMLXml;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('xml', TXMLXml, TargetNamespace) as IXMLXml;
end;

function Newxml: IXMLXml;
begin
  Result := NewXMLDocument.GetDocBinding('xml', TXMLXml, TargetNamespace) as IXMLXml;
end;

{ TXMLXml }

procedure TXMLXml.AfterConstruction;
begin
  RegisterChildNode('dependencies', TXMLDependencies);
  inherited;
end;

function TXMLXml.Get_Version: WideString;
begin
  Result := AttributeNodes['version'].Text;
end;

procedure TXMLXml.Set_Version(Value: WideString);
begin
  SetAttribute('version', Value);
end;

function TXMLXml.Get_Encoding: WideString;
begin
  Result := AttributeNodes['encoding'].Text;
end;

procedure TXMLXml.Set_Encoding(Value: WideString);
begin
  SetAttribute('encoding', Value);
end;

function TXMLXml.Get_Dependencies: IXMLDependencies;
begin
  Result := ChildNodes['dependencies'] as IXMLDependencies;
end;

{ TXMLDependencies }

procedure TXMLDependencies.AfterConstruction;
begin
  RegisterChildNode('dependency', TXMLDependency);
  ItemTag := 'dependency';
  ItemInterface := IXMLDependency;
  inherited;
end;

function TXMLDependencies.Get_Dependency(Index: Integer): IXMLDependency;
begin
  Result := List[Index] as IXMLDependency;
end;

function TXMLDependencies.Add: IXMLDependency;
begin
  Result := AddItem(-1) as IXMLDependency;
end;

function TXMLDependencies.Insert(const Index: Integer): IXMLDependency;
begin
  Result := AddItem(Index) as IXMLDependency;
end;

{ TXMLDependency }

function TXMLDependency.Get_GroupId: WideString;
begin
  Result := ChildNodes['groupId'].Text;
end;

procedure TXMLDependency.Set_GroupId(Value: WideString);
begin
  ChildNodes['groupId'].NodeValue := Value;
end;

function TXMLDependency.Get_ArtifactId: WideString;
begin
  Result := ChildNodes['artifactId'].Text;
end;

procedure TXMLDependency.Set_ArtifactId(Value: WideString);
begin
  ChildNodes['artifactId'].NodeValue := Value;
end;

function TXMLDependency.Get_Version: WideString;
begin
  Result := ChildNodes['version'].Text;
end;

procedure TXMLDependency.Set_Version(Value: WideString);
begin
  ChildNodes['version'].NodeValue := Value;
end;

end.