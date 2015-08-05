unit main;

{$MODE Delphi}{$H+}
                         
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, bass, StdCtrls, ExtCtrls, Menus,
  ComCtrls, Unit1, IdComponent,
  IdHTTP, IdAntiFreeze, Buttons,
  LResources, RadioThread, Hotkey, Refresh, prerecord, inistuff, Plugins;

procedure pause(zeit: longint);
function ReturnPlayButtonIconString(typ:string):string;
procedure RefreshDJSongListener;
procedure updateup(y:string);
procedure MakeOnClickPossible(MenuItem:PMenuItem;tag:integer);

type

  { TForm1 }

  TForm1 = class(TForm)
    CBStream: TComboBox;
    IdHTTP1: TIdHTTP;
    IDJPic: TImage;
    ExtraIB: TImage;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu2: TPopupMenu;
    RecordIB: TImage;
    RefreshIB: TImage;
    RecordSD: TSaveDialog;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    VolumeRuler: TImage;
    VolumeBar: TImage;
    PlayIB: TImage;
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    Beebdeb1: TMenuItem;
    Extras1: TMenuItem;
    Info1: TMenuItem;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    Maximieren1: TMenuItem;
    Beenden1: TMenuItem;
    Einstellungen1: TMenuItem;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    VolumeLabel: TLabel;
    Updatevorhanden1: TMenuItem;
    IdAntiFreeze1: TIdAntiFreeze;
    Log1: TMenuItem;
    CBSender: TComboBox;
    IBackground: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Beebdeb1Click(Sender: TObject);
    procedure ExtraIBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ExtraIBMouseEnter(Sender: TObject);
    procedure ExtraIBMouseLeave(Sender: TObject);
    procedure ExtraIBMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure RecordIBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RecordIBMouseEnter(Sender: TObject);
    procedure RecordIBMouseLeave(Sender: TObject);
    procedure RecordIBMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RefreshIBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayIBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayIBMouseEnter(Sender: TObject);
    procedure PlayIBMouseLeave(Sender: TObject);
    procedure PlayIBMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Info1Click(Sender: TObject);
    procedure Maximieren1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure Einstellungen1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RefreshIBMouseEnter(Sender: TObject);
    procedure RefreshIBMouseLeave(Sender: TObject);
    procedure RefreshIBMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure Updatevorhanden1Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure Log1Click(Sender: TObject);
    procedure madebycrazysaem1Click(Sender: TObject);

    procedure SetPlayIcon(Icontype: String);
    procedure VolumeBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VolumeBarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure VolumeBarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VolumeRulerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VolumeRulerMouseEnter(Sender: TObject);
    procedure VolumeRulerMouseLeave(Sender: TObject);
    procedure VolumeRulerMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure VolumeRulerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayIBMUp;
    procedure VolumeHotkeyChange(dir:string);
    procedure RecordIBStartrecord;
    procedure Minimize(Sender: TObject);
    function  DTBTest:boolean;

    procedure PopUpClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  //Techno-Stream:
  stream:HSTREAM;
  tracking,Form2CB,Form2CB2,aktualisieren,play2,abort,endee,refreshed:boolean;

  Result,Form2Edit1:string;
  djname,songname,songname2,zuhorer,location,DateiEnd:string;
  Form2Left,Form2Top,istream,Form2SpinEdit1,startuptime:integer;
  version:extended;
  fstream:tfilestream;
  win: hwnd;
  FTime: Longword;
  FBytes: Longword;
  DTBTestf:TextFile;
  hThreadRefresh,hThreadSearchMusik,hThreadDownload: THandle;
  //Icon für den Playbutton:
  GIcontype:string;
  //Variable für den Woindows Message Callback:
  PrevWndProc: WNDPROC;
  //Hotkeys:
  Hotkey1,Hotkey2,Hotkey3:THotkey;
  //RecordButtonstate:
  recbuttonstate:integer;
  //Programm schon gestartet ?
  mHandle: THandle;

const
  TB_USER=1337;

  
implementation

uses Unit2, Unit4;

{$R 'C:\Spiele\Delphi Projects\TechnoBaseFM Player\icon.res'}

//*Real Programmers don't need comments-- the code is obvious.*//
//F**k this, I just add some ...
//and by teh way, Real Programmers Don't Use Pascal ..

// Windows CallBack, um die Messages für die Hotkeys rauszufiltern :

function WndCallback(Ahwnd: HWND; uMsg: UINT; wParam: WParam; lParam: LParam):LRESULT; stdcall;
begin
  (*
  if uMsg=WM_NCHITTEST then
  begin
    result:=Windows.DefWindowProc(Ahwnd, uMsg, WParam, LParam);  //not sure about this one
    if result=windows.HTCAPTION then result:=windows.HTCLIENT;
    exit;
  end;*)
  if uMsg=WM_HOTKEY then begin
    //hier: wparam = HOTKey-ID !
    // ID1 -> Start/Stop, ID2 -> Volume+, ID3 -> Volume-
    case wparam of
      1:begin
        Form1.PlayIBMUp;
      end;
      2:begin
        Form1.VolumeHotkeyChange('up');
      end;
      3:begin
        Form1.VolumeHotkeyChange('down');
      end;
    end;
  end;
  if uMsg=TB_USER then begin
    //Fenster soll in den Vordergrund geholt werden!
    if Application.MainForm.WindowState = wsMinimized then
      Application.MainForm.WindowState := wsNormal;    // Override minimized state
    Application.MainForm.Visible := True;
    Form1.visible:=true;
    Form1.BringToFront;
    Form1.SetFocus;

    if AllwaysShowTrayIcon=false then begin
      form1.TrayIcon1.Hide;
    end;
  end;
  (*
  if uMsg=WM_MOVING then begin
    //Wird aufgerufen wenn FORM1 bewergt wird!
    result:=LRESULT(true);
    exit;
  end;*)
  result:=CallWindowProc(PrevWndProc,Ahwnd, uMsg, WParam, LParam);
end;

procedure TForm1.FormCreate(Sender: TObject);
var DataStream: TFileStream;
    newver: float;
    lauf,f6l,f6t,f1ll,f1tt,IVolumeRuler_left:integer;
begin
  //Wenn das Programm neugestartet wird, kurz warten bis das alte Programm beendet ist:
  if ParamStr(1)='/restart' then begin
    sleep(500);
  end;

  Form1.Caption:='Programm is starting pls wait';
  sleep(2);

  if DTBTest=true then begin endee:=true;exit; end else endee:=false;
  randomize;

  Form1.Caption:='TB-PLayer - by crazysaem';

  //PlaybuttonIcon auf 'play' setzen (standart)
  GIcontype:='play';

  //Noch Keine Plugins geladen:
  pluginanzahl:=-1;

  //PreRecord Initialisieren:
  PreRecordInit;

  //Record-Buttonstate auf 0 (standart)
  recbuttonstate:=0;

  //Minimieren-Event von Form1 als CallBack zur Minize-Procedure zuweißen:
  Application.OnMinimize:=Form1.Minimize;

  //Aktuelle Version fest im Programm speicher, (v 1.6.2)
  version:=1.62;

  //Wichtig für die Hotkeys:
  //Windows CallBack festlegen, um zu erkennen wann die Hotkeys aufgerufen werden:
  PrevWndProc:=Windows.WNDPROC(SetWindowLong(Self.Handle,GWL_WNDPROC,PtrInt(@WndCallback)));
  Hotkey1:=THotkey.Create;
  Hotkey2:=THotkey.Create;
  Hotkey3:=THotkey.Create;
  //</Hotkeys>

  //Indy einstellen:
  IdHTTP1.ConnectTimeout:=8000;
  IdHTTP1.ReadTimeout:=8000;

  //Bass initialiesieren
  if BASS_INIT(-1, 44000, 0, Handle, nil) = false then begin
    showmessage('Base_ konnte nicht initialisiert werden');
  end;

  DateiEnd:='';

  // Aktiven Skin auf Default Einstellung setzen.
  skinaktive:=0;

  //Die Breite und Höhe des Players "fixiern"
  (*
  Form1.Constraints.MaxHeight:=Form1.Height;
  Form1.Constraints.MaxWidth:=Form1.Width;
  Form1.Constraints.MinHeight:=Form1.Height;
  Form1.Constraints.MinWidth:=Form1.Width;  *)

  //Play in die Mitte des Bildschirms platzieren:
  form1.Left:=trunc(screen.Width/2-form1.Width/2);
  form1.top:=trunc(screen.Height/2-form1.Height/2);

end;

//Message ausgeben über Versionsinfos

procedure TBversion();
begin
  showmessage(UTF8Encode(
              'Programmierer: Samuel Schneider'+#10#13+
              'HomePage: http://crazysaem.cr.funpic.de/'+#10#13+
              'Version: 1.6.2 stable'+#10#13+
              'Vielen Dank an folgende Projekte:'+#10#13+
              'Lazarus'+#10#13+
              'Indy 10'+#10#13+
              'Bass'+#10#13+
              'http://www.delphi-treff.de/'+#10#13+
              'http://www.delphipraxis.net/'+#10#13+
              '.. und natürlich http://www.technobase.fm/'+#10#13+
              ' sowie seinen Tochterprojekten'));
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  abort:=true;
  BASS_Free();
end;

procedure skinchange();
begin  {
if play=true then begin
    form1.PNGButton1.ImageNormal:=LoadTBIcon(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\p32.png');
  end else begin
    form1.PNGButton1.ImageNormal:=LoadTBIcon(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\s32.png');
  end;

  if record1=false then begin
    form1.PNGButton2.ImageNormal:=LoadTBIcon(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\r32.png');
  end else begin
    form1.PNGButton2.ImageNormal:=LoadTBIcon(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\rs32.png');
  end;

  form1.PNGButton3.ImageNormal:=LoadTBIcon(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\yd.png');

  form1.PNGButton4.ImageNormal:=LoadTBIcon(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\a.png');

  form2.PNGButton2.ImageNormal:=LoadTBIcon(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\q.png'); }
end;

procedure TForm1.Beebdeb1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Info1Click(Sender: TObject);
begin
  TBversion();
end;

procedure TForm1.Einstellungen1Click(Sender: TObject);
begin
  Form2.Visible:=true;
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

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var lauf:integer;
begin
  if endee=false then begin
    IniSaveAllSettings;
    UnLoadAllPlugins;
  end;

  //CloseFile(DTBTestf);
  application.Terminate;
end;

procedure TForm1.Updatevorhanden1Click(Sender: TObject);
begin
  updateup('yes');
end;

procedure TForm1.Panel2Click(Sender: TObject);
begin
  TBversion();
end;

procedure TForm1.Log1Click(Sender: TObject);
begin
  form4.visible:=true;
end;

procedure TForm1.madebycrazysaem1Click(Sender: TObject);
begin
    TBversion();
end;

//Funktionen die die Position der VolumeBar in Volume% umrechnen und an Bass schicken:
procedure TBTrackbar();
var pt: tpoint;
    mousex:integer;
begin
  GetCursorPos(pt);
  mousex:=trunc(pt.x-form1.Left-(form1.Width-form1.ClientWidth))-1-trunc(form1.VolumeRuler.Width/2);
  if (mousex>=form1.VolumeBar.Left) and (mousex<=form1.VolumeBar.Width+form1.VolumeBar.Left) then form1.VolumeRuler.Left:=mousex-1;//-round(Form1.VolumeRuler.Width/2)-form1.VolumeBar.Left;
  if mousex<=form1.VolumeBar.Left then form1.VolumeRuler.Left:=form1.VolumeBar.Left -trunc(form1.VolumeRuler.Width/2);
  if mousex>=(form1.VolumeBar.Width+form1.VolumeBar.Left-round(Form1.VolumeRuler.Width/2)+1) then form1.VolumeRuler.Left:=form1.VolumeBar.Left+form1.VolumeBar.Width-round(Form1.VolumeRuler.Width/2)+1;
  BASS_ChannelSetAttribute(stream,BASS_ATTRIB_VOL,(form1.VolumeRuler.Left-form1.VolumeBar.Left+trunc(form1.VolumeRuler.Width/2))/form1.VolumeBar.Width);
  Form1.VolumeLabel.Caption:=inttostr(trunc(((form1.VolumeRuler.Left-form1.VolumeBar.Left+trunc(form1.VolumeRuler.Width/2))/form1.VolumeBar.Width)*200))+'%';
end;

//VolumeBar Hotkey Funktionen (Volume+ und Volume-)

procedure TForm1.VolumeHotkeyChange(dir:string);
var PreVRleft,vprozent:integer;
begin
  //Ruler verschieben:
  if (dir='up') then begin
    PreVRleft:=VolumeRuler.Left+trunc(VolumeBar.width/200);
  end;
  if dir='down' then begin
    PreVRleft:=VolumeRuler.Left-trunc(VolumeBar.width/200);
  end;

  vprozent:=trunc(((PreVRleft-form1.VolumeBar.Left+round(Form1.VolumeRuler.Width/2)-2)/form1.VolumeBar.Width)*200);

  // Überbrüfen ob der Slider auf der Bar sitzt:
  if (vprozent<200) and (vprozent>=0) then begin
    form1.VolumeRuler.Left:=PreVRleft;

    //Neue Lautstärke setzen:
    BASS_ChannelSetAttribute(stream,BASS_ATTRIB_VOL,(form1.VolumeRuler.Left-form1.VolumeBar.Left+trunc(form1.VolumeRuler.Width/2))/form1.VolumeBar.Width);
    Form1.VolumeLabel.Caption:=inttostr(trunc(((form1.VolumeRuler.Left-form1.VolumeBar.Left+trunc(form1.VolumeRuler.Width/2))/form1.VolumeBar.Width)*200))+'%';
  end else exit;
end;

//VolumeRuler + VolumeBar Funktionen:

procedure TForm1.VolumeRulerMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     VolumeRuler.Tag:=1;
     VolumeRuler.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\ruleronclick.bmp');
end;

procedure TForm1.VolumeRulerMouseEnter(Sender: TObject);
begin
     if VolumeRuler.Tag=0 then VolumeRuler.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\rulerover.bmp');
end;

procedure TForm1.VolumeRulerMouseLeave(Sender: TObject);
begin
     if VolumeRuler.Tag=0 then VolumeRuler.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\ruler.bmp');
end;

procedure TForm1.VolumeRulerMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
     if VolumeRuler.Tag=1 then TBTrackbar;
end;

procedure TForm1.VolumeRulerMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  VolumeRuler.Tag:=0;
  VolumeRuler.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\ruler.bmp');
end;

procedure TForm1.VolumeBarMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Form1.VolumeRuler.Left:=x-trunc(Form1.VolumeRuler.width/2)+Form1.VolumeBar.left;

  VolumeBar.Tag:=1;
  VolumeRuler.Tag:=1;
  VolumeRuler.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\ruleronclick.bmp');
  TBTrackbar;
end;

procedure TForm1.VolumeBarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  VolumeBar.Tag:=0;
  VolumeRuler.Tag:=0;
  VolumeRuler.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\ruler.bmp');
end;

procedure TForm1.VolumeBarMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if VolumeBar.Tag=1 then begin
    Form1.VolumeRuler.Left:=x-trunc(Form1.VolumeRuler.width/2)+Form1.VolumeBar.left;
    TBTrackbar;
  end;
end;

// TechnoBase Streams Funktionen:

//Funktion gibt den Richtigen Pfad zum ButtonIcon zurück und auch ob es "play" "buffer" oder "stop" Icon sein soll:
function ReturnPlayButtonIconString(typ:string):string;
begin
  if typ='down' then begin
    if GIcontype = 'play' then result:=ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\p32down.png';
    if GIcontype = 'buffer' then result:=ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\l.png';
    if GIcontype = 'stop' then result:=ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\s32down.png';
  end;
  if typ='normal' then begin
    if GIcontype = 'play' then result:=ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\p32.png';
    if GIcontype = 'buffer' then result:=ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\l.png';
    if GIcontype = 'stop' then result:=ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\s32.png';
  end;
  if typ='over' then begin
    if GIcontype = 'play' then result:=ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\p32over.png';
    if GIcontype = 'buffer' then result:=ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\l.png';
    if GIcontype = 'stop' then result:=ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\s32over.png';
  end;
end;

//CallBack Funktion für den RadioThread, wird aufgerufen wenn Bass buffert und wenn der STream
//gestarte bzw. fehlgeschlagen ist und setzt den jeweiligen Button-Icon:
procedure TForm1.SetPlayIcon(Icontype: String);
begin
  //Icontype='buffer'
  //Bedeutet der Stream buffert gerade

  //Icontype='play'
  //Bedeutet es gab einen Fehler, den Knopf auf "Play" zurücksetzen

  //Icontype='stop'
  //Der Stream läuft!, Stop Taste zeigen

  GIcontype:=Icontype;
  case PlayIB.Tag of
    -1:PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('down'));
    0:PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('normal'));
    1:PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('over'));
  end;
end;

//Wählt den richtigen ausgewählten Stream aus und leitet ihn an Bass weiter:
function PlaytheStream:boolean;
var URL:string;
    RThread:TRadioThread;
begin
  // Thread zum abspielen des Streams erzeugen:
  RThread:=TRadioThread.Create;
  RThread.OnIconChange:=Form1.SetPlayIcon;
  RThread.Pstream:=@stream;

  case form1.CBSender.ItemIndex of

   0:begin //Bei TechnoBase:
   case form1.CBStream.ItemIndex of
      0: begin RThread.URL:='http://listen.technobase.fm/tunein-dsl-pls'; RThread.aac:=false; DateiEnd:='mp3';PreRecordSetmaxlength(16);end;           //128k MP3
      1: begin RThread.URL:='http://listen.technobase.fm/tunein-aacplus-pls'; RThread.aac:=true; DateiEnd:='aac';PreRecordSetmaxlength(10);end;        //80k  aac
      2: begin RThread.URL:='http://listen.technobase.fm/tunein-oggvorbis-pls.ogg'; RThread.aac:=false; DateiEnd:='ogg';PreRecordSetmaxlength(6);end; //48k  ogg
      3: begin RThread.URL:='http://listen.technobase.fm/tunein-aacisdn-pls'; RThread.aac:=true; DateiEnd:='aac';PreRecordSetmaxlength(5);end;        //40k  aac
    end;end;

    1:begin //Bei HouseTime
    case form1.CBStream.ItemIndex of
      0: begin RThread.URL:='http://listen.housetime.fm/tunein-dsl-pls'; RThread.aac:=false; DateiEnd:='mp3';PreRecordSetmaxlength(16);end;           //128k MP3
      1: begin RThread.URL:='http://listen.housetime.fm/tunein-aacplus-pls'; RThread.aac:=true; DateiEnd:='aac';PreRecordSetmaxlength(10);end;        //80k  aac
      2: begin RThread.URL:='http://listen.housetime.fm/tunein-oggvorbis-pls.ogg'; RThread.aac:=false; DateiEnd:='ogg';PreRecordSetmaxlength(6);end;  //48k  ogg
      3: begin RThread.URL:='http://listen.housetime.fm/tunein-aacisdn-pls'; RThread.aac:=true; DateiEnd:='aac';PreRecordSetmaxlength(5);end;         //40k  aac
    end;end;

    2:begin //Bei HardBase
    case form1.CBStream.ItemIndex of
      0: begin RThread.URL:='http://listen.hardbase.fm/tunein-dsl-pls'; RThread.aac:=false; DateiEnd:='mp3';PreRecordSetmaxlength(16);end;           //128k MP3
      1: begin RThread.URL:='http://listen.hardbase.fm/tunein-aacplus-pls'; RThread.aac:=true; DateiEnd:='aac';PreRecordSetmaxlength(10);end;        //80k  aac
      2: begin RThread.URL:='http://listen.hardbase.fm/tunein-oggvorbis-pls.ogg'; RThread.aac:=false; DateiEnd:='ogg';PreRecordSetmaxlength(6);end;  //48k  ogg
      3: begin RThread.URL:='http://listen.hardbase.fm/tunein-aacisdn-pls'; RThread.aac:=true; DateiEnd:='aac';PreRecordSetmaxlength(5);end;         //40k  aac
    end;end;

    3:begin //Bei TranceBase
    case form1.CBStream.ItemIndex of
      0: begin RThread.URL:='http://listen.trancebase.fm/tunein-dsl-pls'; RThread.aac:=false; DateiEnd:='mp3';PreRecordSetmaxlength(16);end;           //128k MP3
      1: begin RThread.URL:='http://listen.trancebase.fm/tunein-aacplus-pls'; RThread.aac:=true; DateiEnd:='aac';PreRecordSetmaxlength(10);end;        //80k  aac
      2: begin RThread.URL:='http://listen.trancebase.fm/tunein-oggvorbis-pls.ogg'; RThread.aac:=false; DateiEnd:='ogg';PreRecordSetmaxlength(6);end;  //48k  ogg
      3: begin RThread.URL:='http://listen.trancebase.fm/tunein-aacisdn-pls'; RThread.aac:=true; DateiEnd:='aac';PreRecordSetmaxlength(5);end;         //40k  aac
    end;end;

    4:begin //Bei CoreTime
    case form1.CBStream.ItemIndex of
      0: begin RThread.URL:='http://listen.coretime.fm/tunein-dsl-pls'; RThread.aac:=false; DateiEnd:='mp3';PreRecordSetmaxlength(16);end;           //128k MP3
      1: begin RThread.URL:='http://listen.coretime.fm/tunein-aacplus-pls'; RThread.aac:=true; DateiEnd:='aac';PreRecordSetmaxlength(10);end;        //80k  aac
      2: begin RThread.URL:='http://listen.coretime.fm/tunein-oggvorbis-pls.ogg'; RThread.aac:=false; DateiEnd:='ogg';PreRecordSetmaxlength(6);end;  //48k  ogg
      3: begin RThread.URL:='http://listen.coretime.fm/tunein-aacisdn-pls'; RThread.aac:=true; DateiEnd:='aac';PreRecordSetmaxlength(5);end;         //40k  aac
    end;end;

  end;
  RThread.volume:=(form1.VolumeRuler.Left-form1.VolumeBar.Left+trunc(form1.VolumeRuler.Width/2))/form1.VolumeBar.Width;
  RThread.Resume;
end;

//
// IMAGE-Button Sektion :
//

// Play Button:

procedure PlayButtonIcon(typ:string);
begin
end;

procedure TForm1.PlayIBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     //Der Button wurde gedrückt, also Bild dazu laden und Tag dazu setzen:
     PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('down'));
     PlayIB.tag:=-1;
end;

procedure TForm1.PlayIBMouseEnter(Sender: TObject);
begin
     //Entweder der Button ist noch gedrückt (tag=-1) dann Button wieder Gedrückt aussehen lassen:
     if (PlayIB.tag=-1) then begin
        PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('down'));
     //Oder der Button ist nicht gedrückt, dann den Button hervorheben:
     end else begin
         PlayIB.tag:=1;
         PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('over'));
     end;
end;

procedure TForm1.PlayIBMouseLeave(Sender: TObject);
begin
     //Aussehen des Buttons zurücksetzen:
     PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('normal'));
     //Falls Tag nicht -1, also Button nicht gedrückt, Button tag auf 0
     if PlayIB.tag<>-1 then PlayIB.tag:=0;
end;

procedure TForm1.PlayIBMUp;
begin
  if (GIcontype='play') then begin
    case PlayIB.Tag of
      -1:PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('down'));
      0:PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('normal'));
      1:PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('over'));
    end;
    PreReocrdReset;
    PlaytheStream;
  end;

  if (GIcontype='stop') then begin
    if recbuttonstate<>0 then begin
      showmessage('Bitte erst die Aufnahme stoppen, bevor sie den Stream stoppen.');
      exit;
    end;
    PreRecordStop;
    BASS_CHANNELStop(stream);
    BASS_CHANNELSetPosition(stream, 0, 0);
    stream:=0;

    GIcontype:='play';
    case PlayIB.Tag of
      -1:PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('down'));
      0:PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('normal'));
      1:PlayIB.Picture.LoadFromFile(ReturnPlayButtonIconString('over'));
    end;
  end;
end;

procedure TForm1.PlayIBMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //Tag auf 1
  PlayIB.Tag:=1;
  //Überprüfen ob die Maus wirklich auf dem Knopf ist:
  if ((x>=0) and (x<=PlayIB.Width)) and ((y>=0) and (y<=PlayIB.Height)) then begin
    //OnClick:
    //OnlClick funktion wurde ausgelagert um diese Prozedur besser über die Hotkeys zu steuern.
    PlayIBMUp;
  end;
end;

// Refresh Button :

procedure TForm1.RefreshIBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if aktualisieren=false then RefreshIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\adown.png');
  RefreshIB.tag:=-1;
end;

procedure TForm1.RefreshIBMouseEnter(Sender: TObject);
begin
  if aktualisieren=true then exit;
  if (RefreshIB.tag=-1) then begin
    RefreshIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\adown.png');
  end else begin
    RefreshIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\aover.png');
  end;
end;

procedure TForm1.RefreshIBMouseLeave(Sender: TObject);
begin
  if aktualisieren=false then RefreshIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\a.png');
  if RefreshIB.tag>-1 then RefreshIB.tag:=0;
end;

procedure RefreshDJSongListener;
var buffer,djpicurl,djpicpath,djpicname,pictype:string;
    TBPack:TTBPack;
    lauf:integer;
begin
  if aktualisieren=true then exit;

  aktualisieren:=true;
  Form1.RefreshIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\l.png');

  //Labels setzen:
  Form1.label4.caption:='Name des DJs wird geladen, bitte warten.';
  Form1.label2.caption:='Name des Songs wird geladen, bitte warten.';
  // Da ein 'ö', ein Sonderzeichen kommt, UTF8Encode benutzen; WTF ? srsly ...
  Form1.label7.caption:=UTF8Encode('Anzahl der Zuhörer wird geladen, bitte warten.');

  try
    buffer:=Form1.IdHTTP1.Get('http://tray.technobase.fm/radio.xml');
  except
    Form1.label4.caption:='-Timeout - Technobase.fm offline ?-';
    Form1.label2.caption:='-Timeout - Technobase.fm offline ?-';
    Form1.label7.caption:='-Timeout - Technobase.fm offline ?-';

    if Form1.RefreshIB.tag=0 then Form1.RefreshIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\a.png');
    if Form1.RefreshIB.tag=1 then Form1.RefreshIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\aover.png');
    aktualisieren:=false;

    exit;
  end;

  case  Form1.CBSender.ItemIndex of
    0:TBPack:=XMLFilter(buffer);
    1:begin
      buffer:=copy(buffer,pos('HouseTime',buffer),length(buffer));
      TBPack:=XMLFilter(buffer);
    end;
    2:begin
      buffer:=copy(buffer,pos('HardBase',buffer),length(buffer));
      TBPack:=XMLFilter(buffer);
    end;
    3:begin
      buffer:=copy(buffer,pos('TranceBase',buffer),length(buffer));
      TBPack:=XMLFilter(buffer);
    end;
    4:begin
      buffer:=copy(buffer,pos('CoreTime',buffer),length(buffer));
      TBPack:=XMLFilter(buffer);
    end;
  end;

  Form1.label4.caption:=TBPack.tbdjname;
  Form1.label2.caption:=TBPack.tbsongname;
  Form1.label7.caption:=TBPack.tbzuhorer;

  if ShowDJPic=true then begin
    djpicurl:=TBPack.tbdjpicurl;
    djpicname:=copy(djpicurl,pos('eu/',djpicurl)+3,length(djpicurl));
    djpicname:=copy(djpicname,1,length(djpicname)-4);
    djpicpath:=ExtractFilePath(Application.Exename)+'Files\_dj_temp\'+djpicname;

    if FileExists(djpicpath+'.png') or FileExists(djpicpath+'.jpg') then begin
      if (Form1.IDJPic.Picture.GetNamePath<>(djpicpath+'.png')) and (Form1.IDJPic.Picture.GetNamePath<>(djpicpath+'.jpg')) then begin
        if FileExists(djpicpath+'.png') then Form1.IDJPic.Picture.LoadFromFile(djpicpath+'.png');
        if FileExists(djpicpath+'.jpg') then Form1.IDJPic.Picture.LoadFromFile(djpicpath+'.jpg');
      end;
    end else begin
      pictype:=DownloadDJPic(djpicpath,djpicurl);
      if pictype='error' then begin
        if Form1.RefreshIB.tag=0 then Form1.RefreshIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\a.png');
        if Form1.RefreshIB.tag=1 then Form1.RefreshIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\aover.png');
        aktualisieren:=false;
        exit;
      end else Form1.IDJPic.Picture.LoadFromFile(djpicpath+'.'+pictype);
    end;
  end;

  if Form1.RefreshIB.tag=0 then Form1.RefreshIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\a.png');
  if Form1.RefreshIB.tag=1 then Form1.RefreshIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\aover.png');

  if pluginanzahl<>-1 then begin
    for lauf:=1 to pluginanzahl do begin
      FunctionPack[lauf-1].Give_TBPack(TBPack.tbdjname,TBPack.tbsongname,TBPack.tbzuhorer,'');
    end;
  end;

  aktualisieren:=false;
end;

procedure TForm1.RefreshIBMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RefreshIB.Tag:=1;

  if aktualisieren=true then exit;

  if ((x>=0) and (x<=RefreshIB.Width)) and ((y>=0) and (y<=RefreshIB.Height)) then begin
    //Refresh Prozedur auslagen um sie besser von ausen aufrufen zu können:
    RefreshDJSongListener;
  end;
end;

//Extra Button:

procedure TForm1.ExtraIBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //ExtraIB.Picture.LoadFromFile('adown.png');
  Form1.ExtraIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\edown.png');
  ExtraIB.tag:=-1;
end;

procedure TForm1.ExtraIBMouseEnter(Sender: TObject);
begin
  if (ExtraIB.tag=-1) then begin
    //ExtraIB.Picture.LoadFromFile('adown.png');
    Form1.ExtraIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\edown.png');
  end else begin
    //ExtraIB.Picture.LoadFromFile('aover.png');
    Form1.ExtraIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\eover.png');
  end;
end;

procedure TForm1.ExtraIBMouseLeave(Sender: TObject);
begin
  //ExtraIB.Picture.LoadFromFile('a.png');
  Form1.ExtraIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\e.png');
  if ExtraIB.tag>-1 then ExtraIB.tag:=0;
end;

procedure TForm1.ExtraIBMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var pt:tpoint;
begin
  ExtraIB.Tag:=1;

  if ((x>=0) and (x<=ExtraIB.Width)) and ((y>=0) and (y<=ExtraIB.Height)) then begin
     //Pressed!
     GetCursorPos(pt);
     Form1.PopupMenu2.PopUp(pt.x,pt.y);
  end
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  //Release URL aufrufen
  if global_releaseurl='' then begin
    showmessage('Bitte aktualisieren.');
    exit;
  end;
  //SysUtils.ExecuteProcess(global_releaseurl,'');
  ShellExecute(Form1.Handle, 'open', PCHar(global_releaseurl), nil, nil, SW_ShowNormal);
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  //DJProfil URL aufrufen
  if global_djprofilurl='' then begin
    showmessage('Bitte aktualisieren.');
    exit;
  end;
  //SysUtils.ExecuteProcess(global_releaseurl,'');
  ShellExecute(Form1.Handle, 'open', PCHar(global_djprofilurl), nil, nil, SW_ShowNormal);
end;

// Record Button :

procedure TForm1.RecordIBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if recbuttonstate=0 then RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\r32down.png');
  if recbuttonstate=2 then RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\rs32down.png');
  RecordIB.tag:=-1;
end;

procedure TForm1.RecordIBMouseEnter(Sender: TObject);
begin
  if recbuttonstate=0 then begin
    if (RecordIB.tag=-1) then begin
      RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\r32down.png');
    end else begin
      RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\r32over.png');
    end;
  end;
  if recbuttonstate=2 then begin
    if (RecordIB.tag=-1) then begin
      RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\rs32down.png');
    end else begin
      RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\rs32over.png');
    end;
  end;
end;

procedure TForm1.RecordIBMouseLeave(Sender: TObject);
begin
  if recbuttonstate=0 then RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\r32.png');
  if recbuttonstate=2 then RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\rs32.png');
  if RecordIB.tag>-1 then RecordIB.tag:=0;
end;

procedure TForm1.RecordIBStartrecord;
var fname:string;
begin
  RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\r32over.png');
  //Button Pressed!:

  if stream=0 then begin
    showmessage(UTF8Encode('Vor einer Aufnahme muss der Stream zunächst gestartet werden'));
    exit;
    recbuttonstate:=0;
  end;

  recbuttonstate:=1;
  RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\l.png');

  if location<>'' then location:='';

  fname:=DateToStr( Date ) + ' ' + TimeToStr( Time );
  fname:=copy(fname,0,length(fname)-3);
  fname:=StringReplace(fname,'.','_',[rfReplaceAll]);
  fname:=StringReplace(fname,':',' ',[rfReplaceAll]);

  RecordSD.FileName:=fname;

  RecordSD.DefaultExt:=DateiEnd;
  RecordSD.filter:='Musik|*.'+DateiEnd;

  if RecordSD.Execute then begin
    location:=RecordSD.FileName;
  end else begin
    recbuttonstate:=0;
    RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\r32.png');
    exit;
  end;

  default_location:=copy(location,1,length(location)-length(fname)-4);

  if StartRecord(location)=false then begin
    recbuttonstate:=0;
    showmessage('Datei konnte nicht erstellt werden.');
    exit;
  end;

  recbuttonstate:=2;
  RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\rs32.png');
end;

procedure RecordIBStoprecord;
begin
  StopRecord;
  recbuttonstate:=0;
  form1.RecordIB.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'Files\'+skinfolders[skinaktive]+'\r32over.png');
end;

procedure TForm1.RecordIBMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RecordIB.Tag:=1;
  if recbuttonstate=1 then exit;

  if ((x>=0) and (x<=RecordIB.Width)) and ((y>=0) and (y<=RecordIB.Height)) then begin
    case recbuttonstate of
      0:begin
        RecordIBStartrecord;
      end;
      2:begin
        RecordIBStoprecord;
        PreReocrdReset;
      end;
    end;

  end;

end;

// RecordButton />

// MinizeToTray:

procedure Tform1.Minimize(Sender: TObject);
begin
  //Hide App in Taskbar:
   if Minimze2Tray=true then begin
     Visible := False;
     form1.TrayIcon1.Show;
     Form2.close;
     form4.close;
   end;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  if Application.MainForm.WindowState = wsMinimized then
    Application.MainForm.WindowState := wsNormal;    // Override minimized state
  Application.MainForm.Visible := True;
  visible:=true;
  Form1.BringToFront;
  Form1.SetFocus;

  if AllwaysShowTrayIcon=false then begin
    form1.TrayIcon1.Hide;
  end;
end;

// Tray POPUP-Menü :

procedure TForm1.Maximieren1Click(Sender: TObject);
begin
  if Application.MainForm.WindowState = wsMinimized then
    Application.MainForm.WindowState := wsNormal;    // Override minimized state
  Application.MainForm.Visible := True;
  visible:=true;
  Form1.BringToFront;
  Form1.SetFocus;

  if AllwaysShowTrayIcon=false then begin
    form1.TrayIcon1.Hide;
  end;
end;

procedure TForm1.Beenden1Click(Sender: TObject);
begin
  Close;
end;

//Funktion die testet, ob das Programm bereits gestartet wurde:

function TForm1.DTBTest:boolean;
var datei,windowhandle:string;
    FHandlex1,FHandlex2:Thandle;
    error:DWORD;
begin
    (*
    datei:=ExtractFilePath(Application.Exename)+'test.DAT';
    try
      AssignFile(DTBTestf, datei);
      ReWrite(DTBTestf);
      Writeln(DTBTestf, inttostr(handle));
      Flush(DTBTestf);
      //CloseFile(DTBTestf);
    except
      //showmessage('Es wurde Bereits eine Instanz des Programmes gestartet.');
      DTBTest:=true;
      Handle:=findwindow(nil,PChar('TB-PLayer - by crazysaem'));
      PostMessage(Handle,WM_USER,0,0);
      Application.Terminate;
      exit;
    end;
    DTBTest:=false;*)
    FHandlex1:=findwindow(nil,PChar('TB-PLayer - by crazysaem'));
    FHandlex2:=Handle;
    //Handle1:=Form2.Handle;
    //Handle1:=Form4.Handle;
    //error:=GetLastError;
    //SetForegroundWindow(FHandlex1);
    if (FHandlex1=0) or (Handle=FHandlex1) then begin
      DTBTest:=false;
    end else begin
      //Player bereits gestartet
      endee:=true;
      DTBTest:=true;
      //FHandlex1:=findwindow(nil,PChar('TB-PLayer - by crazysaem'));
      PostMessage(FHandlex1,TB_USER,0,0);
      Form1.Close;
      //Application.Terminate;
      exit;
    end;
end;

function xhochy(x:double;y:integer):extended;
var lauf:integer;
    x_result:extended;
begin
  x_result:=1;
  for lauf:=1 to y do begin
    x_result:=x_result*x;
  end;
  result:=x_result;
end;

//Funktion die nachschaut, ob ein Update vorhanden ist:
procedure updateup(y:string);
var newver: extended;
    buffer,buffer2:string;
begin

  //Version.txt vom Server laden, wenn nicht vorhanden Meldung machen:
  try
     buffer:=form1.IdHTTP1.Get('http://crazysaem.cr.funpic.de/version.txt');
  except
     if (y='yes') then showmessage('version.txt auf dem server nicht gefunden');exit;
  end;

  //Versionsnummer des aktuellen Players laden
  //buffer:='TB-Player=1,63';
  buffer2:=copy(buffer,pos('TB-Player=',buffer)+10,length(buffer));
  buffer2:=StringReplace(buffer2, ',', '', [rfReplaceAll, rfIgnoreCase]);
  //newver:=strtoint(buffer2)/((length(buffer2)-1)*10);
  newver:=strtoint(buffer2)/(xhochy(10, ((length(buffer2)-1)) ) );

  //Wenn neue Versionsnummer größer als interne, dann Meldung machen:
  if (newver>version) then showmessage('Neue Version des TB-PLayers gefunden'+#10#13+
                                             'Auf http://crazysaem.funpic.de/ oder auf'+#10#13+
                                             'http://code.google.com/p/technobaseplayer/ herunterladen!')
  else begin
       if (y='yes') then showmessage('Ihre Version des TB-PLayers ist aktuell');
  end;

  //IdHTTP sagen, das die Arbeit zunächst beendet ist:
  form1.IdHTTP1.Disconnect;
end;

// Timer, zum automatischen aktualisiern:

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  aktualisieren:=false;
  RefreshDJSongListener;
end;

//Funktionen für das Pluginsystem

procedure TForm1.PopUpClick(Sender: TObject);
var tag2:integer;
begin
  with (Sender as TMenuItem) do
    tag2:=tag;//showmessage(inttostr(tag));

  if (tag2>0) and (tag2<=pluginanzahl) then begin
    FunctionPack[tag2-1].Aufruf;
  end;
end;

procedure MakeOnClickPossible(MenuItem:PMenuItem;tag:integer);
begin
  MenuItem^.OnClick:=Form1.PopUpClick;
  MenuItem^.tag:=tag;
end;

initialization
  {$i main.lrs}
  {$i main.lrs}

end.


