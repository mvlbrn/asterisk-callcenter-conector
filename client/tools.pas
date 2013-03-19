unit tools;

interface

uses StdCtrls, Classes, Graphics;

function GetComputerNetName: string;

procedure debug(where: tmemo; s:string);

function bool2str(b: boolean): string;

function Explode(separator: String; text: String): TStringList;
function DoubleExplode(separator, separator2: String; text: String): TStringList;

procedure regWriteString(key:string; value:string);
procedure regWriteBool(key:string; value:boolean);
procedure regWriteInt(key:string; value:integer);
function regReadString(key: string; default: string = ''): string;
function regReadBool(key: string; default: Boolean = false): boolean;
function regReadInt(key: string; default: Integer = -1): Integer;

function InitSound: boolean;
function GetSpecialPath(CSIDL: word): string;
function DateTimeToUnix(ConvDate: TDateTime): Longint;

function HexToTColor(sColor : string) : Graphics.TColor;

function urlRegexp(url, caller, callid: string): string;

procedure log(msg: string);

implementation
uses Windows, Messages, SysUtils, Variants, ExtCtrls, Registry, MMSystem,MMDevApi, ComObj, PropSys2, ActiveX, ShlObj, Vars;

function HexToTColor(sColor : string) : Graphics.TColor;
 begin
    Result :=
      RGB(
        StrToInt('$'+Copy(sColor, 1, 2)),
        StrToInt('$'+Copy(sColor, 3, 2)),
        StrToInt('$'+Copy(sColor, 5, 2))
      ) ;
 end;

function GetComputerNetName: string;
 var
   buffer: array[0..255] of char;
   size: dword;
 begin
   size := 256;
   if GetComputerName(buffer, size) then
     Result := buffer
   else
     Result := ''
 end;

procedure debug(where: tmemo; s:string);
var
   ScrollMessage:TWMVScroll;
begin
  where.Lines.BeginUpdate;
  if where.lines.Count>100 then
  begin
    where.Lines.Delete(0);
  end;
  where.lines.Add(s);
  where.Lines.EndUpdate;
  if debug_scroll then
  begin
    ScrollMessage.Msg:=WM_VScroll;
    ScrollMessage.ScrollCode:=sb_PageDown;
    ScrollMessage.Pos:=0;
    where.Dispatch(ScrollMessage);
  end;
end;

function bool2str(b: boolean): string;
begin
  if b then
    Result:='True'
  else
    Result:='False';
end;

function DateTimeToUnix(ConvDate: TDateTime): Longint;
begin
  Result := Round((ConvDate - UnixStartDate) * 86400);
end;

function GetSpecialPath(CSIDL: word): string;
var s:  string;
begin
  SetLength(s, MAX_PATH);
  if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true)
  then s := '';
  result := PChar(s);
end;

function Explode(separator: String; text: String): TStringList;
var
  ts: TStringList;
  i_pos: Integer;
  text_new: String;
  s_item: String;
begin
  ts := TStringList.Create;
  text_new := text;
  while (text_new <> '') do begin
    i_pos := Pos(separator, text_new);
    if i_pos = 0 then begin
      s_item := text_new;
      text_new := '';
    end
    else begin
      s_item := Copy(text_new, 1, i_pos - 1);
      text_new := Copy(text_new, i_pos + Length(separator), Length(text_new) - i_pos);
    end;
    ts.Values[IntToStr(ts.Count)] := Trim(s_item);
  end;
  Result := ts;
end;

function DoubleExplode(separator, separator2: String; text: String): TStringList;
var
  ts: TStringList;
  i_pos: Integer;
  text_new: String;
  s_item: String;
begin
  try
    ts := TStringList.Create;
    text_new := text;
    while (text_new <> '') do begin
      i_pos := Pos(separator, text_new);
      if i_pos = 0 then begin
        s_item := text_new;
        text_new := '';
      end
      else begin
        s_item := Copy(text_new, 1, i_pos - 1);
        text_new := Copy(text_new, i_pos + Length(separator), Length(text_new) - i_pos);
      end;
      ts.Values[Trim(Copy(s_item, 1, Pos(separator2, s_item)-1))] := Trim(Copy(s_item, Pos(separator2,s_item)+length(separator2), Length(s_item)));
    end;
  except
    ts.Free;
    ts := nil
  end;

  Result := ts;
end;

procedure regWriteString(key:string; value:string);
var Reg: TRegistry;
begin
   Reg:= TRegistry.Create;
   try
     Reg.RootKey := HKEY_CURRENT_USER;
     if Reg.OpenKey('SOFTWARE\CallLog', TRUE) then
     begin
       Reg.WriteString(key, value);
     end;
   finally
     Reg.Free;
   end;
end;

procedure regWriteBool(key:string; value:boolean);
var Reg: TRegistry;
begin
   Reg:= TRegistry.Create;
   try
     Reg.RootKey := HKEY_CURRENT_USER;
     if Reg.OpenKey('SOFTWARE\CallLog', TRUE) then
     begin
       Reg.WriteBool(key, value);
     end;
   finally
     Reg.Free;
   end;
end;

procedure regWriteInt(key:string; value:integer);
var Reg: TRegistry;
begin
   Reg:= TRegistry.Create;
   try
     Reg.RootKey := HKEY_CURRENT_USER;
     if Reg.OpenKey('SOFTWARE\CallLog', TRUE) then
     begin
       Reg.WriteInteger(key, value);
     end;
   finally
     Reg.Free;
   end;
end;


function regReadString(key: string; default: string = ''): string;
var Reg: TRegistry;
begin
  Result:=default;
  Reg:= TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey('SOFTWARE\CallLog', TRUE) then
      begin
        if Reg.ValueExists(key) then
          Result:= Reg.ReadString(key);
      end;
    finally
    Reg.Free;
    end;
end;

function regReadBool(key: string; default: Boolean = false): boolean;
var Reg: TRegistry;
begin
  Result:=default;
  Reg:= TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey('SOFTWARE\CallLog', TRUE) then
      begin
        if Reg.ValueExists(key) then
          Result:= Reg.ReadBool(key);
      end;
    finally
    Reg.Free;
    end;
end;

function regReadInt(key: string; default: Integer = -1): Integer;
var Reg: TRegistry;
begin
  Result:=default;
  Reg:= TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey('SOFTWARE\CallLog', TRUE) then
      begin
        if Reg.ValueExists(key) then
          Result:= Reg.ReadInteger(key);
      end;
    finally
    Reg.Free;
    end;
end;

function InitSound: boolean;
var devEnum  : IMMDeviceEnumerator;
    devColl  : IMMDeviceCollection;
    device   : IMMDevice;
    store    : IPropertyStore;
    prop     : PROPVARIANT;
    pwc      : PWideChar;
    i, count : Cardinal;
    hr       : HRESULT;
    state    : LongInt;
    found    : Boolean;
    iu       : IUnknown;
begin
    found := false;
    result:= false;
    CoInitialize(nil);
    devEnum := CreateComObject(CLASS_IMMDeviceEnumerator) as IMMDeviceEnumerator;
    //Получаем коллекцию
    hr := devEnum.EnumAudioEndpoints(eCapture, eMultimedia, devColl);
    if hr <> S_OK then
      Exit;

    devColl.GetCount(count);
    //Двигаемся по аждому устройству из коллекции
    for i:=0 to count-1 do
    begin
      //Получаем устройство
      hr := devColl.Item(i, device);
      if hr <> S_OK then Exit;

      device.GetState(state); //Состояние устройства
      device.GetId(pwc);      //Строковый uid

      //Открываем хранилище параметров устройства
      hr:=device.OpenPropertyStore(integer(0), store);
      if hr <> S_OK then Exit;

      //Получаем нужный нам ключ - человеческре наименование
      PropVariantInit(prop);
      hr := store.GetValue(PKEY_Device_FriendlyName, prop);
      if hr <> S_OK then Exit;
      if (not found) and (Pos('Микрофон',string(prop.pwszVal))>0) then
      begin
        Result := true;
        try
          hr := device.Activate(IID_IAudioEndpointVolume, CLSCTX_ALL, nil, IUnknown(FVolControl));
          hr := Device.Activate(IID_IAudioMeterInformation, CLSCTX_INPROC_SERVER, nil, IUnknown(PeakMeter));
        except
          Result := false;
        end;
        if Result then
          FVolControl.GetVolumeRange(volMin, volMax, volStep);
      end;

    end;
    //CoTaskMemFree(pwc);
    //pwc := nil;
    //store._Release;
    //device._Release;
end;

function urlRegexp(url, caller, callid: string): string;
var url_new: string;
begin
  url_new := url;
  url_new := StringReplace(url_new, '{PHONE}', caller, [rfReplaceAll]);
  url_new := StringReplace(url_new, '{CALLID}', callid, [rfReplaceAll]);
  urlRegexp:=url_new;
end;

procedure log(msg: string);
var LogFile: TextFile;
begin
  AssignFile(LogFile, logfilename);
  if FileExists(logfilename)
      then
        begin
          Append(LogFile);
          WriteLn(LogFile);
        end
      else
        begin
          ReWrite(LogFile);
        end;
  WriteLn(LogFile);
  Write(LogFile,DateToStr(Date)+' '+TimeToStr(Time)+' ');
  WriteLn(LogFile, msg);
  Flush(LogFile);
  CloseFile(LogFile);
end;

begin
  sound := InitSound;
end.
