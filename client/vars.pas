unit vars;

interface

uses MMDevApi, ComObj, PropSys2, Classes;
var
  //queue, queue_waiting, queue_pausestatus: TStringList;
  pause, old_pause, queues: boolean;
  exiting: boolean;
  exten, caller, callid, url, urlaon: string;
  port: integer;
  server, login, password, queuelist: string;
  autoopen: boolean;
  autologin: boolean;
  ontop, autoaon, miniinfo: boolean;
  miniinfo_x, miniinfo_y: Integer;
  mute: Boolean;

  connection    : integer; // -1 error 0 disconnected 1 connected
  loggedin      : boolean;
  sound         : boolean;
  pause_reason  : string;
  logfilename   : string;

  debug_visible : boolean;
  debug_log     : boolean;
  debug_filter  : boolean;
  debug_scroll  : boolean;

  count_max_queue1 :integer;
  count_max_queueA :integer;


  FVolControl   : IAudioEndpointVolume;
  PeakMeter     : IAudioMeterInformation;
  volMin, volMax, volStep : single;

const
  crlf = AnsiString(#13#10);
  UnixStartDate: TDateTime = 25569.0;

type
  TPauseDialogResult = record
    ok: boolean;
    queue_name: string;
    reason_index:integer;
    reason_text:string;
  end;

procedure InitVars;
procedure SaveVars;

implementation
uses tools, ComCtrls, SysUtils;

procedure InitVars;
begin
  if not regReadBool('FirstRun', true) then
  begin
    exten           := regReadString('Extention');
    url             := regReadString('URL', 'http://yourdomain/api/search1.php?phone={PHONE}&callid={CALLID}');
    urlaon          := regReadString('URLaon', 'http://yourdomain/api/calllog_backend.php?phone={PHONE}');
    autoopen        := regReadBool('Autoopen');
    autologin       := regReadBool('Autologin') AND false;
    autoaon         := regReadBool('AutoAon');
    autologin       := regReadBool('AutoLogin');
    ontop           := regReadBool('OnTop');
    miniinfo        := regReadBool('MiniInfo');

    miniinfo_x      := regReadInt('MiniInfoX', 0);
    miniinfo_y      := regReadInt('MiniInfoY', 0);

    debug_visible   := regReadBool('DebugVisible');
    debug_log       := regReadBool('DebugLog');
    debug_filter    := regReadBool('DebugFilter');
    debug_scroll    := regReadBool('DebugScroll');

    server          := regReadString('Server', '192.168.2.7');
    port            := regReadInt('Port', 5038);
    login           := regReadString('Login', 'crm');
    password        := regReadString('Password', 'crm');
    //queuelist       := regReadString('QueueList', '3000/A, 3001/A, 3002/A, 3333/M');
    queuelist       := regReadString('ConfigURL', 'http://192.168.2.7/connector/config.php?agent={EXTEN}');


    count_max_queue1 := regReadInt('count_max_queue1', 3);
    count_max_queueA := regReadInt('count_max_queueA', 3);

  end
  else
    regWriteBool('FirstRun', false);
end;

procedure SaveVars;
begin
  regWriteString('Extention',  exten);
  regWriteString('URL',        url);
  regWriteString('URLaon',     urlaon);
  regWriteBool('Autoopen',     autoopen);
  regWriteBool('AutoAon',      autoaon);
  regWriteBool('OnTop',        ontop);
  regWriteBool('MiniInfo',     miniinfo);
  regWriteInt('MiniInfoX',     miniinfo_x);
  regWriteInt('MiniInfoY',     miniinfo_y);
  regWriteBool('AutoLogin',    autologin);
  regWriteBool('DebugVisible', debug_visible);
  regWriteBool('DebugLog',     debug_log);
  regWriteBool('DebugFilter',  debug_filter);
  regWriteBool('DebugScroll',  debug_scroll);

  regWriteString('Server',   server);
  regWriteInt('Port',        port);
  regWriteString('Login',    login);
  regWriteString('Password', password);
  //regWriteString('QueueList', queuelist);
  regWriteString('ConfigURL', queuelist);


  regWriteInt('count_max_queue1', count_max_queue1);
  regWriteInt('count_max_queueA', count_max_queueA);
  end;

begin
  //queue := TStringList.Create();
  //queue_pausestatus := TStringList.Create();
  //queue_waiting := TStringList.Create();
  pause          := false;
  old_pause      := false;
  queues         := false;
  exiting        := false;
  connection     := 0;     // -1 error 0 disconnected 1 connected
  loggedin       := false;
  pause_reason   := '';
  logfilename    := GetSpecialPath($001a)+'\calllog-xe-'+IntToStr(DateTimeToUnix(Now))+'.txt';
end.
