unit inistuff;

{$MODE Delphi}{$H+}

interface

uses
  dialogs, windows, Graphics, inifiles, Classes, SysUtils, Controls, plugins, hotkey;

procedure IniSaveAllSettings;
procedure IniLoadAllSettings;

//type

//GlobaleVariablen für die Settings:
var
  //Tray:
  Minimze2Tray,AllwaysShowTrayIcon:boolean;
  //Other Stuff:
  Check4Update,SaveLog,ShowDJPic:boolean;
  //Refresh:
  AutomaticRefresh:boolean;
  RefreshTime:integer;
  //PreRecord:
  AktivatePreRecord:boolean;
  PreRecordTime:integer;
  //Hotkey:
  AktivateHotkeys:boolean;
  KeyNumbers:Array[1..3,1..2] of word;
  //Skin:
  skinanzahl,skinaktive:integer;
  skinfolders: array of string;
  GFontColor,GBackgroundColor:TCOLOR;
  //Record:
  default_location:string;

  //Release/DJProfil-URL:
  global_releaseurl,global_djprofilurl:string;

implementation
  uses main,unit2;

var Hotkey1text,Hotkey2text,Hotkey3text:string;

procedure IniSaveAllSettings;
var ini: TIniFile;
    text,temp1,temp2:string;
begin
  ini:=TIniFile.create(ExtractFilePath(ParamStr(0))+'settings.ini');

  //Allgemeines abspeichern:

  //Tray:
  ini.WriteBool('TBsettings','CBMinimze2Tray',Form2.CBMinimize2Tray.Checked);
  ini.WriteBool('TBsettings','CBAllwaysShowTrayIcon',Form2.CBAllwaysShowTrayIcon.Checked);

  //Other Stuff:
  ini.WriteBool('TBsettings','CBCheck4Update',Form2.CBCheck4Update.Checked);
  ini.WriteBool('TBsettings','CBSaveLog',Form2.CBSaveLog.Checked);
  ini.WriteBool('TBsettings','CBShowDJPic',Form2.CBShowDJPic.Checked);
  //Refresh:
  ini.WriteBool('TBsettings','CBAutomaticRefresh',Form2.CBAutomaticRefresh.Checked);
  ini.WriteInteger('TBsettings','SERefreshTime',Form2.SERefreshTime.Value);

  //PreRecord:
  ini.WriteBool('TBsettings','CBAktivatePreRecord',Form2.CBAktivatePreRecord.Checked);
  ini.WriteInteger('TBsettings','SEPreRecordTime',Form2.SEPreRecordTime.Value);

  //Hotkeys abspeichern:

  //EditHotkeys:
  case Hotkey1.Hotkeyp1 of
    0:           temp1:='XXX';
    MOD_SHIFT:   temp1:='SHIFT';
    MOD_CONTROL: temp1:='STRG';
    MOD_ALT:     temp1:='ALT';
  end;
  temp2:=inttostr(Hotkey1.Hotkeyp2);
  ini.WriteString('TBsettings','EHPlayStop',temp1+' + '+temp2);

  case Hotkey1.Hotkeyp1 of
    0:           temp1:='XXX';
    MOD_SHIFT:   temp1:='SHIFT';
    MOD_CONTROL: temp1:='STRG';
    MOD_ALT:     temp1:='ALT';
  end;
  temp2:=inttostr(Hotkey2.Hotkeyp2);
  ini.WriteString('TBsettings','EHVolumep',temp1+' + '+temp2);

  case Hotkey1.Hotkeyp1 of
    0:           temp1:='XXX';
    MOD_SHIFT:   temp1:='SHIFT';
    MOD_CONTROL: temp1:='STRG';
    MOD_ALT:     temp1:='ALT';
  end;
  temp2:=inttostr(Hotkey3.Hotkeyp2);
  ini.WriteString('TBsettings','EHVolumem',temp1+' + '+temp2);

  ini.WriteBool('TBsettings','CBAktivateHotkeys',form2.CBAktivateHotkeys.checked);

  //Save Selected Skin:
  if Form2.LBSkin.ItemIndex<>-1 then ini.WriteInteger('TBsettings','LBSkin',Form2.LBSkin.ItemIndex)
    else ini.WriteInteger('TBsettings','LBSkin',0);

  //Speichere ausgesuchten Stream:
  ini.WriteInteger('TBsettings','CBSender',Form1.CBSender.itemindex);
  ini.WriteInteger('TBsettings','CBStream',Form1.CBStream.itemindex);

  //Standart Record SpeicherOrt:
  ini.WriteString('TBsettings','Record_Loc',default_location);

  ini.free;
end;

procedure IniLoadSkin;
var skinini: TIniFile;
    lauf:integer;
begin
  skinini:=TIniFile.create(ExtractFilePath(ParamStr(0))+'Files\skins.ini');
  try
    skinanzahl:=skinini.ReadInteger('Skins','NumberOfSkins',1);
    setlength(skinfolders,skinanzahl);
    for lauf:=1 to skinanzahl do begin
      if lauf<=10 then begin
        skinfolders[lauf-1]:=skinini.readstring('Skins',('Skin0'+inttostr(lauf-1)),'');
      end else begin
        skinfolders[lauf-1]:=skinini.readstring('Skins',('Skin'+inttostr(lauf-1)),'');
      end;
    end;
  finally
    skinini.free;
  end;

  for lauf:=1 to skinanzahl do begin
    form2.LBSkin.Items.Add(skinfolders[lauf-1]);
  end;

  skinini:=TIniFile.create(ExtractFilePath(ParamStr(0))+'Files\'+skinfolders[skinaktive]+'\skin.ini');

  GBackgroundColor:=skinini.ReadInteger('Skin','backcolor',$00F2E1BD);
  GFontColor:=skinini.ReadInteger('Skin','fontcolor',$00000000);

  skinini.free;
end;

procedure SetHotkeys;
var key1text,key2text:string;
    key1,key2:word;
begin

  //Hotkey1

  Hotkey1.SetHotkeyKeysManually(KeyNumbers[1,1],KeyNumbers[1,2]);

  //Hotkey2

  Hotkey2.SetHotkeyKeysManually(KeyNumbers[2,1],KeyNumbers[2,2]);

  //Hotkey3

  Hotkey3.SetHotkeyKeysManually(KeyNumbers[3,1],KeyNumbers[3,2]);

  //Hotkeys JETZT setzen:

  if Hotkey1.SetHotkey(Form1.Handle)=false then begin
    showmessage('Hotkey1 (Play/Stop) konnte nicht gesetzt werden.'+#10#13+'Villeicht bereits belegt ?');
  end else Form2.EHPlayStop.text:='omglol';


  if Hotkey2.SetHotkey(Form1.Handle)=false then begin
    showmessage('Hotkey2 (Volume + ) konnte nicht gesetzt werden.'+#10#13+'Villeicht bereits belegt ?');
  end else Form2.EHVolumep.text:='omglol';

  if Hotkey3.SetHotkey(Form1.Handle)=false then begin
    showmessage('Hotkey3 (Volume - ) konnte nicht gesetzt werden.'+#10#13+'Villeicht bereits belegt ?');
  end else Form2.ehvolumem.text:='omglol';

end;

procedure IniLoadAllSettings;
var ini: TIniFile;
    text,temp1,temp2,HotText:string;
begin
  ini:=TIniFile.create(ExtractFilePath(ParamStr(0))+'settings.ini');

  //showmessage(inttostr(Text_TO_Hotkey('P')));

  //Allgemeines lesen:
  default_location:='C:\';

  //Init RealeaseURL:
  global_releaseurl:='';

  //Init DJProfilURL:
  global_djprofilurl:='';

  //Tray:
  Minimze2Tray:=ini.ReadBool('TBsettings','CBMinimze2Tray',true);
  AllwaysShowTrayIcon:=ini.ReadBool('TBsettings','CBAllwaysShowTrayIcon',true);

  Form2.CBMinimize2Tray.Checked:=Minimze2Tray;
  Form2.CBAllwaysShowTrayIcon.Checked:=AllwaysShowTrayIcon;

  //Other Stuff:
  Check4Update:=ini.ReadBool('TBsettings','CBCheck4Update',true);
  SaveLog:=ini.ReadBool('TBsettings','CBSaveLog',true);
  ShowDJPic:=ini.ReadBool('TBsettings','CBShowDJPic',true);

  Form2.CBCheck4Update.Checked:=Check4Update;
  Form2.CBSaveLog.Checked:=SaveLog;
  Form2.CBShowDJPic.Checked:=ShowDJPic;

  //DJPIC-Einstellungen:
  if ShowDJPic=true then begin

  end else begin
    Form1.IDJPic.left:=-150;

    //Form1.BorderStyle:=bsSizeable;
    Form1.Width:=414;

    Form1.label2.left:=Form1.label2.left-100;
    Form1.label4.left:=Form1.label4.left-100;
    Form1.label7.left:=Form1.label7.left-100;

    //Form1.BorderStyle:=bsSingle;
  end;

  //Refresh:
  AutomaticRefresh:=ini.ReadBool('TBsettings','CBAutomaticRefresh',true);
  RefreshTime:=ini.ReadInteger('TBsettings','SERefreshTime',15);

  Form2.CBAutomaticRefresh.Checked:=AutomaticRefresh;
  Form2.SERefreshTime.Value:=RefreshTime;

  //PreRecord:
  AktivatePreRecord:=ini.ReadBool('TBsettings','CBAktivatePreRecord',true);
  PreRecordTime:=ini.ReadInteger('TBsettings','SEPreRecordTime',180);

  Form2.CBAktivatePreRecord.Checked:=AktivatePreRecord;
  Form2.SEPreRecordTime.Value:=PreRecordTime;

  //Hotkeys lesen:

  //EditHotkeys:
  Hotkey1text:=ini.ReadString('TBsettings','EHPlayStop','STRG + 80');
  temp1:=copy(Hotkey1text,1,pos('+',Hotkey1text)-2);
  temp2:=copy(Hotkey1text,pos('+',Hotkey1text)+2,length(Hotkey1text));
  KeyNumbers[1,2]:=strtoint(temp2);
  HotText:=Hotkey_TO_Text(strtoint(temp2))+chr(0);
  if temp1='SHIFT' then KeyNumbers[1,1]:=MOD_SHIFT;
  if temp1='STRG' then KeyNumbers[1,1]:=MOD_CONTROL;
  if temp1='ALT' then KeyNumbers[1,1]:=MOD_ALT;
  if temp1='XXX' then KeyNumbers[1,1]:=0;
  //if temp1='XXX' then Hotkey1.SetEditText:=HotText else Hotkey1.SetEditText:=temp1+' + '+HotText;

  Hotkey2text:=ini.ReadString('TBsettings','EHVolumep','STRG + 85');
  temp1:=copy(Hotkey2text,1,pos('+',Hotkey2text)-2);
  temp2:=copy(Hotkey2text,pos('+',Hotkey2text)+2,length(Hotkey2text));
  KeyNumbers[2,2]:=strtoint(temp2);
  temp2:=Hotkey_TO_Text(strtoint(temp2));
  if temp1='SHIFT' then KeyNumbers[2,1]:=MOD_SHIFT;
  if temp1='STRG' then KeyNumbers[2,1]:=MOD_CONTROL;
  if temp1='ALT' then KeyNumbers[2,1]:=MOD_ALT;
  if temp1='XXX' then KeyNumbers[2,1]:=0;
  //if temp1='XXX' then Hotkey2.SetEditText(HotText) else Hotkey2.SetEditText(temp1+' + '+HotText);

  Hotkey3text:=ini.ReadString('TBsettings','EHVolumem','STRG + 74');
  temp1:=copy(Hotkey3text,1,pos('+',Hotkey3text)-2);
  temp2:=copy(Hotkey3text,pos('+',Hotkey3text)+2,length(Hotkey3text));
  KeyNumbers[3,2]:=strtoint(temp2);
  temp2:=Hotkey_TO_Text(strtoint(temp2));
  if temp1='SHIFT' then KeyNumbers[3,1]:=MOD_SHIFT;
  if temp1='STRG' then KeyNumbers[3,1]:=MOD_CONTROL;
  if temp1='ALT' then KeyNumbers[3,1]:=MOD_ALT;
  if temp1='XXX' then KeyNumbers[3,1]:=0;
  //if temp1='XXX' then Hotkey3.SetEditText(HotText) else Hotkey3.SetEditText(temp1+' + '+HotText);

  AktivateHotkeys:=ini.ReadBool('TBsettings','CBAktivateHotkeys',true);
  form2.CBAktivateHotkeys.Checked:=AktivateHotkeys;

  //Read Selected Skin:
  skinaktive:=ini.ReadInteger('TBsettings','LBSkin',0);

  //Lade lister der verfügbaren Skins:
  IniLoadSkin;
  Form2.LBSkin.ItemIndex:=skinaktive;

  //Lade ausgesuchten Stream:
  Form1.CBSender.itemindex:=ini.ReadInteger('TBsettings','CBSender',0);
  Form1.CBStream.itemindex:=ini.ReadInteger('TBsettings','CBStream',0);

  //Standart Record SpeicherOrt:
  default_location:=ini.ReadString('TBsettings','Record_Loc','C:\');
  Form1.RecordSD.InitialDir:=default_location;

  ini.free;

  //SetHotkeys:
  if AktivateHotkeys=true then begin
    SetHotkeys;
  end;

  //Change the Skin:
  SkinChange;

  //Initialisierungen die durch die Settings bestimmt sind:

  //Tray Icon anzeigen:
  if AllwaysShowTrayIcon=true then begin
    Form1.TrayIcon1.Show;
  end;

  //Wenn gewüncht, nach update schauen:
  if (Check4Update=true) then updateup('');

  //Timer aktivieren:
  if AutomaticRefresh=true then begin
    Form1.Timer1.interval:=RefreshTime*1000;
    Form1.Timer1.Enabled:=true;
    RefreshDJSongListener;
  end;

  //PluginStuff:
  LoadAllPlugins();

  restart_need:=false;
end;

end.

