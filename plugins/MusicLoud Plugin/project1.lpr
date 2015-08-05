library project1;

{$MODE Delphi}{$H+}

uses
  SysUtils, Classes, Dialogs, Interfaces, Forms, StdCtrls, Controls, ComCtrls, windows,
  FileUtil, LResources, Graphics, ExtCtrls, Indy_Thread, Download_mp3showDOTeu;

{$IFDEF WINDOWS}{$R tb.res}{$ENDIF}

type

  TTBPack = record
    tbdjname,tbsongname,tbzuhorer,tbdjpicurl:string;
  end;

  TFormNew = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure ProzentChange(Prozent:integer);
    procedure StatementEvent(Statement:string);
    procedure FinishEvent(finished_event:string);

    procedure BDownloadClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
    procedure BVerzeichnisClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
    procedure BRefreshClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

  private
  public
    constructor create(AOwner : TComponent);
  end;

var
  FormNew:TFormNew;
  TBPack:TTBPack;
  BRefresh,BDownload,BVerzeichnis: TButton;
  EVerzeichnis: TEdit;
  ProgressBar:TProgressBar;
  PProgress,PFolder,PSource: TPanel;
  CBSongs,CBSource: TComboBox;
  DownloadInProgres,RefreshInProgres:boolean;
  Download_Verzeichnis:string;
  SelectDirectoryDialog1: TSelectDirectoryDialog;

  //Indy_Thread:TIndy_Thread;
  //ZIndy_Thread:PIndy_Thread;

// FormFunktions:

constructor TFormNew.create(AOwner : TComponent);
begin
  inherited Create(AOwner);
end;

procedure TFormNew.BDownloadClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Datei:TFileStream;
    //Datei2:TextFile;
    Datei_Name,Datei_URL:string;
    Indy_Thread:TIndy_Thread;
begin

  if (RefreshInProgres=true) then exit;
  if (DownloadInProgres=true) then begin
    cancel:=true;
    exit;
  end;
  cancel:=false;

  DownloadInProgres:=true;
  BDownload.Caption:='Cancel';

  //Datei_Name:=ExtractFilePath(Application.Exename)+DownloadSongs[CBSongs.itemindex].Songname+'.mp3';
  Datei_Name:=Download_Verzeichnis+DownloadSongs[CBSongs.itemindex].Songname+'.mp3';
  Datei_URL:=DownloadSongs[CBSongs.itemindex].Download_URL;

  CBSongs.Text:='Downloading Song, pls wait';

  //Indy_Thread.Download(Datei_Name,Datei_URL);
  Indy_Thread:=TIndy_Thread.Create;
  Indy_Thread.OnProzentChange:=FormNew.ProzentChange;
  Indy_Thread.OnStatementEvent:=FormNew.StatementEvent;
  Indy_Thread.OnFinishEvent:=FormNew.FinishEvent;

  Indy_Thread.DateiPfad_:=Datei_Name;
  Indy_Thread.URL_:=Datei_URL;
  Indy_Thread.event:='Download';
  Indy_Thread.Resume;

  //ZIndy_Thread:=@Indy_Thread;

end;

procedure TFormNew.BVerzeichnisClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  if SelectDirectoryDialog1.Execute then begin
    EVerzeichnis.text:=SelectDirectoryDialog1.FileName+'\';
    Download_Verzeichnis:=SelectDirectoryDialog1.FileName+'\';
  end;

end;

procedure TFormNew.BRefreshClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var searchsong,download_str,buffer,
    search_str1:string;
    lauf:integer;
    Indy_Thread:TIndy_Thread;
begin

  if (DownloadInProgres=true) or (RefreshInProgres=true) then exit;
  if TBPack.tbsongname='' then begin
    MessageBox(FormNew.Handle,'Error: Please press Refresh in the Player.', 'Error', MB_OK);
    exit;
  end;

  if TBPack.tbsongname='k.A.' then begin
    MessageBox(FormNew.Handle,'Error: "k.A." is no Songname', 'Error', MB_OK);
    exit;
  end;

  if TBPack.tbsongname='Unknown Artist - Unknown Title' then begin
    MessageBox(FormNew.Handle,'Error: "Unknown Artist - Unknown Title" is no Songname', 'Error', MB_OK);
    exit;
  end;

  RefreshInProgres:=true;
  BRefresh.Caption:='Wait..';
  BDownload.Caption:='Wait..';

  CBSongs.Text:='Getting the SongList, pls wait';

  searchsong:=TBPack.tbsongname;

  //MessageBox(FormNew.Handle,PChar(MakeDownloadStr_mp3showDOTeu(searchsong)), 'Message', MB_OK);

  Indy_Thread:=TIndy_Thread.Create;
  Indy_Thread.OnProzentChange:=FormNew.ProzentChange;
  Indy_Thread.OnStatementEvent:=FormNew.StatementEvent;
  Indy_Thread.OnFinishEvent:=FormNew.FinishEvent;

  Indy_Thread.Donwload_Page:=CBSource.ItemIndex;
  Indy_Thread.songname_:=searchsong;
  Indy_Thread.event:='Refresh';
  Indy_Thread.Resume;
  //Indy_Thread.Refresh(searchsong);

end;

procedure TFormNew.ProzentChange(Prozent:integer);
begin
  ProgressBar.Position:=Prozent;
end;

procedure TFormNew.StatementEvent(Statement:string);
begin
  CBSongs.Text:=Statement;

  if Statement='Error while Refreshing.' then begin
    RefreshInProgres:=false;
    BRefresh.Caption:='Refresh';
    BDownload.Caption:='Download';

    CBSongs.Items.Clear;
    CBSongs.Text:=Statement;
  end;

  if Statement='Song-Download Error :(' then begin
    DownloadInProgres:=false;
    BDownload.Caption:='Download';
  end;
end;

procedure TFormNew.FinishEvent(finished_event:string);
var lauf:integer;
    song:string; //Maxlength:29
begin
  if finished_event='Refresh' then begin
    RefreshInProgres:=false;
    BRefresh.Caption:='Refresh';
    BDownload.Caption:='Download';

    CBSongs.Items.Clear;

    if songcount<>0 then begin
      for lauf:=1 to songcount do begin
        song:=DownloadSongs[lauf-1].Songname;
        if length(song)>53 then song:=copy(song,1,52);
        CBSongs.Items.Add(song+' '+DownloadSongs[lauf-1].song_length);
      end;
    end;

    if songcount=0 then begin
      CBSongs.Items.Clear;
      CBSongs.Text:='No Songs found, sorry';
    end else begin
      CBSongs.Text:='Songs found, please choose 1 and click Download';
    end;

  end;

  if finished_event='Download' then begin
    //Indy_Thread.Free;
    DownloadInProgres:=false;
    BDownload.Caption:='Download';
    if cancel=false then
      CBSongs.Text:='Song-Download Complete :)'
    else
      CBSongs.Text:='Song-Download abgebrochen.';
    cancel:=false;
  end;

  //Indy_Thread.Destroy;
end;

procedure TFormNew.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //showmessage('TEST');
end;

function Initialisierung():boolean; stdcall;
begin
  //ShowMessage('Hello World');

  FormNew:=TFormNew.Create(nil);
  FormNew.Caption:='Music-Downloader v1.0';
  FormNew.width:=342;
  FormNew.height:=133;
  FormNew.Left:=trunc(screen.Width/2-FormNew.Width/2);
  FormNew.top:=trunc(screen.Height/2-FormNew.Height/2);
  FormNew.BorderStyle:=bsSingle;
  //FormNew.Icon.LoadFromResourceName(hInstance,'TBICON');
  FormNew.Icon.Handle := Loadicon(HInstance, 'TBICON');
  FormNew.Color:=TColor($00F2E1BD);

  BDownload:=TButton.Create(nil);
  BDownload.left:=261;
  BDownload.Top:=8;
  BDownload.Caption:='Download';
  BDownload.Parent:=FormNew;
  BDownload.OnMouseUp:=FormNew.BDownloadClick;

  BVerzeichnis:=TButton.Create(nil);
  BVerzeichnis.left:=285;
  BVerzeichnis.Top:=99;
  BVerzeichnis.width:=51;
  BVerzeichnis.Caption:='[..]';
  BVerzeichnis.OnMouseUp:=FormNew.BVerzeichnisClick;
  BVerzeichnis.Parent:=FormNew;

  BRefresh:=TButton.Create(nil);
  BRefresh.OnMouseUp:=FormNew.BRefreshClick;
  BRefresh.left:=8;
  BRefresh.Top:=8;
  BRefresh.Caption:='Refresh';
  BRefresh.Parent:=FormNew;

  CBSongs:=TComboBox.create(nil);
  CBSongs.Left:=8;
  CBSongs.top:=40;
  CBSongs.width:=328;
  CBSongs.Text:='Press Refresh to List Links here, then Pick 1, Then Download';
  CBSongs.ItemIndex:=-1;
  //CBSongs.Style:=csDropDownList;
  CBSongs.Font.Name:='Arial';
  CBSongs.Font.Size:=10;
  //CBSongs.ReadOnly:=true;
  CBSongs.Parent:=FormNew;

  CBSource:=TComboBox.create(nil);
  CBSource.Left:=145;
  CBSource.top:=10;
  CBSource.width:=100;
  CBSource.Items.Add('musicloud.fm');
  CBSource.Items.Add('mp3show.eu');
  CBSource.Style:=csDropDownList;
  CBSource.Font.Name:='Arial';
  CBSource.Font.Size:=10;
  CBSource.ItemIndex:=0;
  CBSource.Parent:=FormNew;

  PProgress:=TPanel.Create(nil);
  PProgress.BevelOuter:=bvNone;
  PProgress.width:=49;
  PProgress.height:=16;
  PProgress.left:=8;
  PProgress.top:=72;
  PProgress.caption:='Progress:';
  PProgress.Parent:=FormNew;
  PProgress.Visible:=true;

  PFolder:=TPanel.Create(nil);
  PFolder.BevelOuter:=bvNone;
  PFolder.width:=37;
  PFolder.height:=16;
  PFolder.left:=8;
  PFolder.top:=104;
  PFolder.caption:='Folder:';
  PFolder.Parent:=FormNew;
  PFolder.Visible:=true;

  PSource:=TPanel.Create(nil);
  PSource.BevelOuter:=bvNone;
  PSource.width:=40;
  PSource.height:=16;
  PSource.left:=100;
  PSource.top:=15;
  PSource.caption:='Source:';
  PSource.Parent:=FormNew;
  PSource.Visible:=true;

  ProgressBar:=TProgressBar.Create(nil);
  ProgressBar.left:=72;
  ProgressBar.top:=72;
  ProgressBar.width:=264;
  ProgressBar.height:=20;
  ProgressBar.Min:=0;
  ProgressBar.Max:=100;
  ProgressBar.Parent:=FormNew;

  EVerzeichnis:=TEdit.Create(nil);
  EVerzeichnis.left:=72;
  EVerzeichnis.top:=101;
  EVerzeichnis.width:=208;
  //EVerzeichnis.text:='C:\';
  EVerzeichnis.text:=ExtractFilePath(Application.Exename);
  EVerzeichnis.ReadOnly:=true;
  EVerzeichnis.parent:=FormNew;
  (*
  Indy_Thread:=TIndy_Thread.Create;
  Indy_Thread.OnProzentChange:=FormNew.ProzentChange;
  Indy_Thread.OnStatementEvent:=FormNew.StatementEvent;
  Indy_Thread.OnFinishEvent:=FormNew.FinishEvent;*)

  SelectDirectoryDialog1 := TSelectDirectoryDialog.Create(nil);
  SelectDirectoryDialog1.Title:='Choose the Download Directory';
  SelectDirectoryDialog1.InitialDir := ExtractFilePath(Application.Exename);

  RedrawWindow(FormNew.Handle, 0, 0, RDW_INVALIDATE or RDW_ERASE or RDW_UPDATENOW or RDW_ALLCHILDREN or RDW_FRAME);

  songcount:=0;
  TBPack.tbdjname:='';
  TBPack.tbsongname:='';
  TBPack.tbzuhorer:='';
  TBPack.tbdjpicurl:='';
  DownloadInProgres:=false;
  RefreshInProgres:=false;

  Result:=true;
end;

procedure Give_TBPack(djname,songname,zuhorer,djpicurl:string); stdcall;
begin
  TBPack.tbdjname:=djname;
  TBPack.tbsongname:=songname;
  TBPack.tbzuhorer:=zuhorer;
  TBPack.tbdjpicurl:=djpicurl;

  //EVerzeichnis.text:=TBPack.tbdjname+' '+TBPack.tbsongname+' '+TBPack.tbzuhorer;
end;

function Aufruf():boolean; stdcall;
begin
  FormNew.Visible:=true;
  Result:=true;
end;

function Ende():boolean; stdcall;
begin
  FormNew.Free;
  Result:=true;
end;

function GetName():string; stdcall;
begin
  Result:='Download the Song';
end;

exports
  Initialisierung index 1,
  Give_TBPack index 2,
  Aufruf index 3,
  Ende index 4,
  GetName index 5;

begin
  {$I project1.lrs}
end.

