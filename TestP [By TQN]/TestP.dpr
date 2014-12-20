library TestP;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Windows, Messages, Plugin2, CommCtrl;

{$R *.res}

var
  hwndClient: HWND;

function MDIClientProc(hWnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM; uId: UINT_PTR; dwRefData: DWORD_PTR): LRESULT; stdcall;
begin
  Result := DefSubclassProc(hWnd, uMsg, wParam, lParam);
  if (uMsg = WM_MDIACTIVATE) then
    ShowWindow(wParam, SW_SHOWMAXIMIZED)
  else if (uMsg = WM_MDIGETACTIVE) and (PBOOL(lParam)^ <> True) then
    PostMessage(hwndClient, WM_MDIMAXIMIZE, Result, 0);
end;

function ODBG2_Pluginquery(ollydbgversion: LongInt; features: PULong; pluginname, pluginversion: PWChar): LongInt; cdecl;
begin
  if (ollydbgversion < 201) then
    Result := 0
  else
  begin
    lstrcpy(pluginname, 'Test');
    lstrcpy(pluginversion, '0.1');
    Result := PLUGIN_VERSION;
  end;
end;

function ODBG2_Plugininit: Integer; cdecl;
begin
  hwndclient := hwclient^;
  SetWindowSubclass(hwndClient, MDIClientProc, 0, 0);
  Result := 0;
end;

var
  icc: TInitCommonControlsEx;

exports
  ODBG2_Pluginquery,
  ODBG2_Plugininit;

begin
  InitCommonControlsEx(icc);
end.

