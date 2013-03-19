unit PropSys2;

interface

uses Windows, ActiveX, ComObj;

type

   IInitializeWithFile = interface(IUnknown)
   ['{b7d14566-0509-4cce-a71f-0a554233bd9b}']
     function Initialize(pszFilePath: PAnsiChar; grfMode: DWORD):HRESULT; stdcall;
   end;


   IInitializeWithStream = interface(IUnknown)
   ['{b824b49d-22ac-4161-ac8a-9916e8fa3f7f}']
     function Initialize(var pIStream: IStream; grfMode: DWORD):HRESULT; stdcall;
   end;

   //_tagpropertykey = packed record
   //  fmtid: TGUID;
   //  pid: DWORD;
   //end;
   PROPERTYKEY = _tagpropertykey;
   PPropertyKey = ^TPropertyKey;
   TPropertyKey = _tagpropertykey;

   //IPropertyStore = interface(IUnknown)
   //  ['{886d8eeb-8cf2-4446-8d02-cdba1dbdcf99}']
   //  function GetCount(out cProps: DWORD): HResult; stdcall;
   //  function GetAt(iProp: DWORD; out pkey: TPropertyKey): HResult; stdcall;
   //  function GetValue(const key: TPropertyKey; out pv: TPropVariant):HResult; stdcall;
   //  function SetValue(const key: TPropertyKey; const propvar:TPropVariant): HResult; stdcall;
   //  function PropVariantToString(propvar: TPropVariant; out psz: PWideChar; cch: UINT): HResult; stdcall;
   //  function Commit: HResult; stdcall;
   //end;

   IPropertyStoreCapabilities = interface(IUnknown)
   ['{c8e2d566-186e-4d49-bf41-6909ead56acc}']
     function IsPropertyWritable(pPropKey: PPropertyKey): HRESULT; stdcall;
   end;

const
   PKEY_Device_FriendlyName: TPropertyKey = (
                fmtid: (D1:$a45c254e; D2:$df1c ; D3:$4efd;
                D4: ($80, $20, $67, $d1, $46, $a8, $50, $e0));
                pid: 14);

procedure PropVariantInit(var pv : TPropVariant);

implementation

procedure PropVariantInit(var pv : TPropVariant);
begin
  pv.vt := VT_EMPTY;
end;

end.
