unit MMDevApi;

{$MINENUMSIZE 4}
{$WEAKPACKAGEUNIT}

interface

uses
  Windows, ActiveX, ComObj, propsys2, MMSystem, PropSys;

type
  Int8   = ShortInt;
  Int16  = SmallInt;
  Int32  = Integer;
  UInt8  = Byte;
  UInt16 = Word;
  UInt32 = Cardinal;
  PUInt64 = ^UInt64;
const
  CLASS_IMMDeviceEnumerator             : TGUID = '{BCDE0395-E52F-467C-8E3D-C4579291692E}';
  IID_IMMDeviceEnumerator               : TGUID = '{A95664D2-9614-4F35-A746-DE8DB63617E6}';
  IID_IMMDevice                         : TGUID = '{D666063F-1587-4E43-81F1-B948E807363F}';
  IID_IMMDeviceCollection               : TGUID = '{0BD7A1BE-7A1A-44DB-8397-CC5392387B5E}';
  IID_IAudioEndpointVolume              : TGUID = '{5CDF2C82-841E-4546-9722-0CF74078229A}';
  IID_IAudioMeterInformation            : TGUID = '{C02216F6-8C67-4B5B-9D00-D008E73E0064}';
  IID_IAudioEndpointVolumeCallback      : TGUID = '{657804FA-D6AD-4496-8A60-352752AF4F89}';
  IID_IAudioClient                      : TGUID = '{1CB9AD4C-DBFA-4c32-B178-C2F568A703B2}';
  IID_IMMNotificationClient             : TGUID = '{7991EEC9-7E89-4D85-8390-6C703CEC60C0}';
  IID_IAudioSessionManager              : TGUID = '{BFA971F1-4D5E-40BB-935E-967039BFBEE4}';
  IID_IAudioCaptureClient               : TGUID = '{C8ADBD64-E71E-48a0-A4DE-185C395CD317}';
  IID_IAudioRenderClient                : TGUID = '{F294ACFC-3146-4483-A7BF-ADDCA7C260E2}';

  DEVICE_STATE_ACTIVE                   = $00000001;
  DEVICE_STATE_UNPLUGGED                = $00000002;
  DEVICE_STATE_NOTPRESENT               = $00000004;
  DEVICE_STATEMASK_ALL                  = $00000007;

  eRender                               = $00000000;
  eCapture                              = $00000001;
  eAll                                  = $00000002;
  EDataFlow_enum_count                  = $00000003;

  eConsole                              = $00000000;
  eMultimedia                           = $00000001;
  eCommunications                       = $00000002;
  ERole_enum_count                      = $00000003;

  //STGM_READ	                            = $00000000;
 	//STGM_WRITE                            = $00000001;
 	//STGM_READWRITE                        =	$00000002;

  ENDPOINT_HARDWARE_SUPPORT_VOLUME    = $00000001;
  ENDPOINT_HARDWARE_SUPPORT_MUTE      = $00000002;
  ENDPOINT_HARDWARE_SUPPORT_METER     = $00000004;

  AUDCLNT_SHAREMODE_SHARED              = 0;
  AUDCLNT_SHAREMODE_EXCLUSIVE           = 1;

  AUDCLNT_BUFFERFLAGS_DATA_DISCONTINUITY   = 1;
  AUDCLNT_BUFFERFLAGS_SILENT               = 2;
  AUDCLNT_BUFFERFLAGS_TIMESTAMP_ERROR      = 4;

  AUDCLNT_STREAMFLAGS_LOOPBACK        = $00020000;
  AUDCLNT_STREAMFLAGS_EVENTCALLBACK   = $00040000;
  AUDCLNT_STREAMFLAGS_NOPERSIST       = $00080000;

  // Constants for AudioSessionState value
  AudioSessionStateInactive = 0;       // The last running stream in the session stops.
  AudioSessionStateActive = 1;         // The session has one or more streams that are running.
  AudioSessionStateExpired = 2;        // The client destroys the last stream in the session by releasing all
                                       // references to the stream object.
// Constants for DisconnectReason value
  DisconnectReasonDeviceRemoval = 0;   // The user removed the audio endpoint device.
  DisconnectReasonServerShutdown = 1;  // The Windows audio service has stopped.
  DisconnectReasonFormatChanged = 2;   // The stream format changed for the device that the audio session is connected to.
  DisconnectReasonSessionLogoff = 3;   // The user logged off the Windows Terminal Services (WTS) session that the audio
                                       // session was running in.
  DisconnectReasonSessionDisconnected = 4; // The WTS session that the audio session was running in was disconnected.
  DisconnectReasonExclusiveModeOverride = 5;  // The (shared-mode) audio session was disconnected to make the audio endpoint
                                              // device available for an exclusive-mode connection.

type
  REFERENCE_TIME = int64;
  EDataFlow = TOleEnum;
  ERole = TOleEnum;
  AUDCLNT_SHAREMODE = TOleEnum;

  PAUDIO_VOLUME_NOTIFICATION_DATA = ^AUDIO_VOLUME_NOTIFICATION_DATA;
  AUDIO_VOLUME_NOTIFICATION_DATA = packed record
    guidEventContext: TGUID;
    bMuted: BOOL;
    fMasterVolume: Single;
    nChannels: UINT;
    afChannelVolumes: array [1..1] of Single;
  end;

type
  IAudioEndpointVolumeCallback = interface(IUnknown)
  ['{657804FA-D6AD-4496-8A60-352752AF4F89}']
    function OnNotify(pNotify:PAUDIO_VOLUME_NOTIFICATION_DATA):HRESULT; stdcall;
  end;

  IAudioEndpointVolume = interface(IUnknown)
    ['{5CDF2C82-841E-4546-9722-0CF74078229A}']
    function RegisterControlChangeNotify(pNotify: IAudioEndpointVolumeCallback): HRESULT; stdcall;
    function UnregisterControlChangeNotify(pNotify: IAudioEndpointVolumeCallback): HRESULT; stdcall;
    function GetChannelCount(var pnChannelCount: UINT): HRESULT; stdcall;
    function SetMasterVolumeLevel(fLevelDB: Single; pguidEventContext: PGuid): HRESULT; stdcall;
    function SetMasterVolumeLevelScalar(fLevel: Single; pguidEventContext: PGuid): HRESULT; stdcall;
    function GetMasterVolumeLevel(var pfLevelDB: Single): HRESULT; stdcall;
    function GetMasterVolumeLevelScalar(var pfLevel: Single): HRESULT; stdcall;
    function SetChannelVolumeLevel(nChannel: UINT; fLevelDB: Single; pguidEventContext: PGuid): HRESULT; stdcall;
    function SetChannelVolumeLevelScalar(nChannel: UINT; fLevel:Single; pguidEventContext: PGuid): HRESULT; stdcall;
    function GetChannelVolumeLevel(nChannel: UINT; fLevelDB: Single): HRESULT; stdcall;
    function GetChannelVolumeLevelScalar(nChannel: UINT; fLevel: Single): HRESULT; stdcall;
    function SetMute(bMute: LongInt; pguidEventContext: PGuid): HRESULT; stdcall;
    function GetMute(var pbMute: LongInt): HRESULT; stdcall;
    function GetVolumeStepInfo(var pnStep: UINT; var pnStepCount: UINT): HRESULT; stdcall;
    function VolumeStepUp(pguidEventContext: PGuid): HRESULT; stdcall;
    function VolumeStepDown(pguidEventContext: PGuid): HRESULT; stdcall;
    function QueryHardwareSupport(var pdwHardwareSupportMask: UINT): HRESULT; stdcall;
    function GetVolumeRange(var pflVolumeMindB: Single; var pflVolumeMaxdB: Single;
                            var pflVolumeIncrementdB: Single): HRESULT; stdcall;
  end;

  IAudioMeterInformation = interface(IUnknown)
  ['{C02216F6-8C67-4B5B-9D00-D008E73E0064}']
    function GetPeakValue(out fPeak: Single): HRESULT; stdcall;
    function GetMeteringChannelCount(out nChannelCount: UINT): HRESULT; stdcall;
    function GetChannelsPeakValues(u32ChannelCount: UINT; pfPeakValues: pSingle): HRESULT; stdcall;
    function QueryHardwareSupport(out dwHardwareSupportMask: UINT): HRESULT; stdcall;
  end;

  IMMDevice = interface(IUnknown)
    ['{D666063F-1587-4E43-81F1-B948E807363F}']
    function Activate(const iid: TGUID; dwClsCtx: UINT; pActivationParams: PPropVariant; out ppInterface:IUnknown): HRESULT; stdcall;
    function OpenPropertyStore(stgmAccess: integer; out ppProperties: IPropertyStore): HRESULT; stdcall;  // ** Changed at 2011-08-09
    function GetId(out ppstrId: PWChar): HRESULT; stdcall;
    function GetState(var pdwState: Integer): HRESULT; stdcall;
  end;


  IMMDeviceCollection = interface(IUnknown)
    ['{0BD7A1BE-7A1A-44DB-8397-CC5392387B5E}']
    function GetCount(var pcDevices: UINT):HRESULT; stdcall;
    function Item(nDevice: UINT; out ppDevice: IMMDevice):HRESULT; stdcall;
  end;

 // IMMNotificationClient = interface(IUnknown)
 // ['{7991EEC9-7E89-4D85-8390-6C703CEC60C0}']
 // end;
  IMMNotificationClient = interface(IUnknown)
  ['{7991EEC9-7E89-4D85-8390-6C703CEC60C0}']
   function OnDeviceStateChanged(DeviceId: LPCWSTR; NewState: DWORD): HRESULT; stdcall;
   function OnOnDeviceAdded(DeviceId: LPCWSTR): HRESULT; stdcall;
   function OnDeviceRemoved(DeviceId: LPCWSTR): HRESULT; stdcall;
   function OnDefaultDeviceChanged(Flow: EDataFlow; Role: ERole; NewDefaultDeviceId: LPCWSTR): HRESULT; stdcall;
   function OnPropertyValueChanged(DeviceId: LPCWSTR; const Key: PROPERTYKEY): HRESULT; stdcall;
  end;

  IMMDeviceEnumerator = interface(IUnknown)
    ['{A95664D2-9614-4F35-A746-DE8DB63617E6}']
    function EnumAudioEndpoints(dataFlow:EDataFlow; dwStateMask:DWORD; out ppDevices: IMMDeviceCollection): HRESULT; stdcall;
    function GetDefaultAudioEndpoint(dataFlow:EDataFlow; role: ERole; out ppEndpoint: IMMDevice): HRESULT; stdcall;
    function GetDevice(pwstrId: PWChar;out ppDevice:IMMDevice): HRESULT; stdcall;
    function RegisterEndpointNotificationCallback(var pClient: IMMNotificationClient): HRESULT; stdcall;
    function UnregisterEndpointNotificationCallback(var pClient: IMMNotificationClient): HRESULT; stdcall;
  end;

  IAudioClient = interface(IUnknown)
  ['{1CB9AD4C-DBFA-4c32-B178-C2F568A703B2}']
   function Initialize(ShareMode: AUDCLNT_SHAREMODE; StreamFlags: DWORD; hmsBufferDuration: REFERENCE_TIME;
    hmsPeriodicity: REFERENCE_TIME; pFormat: PWAVEFORMATEX; AudioSessionGuid: pGuid): HRESULT; stdcall;
   function GetBufferSize(out NumBufferFrames: UINT32): HRESULT; stdcall;
   function GetStreamLatency(out hmsLatency: REFERENCE_TIME): HRESULT; stdcall;
   function GetCurrentPadding(out NumPaddingFrames: UINT32): HRESULT; stdcall;
   function IsFormatSupported(ShareMode: DWORD; pFormat: PWAVEFORMATEX; out pClosestMatch: PWAVEFORMATEX): HRESULT; stdcall;
   function GetMixFormat(out pFormat: PWAVEFORMATEX): HRESULT; stdcall;
   function GetDevicePeriod(out hmsDefaultDevicePeriod, hmsMinimumDevicePeriod: REFERENCE_TIME): HRESULT; stdcall;
   function Start: HRESULT; stdcall;
   function Stop: HRESULT; stdcall;
   function Reset: HRESULT; stdcall;
   function SetEventHandle(eventHandle: HWND): HRESULT; stdcall;
   function GetService(const iid: TGUID; out ppInterface:IUnknown): HRESULT; stdcall;
  end;

  IAudioSessionEvents = interface(IUnknown)
  ['{24918ACC-64B3-37C1-8CA9-74A66E9957A8}']
   function OnDisplayNameChanged(NewDisplayName: LPCWSTR; EventContext: pGuid): HResult; stdcall;
   function OnIconPathChanged(NewIconPath: LPCWSTR; EventContext: pGuid): HResult; stdcall;
   function OnSimpleVolumeChanged(NewVolume: Single; NewMute: LongBool; EventContext: pGuid): HResult; stdcall;
   function OnChannelVolumeChanged(ChannelCount: uint; NewChannelArray: PSingle; ChangedChannel: uint;
    EventContext: pGuid): HResult; stdcall;
   function OnGroupingParamChanged(NewGroupingParam, EventContext: pGuid): HResult; stdcall;
   function OnStateChanged(NewState: uint): HResult; stdcall; // AudioSessionState
   function OnSessionDisconnected(DisconnectReason: uint): HResult; stdcall; // AudioSessionDisconnectReason
  end;

  IAudioSessionControl = interface(IUnknown)
  ['{F4B1A599-7266-4319-A8CA-E70ACB11E8CD}']
   function GetState(out pRetVal: uint): HResult; stdcall;
   function GetDisplayName(out pRetVal: LPWSTR): HResult; stdcall; // pRetVal must be freed by CoTaskMemFree
   function SetDisplayName(Value: LPCWSTR; EventContext: pGuid): HResult; stdcall;
   function GetIconPath(out pRetVal: LPWSTR): HResult; stdcall; // pRetVal must be freed by CoTaskMemFree
   function SetIconPath(Value: LPCWSTR; EventContext: pGuid): HResult; stdcall;
   function GetGroupingParam(pRetVal: pGuid): HResult; stdcall;
   function SetGroupingParam(OverrideValue, EventContext: pGuid): HResult; stdcall;
   function RegisterAudioSessionNotification(const NewNotifications: IAudioSessionEvents): HResult; stdcall;
   function UnregisterAudioSessionNotification(const NewNotifications: IAudioSessionEvents): HResult; stdcall;
  end;

  ISimpleAudioVolume = interface(IUnknown)
  ['{87CE5498-68D6-44E5-9215-6DA47EF883D8}']
   function SetMasterVolume(fLevel: Single; EventContext: pGuid): HResult; stdcall;
   function GetMasterVolume(out fLevel: Single): HResult; stdcall;
   function SetMute(bMute: LongBool; EventContext: pGuid): HResult; stdcall;
   function GetMute(out bMute: LongBool): HResult; stdcall;
  end;

  IAudioSessionManager = interface(IUnknown)
  ['{BFA971F1-4D5E-40BB-935E-967039BFBEE4}']
   function GetAudioSessionControl(AudioSessionGuid: pGUID; CrossProcessSession: LongBool;
    out SessionControl: IAudioSessionControl): HResult; stdcall;
   function GetSimpleAudioVolume(AudioSessionGuid: pGuid; StreamFlag: uint;
    out AudioVolume: ISimpleAudioVolume): HResult; stdcall;
  end;

  IAudioCaptureClient = interface(IUnknown)
  ['{C8ADBD64-E71E-48a0-A4DE-185C395CD317}']
   function GetBuffer(out pData: PBYTE; out NumFramesToRead: UINT32; out dwFlags: DWORD;
    pu64DevicePosition: PUINT64; pu64QPCPosition: PUINT64): HResult; stdcall;
   function ReleaseBuffer(NumFramesRead: UINT32): HResult; stdcall;
   function GetNextPacketSize(out NumFramesInNextPacket: UINT32): HResult; stdcall;
  end;

  IAudioRenderClient = interface(IUnknown)
  ['{F294ACFC-3146-4483-A7BF-ADDCA7C260E2}']
   function GetBuffer(NumFramesRequested: UINT32; out pData: pByte): HResult; stdcall;
   function ReleaseBuffer(NumFramesWritten: UINT32; dwFlags: DWORD): HResult; stdcall;
  end;

  //IPropertyStore = interface(IUnknown)
  //end;
implementation

end.
