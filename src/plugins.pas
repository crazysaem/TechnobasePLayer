unit Plugins;

{$MODE Delphi}{$H+}

interface

uses
  Classes, SysUtils, dialogs, Controls, windows, menus, inifiles;

function LoadAllPlugins():boolean;
function UnLoadAllPlugins():boolean;

type
  PMenuItem=^TMenuItem;
  TInitialisierung=function():boolean; stdcall;
  TGive_TBPack=procedure(djname,songname,zuhorer,djpicurl:string); stdcall;
  TAufruf=function():boolean; stdcall;
  TEnde=function():boolean; stdcall;
  TGetName=function():string; stdcall;

  TFunctionPack = record
    Initialisierung:TInitialisierung;
    Give_TBPack:TGive_TBPack;
    Aufruf:TAufruf;
    Ende:TEnde;
    GetName:TGetName;
  end;

var
  FunctionPack:array of TFunctionPack;
  DLLhandle:array of Thandle;
  pluginanzahl:integer;
  pluginsloaded:boolean;

implementation

uses main;
(*
procedure PopUpClick(Sender: TMenuItem);
begin
  with (Sender as TMenuItem) do
    showmessage(inttostr(tag));
end;*)

function LoadAllPlugins():boolean;
var pluginini: TIniFile;
    lauf:integer;
    pluginnames,PopUpNames:array of string;
    loadplugin:string;
    Items:array of TMenuItem;
begin
  pluginini:=TIniFile.create(ExtractFilePath(ParamStr(0))+'Plugins\plugins.ini');

  try
    pluginanzahl:=pluginini.ReadInteger('Plugins','NumberOfPlugins',0);
    if pluginanzahl=0 then begin
      result:=false;
      pluginsloaded:=false;
      exit;
    end;
    setlength(DLLhandle,pluginanzahl);
    setlength(FunctionPack,pluginanzahl);
    setlength(pluginnames,pluginanzahl);
    setlength(Items,pluginanzahl);
    setlength(PopUpNames,pluginanzahl);
    for lauf:=1 to pluginanzahl do begin
      if lauf<=10 then begin
        pluginnames[lauf-1]:=pluginini.readstring('Plugins',('Plugin0'+inttostr(lauf-1)),'');
      end else begin
        pluginnames[lauf-1]:=pluginini.readstring('Plugins',('Plugin'+inttostr(lauf-1)),'');
      end;
    end;
    for lauf:=1 to pluginanzahl do begin
      loadplugin:='Plugins\'+pluginnames[lauf-1]+'.dll';
      DLLhandle[lauf-1]:=LoadLibrary(PChar(loadplugin));
    end;
  finally
    pluginini.free;
  end;

  for lauf:=1 to pluginanzahl do begin

    if DLLhandle[lauf-1]=0 then begin
      //Fehler!
      showmessage(pluginnames[lauf-1]+'.dll konnte nicht geladen werden');
    end else begin
      FunctionPack[lauf-1].Initialisierung:=GetProcAddress(DLLhandle[lauf-1],'Initialisierung');
      If @FunctionPack[lauf-1].Initialisierung <> nil then FunctionPack[lauf-1].Initialisierung()
      else showmessage('Fehler : PluginFunktion nicht gefunden');

      FunctionPack[lauf-1].Give_TBPack:=GetProcAddress(DLLhandle[lauf-1],'Give_TBPack');
      If @FunctionPack[lauf-1].Give_TBPack = nil then
        showmessage('Fehler : PluginFunktion nicht gefunden');

      FunctionPack[lauf-1].Aufruf:=GetProcAddress(DLLhandle[lauf-1],'Aufruf');
      If @FunctionPack[lauf-1].Aufruf = nil then
        showmessage('Fehler : PluginFunktion nicht gefunden');

      FunctionPack[lauf-1].Ende:=GetProcAddress(DLLhandle[lauf-1],'Ende');
      If @FunctionPack[lauf-1].Ende = nil then
        showmessage('Fehler : PluginFunktion nicht gefunden');

      FunctionPack[lauf-1].GetName:=GetProcAddress(DLLhandle[lauf-1],'GetName');
      If @FunctionPack[lauf-1].GetName = nil then
        showmessage('Fehler : PluginFunktion nicht gefunden') else begin
        PopUpNames[lauf-1]:=FunctionPack[lauf-1].GetName;
      end;

      Items[lauf-1]:=TMenuItem.Create(nil);
      Items[lauf-1].Caption:=PopUpNames[lauf-1];
      //Items[lauf-1].OnClick:=FunctionPack[lauf-1].Aufruf;
      Items[lauf-1].Tag:=lauf;
      MakeOnClickPossible(@Items[lauf-1],lauf);

      Form1.PopupMenu2.Items.Add(Items[lauf-1]);

      //FreeLibrary(DLLhandle[0]);
    end;

  end;

  result:=true;
  pluginsloaded:=true;

  //Form1.PopupMenu2.Items.Add(MenuItems[0]);
end;

function UnLoadAllPlugins():boolean;
var lauf:integer;
begin
  if (pluginsloaded=false) or (pluginanzahl=-1) then exit;
  exit;
  for lauf:=1 to pluginanzahl do begin
    FunctionPack[lauf-1].Ende;
    FreeLibrary(DLLhandle[lauf-1]);
  end;
end;

end.

