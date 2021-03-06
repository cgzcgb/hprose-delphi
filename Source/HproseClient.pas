{
/**********************************************************\
|                                                          |
|                          hprose                          |
|                                                          |
| Official WebSite: http://www.hprose.com/                 |
|                   http://www.hprose.org/                 |
|                                                          |
\**********************************************************/

/**********************************************************\
 *                                                        *
 * HproseClient.pas                                       *
 *                                                        *
 * hprose client unit for delphi.                         *
 *                                                        *
 * LastModified: Jun 11, 2016                             *
 * Author: Ma Bingyao <andot@hprose.com>                  *
 *                                                        *
\**********************************************************/
}
unit HproseClient;

{$I Hprose.inc}

interface

uses HproseCommon, Classes, SysUtils, TypInfo, Variants;

type
{$IFDEF Supports_Anonymous_Method}
  THproseCallback1 = reference to procedure(Result: Variant);
  THproseCallback2 = reference to procedure(Result: Variant;
    const Args: TVariants);
  THproseErrorEvent = reference to procedure(const Name:string;
                                const Error: Exception);
{$ELSE}
  THproseCallback1 = procedure(Result: Variant) of object;
  THproseCallback2 = procedure(Result: Variant;
    const Args: TVariants) of object;

  THproseErrorEvent = procedure(const Name:string;
                                const Error: Exception) of object;
{$ENDIF}

{$IFDEF Supports_Generics}
  THproseCallback1<T> = reference to procedure(Result: T);
  THproseCallback2<T> = reference to procedure(Result: T;
    const Args: TVariants);
{$ENDIF}

  IHproseReceiver = interface
    procedure Callback(Data: TBytes);
  end;

  THproseClient = class(TComponent, IInvokeableVarObject)
  private
    FNameSpace: string;
    FErrorEvent: THproseErrorEvent;
    FFilters: IList;
    function GetFilter: IHproseFilter;
    procedure SetFilter(const Filter: IHproseFilter);
    function DoInput(var Args: TVariants; ResultType: PTypeInfo;
      ResultMode: THproseResultMode; Data: TBytes): Variant; overload;
    function DoInput(ResultType: PTypeInfo; ResultMode: THproseResultMode;
      Data: TBytes): Variant; overload;
    function DoOutput(const AName: string;
      const Args: array of const; Simple: Boolean): TBytes; overload;
    function DoOutput(const AName: string; const Args: TVariants;
      ByRef: Boolean; Simple: Boolean): TBytes; overload;
{$IFDEF Supports_Generics}
    procedure DoInput(var Args: TVariants; ResultType: PTypeInfo;
      Data: TBytes; out Result); overload;
    procedure DoInput(ResultType: PTypeInfo;
      Data: TBytes; out Result); overload;
{$ENDIF}
    // Synchronous invoke
    function Invoke(const AName: string; const Args: array of const;
      ResultType: PTypeInfo; ResultMode: THproseResultMode; Simple: Boolean): Variant;
      overload;
    function Invoke(const AName: string; var Args: TVariants;
      ResultType: PTypeInfo; ByRef: Boolean;
      ResultMode: THproseResultMode; Simple: Boolean): Variant;
      overload;
    // Asynchronous invoke
    procedure Invoke(const AName: string; const Args: array of const;
      Callback: THproseCallback1;
      ErrorEvent: THproseErrorEvent;
      ResultType: PTypeInfo; ResultMode: THproseResultMode; Simple: Boolean); overload;
    procedure Invoke(const AName: string; var Args: TVariants;
      Callback: THproseCallback1;
      ErrorEvent: THproseErrorEvent;
      ResultType: PTypeInfo; ResultMode: THproseResultMode; Simple: Boolean); overload;
    procedure Invoke(const AName: string; var Args: TVariants;
      Callback: THproseCallback2;
      ErrorEvent: THproseErrorEvent;
      ResultType: PTypeInfo;
      ByRef: Boolean; ResultMode: THproseResultMode; Simple: Boolean); overload;
  protected
    FUri: string;
    function SendAndReceive(Data: TBytes): TBytes; overload; virtual; abstract;
    procedure SendAndReceive(Data: TBytes; Receiver: IHproseReceiver); overload; virtual;
    function Blocking: Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    class function New(const AUrl: string; const ANameSpace: string = ''): Variant;
    function UseService(const AUri: string = ''; const ANameSpace: string = ''): Variant; virtual;
    procedure AddFilter(const Filter: IHproseFilter);
    function RemoveFilter(const Filter: IHproseFilter): Boolean;
    // Synchronous invoke
    function Invoke(const AName: string;
      ResultMode: THproseResultMode = Normal): Variant;
      overload;
    function Invoke(const AName: string; ResultType: PTypeInfo): Variant;
      overload;
    // Synchronous invoke
    function Invoke(const AName: string; const Args: array of const;
      ResultMode: THproseResultMode = Normal; Simple: Boolean = False): Variant;
      overload;
    function Invoke(const AName: string; const Args: array of const;
      ResultType: PTypeInfo; Simple: Boolean = False): Variant;
      overload;
    // Synchronous invoke
    function Invoke(const AName: string; const Arguments: TVarDataArray): Variant; overload;
    function Invoke(const AName: string; var Args: TVariants; ByRef: Boolean = True;
      ResultMode: THproseResultMode = Normal; Simple: Boolean = False): Variant;
      overload;
    function Invoke(const AName: string; var Args: TVariants; ResultType: PTypeInfo;
      ByRef: Boolean = True; Simple: Boolean = False): Variant;
      overload;
{$IFDEF Supports_Generics}
    // Synchronous invoke
    function Invoke<T>(const AName: string): T; overload;
    function Invoke<T>(const AName: string; const Args: array of const;
      Simple: Boolean = False): T; overload;
    function Invoke<T>(const AName: string; var Args: TVariants;
      ByRef: Boolean = True; Simple: Boolean = False): T; overload;
{$ENDIF}
    // Asynchronous invoke
    procedure Invoke(const AName: string;
      Callback: THproseCallback1;
      ResultMode: THproseResultMode = Normal);
      overload;
    procedure Invoke(const AName: string;
      Callback: THproseCallback1;
      ErrorEvent: THproseErrorEvent;
      ResultMode: THproseResultMode = Normal);
      overload;
    // Asynchronous invoke
    procedure Invoke(const AName: string;
      Callback: THproseCallback1;
      ResultType: PTypeInfo);
      overload;
    procedure Invoke(const AName: string;
      Callback: THproseCallback1;
      ErrorEvent: THproseErrorEvent;
      ResultType: PTypeInfo);
      overload;
    // Asynchronous invoke
    procedure Invoke(const AName: string; const Args: array of const;
      Callback: THproseCallback1;
      ResultMode: THproseResultMode = Normal; Simple: Boolean = False);
      overload;
    procedure Invoke(const AName: string; const Args: array of const;
      Callback: THproseCallback1;
      ErrorEvent: THproseErrorEvent;
      ResultMode: THproseResultMode = Normal; Simple: Boolean = False);
      overload;
    // Asynchronous invoke
    procedure Invoke(const AName: string; const Args: array of const;
      Callback: THproseCallback1;
      ResultType: PTypeInfo; Simple: Boolean = False);
      overload;
    procedure Invoke(const AName: string; const Args: array of const;
      Callback: THproseCallback1;
      ErrorEvent: THproseErrorEvent;
      ResultType: PTypeInfo; Simple: Boolean = False);
      overload;
    // Asynchronous invoke
    procedure Invoke(const AName: string; var Args: TVariants;
      Callback: THproseCallback1;
      ResultMode: THproseResultMode = Normal; Simple: Boolean = False);
      overload;
    procedure Invoke(const AName: string; var Args: TVariants;
      Callback: THproseCallback1;
      ErrorEvent: THproseErrorEvent;
      ResultMode: THproseResultMode = Normal; Simple: Boolean = False);
      overload;
    // Asynchronous invoke
    procedure Invoke(const AName: string; var Args: TVariants;
      Callback: THproseCallback1;
      ResultType: PTypeInfo; Simple: Boolean = False);
      overload;
    procedure Invoke(const AName: string; var Args: TVariants;
      Callback: THproseCallback1;
      ErrorEvent: THproseErrorEvent;
      ResultType: PTypeInfo; Simple: Boolean = False);
      overload;
    // Asynchronous invoke
    procedure Invoke(const AName: string; var Args: TVariants;
      Callback: THproseCallback2;
      ByRef: Boolean = True;
      ResultMode: THproseResultMode = Normal; Simple: Boolean = False);
      overload;
    procedure Invoke(const AName: string; var Args: TVariants;
      Callback: THproseCallback2;
      ErrorEvent: THproseErrorEvent;
      ByRef: Boolean = True;
      ResultMode: THproseResultMode = Normal; Simple: Boolean = False);
      overload;
    // Asynchronous invoke
    procedure Invoke(const AName: string; var Args: TVariants;
      Callback: THproseCallback2;
      ResultType: PTypeInfo;
      ByRef: Boolean = True; Simple: Boolean = False);
      overload;
    procedure Invoke(const AName: string; var Args: TVariants;
      Callback: THproseCallback2;
      ErrorEvent: THproseErrorEvent;
      ResultType: PTypeInfo;
      ByRef: Boolean = True; Simple: Boolean = False);
      overload;
{$IFDEF Supports_Generics}
    // Asynchronous invoke
    procedure Invoke<T>(const AName: string;
      Callback: THproseCallback1<T>;
      ErrorEvent: THproseErrorEvent = nil); overload;
    procedure Invoke<T>(const AName: string; const Args: array of const;
      Callback: THproseCallback1<T>;
      ErrorEvent: THproseErrorEvent = nil; Simple: Boolean = False); overload;
    procedure Invoke<T>(const AName: string; var Args: TVariants;
      Callback: THproseCallback2<T>;
      ByRef: Boolean = True; Simple: Boolean = False); overload;
    procedure Invoke<T>(const AName: string; var Args: TVariants;
      Callback: THproseCallback2<T>;
      ErrorEvent: THproseErrorEvent;
      ByRef: Boolean = True; Simple: Boolean = False); overload;
{$ENDIF}
  published
    property Uri: string read FUri;
    property Filter: IHproseFilter read GetFilter write SetFilter;
    property NameSpace: string read FNameSpace write FNameSpace;
    // This event OnError only for asynchronous invoke
    property OnError: THproseErrorEvent read FErrorEvent write FErrorEvent;
  end;

{$IFDEF Supports_Generics}
// The following two classes is private class, but they can't be moved to the
// implementation section because of E2506.
  TAsyncInvokeThread1<T> = class(TThread)
  private
    FClient: THproseClient;
    FName: string;
    FArgs: TConstArray;
    FCallback: THproseCallback1<T>;
    FErrorEvent: THproseErrorEvent;
    FSimple: Boolean;
    FResult: T;
    FError: Exception;
    constructor Create(Client: THproseClient; const AName: string;
      const Args: array of const; Callback: THproseCallback1<T>;
      ErrorEvent: THproseErrorEvent; Simple: Boolean);
  protected
    procedure Execute; override;
    procedure DoCallback;
    procedure DoError;
  end;

  TAsyncInvokeThread2<T> = class(TThread)
  private
    FClient: THproseClient;
    FName: string;
    FArgs: TVariants;
    FCallback: THproseCallback2<T>;
    FErrorEvent: THproseErrorEvent;
    FByRef: Boolean;
    FSimple: Boolean;
    FResult: T;
    FError: Exception;
    constructor Create(Client: THproseClient; const AName: string;
      const Args: TVariants; Callback: THproseCallback2<T>;
      ErrorEvent: THproseErrorEvent; ByRef: Boolean; Simple: Boolean);
  protected
    procedure Execute; override;
    procedure DoCallback;
    procedure DoError;
  end;

  THproseReceiver<T> = class(TInterfacedObject, IHproseReceiver)
    private
      FClient: THproseClient;
      FName: string;
      FCallback1: THproseCallback1<T>;
      FCallback2: THproseCallback2<T>;
      FErrorEvent: THproseErrorEvent;
    public
      constructor Create(Client: THproseClient;
        const AName: string;
        Callback: THproseCallback1<T>;
        ErrorEvent: THproseErrorEvent); overload;
      constructor Create(Client: THproseClient;
        const AName: string;
        Callback: THproseCallback2<T>;
        ErrorEvent: THproseErrorEvent); overload;
      procedure Callback(Data: TBytes);
  end;

{$ENDIF}

  THproseType = class
  private
    FTypeInfo: PTypeInfo;
  public
{$IFDEF Supports_Generics}
    class function New<T>: Variant;
{$ENDIF}
    constructor Create(Info: PTypeInfo);
  end;

function HproseType(Info: PTypeInfo): Variant;

function HproseCallback: Variant; overload;
function HproseCallback(Callback: THproseCallback1): Variant; overload;
function HproseCallback(Callback: THproseCallback2): Variant; overload;
function HproseCallback(ErrorEvent: THproseErrorEvent): Variant; overload;

implementation

uses
  HproseIO;

type

  THproseCallback = class
  private
    FCallback1: THproseCallback1;
    FCallback2: THproseCallback2;
    FErrorEvent: THproseErrorEvent;
  public
    constructor Create; overload;
    constructor Create(Callback: THproseCallback1); overload;
    constructor Create(Callback: THproseCallback2); overload;
    constructor Create(ErrorEvent: THproseErrorEvent); overload;
  end;

  TAsyncInvokeThread1 = class(TThread)
  private
    FClient: THproseClient;
    FName: string;
    FArgs: TConstArray;
    FCallback: THproseCallback1;
    FErrorEvent: THproseErrorEvent;
    FResultType: PTypeInfo;
    FResultMode: THproseResultMode;
    FSimple: Boolean;
    FResult: Variant;
    FError: Exception;
  protected
    procedure Execute; override;
    procedure DoCallback;
    procedure DoError;
  public
    constructor Create(Client: THproseClient; const AName: string;
      const Args: array of const; Callback: THproseCallback1;
      ErrorEvent: THproseErrorEvent; ResultType: PTypeInfo;
      ResultMode: THproseResultMode; Simple: Boolean);
  end;

  TAsyncInvokeThread2 = class(TThread)
  private
    FClient: THproseClient;
    FName: string;
    FArgs: TVariants;
    FCallback1: THproseCallback1;
    FCallback2: THproseCallback2;
    FErrorEvent: THproseErrorEvent;
    FResultType: PTypeInfo;
    FByRef: Boolean;
    FResultMode: THproseResultMode;
    FSimple: Boolean;
    FResult: Variant;
    FError: Exception;
  protected
    procedure Execute; override;
    procedure DoCallback;
    procedure DoError;
  public
    constructor Create(Client: THproseClient; const AName: string;
      const Args: TVariants; Callback: THproseCallback1;
      ErrorEvent: THproseErrorEvent; ResultType: PTypeInfo;
      ByRef: Boolean; ResultMode: THproseResultMode; Simple: Boolean); overload;
    constructor Create(Client: THproseClient; const AName: string;
      const Args: TVariants; Callback: THproseCallback2;
      ErrorEvent: THproseErrorEvent; ResultType: PTypeInfo;
      ByRef: Boolean; ResultMode: THproseResultMode; Simple: Boolean); overload;
  end;

  THproseReceiver = class(TInterfacedObject, IHproseReceiver)
    private
      FClient: THproseClient;
      FName: string;
      FCallback1: THproseCallback1;
      FCallback2: THproseCallback2;
      FErrorEvent: THproseErrorEvent;
      FResultType: PTypeInfo;
      FResultMode: THproseResultMode;
    public
      constructor Create(Client: THproseClient;
        const AName: string;
        ACallback: THproseCallback1;
        ErrorEvent: THproseErrorEvent;
        ResultType: PTypeInfo;
        ResultMode: THproseResultMode); overload;
      constructor Create(Client: THproseClient;
        const AName: string;
        ACallback: THproseCallback2;
        ErrorEvent: THproseErrorEvent;
        ResultType: PTypeInfo;
        ResultMode: THproseResultMode); overload;
      procedure Callback(Data: TBytes);
  end;

{ THproseType }

{$IFDEF Supports_Generics}
class function THproseType.New<T>: Variant;
begin
  Result := ObjToVar(Self.Create(TypeInfo(T)));
end;
{$ENDIF}

constructor THproseType.Create(Info: PTypeInfo);
begin
  FTypeInfo := Info;
end;

function HproseType(Info: PTypeInfo): Variant;
begin
  Result := ObjToVar(THproseType.Create(Info));
end;

function HproseCallback: Variant;
begin
  Result := ObjToVar(THproseCallback.Create);
end;

function HproseCallback(Callback: THproseCallback1): Variant;
begin
  Result := ObjToVar(THproseCallback.Create(Callback));
end;

function HproseCallback(Callback: THproseCallback2): Variant;
begin
  Result := ObjToVar(THproseCallback.Create(Callback));
end;

function HproseCallback(ErrorEvent: THproseErrorEvent): Variant;
begin
  Result := ObjToVar(THproseCallback.Create(ErrorEvent));
end;

{ THproseCallback }

constructor THproseCallback.Create;
begin
  inherited Create;
  FCallback1 := nil;
  FCallback2 := nil;
  FErrorEvent := nil;
end;

constructor THproseCallback.Create(Callback: THproseCallback1);
begin
  inherited Create;
  FCallback1 := Callback;
  FCallback2 := nil;
  FErrorEvent := nil;
end;

constructor THproseCallback.Create(Callback: THproseCallback2);
begin
  inherited Create;
  FCallback1 := nil;
  FCallback2 := Callback;
  FErrorEvent := nil;
end;

constructor THproseCallback.Create(ErrorEvent: THproseErrorEvent);
begin
  inherited Create;
  FCallback1 := nil;
  FCallback2 := nil;
  FErrorEvent := ErrorEvent;
end;

{ THproseClient }

constructor THproseClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FUri := '';
  FNameSpace := '';
  FErrorEvent := nil;
  FFilters := THashedList.Create;
end;

class function THproseClient.New(const AUrl: string; const ANameSpace: string): Variant;
begin
  Result := Self.Create(nil).UseService(AUrl, ANameSpace);
end;

function THproseClient.GetFilter: IHproseFilter;
begin
  if FFilters.Count = 0 then
    Result := nil
  else
    VarToIntf(FFilters[0], IHproseFilter, Result);
end;

procedure THproseClient.SetFilter(const Filter: IHproseFilter);
begin
  if FFilters.Count > 0 then FFilters.Clear;
  if Filter <> nil then FFilters.Add(Filter);
end;

procedure THproseClient.AddFilter(const Filter: IHproseFilter);
begin
  if Filter <> nil then FFilters.Add(Filter);
end;

function THproseClient.RemoveFilter(const Filter: IHproseFilter): Boolean;
begin
  Result := (FFilters.Remove(Filter) >= 0);
end;

function THproseClient.DoInput(var Args: TVariants; ResultType: PTypeInfo;
  ResultMode: THproseResultMode; Data: TBytes): Variant;
var
  I: Integer;
  AFilter: IHproseFilter;
  ATag: Byte;
  InStream: TBytesStream;
  HproseReader: THproseReader;
begin
  for I := FFilters.Count - 1 downto 0 do begin
    VarToIntf(FFilters[I], IHproseFilter, AFilter);
    Data := AFilter.InputFilter(Data, Self);
  end;
  if Data[Length(Data) - 1] <> HproseTagEnd then
    raise EHproseException.Create('Wrong Response: ' + #13#10 + StringOf(Data));
  Result := Null;
  if (ResultMode = RawWithEndTag) or
    (ResultMode = Raw) then begin
    if ResultMode = Raw then SetLength(Data, Length(Data) - 1);
    Result := Data;
  end
  else begin
    InStream := TBytesStream.Create(Data);
    HproseReader := THproseReader.Create(InStream);
    try
      ATag := 0;
      while Data[Instream.Position] <> HproseTagEnd do begin
        InStream.ReadBuffer(ATag, 1);
        if ATag = HproseTagResult then begin
          if ResultMode = Serialized then
            Result := HproseReader.ReadRaw
          else begin
            HproseReader.Reset;
            Result := HproseReader.Unserialize(ResultType)
          end
        end
        else if ATag = HproseTagArgument then begin
          HproseReader.Reset;
          Args := HproseReader.ReadVariantArray;
        end
        else if ATag = HproseTagError then begin
          HproseReader.Reset;
          raise EHproseException.Create(HproseReader.ReadString());
        end
        else raise EHproseException.Create('Wrong Response: ' + #13#10 + StringOf(Data));
      end;
    finally
      HproseReader.Free;
      InStream.Free;
    end;
  end;
end;

function THproseClient.DoInput(ResultType: PTypeInfo;
  ResultMode: THproseResultMode; Data: TBytes): Variant;
var
  Args: TVariants;
begin
  SetLength(Args, 0);
  Result := DoInput(Args, ResultType, ResultMode, Data);
end;

{$IFDEF Supports_Generics}
procedure THproseClient.DoInput(var Args: TVariants; ResultType: PTypeInfo;
      Data: TBytes; out Result);
var
  I: Integer;
  Filter: IHproseFilter;
  Tag: Byte;
  InStream: TBytesStream;
  HproseReader: THproseReader;
begin
  for I := FFilters.Count - 1 downto 0 do begin
    VarToIntf(FFilters[I], IHproseFilter, Filter);
    Data := Filter.InputFilter(Data, Self);
  end;
  if Data[Length(Data) - 1] <> HproseTagEnd then
    raise EHproseException.Create('Wrong Response: ' + #13#10 + StringOf(Data));
  InStream := TBytesStream.Create(Data);
  HproseReader := THproseReader.Create(InStream);
  try
    while Data[Instream.Position] <> HproseTagEnd do begin
      InStream.ReadBuffer(Tag, 1);
      if Tag = HproseTagResult then begin
        HproseReader.Reset;
        HproseReader.Unserialize(ResultType, Result);
      end
      else if Tag = HproseTagArgument then begin
        HproseReader.Reset;
        Args := HproseReader.ReadVariantArray;
      end
      else if Tag = HproseTagError then begin
        HproseReader.Reset;
        raise EHproseException.Create(HproseReader.ReadString());
      end
      else raise EHproseException.Create('Wrong Response: ' + #13#10 + StringOf(Data));
    end;
  finally
    HproseReader.Free;
    InStream.Free;
  end;
end;

procedure THproseClient.DoInput(ResultType: PTypeInfo;
  Data: TBytes; out Result);
var
  Args: TVariants;
begin
  DoInput(Args, ResultType, Data, Result);
end;
{$ENDIF}

function THproseClient.DoOutput(const AName: string;
  const Args: array of const; Simple: Boolean): TBytes;
var
  I: Integer;
  AFilter: IHproseFilter;
  OutStream: TBytesStream;
  HproseWriter: THproseWriter;
begin
  OutStream := TBytesStream.Create;
  HproseWriter := THproseWriter.Create(OutStream, Simple);
  try
    OutStream.Write(HproseTagCall, 1);
    HproseWriter.WriteString(AName);
    if Length(Args) > 0 then begin
      HproseWriter.Reset;
      HproseWriter.WriteArray(Args);
    end;
    OutStream.Write(HproseTagEnd, 1);
    Result := OutStream.Bytes;
    SetLength(Result, OutStream.Size);
  finally
    HproseWriter.Free;
    OutStream.Free;
  end;
  for I := 0 to FFilters.Count - 1 do begin
    VarToIntf(FFilters[I], IHproseFilter, AFilter);
    Result := AFilter.OutputFilter(Result, Self);
  end;
end;

function THproseClient.DoOutput(const AName: string;
  const Args: TVariants; ByRef: Boolean; Simple: Boolean): TBytes;
var
  I: Integer;
  AFilter: IHproseFilter;
  OutStream: TBytesStream;
  HproseWriter: THproseWriter;
begin
  OutStream := TBytesStream.Create;
  HproseWriter := THproseWriter.Create(OutStream, Simple);
  try
    OutStream.Write(HproseTagCall, 1);
    HproseWriter.WriteString(AName);
    if (Length(Args) > 0) or ByRef then begin
      HproseWriter.Reset;
      HproseWriter.WriteArray(Args);
      if ByRef then HproseWriter.WriteBoolean(True);
    end;
    OutStream.Write(HproseTagEnd, 1);
    Result := OutStream.Bytes;
    SetLength(Result, OutStream.Size);
  finally
    HproseWriter.Free;
    OutStream.Free;
  end;
  for I := 0 to FFilters.Count - 1 do begin
    VarToIntf(FFilters[I], IHproseFilter, AFilter);
    Result := AFilter.OutputFilter(Result, Self);
  end;
end;

procedure THproseClient.SendAndReceive(Data: TBytes; Receiver: IHproseReceiver);
begin
end;

function THproseClient.Blocking: Boolean;
begin
  Result := True;
end;

function THproseClient.Invoke(const AName: string; const Arguments: TVarDataArray): Variant;
var
  Async: Boolean;
  Callback: THproseCallback;
  Callback1: THproseCallback1;
  Callback2: THproseCallback2;
  ErrorEvent: THproseErrorEvent;
  HType: THproseType;
  Info: PTypeInfo;
  Args: TVariants;
  Len: Integer;
begin
  Async := False;
  Callback := nil;
  Callback1 := nil;
  Callback2 := nil;
  ErrorEvent := nil;
  HType := nil;
  Info := nil;
  Args := TVariants(Arguments);
  Len := Length(Args);
  while (Len > 0) and VarToObj(Args[Len - 1], THproseType, HType) and Assigned(HType) do begin
    if Assigned(HType.FTypeInfo) then Info := HType.FTypeInfo;
    HType.Free;
    Dec(Len);
    SetLength(Args, Len);
  end;
  while (Len > 0) and VarToObj(Args[Len - 1], THproseCallback, Callback) and Assigned(Callback) do begin
    Async := True;
    if Assigned(Callback.FCallback1) then Callback1 := Callback.FCallback1;
    if Assigned(Callback.FCallback2) then Callback2 := Callback.FCallback2;
    if Assigned(Callback.FErrorEvent) then ErrorEvent := Callback.FErrorEvent;
    Callback.Free;
    Dec(Len);
    SetLength(Args, Len);
  end;
  if Async then
      if Assigned(Callback1) then
        Invoke(AName, Args, Callback1, ErrorEvent, Info, Normal, False)
      else
        Invoke(AName, Args, Callback2, ErrorEvent, Info, True, Normal, False)
  else
    Result := Invoke(AName, Args, Info, False, Normal, False);
end;

// Synchronous invoke
function THproseClient.Invoke(const AName: string;
  ResultMode: THproseResultMode): Variant;
begin
  Result := Invoke(AName, [], PTypeInfo(nil), ResultMode, True);
end;

function THproseClient.Invoke(const AName: string;
  ResultType: PTypeInfo): Variant;
begin
  Result := Invoke(AName, [], ResultType, Normal, True);
end;

function THproseClient.Invoke(const AName: string;
  const Args: array of const; ResultMode: THproseResultMode; Simple: Boolean): Variant;
begin
  Result := Invoke(AName, Args, PTypeInfo(nil), ResultMode, Simple);
end;

function THproseClient.Invoke(const AName: string;
  const Args: array of const; ResultType: PTypeInfo; Simple: Boolean): Variant;
begin
  Result := Invoke(AName, Args, ResultType, Normal, Simple);
end;

function THproseClient.Invoke(const AName: string;
  const Args: array of const; ResultType: PTypeInfo;
  ResultMode: THproseResultMode; Simple: Boolean): Variant;
begin
  Result := DoInput(ResultType, ResultMode, SendAndReceive(DoOutput(AName, Args, Simple)));
end;

// Synchronous invoke

function THproseClient.Invoke(const AName: string; var Args: TVariants;
  ByRef: Boolean; ResultMode: THproseResultMode; Simple: Boolean): Variant;
begin
  Result := Invoke(AName, Args, PTypeInfo(nil), ByRef, ResultMode, Simple);
end;

function THproseClient.Invoke(const AName: string; var Args: TVariants;
  ResultType: PTypeInfo; ByRef: Boolean; Simple: Boolean): Variant;
begin
  Result := Invoke(AName, Args, ResultType, ByRef, Normal, Simple);
end;

function THproseClient.Invoke(const AName: string; var Args: TVariants;
  ResultType: PTypeInfo; ByRef: Boolean;
  ResultMode: THproseResultMode; Simple: Boolean): Variant;
var
  FullName: string;
begin
  if FNameSpace <> '' then
    FullName := FNameSpace + '_' + AName
  else
    FullName := AName;
  Result := DoInput(Args, ResultType, ResultMode, SendAndReceive(DoOutput(FullName, Args, ByRef, Simple)));
end;

{$IFDEF Supports_Generics}
// Synchronous invoke
function THproseClient.Invoke<T>(const AName: string): T;
var
  Args: array of TVarRec;
begin
  SetLength(Args, 0);
  Result := Self.Invoke<T>(AName, Args, True);
end;

function THproseClient.Invoke<T>(const AName: string;
  const Args: array of const; Simple: Boolean): T;
var
  Context: TObject;
  InStream, OutStream: TStream;
  FullName: string;
begin
  if FNameSpace <> '' then
    FullName := FNameSpace + '_' + AName
  else
    FullName := AName;
  Result := Default(T);
  DoInput(TypeInfo(T), SendAndReceive(DoOutput(FullName, Args, Simple)), Result);
end;

function THproseClient.Invoke<T>(const AName: string; var Args: TVariants;
  ByRef: Boolean; Simple: Boolean): T;
var
  Context: TObject;
  InStream, OutStream: TStream;
  FullName: string;
begin
  if FNameSpace <> '' then
    FullName := FNameSpace + '_' + AName
  else
    FullName := AName;
  Result := Default(T);
  DoInput(Args, TypeInfo(T), SendAndReceive(DoOutput(FullName, Args, ByRef, Simple)), Result);
end;
{$ENDIF}

// Asynchronous invoke
procedure THproseClient.Invoke(const AName: string;
  Callback: THproseCallback1;
  ResultMode: THproseResultMode);
var
  Args: array of TVarRec;
  ErrorEvent: THproseErrorEvent;
begin
  SetLength(Args, 0);
  ErrorEvent := nil;
  Invoke(AName, Args, Callback, ErrorEvent, nil, ResultMode, True);
end;

procedure THproseClient.Invoke(const AName: string;
  Callback: THproseCallback1;
  ErrorEvent: THproseErrorEvent;
  ResultMode: THproseResultMode);
var
  Args: array of TVarRec;
begin
  SetLength(Args, 0);
  Invoke(AName, Args, Callback, ErrorEvent, nil, ResultMode, True);
end;

// Asynchronous invoke
procedure THproseClient.Invoke(const AName: string;
  Callback: THproseCallback1;
  ResultType: PTypeInfo);
var
  Args: array of TVarRec;
  ErrorEvent: THproseErrorEvent;
begin
  SetLength(Args, 0);
  ErrorEvent := nil;
  Invoke(AName, Args, Callback, ErrorEvent, ResultType, Normal, True);
end;

procedure THproseClient.Invoke(const AName: string;
  Callback: THproseCallback1;
  ErrorEvent: THproseErrorEvent;
  ResultType: PTypeInfo);
var
  Args: array of TVarRec;
begin
  SetLength(Args, 0);
  Invoke(AName, Args, Callback, ErrorEvent, ResultType, Normal, True);
end;

// Asynchronous invoke
procedure THproseClient.Invoke(const AName: string; const Args: array of const;
  Callback: THproseCallback1;
  ResultMode: THproseResultMode; Simple: Boolean);
var
  ErrorEvent: THproseErrorEvent;
begin
  ErrorEvent := nil;
  Invoke(AName, Args, Callback, ErrorEvent, nil, ResultMode, Simple);
end;

procedure THproseClient.Invoke(const AName: string; const Args: array of const;
  Callback: THproseCallback1;
  ErrorEvent: THproseErrorEvent;
  ResultMode: THproseResultMode; Simple: Boolean);
begin
  Invoke(AName, Args, Callback, ErrorEvent, nil, ResultMode, Simple);
end;

// Asynchronous invoke
procedure THproseClient.Invoke(const AName: string; const Args: array of const;
  Callback: THproseCallback1;
  ResultType: PTypeInfo; Simple: Boolean);
var
  ErrorEvent: THproseErrorEvent;
begin
  ErrorEvent := nil;
  Invoke(AName, Args, Callback, ErrorEvent, ResultType, Normal, Simple);
end;

procedure THproseClient.Invoke(const AName: string; const Args: array of const;
  Callback: THproseCallback1;
  ErrorEvent: THproseErrorEvent;
  ResultType: PTypeInfo; Simple: Boolean);
begin
  Invoke(AName, Args, Callback, ErrorEvent, ResultType, Normal, Simple);
end;

procedure THproseClient.Invoke(const AName: string; const Args: array of const;
  Callback: THproseCallback1;
  ErrorEvent: THproseErrorEvent;
  ResultType: PTypeInfo; ResultMode: THproseResultMode; Simple: Boolean);
var
  FullName: string;
  Receiver: IHproseReceiver;
begin
  if FNameSpace <> '' then
    FullName := FNameSpace + '_' + AName
  else
    FullName := AName;
  if Blocking then
    TAsyncInvokeThread1.Create(Self, FullName, Args, Callback, ErrorEvent, ResultType, ResultMode, Simple)
  else
    try
      Receiver := THproseReceiver.Create(Self, FullName, Callback, ErrorEvent, ResultType, ResultMode);
      SendAndReceive(DoOutput(FullName, Args, Simple), Receiver);
    except
      on E: Exception do begin
        if Assigned(ErrorEvent) then
          ErrorEvent(FullName, E)
        else if Assigned(FErrorEvent) then
          FErrorEvent(FullName, E);
      end;
    end;
end;

// Asynchronous invoke
procedure THproseClient.Invoke(const AName: string; var Args: TVariants;
  Callback: THproseCallback1;
  ResultMode: THproseResultMode; Simple: Boolean);
var
  ErrorEvent: THproseErrorEvent;
begin
  ErrorEvent := nil;
  Invoke(AName, Args, Callback, ErrorEvent, nil, ResultMode, Simple);
end;

procedure THproseClient.Invoke(const AName: string; var Args: TVariants;
  Callback: THproseCallback1;
  ErrorEvent: THproseErrorEvent;
  ResultMode: THproseResultMode; Simple: Boolean);
begin
  Invoke(AName, Args, Callback, ErrorEvent, nil, ResultMode, Simple);
end;

// Asynchronous invoke
procedure THproseClient.Invoke(const AName: string; var Args: TVariants;
  Callback: THproseCallback1;
  ResultType: PTypeInfo; Simple: Boolean);
var
  ErrorEvent: THproseErrorEvent;
begin
  ErrorEvent := nil;
  Invoke(AName, Args, Callback, ErrorEvent, ResultType, Normal, Simple);
end;

procedure THproseClient.Invoke(const AName: string; var Args: TVariants;
  Callback: THproseCallback1;
  ErrorEvent: THproseErrorEvent;
  ResultType: PTypeInfo; Simple: Boolean);
begin
  Invoke(AName, Args, Callback, ErrorEvent, ResultType, Normal, Simple);
end;

procedure THproseClient.Invoke(const AName: string; var Args: TVariants;
  Callback: THproseCallback1;
  ErrorEvent: THproseErrorEvent;
  ResultType: PTypeInfo;
  ResultMode: THproseResultMode; Simple: Boolean);
var
  FullName: string;
  Receiver: IHproseReceiver;
begin
  if FNameSpace <> '' then
    FullName := FNameSpace + '_' + AName
  else
    FullName := AName;
  if Blocking then
    TAsyncInvokeThread2.Create(Self, FullName, Args, Callback, ErrorEvent, ResultType, False, ResultMode, Simple)
  else
    try
      Receiver := THproseReceiver.Create(Self, FullName, Callback, ErrorEvent, ResultType, ResultMode);
      SendAndReceive(DoOutput(FullName, Args, False, Simple), Receiver);
    except
      on E: Exception do begin
        if Assigned(ErrorEvent) then
          ErrorEvent(FullName, E)
        else if Assigned(FErrorEvent) then
          FErrorEvent(FullName, E);
      end;
    end;
end;

// Asynchronous invoke
procedure THproseClient.Invoke(const AName: string; var Args: TVariants;
  Callback: THproseCallback2;
  ByRef: Boolean;
  ResultMode: THproseResultMode; Simple: Boolean);
var
  ErrorEvent: THproseErrorEvent;
begin
  ErrorEvent := nil;
  Invoke(AName, Args, Callback, ErrorEvent, nil, ByRef, ResultMode, Simple);
end;

procedure THproseClient.Invoke(const AName: string; var Args: TVariants;
  Callback: THproseCallback2;
  ErrorEvent: THproseErrorEvent;
  ByRef: Boolean;
  ResultMode: THproseResultMode; Simple: Boolean);
begin
  Invoke(AName, Args, Callback, ErrorEvent, nil, ByRef, ResultMode, Simple);
end;

// Asynchronous invoke
procedure THproseClient.Invoke(const AName: string; var Args: TVariants;
  Callback: THproseCallback2;
  ResultType: PTypeInfo;
  ByRef: Boolean; Simple: Boolean);
var
  ErrorEvent: THproseErrorEvent;
begin
  ErrorEvent := nil;
  Invoke(AName, Args, Callback, ErrorEvent, ResultType, ByRef, Normal, Simple);
end;

procedure THproseClient.Invoke(const AName: string; var Args: TVariants;
  Callback: THproseCallback2;
  ErrorEvent: THproseErrorEvent;
  ResultType: PTypeInfo;
  ByRef: Boolean; Simple: Boolean);
begin
  Invoke(AName, Args, Callback, ErrorEvent, ResultType, ByRef, Normal, Simple);
end;

procedure THproseClient.Invoke(const AName: string; var Args: TVariants;
  Callback: THproseCallback2;
  ErrorEvent: THproseErrorEvent;
  ResultType: PTypeInfo;
  ByRef: Boolean; ResultMode: THproseResultMode; Simple: Boolean);
var
  FullName: string;
  Receiver: IHproseReceiver;
begin
  if FNameSpace <> '' then
    FullName := FNameSpace + '_' + AName
  else
    FullName := AName;
  if Blocking then
    TAsyncInvokeThread2.Create(Self, FullName, Args, Callback, ErrorEvent, ResultType, ByRef, ResultMode, Simple)
  else
    try
      Receiver := THproseReceiver.Create(Self, FullName, Callback, ErrorEvent, ResultType, ResultMode);
      SendAndReceive(DoOutput(FullName, Args, ByRef, Simple), Receiver);
    except
      on E: Exception do begin
        if Assigned(ErrorEvent) then
          ErrorEvent(FullName, E)
        else if Assigned(FErrorEvent) then
          FErrorEvent(FullName, E);
      end;
    end;
end;

{$IFDEF Supports_Generics}
procedure THproseClient.Invoke<T>(const AName: string;
  Callback: THproseCallback1<T>;
  ErrorEvent: THproseErrorEvent);
begin
  Self.Invoke<T>(AName, [], Callback, ErrorEvent, True);
end;

procedure THproseClient.Invoke<T>(const AName: string; const Args: array of const;
  Callback: THproseCallback1<T>;
  ErrorEvent: THproseErrorEvent; Simple: Boolean);
var
  FullName: string;
begin
  if FNameSpace <> '' then
    FullName := FNameSpace + '_' + AName
  else
    FullName := AName;
  if Blocking then
    TAsyncInvokeThread1<T>.Create(Self, FullName, Args, Callback, ErrorEvent, Simple)
  else
    try
      SendAndReceive(DoOutput(FullName, Args, Simple),
        THproseReceiver<T>.Create(Self, FullName, Callback, ErrorEvent));
    except
      on E: Exception do begin
        if Assigned(ErrorEvent) then
          ErrorEvent(FullName, E)
        else if Assigned(FErrorEvent) then
          FErrorEvent(FullName, E);
      end;
    end;
end;

procedure THproseClient.Invoke<T>(const AName: string; var Args: TVariants;
  Callback: THproseCallback2<T>;
  ByRef: Boolean; Simple: Boolean);
begin
  Self.Invoke<T>(AName, Args, Callback, nil, ByRef, Simple);
end;

procedure THproseClient.Invoke<T>(const AName: string; var Args: TVariants;
  Callback: THproseCallback2<T>;
  ErrorEvent: THproseErrorEvent;
  ByRef: Boolean; Simple: Boolean);
var
  FullName: string;
begin
  if FNameSpace <> '' then
    FullName := FNameSpace + '_' + AName
  else
    FullName := AName;
  if Blocking then
    TAsyncInvokeThread2<T>.Create(Self, FullName, Args, Callback, ErrorEvent, ByRef, Simple)
  else
    try
      SendAndReceive(DoOutput(FullName, Args, ByRef, Simple),
        THproseReceiver<T>.Create(Self, FullName, Callback, ErrorEvent));
    except
      on E: Exception do begin
        if Assigned(ErrorEvent) then
          ErrorEvent(FullName, E)
        else if Assigned(FErrorEvent) then
          FErrorEvent(FullName, E);
      end;
    end;
end;
{$ENDIF}

function THproseClient.UseService(const AUri: string; const ANameSpace: string): Variant;
begin
  if AUri <> '' then FUri := AUri;
  FNameSpace := ANameSpace;
  Result := ObjToVar(Self);
end;

{ TAsyncInvokeThread1 }

constructor TAsyncInvokeThread1.Create(Client: THproseClient;
  const AName: string; const Args: array of const;
  Callback: THproseCallback1; ErrorEvent: THproseErrorEvent;
  ResultType: PTypeInfo; ResultMode: THproseResultMode; Simple: Boolean);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FClient := Client;
  FName := AName;
  FArgs := CreateConstArray(Args);
  FCallback := Callback;
  FErrorEvent := ErrorEvent;
  FResultType := ResultType;
  FResultMode := ResultMode;
  FSimple := Simple;
  FError := nil;
end;

procedure TAsyncInvokeThread1.DoCallback;
begin
  if not Assigned(FError) and Assigned(FCallback) then FCallback(FResult);
end;

procedure TAsyncInvokeThread1.DoError;
begin
  if Assigned(FErrorEvent) then
    FErrorEvent(FName, FError)
  else if Assigned(FClient.FErrorEvent) then
    FClient.FErrorEvent(FName, FError);
end;

procedure TAsyncInvokeThread1.Execute;
begin
  try
    try
      FResult := FClient.Invoke(FName,
                                FArgs,
                                FResultType,
                                FResultMode,
                                FSimple);
    except
      on E: Exception do begin
        FError := E;
        Synchronize({$IFDEF FPC}@{$ENDIF}DoError);
      end;
    end;
  finally
    FinalizeConstArray(FArgs);
  end;
  Synchronize({$IFDEF FPC}@{$ENDIF}DoCallback);
end;

{ TAsyncInvokeThread2 }

constructor TAsyncInvokeThread2.Create(Client: THproseClient;
  const AName: string; const Args: TVariants;
  Callback: THproseCallback1; ErrorEvent: THproseErrorEvent;
  ResultType: PTypeInfo; ByRef: Boolean;
  ResultMode: THproseResultMode; Simple: Boolean);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FClient := Client;
  FName := AName;
  FArgs := Args;
  FCallback1 := Callback;
  FCallback2 := nil;
  FErrorEvent := ErrorEvent;
  FResultType := ResultType;
  FByRef := ByRef;
  FResultMode := ResultMode;
  FSimple := Simple;
  FError := nil;
end;

constructor TAsyncInvokeThread2.Create(Client: THproseClient;
  const AName: string; const Args: TVariants;
  Callback: THproseCallback2; ErrorEvent: THproseErrorEvent;
  ResultType: PTypeInfo; ByRef: Boolean;
  ResultMode: THproseResultMode; Simple: Boolean);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FClient := Client;
  FName := AName;
  FArgs := Args;
  FCallback1 := nil;
  FCallback2 := Callback;
  FErrorEvent := ErrorEvent;
  FResultType := ResultType;
  FByRef := ByRef;
  FResultMode := ResultMode;
  FSimple := Simple;
  FError := nil;
end;

procedure TAsyncInvokeThread2.DoCallback;
begin
  if not Assigned(FError) then
    if Assigned(FCallback1) then FCallback1(FResult)
    else if Assigned(FCallback2) then FCallback2(FResult, FArgs);
end;

procedure TAsyncInvokeThread2.DoError;
begin
  if Assigned(FErrorEvent) then
    FErrorEvent(FName, FError)
  else if Assigned(FClient.FErrorEvent) then
    FClient.FErrorEvent(FName, FError);
end;

procedure TAsyncInvokeThread2.Execute;
begin
  try
    FResult := FClient.Invoke(FName,
                              FArgs,
                              FResultType,
                              FByRef,
                              FResultMode,
                              FSimple);
  except
    on E: Exception do begin
      FError := E;
      Synchronize({$IFDEF FPC}@{$ENDIF}DoError);
    end;
  end;
  Synchronize({$IFDEF FPC}@{$ENDIF}DoCallback);
end;

{ THproseReceiver }

constructor THproseReceiver.Create(Client: THproseClient;
  const AName: string;
  ACallback: THproseCallback1;
  ErrorEvent: THproseErrorEvent;
  ResultType: PTypeInfo;
  ResultMode: THproseResultMode);
begin
  inherited Create;
  FClient := Client;
  FName := AName;
  FCallback1 := ACallback;
  FCallback2 := nil;
  FErrorEvent := ErrorEvent;
  FResultType := ResultType;
  FResultMode := ResultMode;
end;

constructor THproseReceiver.Create(Client: THproseClient;
  const AName: string;
  ACallback: THproseCallback2;
  ErrorEvent: THproseErrorEvent;
  ResultType: PTypeInfo;
  ResultMode: THproseResultMode);
begin
  inherited Create;
  FClient := Client;
  FName := AName;
  FCallback1 := nil;
  FCallback2 := ACallback;
  FErrorEvent := ErrorEvent;
  FResultType := ResultType;
  FResultMode := ResultMode;
end;

procedure THproseReceiver.Callback(Data: TBytes);
var
  Args: TVariants;
  Result: Variant;
begin
  try
    SetLength(Args, 0);
    Result := FClient.DoInput(Args, FResultType, FResultMode, Data);
  except
    on E: Exception do begin
      if Assigned(FErrorEvent) then
        FErrorEvent(FName, E)
      else if Assigned(FClient.FErrorEvent) then
        FClient.FErrorEvent(FName, E);
      Exit;
    end;
  end;
  if Assigned(FCallback1) then FCallback1(Result)
  else if Assigned(FCallback2) then FCallback2(Result, Args);
end;

{$IFDEF Supports_Generics}
{ TAsyncInvokeThread1<T> }

constructor TAsyncInvokeThread1<T>.Create(Client: THproseClient;
  const AName: string; const Args: array of const;
  Callback: THproseCallback1<T>; ErrorEvent: THproseErrorEvent; Simple: Boolean);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FClient := Client;
  FName := AName;
  FArgs := CreateConstArray(Args);
  FCallback := Callback;
  FErrorEvent := ErrorEvent;
  FSimple := Simple;
  FError := nil;
end;

procedure TAsyncInvokeThread1<T>.DoCallback;
begin
  if not Assigned(FError) and Assigned(FCallback) then FCallback(FResult);
end;

procedure TAsyncInvokeThread1<T>.DoError;
begin
  if Assigned(FErrorEvent) then
    FErrorEvent(FName, FError)
  else if Assigned(FClient.FErrorEvent) then
    FClient.FErrorEvent(FName, FError);
end;

procedure TAsyncInvokeThread1<T>.Execute;
begin
  try
    try
      FResult := FClient.Invoke<T>(FName, FArgs, FSimple);
    except
      on E: Exception do begin
        FError := E;
        Synchronize(DoError);
      end;
    end;
  finally
    FinalizeConstArray(FArgs);
  end;
  Synchronize(DoCallback);
end;

{ TAsyncInvokeThread2<T> }

constructor TAsyncInvokeThread2<T>.Create(Client: THproseClient;
  const AName: string; const Args: TVariants;
  Callback: THproseCallback2<T>; ErrorEvent: THproseErrorEvent;
  ByRef: Boolean; Simple: Boolean);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FClient := Client;
  FName := AName;
  FArgs := Args;
  FCallback := Callback;
  FErrorEvent := ErrorEvent;
  FByRef := ByRef;
  FSimple := Simple;
  FError := nil;
end;

procedure TAsyncInvokeThread2<T>.DoCallback;
begin
  if not Assigned(FError) and Assigned(FCallback) then FCallback(FResult, FArgs);
end;

procedure TAsyncInvokeThread2<T>.DoError;
begin
  if Assigned(FErrorEvent) then
    FErrorEvent(FName, FError)
  else if Assigned(FClient.FErrorEvent) then
    FClient.FErrorEvent(FName, FError);
end;

procedure TAsyncInvokeThread2<T>.Execute;
begin
  try
    FResult := FClient.Invoke<T>(FName, FArgs, FByRef, FSimple);
  except
    on E: Exception do begin
      FError := E;
      Synchronize(DoError);
    end;
  end;
  Synchronize(DoCallback);
end;

{ THproseReceiver<T> }

constructor THproseReceiver<T>.Create(Client: THproseClient;
  const AName: string;
  Callback: THproseCallback1<T>;
  ErrorEvent: THproseErrorEvent);
begin
  inherited Create;
  FClient := Client;
  FName := AName;
  FCallback1 := Callback;
  FCallback2 := nil;
  FErrorEvent := ErrorEvent;
end;

constructor THproseReceiver<T>.Create(Client: THproseClient;
  const AName: string;
  Callback: THproseCallback2<T>;
  ErrorEvent: THproseErrorEvent);
begin
  inherited Create;
  FClient := Client;
  FName := AName;
  FCallback1 := nil;
  FCallback2 := Callback;
  FErrorEvent := ErrorEvent;
end;

procedure THproseReceiver<T>.Callback(Data: TBytes);
var
  Args: TVariants;
  Result: T;
begin
  try
    FClient.DoInput(Args, TypeInfo(T), Data, Result);
  except
    on E: Exception do begin
      if Assigned(FErrorEvent) then
        FErrorEvent(FName, E)
      else if Assigned(FClient.FErrorEvent) then
        FClient.FErrorEvent(FName, E);
      Exit;
    end;
  end;
  if Assigned(FCallback1) then FCallback1(Result)
  else if Assigned(FCallback2) then FCallback2(Result, Args);
end;
{$ENDIF}

end.
