unit Unit2;

{$MODE Delphi}

interface

uses
  LCLIntf, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Spin, ExtCtrls, LResources, inifiles,
  inistuff, LCLType;

procedure tttimer(enabletimer:boolean);
procedure SkinChange;

type

  { TForm2 }

  TForm2 = class(TForm)
    CBAktivatePreRecord: TCheckBox;
    CBShowDJPic: TCheckBox;
    CBAktivateHotkeys: TCheckBox;
    EHVolumep: TEdit;
    EHVolumem: TEdit;
    EHPlayStop: TEdit;
    GroupBox4: TGroupBox;
    HotkeyIB: TImage;
    Label1: TLabel;
    PageControl1: TPageControl;
    SEPreRecordTime: TSpinEdit;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    CBMinimize2Tray: TCheckBox;
    GroupBox2: TGroupBox;
    CBAutomaticRefresh: TCheckBox;
    Label13: TLabel;
    GroupBox3: TGroupBox;
    CBAllwaysShowTrayIcon: TCheckBox;
    CBCheck4Update: TCheckBox;
    TabSheet3: TTabSheet;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    TabSheet2: TTabSheet;
    LBSkin: TListBox;
    Label2: TLabel;
    CBSaveLog: TCheckBox;
    SERefreshTime: TSpinEdit;
    procedure BAbbrechenClick(Sender: TObject);
    procedure CBAktivateHotkeysChange(Sender: TObject);
    procedure CBAktivatePreRecordChange(Sender: TObject);
    procedure CBAllwaysShowTrayIconChange(Sender: TObject);
    procedure CBAutomaticRefreshChange(Sender: TObject);
    procedure CBCheck4UpdateChange(Sender: TObject);
    procedure CBMinimize2TrayChange(Sender: TObject);
    procedure CBSaveLogChange(Sender: TObject);
    procedure CBShowDJPicChange(Sender: TObject);
    procedure EHPlayStopChange(Sender: TObject);
    procedure EHPlayStopKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EHPlayStopKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EHVolumepChange(Sender: TObject);
    procedure EHVolumepKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EHVolumepKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EHVolumemChange(Sender: TObject);
    procedure EHVolumemKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EHVolumemKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure HotkeyIBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HotkeyIBMouseEnter(Sender: TObject);
    procedure HotkeyIBMouseLeave(Sender: TObject);
    procedure HotkeyIBMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LBSkinClick(Sender: TObject);
    procedure SEPreRecordTimeChange(Sender: TObject);
    procedure SERefreshTimeChange(Sender: TObject);
    procedure TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;
  aktl,f2start:boolean;
  bg,fon,pane:tcolor;
  HotKeyVar1,HotKeyVar2,HotKeyVar3,HotKeyVar4,HotKeyVar5: Cardinal;
  ttime,tchange:integer;
  restart_need:boolean;

implementation

uses main;

procedure TForm2.BAbbrechenClick(Sender: TObject);
begin
  Form2.Visible:=false;
end;

procedure pause(zeit: longint);
var zeit1: longint;
begin
  zeit1:= GetTickCount;
  repeat
    Application.ProcessMessages;
    sleep(1);
  until (GetTickCount - zeit1 > zeit)
end;

procedure TForm2.FormCreate(Sender: TObject);
var lauf:integer;
begin
  if endee=true then exit;
  bg:=-1;fon:=-1;pane:=-1;
  songname:='';

  ttime:=0;
  tchange:=-1;

  aktl:=false;f2start:=true;
  Form2.Constraints.MaxHeight:=Form2.Height;Form2.Constraints.MinHeight:=Form2.Height;
  Form2.Constraints.MaxWidth:=Form2.Width;Form2.Constraints.MinWidth:=Form2.Width;

  Form2.left:=trunc(-(Form2.Width/2)+(Screen.MonitorFromWindow(handle).Width/2));
  Form2.Top:=trunc(-(Form2.Height/2)+(Screen.MonitorFromWindow(handle).Height/2));

  restart_need:=false;

  f2start:=false;
end;

procedure tttimer(enabletimer:boolean);
var f:TextFile;
    datei,tstring1,tstring2,tstring3:string;
    time2,time3,lauf:integer;
begin
  {
  if (form2.checkbox3.Checked) and (start=false) then begin
  form2.timer1.Enabled:=false;

  //form1.PNGButton4Click(nil);

  if (form2.spinedit2.value < form2.spinedit2.MinValue) then form2.spinedit2.value:=form2.spinedit2.MinValue;
  form2.timer1.Interval:=form2.spinedit2.value*1000;
  if enabletimer=true then form2.timer1.Enabled:=true;

  if (record1=true) and (form2.checkbox2.Checked=true) then begin
    datei:=copy(location,0,length(location)-3)+'txt';
    AssignFile(f, datei);
    if Fileexists(datei) then Append(f) else ReWrite(f);
    //if songname2<>Form1.Label2.caption then begin

      time2:=(ttime div 60);
      time3:=(ttime mod 60);

      if length(inttostr(time2))=1 then tstring2:='0'+inttostr(time2) else begin
        if length(inttostr(time2))>=2 then tstring2:=inttostr(time2);
      end;

      if length(inttostr(time3))=1 then tstring3:='0'+inttostr(time3) else tstring3:=inttostr(time3);

      tstring1:=tstring2+':'+tstring3;

      if ttime=0 then begin
        Writeln(f, '//*Die Gegeben Zeiten sind/können nicht genau (sein). Sie dienen');
        Writeln(f, 'nur für eine grobe Orientierung beim Schneiden des rec-Files*//');
        Writeln(f, '(*Zeit kann bis zu 30 Sekunden vom Angegeben Wert abweichen!*)');
        Writeln(f, '');
      end;
      if songname2<>Form1.Label2.caption then begin
        songname2:=Form1.Label2.caption;
        Writeln(f, tstring1+' '+songname2);
      end;
      Flush(f);
      if tchange=-1 then tchange:=form2.SpinEdit2.Value;
      ttime:=ttime+tchange;
    //end;
    CloseFile(f);
  end else begin
    ttime:=0;
    tchange:=-1;
  end;

  end;}

end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
  {
  if (form2.checkbox3.Checked) and (start=false) then begin
  form2.timer1.Enabled:=false;
  form1.Button1.Click;
  if (form2.spinedit2.value < form2.spinedit2.MinValue) then form2.spinedit2.value:=form2.spinedit2.MinValue;
  form2.timer1.Interval:=form2.spinedit2.value*1000;
  form2.timer1.Enabled:=true; }

  tttimer(true);

  //end;

end;

procedure TForm2.Button9Click(Sender: TObject);
begin
  //showmessage('Panel Farbe: '+INtTostr(Form1.Panel1.Font.Color)+' Font-Farbe: '+Inttostr(form1.Label1.Font.Color));
  //WinExec(PChar('ffmpeg.exe -i "'+'c:\Kopie von Rick Astley - Never Gonna Give You Up.flv'+'" -ab '+IntToStr(SEPreRecordTime.value)+'000 "'+'c:\Kopie von Rick Astley - Never Gonna Give You Up.mp3'+'"'), SW_SHOWNORMAL);
end;
{
procedure TForm2.CheckBox7Click(Sender: TObject);
begin
  ChangeVolume();
end;}
{
procedure TForm2.RadioGroup2Click(Sender: TObject);
begin
  if form2.RadioGroup2.ItemIndex=0 then begin
  form2.CheckBox10.Visible:=false;
  form2.CheckBox10.Checked:=false;
  end else begin
  form2.CheckBox10.Visible:=true;
  form2.CheckBox10.Checked:=true;
  end;

  if form2.RadioGroup2.ItemIndex=1 then begin
  form2.GroupBox4.Visible:=true;
  form2.CheckBox8.Visible:=true;
  form2.CheckBox9.Visible:=true;
  end else begin
  form2.GroupBox4.Visible:=false;
  form2.CheckBox8.Visible:=false;
  form2.CheckBox9.Visible:=false;
  end;

end;}
{
procedure TForm2.RadioGroup1Click(Sender: TObject);
begin

  if RadioGroup1.ItemIndex=0 then begin

  form1.label1.caption:='TB Stream:';form1.label1.left:=10;

  Form1.CBStream.Clear;
  Form1.CBStream.Items.Add('128k MP3');
  Form1.CBStream.Items.Add('80k aacPlus');
  Form1.CBStream.Items.Add('48k OGG-Vorbis');
  Form1.CBStream.Items.Add('40k aacPlus');
  Form1.CBStream.ItemIndex:=0;

  end;

  if RadioGroup1.ItemIndex=1 then begin

  form1.label1.caption:='HT Stream:';form1.label1.left:=10;

  Form1.CBStream.Clear;
  Form1.CBStream.Items.Add('128k MP3');
  Form1.CBStream.Items.Add('80k aacPlus');
  Form1.CBStream.Items.Add('40k aacPlus');
  Form1.CBStream.ItemIndex:=0;
  end;

  if RadioGroup1.ItemIndex=2 then begin

  form1.label1.caption:='HB Stream:';form1.label1.left:=10;

  Form1.CBStream.Clear;
  Form1.CBStream.Items.Add('128k MP3');
  Form1.CBStream.Items.Add('80k aacPlus');
  //Form1.CBStream.Items.Add('48k OGG-Vorbis');
  Form1.CBStream.Items.Add('40k aacPlus');
  Form1.CBStream.ItemIndex:=0;
  end;

  if RadioGroup1.ItemIndex=3 then begin

  form1.label1.caption:='TCB Stream:';form1.label1.left:=3;

  Form1.CBStream.Clear;
  Form1.CBStream.Items.Add('128k MP3');
  Form1.CBStream.Items.Add('80k aacPlus');
  //Form1.CBStream.Items.Add('48k OGG-Vorbis');
  Form1.CBStream.Items.Add('40k aacPlus');
  Form1.CBStream.ItemIndex:=0;
  end;

  if RadioGroup1.ItemIndex=4 then begin

  form1.label1.caption:='CT Stream:';form1.label1.left:=4;

  Form1.CBStream.Clear;
  Form1.CBStream.Items.Add('128k MP3');
  Form1.CBStream.Items.Add('80k aacPlus');
  //Form1.CBStream.Items.Add('48k OGG-Vorbis');
  Form1.CBStream.Items.Add('64k aacPlus');
  Form1.CBStream.ItemIndex:=0;
  end;

  //form1.ComboBox1.ItemIndex:=form2.RadioGroup1.ItemIndex;

end; }

// Hotkey Sektion:

// Hotkey 1 :

procedure TForm2.EHPlayStopChange(Sender: TObject);
begin
  EHPlayStop.text:=Hotkey1.SetEditText;
end;

procedure TForm2.EHPlayStopKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Hotkey1.RegognizeKeys(key);
  EHPlayStop.text:=Hotkey1.SetEditText;
  //showmessage(inttostr(key));
end;

procedure TForm2.EHPlayStopKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Hotkey1.ResetKeys(key);
end;

// Hotkey 2 :

procedure TForm2.EHVolumepChange(Sender: TObject);
begin
  EHVolumep.text:=Hotkey2.SetEditText;
end;

procedure TForm2.EHVolumepKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Hotkey2.RegognizeKeys(key);
  EHVolumep.text:=Hotkey2.SetEditText;
end;

procedure TForm2.EHVolumepKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Hotkey2.ResetKeys(key);
end;

// Hotkey 3 :

procedure TForm2.EHVolumemChange(Sender: TObject);
begin
  EHVolumem.text:=Hotkey3.SetEditText;
end;

procedure TForm2.EHVolumemKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Hotkey3.RegognizeKeys(key);
  EHVolumem.text:=Hotkey3.SetEditText;
end;

procedure TForm2.EHVolumemKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Hotkey3.ResetKeys(key);
end;

// Image Button:

procedure TForm2.HotkeyIBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  HotkeyIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\ac2down.png');
  HotkeyIB.tag:=-1;
end;

procedure TForm2.HotkeyIBMouseEnter(Sender: TObject);
begin
  if (HotkeyIB.tag=-1) then begin
  HotkeyIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\ac2down.png');
  end else begin
  HotkeyIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\ac2over.png');
  end;
end;

procedure TForm2.HotkeyIBMouseLeave(Sender: TObject);
begin
  HotkeyIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\ac2.png');
  if HotkeyIB.tag>-1 then HotkeyIB.tag:=0;
end;

procedure TForm2.HotkeyIBMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Hotkeytest:boolean;
begin
  if AktivateHotkeys=false then begin
    showmessage('Hotkeys sind deaktiviert. Um sie zu aktivieren,'+#10#13+
                'die Checkbox aktivieren und das Programm neustarten.');
    exit;
  end;

  HotkeyIB.Tag:=1;

  if ((x>=0) and (x<=HotkeyIB.Width)) and ((y>=0) and (y<=HotkeyIB.Height)) then begin
    //Button wurde gedrückt!:
    HotkeyIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\ac2over.png');

    Hotkey1.DeleteHotkey(Form1.handle);
    Hotkey2.DeleteHotkey(Form1.handle);
    Hotkey3.DeleteHotkey(Form1.handle);

    Hotkeytest:=true;

    if Hotkey1.SetHotkey(Form1.Handle)=false then begin
      showmessage('Hotkey1 (Play/Stop) konnte nicht gesetzt werden.'+#10#13+'Villeicht bereits belegt ?');
      Hotkeytest:=false;
    end;

    if Hotkey2.SetHotkey(Form1.Handle)=false then begin
      showmessage('Hotkey2 (Volume + ) konnte nicht gesetzt werden.'+#10#13+'Villeicht bereits belegt ?');
      Hotkeytest:=false;
    end;

    if Hotkey3.SetHotkey(Form1.Handle)=false then begin
      showmessage('Hotkey3 (Volume - ) konnte nicht gesetzt werden.'+#10#13+'Villeicht bereits belegt ?');
      Hotkeytest:=false;
    end;

    if Hotkeytest=true then begin
      showmessage('Hotkeys wurden gesetzt!');
    end;
  end;
end;

//SkinEinstellungen:

procedure SkinChange;
var skinini:TIniFile;
begin
  skinini:=TIniFile.create(ExtractFilePath(ParamStr(0))+'Files\'+skinfolders[skinaktive]+'\skin.ini');

  GBackgroundColor:=skinini.ReadInteger('Skin','backcolor',$00F2E1BD);
  GFontColor:=skinini.ReadInteger('Skin','fontcolor',$00000000);

  skinini.free;

  if FileExists(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\bg.bmp') then begin
    form1.IBackground.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\bg.bmp');
  end else begin
    form1.IBackground.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\default_bg.bmp');
  end;

  Form1.Label2.Font.Color:=GFontColor;
  Form1.Label3.Font.Color:=GFontColor;
  Form1.Label4.Font.Color:=GFontColor;
  Form1.Label5.Font.Color:=GFontColor;
  Form1.Label6.Font.Color:=GFontColor;
  Form1.Label7.Font.Color:=GFontColor;
  Form1.VolumeLabel.Font.Color:=GFontColor;

  case Form1.PlayIB.Tag of
    -1:Form1.PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('down'));
    0:Form1.PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('normal'));
    1:Form1.PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('over'));
  end;

  case recbuttonstate of
    0:begin
      Form1.RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\r32.png');
    end;
    2:begin
      Form1.RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\rs32.png');
    end;
  end;

  Form1.RefreshIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\a.png');
  Form1.ExtraIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\e.png');
end;

procedure TForm2.LBSkinClick(Sender: TObject);
begin
  skinaktive:=Form2.LBSkin.ItemIndex;
  SkinChange;
end;

procedure TForm2.TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

//Falls eine Einstellung geänder wurde, die ein Neustart erfordert, dem User mitteilen:
procedure TForm2.CBMinimize2TrayChange(Sender: TObject);
begin
  restart_need:=true;
end;

procedure TForm2.CBAllwaysShowTrayIconChange(Sender: TObject);
begin
  restart_need:=true;
end;

procedure TForm2.CBCheck4UpdateChange(Sender: TObject);
begin
  restart_need:=true;
end;

procedure TForm2.CBSaveLogChange(Sender: TObject);
begin
  restart_need:=true;
end;

procedure TForm2.CBShowDJPicChange(Sender: TObject);
begin
  restart_need:=true;
end;

procedure TForm2.CBAutomaticRefreshChange(Sender: TObject);
begin
  restart_need:=true;
end;

procedure TForm2.SERefreshTimeChange(Sender: TObject);
begin
  restart_need:=true;
end;

procedure TForm2.CBAktivatePreRecordChange(Sender: TObject);
begin
  restart_need:=true;
end;

procedure TForm2.SEPreRecordTimeChange(Sender: TObject);
begin
  restart_need:=true;
end;

procedure TForm2.CBAktivateHotkeysChange(Sender: TObject);
begin
  restart_need:=true;
end;

procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if restart_need=true then begin
    restart_need:=false;

    if Application.MessageBox(
      PChar(UTF8Encode('Die geänderten Einstellungen erforden einen Neustart')+#10#13+
            'Jetzt neustarten ?'),
      PChar('TB-PLayer neustarten'),
      MB_YESNO) = IDYES then
    begin
      form1.Timer1.Enabled:=false;

      SysUtils.ExecuteProcess(ExtractFilePath(Application.Exename)+'restart.bat','');

      form1.Close;
    end;
  end;

  Hotkey1.ResetEditText;
  Hotkey2.ResetEditText;
  Hotkey3.ResetEditText;

  Form2.EHPlayStop.text:='omglol';
  Form2.EHVolumep.text:='omglol';
  Form2.ehvolumem.text:='omglol';
end;

initialization
  {$i Unit2.lrs}
  {$i Unit2.lrs}

end.
