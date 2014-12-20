Library OD2DelphiPlugin;

uses
  Windows, plugin2;
  
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}

var
  SaveDLLProc: TDLLProc;
  //SelfIns:     Cardinal;

  function MP_MainMenu(table:P_table;text:PWChar;index:ULong;mode:LongInt): LongInt; cdecl; forward;
  function MP_DisasmMenu(table:P_table;text:PWChar;index:ULong;mode:LongInt): LongInt; cdecl; forward;

const
  PLUGIN_NAME: PWChar = 'OD2-Delphi-Plugin';
  PLUGIN_VERS: PWChar = '201.02';
  PLUGIN_AUTH: PWChar = 'quygia128';
  PLUGIN_SITE: PWChar = 'http://cin1team.biz';
  PLUGIN_BLOG: PWChar = 'http://crackertool.blogspot.com';
  PLUGIN_DATE: PWChar = '04.23.2014';

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// Plugin Menu ///////////////////////////////
MainMenu:array[0..2] of t_menu=(
  (Name:'Options';help: 'Open Options';shortcutid: 0;menufunc: MP_MainMenu;submenu: nil;menuType: (index: 1)),
  (Name:'|About..';help: 'About Plugin';shortcutid: 0;menufunc: MP_MainMenu;submenu: nil;menuType: (index: 2)),
  ()
  );

SubDisasmMenu1:array[0..2] of t_menu=(
  (Name:'Notepad';help: 'Run Notepad';shortcutid: 0;menufunc: MP_DisasmMenu;submenu: nil;menuType: (index: 1)),
  (Name:'|Calculator';help: 'Run Calculator';shortcutid: 0;menufunc: MP_DisasmMenu;submenu: nil;menuType: (index: 2)),
  ()
  );

SubDisasmMenu2:array[0..2] of t_menu=(
  (Name:'Your code 1';help: nil;shortcutid: 0;menufunc: MP_DisasmMenu;submenu: nil;menuType: (index: 3)),
  (Name:'|Your code 2';help: nil;shortcutid: 0;menufunc: MP_DisasmMenu;submenu: nil;menuType: (index: 4)),
  ()
  );

DisasmMenu:array[0..2] of t_menu=(
  (Name:'Tools';help: nil;shortcutid:  0;menufunc: nil;submenu: @SubDisasmMenu1;menuType: (hsubmenu: 0)),
  (Name:'Your Code';help: nil;shortcutid: 0;menufunc: nil;submenu: @SubDisasmMenu2;menuType: (hsubmenu: 1)),
  ()
  );
////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// Plugin Menu ///////////////////////////////


//////////////////////////////////// MainMenu //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function MP_MainMenu(table:P_table;text:PWChar;index:ULong;mode:LongInt): LongInt;
var
  szInfo:array[0..TEXTLEN*2-1] of WCHAR;
  n: LongInt;
Begin

  case mode of
    MENU_VERIFY: begin
      Result:= MENU_NORMAL;
      if index in[1..2] then begin
        //Result:= MENU_SHORTCUT;
      end;
      case index of
        3: begin
          //Result:= MENU_ABSENT;
        end;
      end;
    end;
    MENU_EXECUTE: begin
      Result:= MENU_NOREDRAW;
      case index of
        1: begin
          MessageBoxW(plugin2.hwollymain^,'Hello, This is plugin options','Option',MB_OK);
        end;
        2: begin
          Suspendallthreads;
          FillChar(szInfo,SizeOf(szInfo),#0);
          Swprintf(szInfo,'%s v%s'#10#10, PLUGIN_NAME, PLUGIN_VERS);
          n:= StrlenW(szInfo,TEXTLEN);
          Swprintf(szInfo+n,'Coded by %s'#10'Home: %s'#10#10,PLUGIN_AUTH, PLUGIN_SITE);
          n:= StrlenW(szInfo,TEXTLEN);
          Swprintf(szInfo+n,'Special thanks to TQN ~ phpbb3 ~ BOB'#10#10);
          MessageBoxW(plugin2.hwollymain^,szInfo,'About',MB_OK);
          Resumeallthreads;
        end;
      end;
    end;
  else
    Result:= 0;
  end;
End;
/////////////////////////////////// DisasmMenu /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function MP_DisasmMenu(table:P_table;text:PWChar;index:ULong;mode:LongInt): LongInt;
var
  runStatus: p_run;
  flag3: LongInt;
Begin
  case mode of
    MENU_VERIFY: begin
      Result:= MENU_NORMAL;
      if index in[1..2] then begin
        //Result:= MENU_SHORTCUT;
      end;
      case index of
        3: begin
          Getfromini(nil,'OD2DelphiPlugin','YC3','%i',@flag3);
          if flag3 = 1 then Result:= MENU_CHECKED;
        end;
      end;
    end;
    MENU_EXECUTE: begin
      Result:= MENU_NOREDRAW;
      case index of
        1: begin
          runStatus:= @plugin2._run^;
          if runStatus.status <> STAT_IDLE then
            WinExec('notepad.exe',SW_SHOWNORMAL)
          else MessageBoxW(plugin2.hwollymain^,'Load a process for use this funtion','Warning',MB_ICONWARNING);
        end;
        2: begin
          WinExec('calc.exe',SW_SHOWNORMAL);
        end;
        3: begin
          // Your code
          Writetoini(nil,'OD2DelphiPlugin','YC3','%i',1);
        end;
        4:begin
          // Your code
          Writetoini(nil,'OD2DelphiPlugin','YC3','%i',0);
        end;
        5:begin
          // Not yet
        end;
      end;
    end; 
  else
    Result:= 0;
  end;
End;

// ODBG_Pluginquery() is a "must" for valid OllyDbg plugin. First it must check
// whether given OllyDbg version is correctly supported, and return 0 if not.
// Then it should make one-time initializations and allocate resources. On
// error, it must clean up and return 0. On success, if should fill plugin name
// and plugin version (as UNICODE strings) and return version of expected
// plugin interface. If OllyDbg decides that this plugin is not compatible, it
// will call ODBG2_Plugindestroy() and unload plugin. Plugin name identifies it
// in the Plugins menu. This name is max. 31 alphanumerical UNICODE characters
// or spaces + terminating L'\0' long. To keep life easy for users, this name
// should be descriptive and correlate with the name of DLL. This function
// replaces ODBG_Plugindata() and ODBG_Plugininit() from the version 1.xx.
function  ODBG2_Pluginquery(ollydbgversion: LongInt;features: PULong;pluginname,pluginversion: PWChar): LongInt; cdecl;
Begin
  if (ollydbgversion < 201) then Result:= 0
  else begin
    StrcopyW(pluginname,SHORTNAME,PLUGIN_NAME);
    StrcopyW(pluginversion,SHORTNAME,PLUGIN_VERS);
    Result:= PLUGIN_VERSION;
  end;
End;

// Optional entry, called immediately after ODBG2_Plugininit(). Plugin should
// make one-time initializations and allocate resources. On error, it must
// clean up and return -1. On success, it must return 0.
function  ODBG2_Plugininit: LongInt; cdecl;
Begin
  Addtolist(0,1,'- %s v%s & PDK 4 Delphi by %s. Compiled Date: %s', PLUGIN_NAME, PLUGIN_VERS, PLUGIN_AUTH, PLUGIN_DATE);
  Addtolist(0,2,' - Home: %s',PLUGIN_SITE);
  Addtolist(0,2,' - Blog: %s',PLUGIN_BLOG);
  Addtolist(0,2,' - ');
  Result:= 0;
End;

////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// DUMP WINDOW HOOK ///////////////////////////////

// Dump windows display contents of memory or file as bytes, characters,
// integers, floats or disassembled commands. Plugins have the option to modify
// the contents of the dump windows. If ODBG2_Plugindump() is present and some
// dump window is being redrawn, this function is called first with column=
// DF_FILLCACHE, addr set to the address of the first visible element in the
// dump window and n to the estimated total size of the data displayed in the
// window (n may be significantly higher than real data size for disassembly).
// If plugin returns 0, there are no elements that will be modified by plugin
// and it will receive no other calls. If necessary, plugin may cache some data
// necessary later. OllyDbg guarantees that there are no calls to
// ODBG2_Plugindump() from other dump windows till the final call with
// DF_FREECACHE.
// When OllyDbg draws table, there is one call for each table cell (line/column
// pair). Parameters s (UNICODE), mask (DRAW_xxx) and select (extended DRAW_xxx
// set) contain description of the generated contents of length n. Plugin may
// modify it and return corrected length, or just return the original length.
// When table is completed, ODBG2_Plugindump() receives final call with
// column=DF_FREECACHE. This is the time to free resources allocated on
// DF_FILLCACHE. Returned value is ignored.
// Use this feature only if absolutely necessary, because it may strongly
// impair the responsiveness of the OllyDbg. Always make it switchable with
// default set to OFF!
function  ODBG2_Plugindump(pd: P_dump;s: PWChar;mask: PWChar;n: LongInt;select: PInteger;addr: ULong;column: LongInt): LongInt; cdecl;
Begin
  Result:= 0;
  if (column= DF_FILLCACHE)then begin

    Result:= 0;
  end
  else
  if (column=TSC_MOUSE) then
  begin

  end
  else
  if (column=DF_FREECACHE)then
  begin
    // We have allocated no resources, so we have nothing to do here.
  end;
End;

function  ODBG2_Pluginmenu(WdType: PWChar): P_Menu; cdecl;
Begin
   Result:= nil;
   if (lstrcmpW(WdType,PWM_MAIN) = 0) then Result:= @MainMenu
   else if (lstrcmpW(WdType,PWM_DISASM) = 0) then Result:= @DisasmMenu;
End;

// OllyDbg calls this optional function when user wants to terminate OllyDbg.
// All MDI windows created by plugins still exist. Function must return 0 if
// it is safe to terminate. Any non-zero return will stop closing sequence. Do
// not misuse this possibility! Always inform user about the reasons why
// termination is not good and ask for his decision! Attention, don't make any
// unrecoverable actions for the case that some other plugin will decide that
// OllyDbg should continue running.
function ODBG2_Pluginclose:LongInt cdecl;
Begin
  // For automatical restoring of open windows, mark in .ini file whether
  // Bookmarks window is still open.
  Result:= 0;
End;

// OllyDbg calls this optional function once on exit. At this moment, all MDI
// windows created by plugin are already destroyed (and received WM_DESTROY
// messages). Function must free all internally allocated resources, like
// window classes, files, memory etc.

exports
  ODBG2_Pluginquery name '_ODBG2_Pluginquery',
  ODBG2_Plugininit  name '_ODBG2_Plugininit',
  ODBG2_Pluginmenu  name '_ODBG2_Pluginmenu',
  //ODBG2_Plugindump  name '_ODBG2_Plugindump',
  ODBG2_Pluginclose name '_ODBG2_Pluginclose';

procedure DLLEntryPoint(dwReason: DWORD);
var
  szPluginName:array[0..TEXTLEN] of WCHAR;
Begin
  if (dwReason = DLL_PROCESS_DETACH) then
  begin
    // Uninitialize code here
    lstrcatW(szPluginName,PLUGIN_NAME);
    lstrcatW(szPluginName,' Unloaded By DLL_PROCESS_DETACH');
    OutputDebugStringW(szPluginName);
  end;
  // Call saved entry point procedure
  if Assigned(SaveDLLProc) then SaveDLLProc(dwReason);
End;

Begin
  //Initialize code here
  //SelfIns:= HInstance;
  SaveDLLProc:= @DLLProc;
  DLLProc:= @DLLEntryPoint;
End.

