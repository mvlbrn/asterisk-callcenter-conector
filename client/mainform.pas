unit mainform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ImgList, StdCtrls, Buttons, Menus,
  OverbyteIcsWndControl, OverbyteIcsWSocket, Grids, OverbyteIcsHttpProt,
  AppEvnts, vars, xmldom, XMLIntf, msxmldom, XMLDoc;

type
  Tmain = class(TForm)
    tray: TTrayIcon;
    volume: TProgressBar;
    socket: TWSocket;
    popup_tray: TPopupMenu;
    il_tray: TImageList;
    il_pause: TImageList;
    il_mute: TImageList;
    popup_debug: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N10: TMenuItem;
    N12: TMenuItem;
    N9: TMenuItem;
    il_misc: TImageList;
    Button1: TButton;
    btn_pause: TSpeedButton;
    btn_mute: TSpeedButton;
    queue_list: TStringGrid;
    text_exten: TLabel;
    http: THttpCli;
    Timer1: TTimer;
    volumelevel: TTrackBar;
    timer_trigger: TTimer;
    timer_callswaiting: TTimer;
    Panel1: TPanel;
    trace: TMemo;
    levelMin: TProgressBar;
    levelMax: TProgressBar;
    agc: TCheckBox;
    volAccuracy: TTrackBar;
    bg: TShape;
    popup_queue: TPopupMenu;
    N6: TMenuItem;
    N13: TMenuItem;
    N11: TMenuItem;
    Button2: TButton;
    popup_queueenter: TPopupMenu;
    Fdnjdjl1: TMenuItem;
    N14: TMenuItem;
    Edit1: TEdit;
    timer_blink: TTimer;
    xml: TXMLDocument;
    procedure FormCreate(Sender: TObject);
    procedure bgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure img_pauseClick(Sender: TObject);
    procedure img_muteClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure trayBalloonClick(Sender: TObject);
    procedure socketSessionConnected(Sender: TObject; ErrCode: Word);
    procedure socketDataAvailable(Sender: TObject; ErrCode: Word);
    procedure socketSessionClosed(Sender: TObject; ErrCode: Word);
    procedure Button1Click(Sender: TObject);
    procedure queue_listDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure socketChangeState(Sender: TObject; OldState,
      NewState: TSocketState);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure volumelevelChange(Sender: TObject);
    procedure trayDblClick(Sender: TObject);
    procedure httpDocData(Sender: TObject; Buffer: Pointer; Len: Integer);
    procedure volAccuracyChange(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure timer_triggerTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure timer_callswaitingTimer(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure Fdnjdjl1Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure queue_listMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure queue_listMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btn_pauseMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure queue_listTopLeftChanged(Sender: TObject);
    procedure queue_listSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure timer_blinkTimer(Sender: TObject);
  private
    procedure mainResize;{ Private declarations }
    procedure queueListPrepare(queuelist: string);
    procedure queueListPrepareOld(queuelist: string);
    function loginDialog(connected: boolean): boolean;
    function pauseDialog(queue_name: string): TPauseDialogResult;
    procedure pauseAction(p: TPauseDialogResult; force: boolean);
    procedure unpauseAction(queue_name: string);

    procedure setMute(flag: boolean);
    procedure setVolume(level: integer);
    procedure showMute;

    procedure setPause(queue_name: string; flag: boolean);
    procedure showPause(force: boolean);

    procedure runBrowser(caller, callid: string);
    procedure showAON(caller: string);

    procedure showQueue;


    procedure amiReadPacket(packet: TStringList);
    function amiSendPacket(var socket: TWSocket; packet: string): boolean;
    function amiConnect(var socket: TWSocket; server: string; port: integer): boolean;
    function amiLogin(var socket: TWSocket; login, password: string): boolean;
    var
      queue_list_r:integer;
      queue_list_c:integer;
      queue_list_r_click:integer;
      queue_list_c_click:integer;

  public
    { Public declarations }
  end;

var
  main: Tmain;

implementation

uses tools, loginform, pauseform, ShellApi, Math, ShlObj, descriptionform;

var lastpopup: longint;
    countVolumeMax, countVolumeMin, countVolumeTick: integer;
    volLevels: array[0..19] of longint;

    trigger_aon, trigger_autoopen, trigger_status: boolean;
{$R *.dfm}


function getCell(grid: TStringGrid; c,r:integer): string;
var res: string;
begin
  //log('function getCell');
  res:='';
  if (r>=0) and (r<grid.RowCount) then
    if (c>=0) and (c<grid.ColCount) then
      res:=grid.Cells[c,r];
  getCell:=res;
end;

procedure setCell(var grid: TStringGrid; c,r:integer; value: string);
var res: string;
begin
  //log('procedure setCell');
  if (r>=0) and (r<grid.RowCount) then
    if (c>=0) and (c<grid.ColCount) then
      grid.Cells[c,r]:=value;
end;

procedure setQueue(var grid: TStringGrid; qname:string; c:integer; value: string);
var r:integer;
begin
  //log('procedure setQueue');
  //debug(main.trace, 'setQueue "'+qname+'" '+IntToStr(c)+' "'+value+'"');
  if (c>=0) and (c<grid.ColCount) then
    for r := 0 to grid.RowCount-1 do
      if (grid.Cells[0,r]=qname) then
      begin
        grid.Cells[c,r]:=value;
        //debug(main.trace, 'grid.Cells['+IntToStr(c)+', '+qname+']:='+value);
      end;
end;

function StringToPWide(sStr: string): PWideChar;
var
  pw: PWideChar;
  iSize, iNewSize: integer;
begin
  iSize := Length(sStr) + 1;
  iNewSize := iSize * 2;

  pw := AllocMem(iNewSize);

  MultiByteToWideChar(CP_ACP, 0, PAnsiChar(sStr), iSize, pw, iNewSize);

  Result := pw;
end;

procedure setStringList(var sl: TStringList; key, value, fromwhere: string);
var msg: string;
begin
  //log('procedure setStringList');
  try
    sl.Values[key] := value;
  except
    on EListError do
    begin
      msg:='setStringList: EListError: '+key+'='+value;
      MessageBox(0, StringToPWide(msg), 'fromwhere', mb_Ok);
    end;
  end;
end;

function getStringList(var sl: TStringList; key, fromwhere: string): string;
var msg: string;
    res: string;
begin
  //log('function getStringList');
  res:='';
  try
    res:=sl.Values[key];
  except
    on EListError do
    begin
      msg:='getStringList: EListError: '+key;
      MessageBox(0, StringToPWide(msg), StringToPWide(fromwhere), mb_Ok);
    end;
  end;
  getStringList:=res;
end;

function tmain.pauseDialog(queue_name: string): TPauseDialogResult;
var r:TPauseDialogResult;
begin
  log('procedure Tmain.pauseDialog');
  r.ok:=false;
  r.queue_name:=queue_name;

  if (not Assigned(form_pause)) then   // проверка существования Формы (если нет, то
    form_pause:=Tform_pause.Create(Self);    // создание Формы)

  //Initializing
  form_pause.queue_name.text := queue_name;
  form_pause.reason_index.itemindex := -1;
  form_pause.reason_text.Text := '';
  form_pause.reason_text.enabled:=false;

  //Run
  if form_pause.ShowModal=1 then
  begin
    r.ok:=true;
    r.reason_index:=form_pause.reason_index.itemindex+1;
    r.reason_text:=form_pause.reason_text.Text;
  end;
  pauseDialog := r;
end;

procedure tmain.pauseAction(p: TPauseDialogResult; force: boolean);
var s:string;
    d:string;
    i:integer;
begin
  log('procedure Tmain.pauseAction');
  if not p.ok then
    exit;

  if p.queue_name<>'all' then
  begin
    debug(trace, 'pauseAction: Пауза в очереди ' + p.queue_name + ' причина '+inttostr(p.reason_index)+' | '+p.reason_text);
    s:='Action: QueuePause' + crlf + 'Interface: SIP/'+ exten + crlf + 'Paused: 1' + crlf + 'Queue: ' + p.queue_name + crlf + 'Reason: '+inttostr(p.reason_index)+'|' + p.reason_text;
    pause_reason := inttostr(p.reason_index);
    amiSendPacket(socket, s);
    setQueue(queue_list, p.queue_name, 6, inttostr(p.reason_index));
    setQueue(queue_list, p.queue_name, 7, p.reason_text);
  end
  else
  begin
    for i:=0 to queue_list.RowCount-1 do
    if (getCell(queue_list, 1, i)<>'-')AND(getCell(queue_list, 3, i)<>'P')AND((getCell(queue_list, 1, i)<>'p') OR force )then
    begin
      debug(trace, 'pauseAction: Пауза в очереди ' + getCell(queue_list, 0, i) + ' причина '+inttostr(p.reason_index)+' | '+p.reason_text);
      s:='Action: QueuePause' + crlf + 'Interface: SIP/'+ exten + crlf + 'Paused: 1' + crlf + 'Queue: ' + getCell(queue_list, 0, i) + crlf + 'Reason: '+inttostr(p.reason_index)+'|' + p.reason_text;
      pause_reason := inttostr(p.reason_index);
      amiSendPacket(socket, s);
    setQueue(queue_list, getCell(queue_list, 0, i), 6, inttostr(p.reason_index));
    setQueue(queue_list, getCell(queue_list, 0, i), 7, p.reason_text);

    end;
  end;

end;

procedure tmain.unpauseAction(queue_name: string);
var s:string;
begin
  log('procedure Tmain.unpauseAction');
  s:='Action: QueuePause' + crlf + 'Interface: SIP/'+ exten + crlf + 'Paused: 0' + crlf + 'Queue: ' + queue_name;
  amiSendPacket(socket, s);
  debug(trace,'unpauseAction: ' + queue_name);
  setQueue(queue_list, queue_name, 6, '');
  setQueue(queue_list, queue_name, 7, '');
end;

procedure tmain.runBrowser(caller, callid: string);
var url_new: string;
begin
  log('procedure Tmain.runBrowser');
  url_new := urlRegexp(url, caller, callid);
  try
    debug(trace, url_new);
    ShellExecute(0, 'open', PWideChar(url_new), nil, nil, SW_SHOWNORMAL);
  except
  end;

end;
procedure tmain.showAON(caller: string);
var url_new: string;
begin
  log('procedure Tmain.showAON');
  url_new := urlRegexp(urlaon, caller, callid);
  http.URL:=url_new;
  http.GetASync;
end;
procedure tmain.setMute(flag: boolean);
begin
  log('procedure Tmain.setMute');
  if sound then
    FVolControl.SetMute(Ord(mute), nil);
end;

procedure tmain.setVolume(level: integer);
begin
  log('procedure Tmain.setVolume');
  //get values from 1 to 10
  if sound then
      FVolControl.SetMasterVolumeLevel(volMin+((volMax-volMin)/100)* log10(level)*100, nil);
end;

procedure tmain.showMute;
var mute_local:LongInt;
begin
  log('procedure Tmain.showMute');
  if not sound then
  begin
    exit;
  end;

  FVolControl.GetMute(mute_local);
  mute := (mute_local = 1);
  btn_mute.Glyph := nil;
  il_mute.GetBitmap(Ord(mute),btn_mute.Glyph)
end;

procedure tmain.setPause(queue_name: string; flag: boolean);
begin
  log('procedure Tmain.setPause');
  if (flag) then
    //setStringList(queue_pausestatus, queue_name, '1', 'tmain.setPause')
    setQueue(queue_list, queue_name, 4, '1')
  else
    setQueue(queue_list, queue_name, 4, '0');

  pause := flag;
  if not pause then
    pause_reason := exten;
   trigger_status := true;

  //debug(trace, 'Устанавливаем паузу=' + bool2str(pause));
end;

procedure tmain.showPause(force: boolean);
var c: tcolor;
    pause_show: boolean;
begin
    log('procedure Tmain.showPause');
  //Если нет очередей то покажем статус как паузу
  if (not queues) then
    pause_show := true
  else
    pause_show:=pause;

  //debug(trace, bool2str(queues) +' ' + bool2str(pause) +' ' + bool2str(pause_show));

  //Если текущий статус = прошлому и нет необходимости форсированного обновления то выходим
  if (pause_show = old_pause) and not force then
    exit;

  btn_pause.Glyph := nil;
  il_pause.GetBitmap(Ord(pause_show),btn_pause.Glyph);

  if pause_show then
  begin
    tray.IconIndex := 2;
    text_exten.Caption := pause_reason;
    text_exten.Font.Color := HexToTColor('FABF57');
  end
  else
  begin
    tray.IconIndex := 1;
    text_exten.Caption := pause_reason;
    text_exten.Font.Color := HexToTColor('267F00');
  end;
  old_pause := pause_show;
end;

function StrIsReal(AString: string): Boolean;
var I: Extended; Code: Integer;
begin
  Val(AString, I, Code);
  Result := Code = 0;
end;

procedure tmain.showQueue;
var i, l, bcount:integer;
  blink: boolean;
  ValI: Integer;
  Code: Integer;
begin
  log('procedure Tmain.showQueue');
  queues := false;

  for i := 0 to queue_list.RowCount-1 do
    setCell(queue_list, 1, i, '-');

  for i := 0 to queue_list.RowCount-1 do
  begin
    //Заполним столбец статуса
    if queue_list.Cells[5, i]='+' then
      if queue_list.Cells[4, i]='1' then
        queue_list.Cells[1, i]:='p'
      else
      begin
        queue_list.Cells[1, i]:='+';
        queues:=true;
      end
    else
      queue_list.Cells[1, i]:=queue_list.Cells[5, i];
  end;

  //Blinking
  blink:=false;
  bcount:=0;
  for i := 0 to queue_list.RowCount-1 do
  begin
    Val(getCell(queue_list, 2, i), ValI, Code);
    if code<>0 then
      ValI:=0;
    if (getCell(queue_list, 1, i)<>'+') then
    begin
      blink:=blink OR (ValI>count_max_queue1);
      //debug(trace, '* '+getCell(queue_list, 0, i)+'='+getCell(queue_list, 1, i)+' | '+bool2str(ValI>count_max_queue1)+' '+bool2str(getCell(queue_list, 1, i)<>'+'));
      bcount := bcount + ValI;
    end;
  end;
  blink:=blink OR (bcount>count_max_queueA);
  //blink:=blink AND pause;

  if blink = true then
  begin
    timer_blink.Enabled:=true;
  end
  else
  begin
    text_exten.Transparent:=true;
    timer_blink.Enabled:=false;
  end;

  btn_pause.visible := queues;
end;

procedure tmain.queueListPrepare(queuelist: string);
var x,i:integer;
    ts: TStringList;
    ts_param: TStringList;
    url_new: string;
begin
  // 0 - Имя очереди
  // 1 - Статус (цветной)
  // 2 - Количество ожидающих звонков
  // 3 - Режим очереди (P, A, ...)
  // 4 -
  // 5 -
  // 6 - Пенальти
  // 7 - Описание очереди

  log('procedure Tmain.queueListPrepare');
  url_new := StringReplace(queuelist, '{EXTEN}', exten, [rfReplaceAll]);
  xml.LoadFromFile(url_new);
  xml.Active:=true;

  debug(trace, 'Готовим очереди: ' + url_new);
  queue_list.RowCount:=xml.DocumentElement.ChildNodes.Count;
  debug(trace, 'Нашли ' + IntToStr(queue_list.RowCount) + ' очередей');
  for i:=0 to queue_list.RowCount-1 do
  begin
    debug(trace, VarToStr(xml.DocumentElement.ChildNodes.Nodes[i].ChildNodes.Nodes['queue'].Text));

    setCell(queue_list, 0, i, VarToStr(xml.DocumentElement.ChildNodes.Nodes[i].ChildNodes.Nodes['queue'].Text));
    setCell(queue_list, 3, i, VarToStr(xml.DocumentElement.ChildNodes.Nodes[i].ChildNodes.Nodes['mode'].Text));
    setCell(queue_list, 6, i, VarToStr(xml.DocumentElement.ChildNodes.Nodes[i].ChildNodes.Nodes['penalty'].Text));
    setCell(queue_list, 7, i, VarToStr(xml.DocumentElement.ChildNodes.Nodes[i].ChildNodes.Nodes['description'].Text));
    setCell(queue_list, 8, i, VarToStr(xml.DocumentElement.ChildNodes.Nodes[i].ChildNodes.Nodes['readable'].Text));

    setCell(queue_list, 1, i, '-');
    setCell(queue_list, 2, i, '-');
    setCell(queue_list, 5, i, '-');

    queue_list.RowHeights[i] := 19; //abs(queue_list.Font.Height)+6;
    inc(x, queue_list.RowHeights[i]+1);// + queue_list.BevelWidth+1);
  end;

  queue_list.Height := x; //Set new height

  queue_list.ColWidths[1] := 16;
  queue_list.ColWidths[2] := 16;
  queue_list.ColWidths[3] := 16;
  queue_list.ColWidths[0] := queue_list.width - 3*18;
  //queue_list.ColWidths[0] := 40;

  //Setting up width
  x:=0;
  for i := 0 to queue_list.ColCount-1 do
    inc(x, queue_list.ColWidths[i]+ queue_list.BevelWidth);
  //queue_list.Width := x;

  queue_list.Selection := TGridRect(Rect(-1, -1, -1, -1));
end;

procedure tmain.queueListPrepareOld(queuelist: string);
var x,i:integer;
    ts: TStringList;
    ts_param: TStringList;
begin
  log('procedure Tmain.queueListPrepare');
  debug(trace, 'Готовим очереди: ' + queuelist);
  ts:=Explode(',', queuelist);
  x:=0;
  queue_list.RowCount:=ts.Count;
  debug(trace, 'Нашли ' + IntToStr(ts.Count) + ' очередей');
  for i:=0 to ts.Count-1 do
  begin
    ts_param:=Explode('/', ts.ValueFromIndex[i]);
    if (ts_param.Count<>2) then
    begin
      setCell(queue_list, 0, i, ts.ValueFromIndex[i]);
      setCell(queue_list, 3, i, 'A');
    end
    else
    begin
      setCell(queue_list, 0, i, ts_param.ValueFromIndex[0]);
      setCell(queue_list, 3, i, ts_param.ValueFromIndex[1]);
    end;
    setCell(queue_list, 1, i, '-');
    setCell(queue_list, 2, i, '-');
    setCell(queue_list, 5, i, '-');

    queue_list.RowHeights[i] := 19; //abs(queue_list.Font.Height)+6;
    inc(x, queue_list.RowHeights[i]+1);// + queue_list.BevelWidth+1);
  end;

  queue_list.Height := x; //Set new height

  queue_list.ColWidths[1] := 16;
  queue_list.ColWidths[2] := 16;
  queue_list.ColWidths[3] := 16;
  queue_list.ColWidths[0] := queue_list.width - 3*18;
  //queue_list.ColWidths[0] := 40;

  //Setting up width
  x:=0;
  for i := 0 to queue_list.ColCount-1 do
    inc(x, queue_list.ColWidths[i]+ queue_list.BevelWidth);
  //queue_list.Width := x;

  queue_list.Selection := TGridRect(Rect(-1, -1, -1, -1));
end;

function Tmain.amiConnect(var socket: TWSocket; server: string; port: integer): boolean;
begin
  log('procedure Tmain.amiConnect');
  result := false;
  try
    socket.Addr:=server;
    socket.Port := inttostr(port);

    socket.LineEnd   := AnsiString(#13#10#13#10);
    socket.LineMode  := true;
    socket.LineLimit := 1024;
    socket.Connect;
  finally
    result:= Socket.State = wsConnected;  //TSocketState
  end;
end;

function Tmain.amiLogin(var socket: TWSocket; login, password: string): boolean;
begin
  amiSendPacket(socket,'Action: Login' + crlf + 'Username: '+ login + crlf+ 'Secret: '+ password + crlf);
end;

function tmain.loginDialog(connected: boolean): boolean;
begin
  if (not Assigned(login)) then   // проверка существования Формы (если нет, то
    login:=Tlogin.Create(Self);    // создание Формы)

  if not connected then
    login.color:=clRed
  else
  begin
    login.Color:=clWindow;
  end;

  //Initializing
  login.edit_exten.text := trim(exten);
  login.edit_server.Text := trim(server);
  login.edit_port.Text := IntToStr(port);
  login.edit_login.Text := vars.login;
  login.edit_password.Text:=password;
  login.edit_queuelist.Text:=trim(queuelist);

  //Run
  if login.ShowModal=1 then
  begin
    //Setting up variables
    exten       := login.edit_exten.Text;
    server      := login.edit_server.Text;
    port        := StrToInt(login.edit_port.Text);
    vars.login  := login.edit_login.Text;
    password    := login.edit_password.Text;
    queuelist   := login.edit_queuelist.Text;
    loginDialog := true;
    pause_reason := exten;
    mainResize;
  end
  else
    loginDialog := false;
end;

procedure Tmain.amiReadPacket(packet: TStringList);
var i: Integer;
    s:string;
begin
  log('procedure Tmain.amiReadPacket');
  //If no packet
  if not Assigned(packet) then
    exit;

  //Packet debug

  if debug_log then
    if (not debug_filter) or (debug_filter and ((getStringList(packet, 'CallerIDNum', 'packet: get(CallerIDNum)') = exten) or (getStringList(packet, 'MemberName', 'packet: get(MemberName)')='SIP/'+exten))) then
    begin
      debug(trace, ' <- Входящий');
      for i := 0 to packet.Count-1 do
        begin
          debug(trace, packet.Names[i]+'='+packet.ValueFromIndex[i]+'');
        end;
      debug(trace, '');
    end;
  {}

  //Login status packet
  if ((getStringList(packet, 'Response', 'packet: get(Response)') = 'Success') and (getStringList(packet, 'Message', 'packet: get(Message)') = 'Authentication accepted')) or (getStringList(packet, 'Event', 'packet: get(Event)') = 'FullyBooted') then
    if not loggedin then
    Begin
      //debug(trace, 'Вход в систему успешен');
      tray.IconIndex:=2;
      loggedin:=True;
    end;

  //Channel new state packet
  if ((getStringList(packet, 'Event', 'packet: get(Event)') = 'Newstate') and (getStringList(packet, 'CallerIDNum', 'packet: get(CallerIDNum)') = exten) and (getStringList(packet, 'ChannelState', 'packet: get(ChannelState)') = '5')) then
  Begin

    if ((DateTimeToUnix(Now) - lastpopup) > 3) then
      begin
        lastpopup := DateTimeToUnix(Now);

        caller := getStringList(packet, 'ConnectedLineNum', 'packet: get(ConnectedLineNum)');
        callid := getStringList(packet, 'Uniqueid', 'packet: get(Uniqueid)');

        {
        if autoaon then
          showAON(caller);
        //debug(trace, 'Входящий вызов от абонента ' +caller);
        if autoopen then
          runBrowser(caller);
        }
        if autoaon then
          trigger_aon:=true;
        if autoopen then
          trigger_autoopen:=true;
      end;
  end;

  if ((getStringList(packet, 'MemberName', 'packet: get(MemberName)')='SIP/'+exten)) or ((getStringList(packet, 'Name', 'packet: get(Name)')='SIP/'+exten)) then
  begin
    // Queue remove
    if getStringList(packet, 'Event', 'packet: get(Event)') = 'QueueMemberRemoved' then
      setQueue(queue_list, packet.Values['Queue'], 5, '-');

    // Queue add
    if getStringList(packet, 'Event', 'packet: get(Event)') = 'QueueMemberAdded' then
      setQueue(queue_list, packet.Values['Queue'], 5, '+');

    // Queue pause
    if getStringList(packet, 'Event', 'packet: get(Event)') = 'QueueMemberPaused' then
      setPause(packet.Values['Queue'], packet.Values['Paused']='1');

    // Queue status
    if (getStringList(packet, 'Event', 'packet: get(Event)') = 'QueueMemberStatus') or (getStringList(packet, 'Event', 'packet: get(Event)') = 'QueueMember') then
    Begin
      setPause(packet.Values['Queue'], packet.Values['Paused']='1');

      if (packet.Values['Status']='5') or (packet.Values['Status']='4') or (packet.Values['Status']='0') then
        setQueue(queue_list, packet.Values['Queue'], 5, '*')
      else
        setQueue(queue_list, packet.Values['Queue'], 5, '+');
      showQueue;
    end;

    // --------------------------------
    // If something hapend with queue
    // --------------------------------
    if pos('Queue',getStringList(packet, 'Event', 'packet: get(Event)'))>0 then
    begin
      trigger_status := true;
    end;
  end;

  //Bridge
  //if getStringList(packet, 'Event', 'packet: get(BridgeEvent)') = 'Bridge' then
  //  debug(trace, 'Соединение:  '+getStringList(packet, 'Channel1', 'packet: get(BridgeEvent)')+' <=> '+getStringList(packet, 'Channel2', 'packet: get(BridgeEvent)'));

  // Queue waiting count
  if getStringList(packet, 'Event', 'packet: get(Event)') = 'QueueParams' then
  Begin
    setQueue(queue_list, packet.Values['Queue'], 2, packet.Values['Calls']);
    trigger_status := true;
  end;

  if getStringList(packet, 'Event', 'packet: get(Event)') = 'QueueStatusComplete' then
  Begin
    showQueue;
    showPause(true);
  end;
  //packet.Free;
end;

function tmain.amiSendPacket(var socket: TWSocket; packet: string): boolean;
var i: integer;
    ts: TStringList;
begin
  log('procedure Tmain.amiSendPacket');
  if socket.State<>wsConnected then
  begin
    debug(trace, 'Запрос неуспешен. Нет соединения');
    Exit;
  end;

  ts:=Explode(#13#10, packet);
    if debug_log then
      debug(trace, ' -> ');

  for i := 0 to ts.Count-1 do
  begin
    if debug_log then
      debug(trace, ts.ValueFromIndex[i]);
    socket.SendStr(ts.ValueFromIndex[i] + crlf);
  end;
  if debug_log then
    debug(trace, '');

  i:=socket.SendStr(crlf);
  socket.Flush;

  result :=  Socket.LastError=0;

  //if debug_log then
  //  Debug(trace, 'Послано: '+bool2str(result));


end;

procedure Tmain.ApplicationEvents1Exception(Sender: TObject; E: Exception);
var ClassTree: String;
    ClassRef: TClass;
    msg :string;
begin
  log('procedure Tmain.ApplicationEvents1Exception');
  ClassTree:=E.ClassName;
  ClassRef:=E.ClassType;
  while ClassRef.ClassParent<>nil do
  begin
    ClassRef:=ClassRef.ClassParent;
    ClassTree:=ClassRef.ClassName+' => '+ClassTree;
  end;

  msg:='';
  msg:=msg+ClassTree+':'+#13#10;
  msg:=msg+E.Message+#13#10;
  msg:=msg+'Exiting'+#13#10;
  log(msg);
  ShowMessage('Коннектор будет закрыт из-за ошибки. Перезапустите его.');
  Application.Terminate;
end;

procedure Tmain.mainResize;
//const defaultHeight=88;
var newHeight: integer;
begin
  log('procedure Tmain.mainResize');
  if sound then
  begin
    btn_mute.Enabled := true;
    volume.Visible := true
  end
  else
  begin
    btn_mute.Enabled := false;
    volume.Visible := false;
  end;

  //Calculating gb height
  bg.Height:=queue_list.Top + queue_list.Height+4;

  panel1.Top:=bg.Top + bg.Height+2;

  if debug_visible then
  begin
    trace.Visible:=true;
    ClientWidth:=panel1.Width+2;
    ClientHeight:=panel1.Top+panel1.Height+1;
  end
  else
  begin
    if ClientHeight<>bg.Height+1 then
      ClientHeight:=bg.Height+1;
    if ClientWidth<>bg.Width+1 then
      ClientWidth:=bg.Width+1;
  end;
end;

procedure Tmain.bgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (button<>mbRight) then
  begin
    ReleaseCapture;
    Perform(WM_SysCommand,$F012,0);
  end;
end;

procedure Tmain.btn_pauseMouseUp(Sender: TObject; Button: TMouseButton;  Shift: TShiftState; X, Y: Integer);
begin
  log('procedure Tmain.pauseMouseUp');
  if (button=mbRight) then
    pauseAction(pauseDialog('all'), true);
end;

procedure Tmain.Button1Click(Sender: TObject);
begin
  log('procedure Tmain.Button1Click');
  tray.IconIndex:=3;
  main.N9Click(nil);
end;

procedure Tmain.Button2Click(Sender: TObject);
var p: TPauseDialogResult;
begin
  log('procedure Tmain.Button2Click');
  p:=pauseDialog('all');
  if (p.ok) then
    trace.Lines.Add('ok')
  else
    trace.Lines.Add('not ok');
  trace.Lines.Add(inttostr(p.reason_index));
  trace.Lines.Add(p.reason_text);
end;

procedure Tmain.Fdnjdjl1Click(Sender: TObject);
var s:string;
    i:integer;
begin
  log('procedure Tmain.Fdnjd1Click');
  for i:=0 to queue_list.RowCount-1 do
    if getCell(queue_list, 3, i)='A' then
    begin
      s:='Action: QueueAdd' + crlf + 'Interface: SIP/'+ exten + crlf + 'Paused: True' + crlf + 'Queue: ' + getCell(queue_list, 0, i) + crlf + 'Penalty: ' + getCell(queue_list, 6, i);
      amiSendPacket(socket, s);
    end;
end;

procedure Tmain.FormActivate(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure Tmain.FormCreate(Sender: TObject);
var connected: boolean;
begin
  //Initializing variables
  InitVars;
  connected:=true;

  //Terminate if cancelled
  repeat
    if not autologin or not connected then
      if not loginDialog(connected) then
      begin
        application.Terminate;
        exit;
      end;

    text_exten.Caption := exten;
    pause_reason := exten;

    popup_tray.Items[1].Checked := autoopen;
    popup_tray.Items[2].Checked := autoaon;
    popup_tray.Items[3].Checked := autologin;

    popup_debug.Items[0].Checked := debug_visible;
    popup_debug.Items[1].Checked := debug_log;
    popup_debug.Items[2].Checked := debug_scroll;
    popup_debug.Items[3].Checked := debug_filter;

    //Making accurate size and pos
    mainResize;
    main.Left := min(miniinfo_x, screen.Width-50);
    main.Top  := min(miniinfo_y, screen.Height-50);

    tray.Visible:=true;
    tray.IconIndex:=3;

    queueListPrepare(queuelist);
    showMute;

    if sound then
    begin
      //volumelevel.Min := 2;//trunc(volMin*100);
      //volumelevel.Max := 10;//ceil(volMax*100);
      volumelevel.Position := volumelevel.Max;
    end
    else
    begin
      volumelevel.visible:=false;
      volume.Visible:=false;
      btn_mute.visible:=false;
    end;

    connected := amiConnect(socket, server, port);
  until not connected;

  ShowWindow(Handle, SW_HIDE);
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW );
  ShowWindow(Handle, SW_SHOW);
end;

procedure Tmain.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure Tmain.httpDocData(Sender: TObject; Buffer: Pointer; Len: Integer);
var s: String;
begin
  log('procedure Tmain.httpDocData');
  try
    if Len>256 then
    begin
      Abort;
    end;
    s:=PChar(Buffer);
    if s = '' then
      s:=caller
    else
      if Length(Copy(s, Pos('|',s)+1, Length(s))) >0 then
        s:=Copy(s, 1, Pos('|',s)-1)+#13+Copy(s, Pos('|',s)+1, Length(s))
      else
        s:=Copy(s, Pos('|',s)+1, Length(s));
    s := Utf8ToAnsi(s);
  except
  end;

  s:=copy(s, 0, 32); //Обрежем строку, на всякий

  try
    tray.BalloonTitle:='Входящий звонок';
    tray.BalloonHint:=s;
    tray.BalloonTimeout:=3000;
    tray.ShowBalloonHint;
  except
  end;
end;

procedure Tmain.img_muteClick(Sender: TObject);
begin
  //
  mute := not mute;
  setMute(mute);
  showMute;
end;

procedure Tmain.img_pauseClick(Sender: TObject);
var s:string;
    i: integer;
begin
  log('procedure Tmain.img_pauseClick');
  if pause then
    begin
      for i:=0 to queue_list.RowCount-1 do
      begin
        s:='Action: QueuePause' + crlf + 'Interface: SIP/'+ exten + crlf + 'Paused: 0' + crlf + 'Queue: ' + getCell(queue_list, 0, i);
        amiSendPacket(socket, s);
      end;
    end
  else
    pauseAction(pauseDialog('all'), false);
end;

procedure Tmain.N10Click(Sender: TObject);
begin
  autoaon:=not autoaon;
  TMenuItem(Sender).Checked := autoaon;
end;

procedure Tmain.N12Click(Sender: TObject);
begin
  autologin := not autologin;
  TMenuItem(Sender).Checked := autologin;
end;

procedure Tmain.N13Click(Sender: TObject);
var s:string;
begin
    log('procedure Tmain.N13Click');
    s:='Action: QueueRemove' + crlf + 'Interface: SIP/'+ exten + crlf + 'Paused: 0' + crlf + 'Queue: ' + getCell(queue_list, 0, queue_list_r_click);
    amiSendPacket(socket, s);
end;

procedure Tmain.N14Click(Sender: TObject);
var s:string;
    i:integer;
begin
  log('procedure Tmain.N14Click');
  for i:=0 to queue_list.RowCount-1 do
    if getCell(queue_list, 3, i)='A' then
    begin
      s:='Action: QueueRemove' + crlf + 'Interface: SIP/'+ exten + crlf + 'Queue: ' + getCell(queue_list, 0, i);
      amiSendPacket(socket, s);
    end;
end;

procedure Tmain.N1Click(Sender: TObject);
begin
  debug_visible := not debug_visible;
  TMenuItem(Sender).Checked := debug_visible;
  mainResize;
end;

procedure Tmain.N2Click(Sender: TObject);
begin
  debug_log := not debug_log;
  TMenuItem(Sender).Checked := debug_log;
end;

procedure Tmain.N3Click(Sender: TObject);
begin
  debug_scroll := not debug_scroll;
  TMenuItem(Sender).Checked := debug_scroll;
end;

procedure Tmain.N4Click(Sender: TObject);
begin
  debug_filter := not debug_filter;
  TMenuItem(Sender).Checked := debug_filter;
end;

procedure Tmain.N5Click(Sender: TObject);
begin
  trace.Lines.Clear;
end;

procedure Tmain.N6Click(Sender: TObject);
var s:string;
begin
  log('procedure Tmain.N6Click');
  s:='Action: QueueAdd' + crlf + 'Interface: SIP/'+ exten + crlf + 'Paused: 1' + crlf + 'Queue: ' + getCell(queue_list, 0, queue_list_r_click) + crlf + 'Penalty: ' + getCell(queue_list, 6, queue_list_r_click);
  amiSendPacket(socket, s);
end;

procedure Tmain.N7Click(Sender: TObject);
begin
  if main.Visible then
    main.Hide
  else
    main.Show;
end;

procedure Tmain.N8Click(Sender: TObject);
begin
  autoopen := not autoopen;
  TMenuItem(Sender).Checked := autoopen;

end;

procedure Tmain.N9Click(Sender: TObject);
var i:integer;
    s:string;
begin
  log('procedure Tmain.N9Click');
  exiting:=true;
  Application.ProcessMessages;

  miniinfo_x := main.Left;
  miniinfo_y := main.Top;
  SaveVars;

  debug(trace, 'Автовыход...');
  for i:=0 to queue_list.RowCount-1 do
    if getCell(queue_list, 1, i)<>'-' then
    begin
      s:='Action: QueueRemove' + crlf + 'Interface: SIP/'+ exten + crlf + 'Paused: True' + crlf + 'Queue: ' + getCell(queue_list, 0, i);
      amiSendPacket(socket, s);
      debug(trace, 'Очередь '+getCell(queue_list, 0, i));
    end;

  //Try to logout
  if socket.State = wsConnected then
  begin
    try
      //debug(trace,'Завершаем активное подключение...');
      //amiSendPacket(socket, 'Action: Logout');
      //debug(trace,'Закрываем соединение...');
      //socket.CloseDelayed;
      Sleep(2000);
      socket.Close;
    except
      debug(trace,'Проблема с закрытием сокета');
    end;
  end;

  Application.Terminate;
end;

procedure Tmain.queue_listDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var r: TRect;
begin
  if ACol=1 then
    With Sender as TStringGrid do
    begin
      r.Left   := Rect.Left+2;
      r.Top    := Rect.Top+2;
      r.Right  := Rect.Left+ColWidths[ACol]-2; //Rect.Right;
      r.Bottom := Rect.Top+RowHeights[ARow]-2; //Rect.Bottom;

      if Cells[ACol, ARow]='-' then
        Canvas.Brush.Color:=clRed;

      if Cells[ACol, ARow]='+' then
        Canvas.Brush.Color:=clMoneyGreen;

      if Cells[ACol, ARow]='*' then
        Canvas.Brush.Color:=clFuchsia;

      if Cells[ACol, ARow]='p' then
        Canvas.Brush.Color:=clYellow;

      Canvas.FillRect(R);
      if Top+Height > bg.Top+bg.Height then
        mainresize;

    end;

  if ACol=0 then
    With Sender as TStringGrid do
    begin
      Canvas.Brush.Color:=clWhite;
      Canvas.FillRect(Rect);
      Canvas.Pen.Color:=clBlack;
      Canvas.TextOut(Rect.Left+2, Rect.Top+2, Cells[8, ARow]);
    end;

end;
procedure Tmain.queue_listMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var R,C:integer;
begin
  TStringGrid(Sender).MouseToCell(X, Y, C, R);
  if (queue_list_r<>R) or (queue_list_c<>c) then
  begin
    Application.CancelHint;
    if c=0 then
    begin
      TStringGrid(Sender).Hint:=TStringGrid(Sender).Cells[7,R];
    end;

    if c=1 then
    begin
      if TStringGrid(Sender).Cells[C,R]='+' then TStringGrid(Sender).Hint:='Активная очередь';
      if TStringGrid(Sender).Cells[C,R]='-' then TStringGrid(Sender).Hint:='Неактивная очередь';
      if TStringGrid(Sender).Cells[C,R]='*' then TStringGrid(Sender).Hint:='Телефон оператора выключен';
      if TStringGrid(Sender).Cells[C,R]='p' then TStringGrid(Sender).Hint:='На паузе: ' + TStringGrid(Sender).Cells[6,R] + '('+TStringGrid(Sender).Cells[7,R]+')';
    end;

    if c=2 then
    begin
      TStringGrid(Sender).Hint:='Количество звонков в очереди, ожидающих ответа';
    end;

    if c=3 then
    begin
      if TStringGrid(Sender).Cells[C,R]='A' then TStringGrid(Sender).Hint:='Автологин при входе';
      if TStringGrid(Sender).Cells[C,R]='P' then TStringGrid(Sender).Hint:='Постоянное нахождение в данной очереди';
      if TStringGrid(Sender).Cells[C,R]='M' then TStringGrid(Sender).Hint:='Ручной вход';
    end;

    queue_list_r:=r;
    queue_list_c:=c;
  end;
end;

procedure Tmain.queue_listMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var R,C:integer;
  p:TPauseDialogResult;
begin
  log('procedure Tmain.queue_listMouseUp');
  if Button<>mbRight then
    exit;

  TStringGrid(Sender).MouseToCell(X, Y, C, R);

  if (r<0) or (c<0) then
    exit;

  queue_list_r_click:=R;
  queue_list_c_click:=C;

  if C = 0 then
    if TStringGrid(Sender).Cells[3, R]<>'P' then
      popup_queue.Popup(5+main.Left+TStringGrid(Sender).Left, 5+main.top + TStringGrid(Sender).Top + R*TStringGrid(Sender).RowHeights[R]);

  if C = 1 then
  begin
    if (TStringGrid(Sender).Cells[1, R]='+')AND(TStringGrid(Sender).Cells[3, R]<>'P') then
      pauseAction(pauseDialog(TStringGrid(Sender).Cells[0, R]), false);
    if (TStringGrid(Sender).Cells[1, R]='p') then
      unpauseAction(TStringGrid(Sender).Cells[0, R]);
  end;

  if C = 3 then
    popup_queueenter.Popup(5+main.Left+TStringGrid(Sender).Left, 5+main.top + TStringGrid(Sender).Top + R*TStringGrid(Sender).RowHeights[R]);
end;

procedure Tmain.queue_listSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
begin
  if (ACol=4) or (ACol=5) then
  begin
    if queue_list.Cells[5, ARow]='+' then
      if queue_list.Cells[4, ARow]='1' then
        queue_list.Cells[1, ARow]:='p'
      else
      begin
        queue_list.Cells[1, ARow]:='+';
      end
    else
      queue_list.Cells[1, ARow]:=queue_list.Cells[5, ARow];
  end;
end;

procedure Tmain.queue_listTopLeftChanged(Sender: TObject);
begin
  TStringGrid(Sender).TopRow:=0;
  TStringGrid(Sender).LeftCol:=0;
end;

function state2string(state: TSocketState): string;
begin
  case state of
    wsInvalidState:   result := 'wsInvalidState';
    wsOpened:         result := 'wsOpened';
    wsBound:          result := 'wsBound';
    wsConnecting:     result := 'wsConnecting';
    wsSocksConnected: result := 'wsSocksConnected';
    wsConnected:      result := 'wsConnected';
    wsAccepting:      result := 'wsAccepting';
    wsListening:      result := 'wsListening';
    wsClosed:         result := 'wsClosed';
    else result := 'wsXxxxxxxx';
  end;
end;

procedure Tmain.socketChangeState(Sender: TObject; OldState,
  NewState: TSocketState);
begin
  //
  log('procedure Tmain.sockeChangeState');
  debug(trace, 'Сокет: '+state2string(OldState)+' -> '+state2string(NewState));
end;

procedure Tmain.socketDataAvailable(Sender: TObject; ErrCode: Word);
var
  Line :string;
begin
  log('procedure Tmain.socketdataAvailable');
  if exiting then
    exit;

  if ErrCode <> 0 then
  begin
    debug(trace, 'There is error');
    Exit;
  end;

  with Sender as TWSocket do begin
    Line := ReceiveStr;
  end;

  amiReadPacket(DoubleExplode(crlf, ':', Line));
end;

procedure Tmain.socketSessionClosed(Sender: TObject; ErrCode: Word);
begin
    if exiting then exit;

    ShowMessage('Соединение потеряно. Перезапустите коннектор.');
    Application.Terminate;
end;

procedure Tmain.socketSessionConnected(Sender: TObject; ErrCode: Word);
var s:string;
    i:integer;
begin
  tray.IconIndex := 2;

  debug(trace, 'Соединение установлено');
  debug(trace, 'Авторизация...');
  if amiLogin(socket, vars.login, vars.password) then
    debug(trace, 'Успешна');
  //sleep(100);

  debug(trace, 'Подписка на события...');
  amiSendPacket(socket, 'Action: Events' + crlf + 'EventMask: call,agent');

  debug(trace, 'Автологин в очереди автовхода...');
  for i:=0 to queue_list.RowCount-1 do
    if getCell(queue_list, 3, i)='A' then
    begin
      s:='Action: QueueAdd' + crlf + 'Interface: SIP/'+ exten + crlf + 'Paused: True' + crlf + 'Queue: ' + getCell(queue_list, 0, i) + crlf + 'Penalty: ' + getCell(queue_list, 6, i);
      amiSendPacket(socket, s);
      debug(trace, 'Очередь '+getCell(queue_list, 0, i));
    end;

  debug(trace, 'Автологин в очереди перманетные...');
  for i:=0 to queue_list.RowCount-1 do
    if getCell(queue_list, 3, i)='P' then
    begin
      s:='Action: QueueAdd' + crlf + 'Interface: SIP/'+ exten + crlf + 'Paused: False' + crlf + 'Queue: ' + getCell(queue_list, 0, i) + crlf + 'Penalty: ' + getCell(queue_list, 6, i);
      amiSendPacket(socket, s);
      debug(trace, 'Очередь '+getCell(queue_list, 0, i));
    end;

  debug(trace, 'Запрос статуса очереди...');
  amiSendPacket(socket, 'Action: QueueStatus');
  //sleep(100);

end;

procedure Tmain.Timer1Timer(Sender: TObject);
var
  fPeak: Single;
  HR: HRESULT;
  i:integer;
begin
  if not sound then
  begin
    volume.Visible := false;
    timer1.Enabled := false;
  end;

  if not Assigned(PeakMeter) then Exit;

  try
    HR := PeakMeter.GetPeakValue(fPeak);
    if Succeeded(HR) then
      volume.Position := round(fPeak * 100.0);

      //AutoVolume

      //Вариант с частнотной характеристикой уровней громкости
      if agc.Checked and not mute then
      begin
        i:=min(floor(fPeak * 100.0 / 5), 19);
        inc(volLevels[i]);
        inc(countVolumeTick);

        if (countVolumeTick)>(1000/timer1.Interval) then
        begin
          countVolumeTick:=0;
          countVolumeMax:=0;
          for i:=0 to 19 do
          begin
            if volLevels[i] > volLevels[countVolumeMax] then
              countVolumeMax:=i;
            volLevels[i]:=0;
          end;

          if countVolumeMax>17 then
            volumeLevel.Position:=volumeLevel.Position-1
          else
            volumeLevel.Position:=volumeLevel.Position+1;
          //debug(trace, 'I = '+inttostr(countVolumeMax));
        end;

        { //вариант с воронкой значений
        inc(countVolumeTick);
        if volume.Position>90 then
          inc(countVolumeMax);
        if (volume.Position<60) and (volume.Position>15) then
          inc(countVolumeMin);

        if (countVolumeTick)>(1000/timer1.Interval) then
        begin
          if (countVolumeMax/countVolumeTick>(volAccuracy.Position/100)) then
            volumeLevel.Position:=volumeLevel.Position-1
          else
            if (countVolumeMin/countVolumeTick>(volAccuracy.Position/100)) then
              volumeLevel.Position:=volumeLevel.Position+1;

          levelMin.Position:=round(levelMin.Max*countVolumeMin/countVolumeTick);
          levelMax.Position:=round(levelMax.Max*countVolumeMax/countVolumeTick);
          countVolumeTick:=0;
          countVolumeMax:=0;
          countVolumeMin:=0;
        end;
        }
      end;
      //End Autovolume

  except

  end;
end;

procedure Tmain.volAccuracyChange(Sender: TObject);
begin
  debug(trace, 'Чувствительность: ' + inttostr(volAccuracy.Position));
end;

procedure Tmain.timer_blinkTimer(Sender: TObject);
begin
  text_exten.transparent:= not text_exten.transparent;
end;

procedure Tmain.timer_callswaitingTimer(Sender: TObject);
begin
  log('procedure Tmain.callswaitingTimer');
  amiSendPacket(socket, 'Action: QueueStatus' + crlf + 'Member: paramsonly');
end;

procedure Tmain.timer_triggerTimer(Sender: TObject);
begin
  if trigger_aon then
  begin
    trigger_aon := false;
    ShowAON(caller);
  end;

  if trigger_autoopen then
  begin
    trigger_autoopen := false;
    runBrowser(caller, callid);
  end;


  if trigger_status then
  begin
    //debug(trace, 'Pasue:  '+ bool2str(pause));
    trigger_status := false;
    showQueue;
    showPause(true);
  end;
end;

procedure Tmain.trayBalloonClick(Sender: TObject);
begin
  try
    debug(trace,'Открываем страницу поиска');
    runBrowser(caller, callid);
  finally
    debug(trace,'Готово');
  end;
end;

procedure Tmain.trayDblClick(Sender: TObject);
begin
    if ((DateTimeToUnix(Now) - lastpopup) > 1) then
      begin
        lastpopup := DateTimeToUnix(Now);
        runBrowser(caller, callid);
      end;
end;

procedure Tmain.volumelevelChange(Sender: TObject);
begin
  setVolume(volumelevel.Position);
end;

end.
