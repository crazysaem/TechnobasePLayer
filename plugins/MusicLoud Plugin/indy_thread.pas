unit Indy_Thread;

{$MODE Delphi}{$H+}

interface

uses
  Classes, SysUtils, IdHTTP, IdAntiFreeze, IdComponent, Download_mp3showDOTeu, Download_musicloudDOTfm, windows;

type
  TGiveProzentEvent = procedure(Prozent:integer) of Object;
  TGiveStatementEvent = procedure(Statement:string) of Object;
  TFinishEvent = procedure(finished_event:string) of Object;

  TDownloadSongs = record
    Songname,Download_URL,song_length:string;
  end;

  TIndy_Thread = class(TThread)
  private
    //Prozent:integer;

    FOnProzentChange: TGiveProzentEvent;
      procedure SetProzent(Prozent:integer);
    FOnStatementEvent: TGiveStatementEvent;
      procedure SetStatement(Statement:string);
    FOnFinishEvent: TFinishEvent;
      procedure Finished(finished_event:string);

    IdHTTP1: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;

    procedure IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);

    procedure Refresh(songname:string);
    procedure Download(DateiPfad,URL:string);
  protected
    procedure Execute; override;
  public
    event:string;
    Donwload_Page:integer;
    songname_,DateiPfad_,URL_:string;
    Constructor Create;
    Destructor Destroy; override;
    property OnProzentChange: TGiveProzentEvent read FOnProzentChange write FOnProzentChange;
    property OnStatementEvent: TGiveStatementEvent read FOnStatementEvent write FOnStatementEvent;
    property OnFinishEvent: TFinishEvent read FOnFinishEvent write FOnFinishEvent;
  end;

  //PIndy_Thread = ^TIndy_Thread;

var
  songcount:integer;
  AWorkCountMax_global:Int64;
  DownloadSongs:array of TDownloadSongs;
  cancel:boolean;

implementation
  //uses project1.lpr;

Constructor TIndy_Thread.Create;
begin
  //Initialisirungsteil...
  FreeOnTerminate:=True;
  inherited Create(true);

  IdHTTP1:=TIdHTTP.Create(nil);
  IdHTTP1.HandleRedirects:=true;
  Idhttp1.Request.UserAgent:='Mozilla/4.0';
  Idhttp1.Request.Connection:='Keep-Alive';
  IdHTTP1.ConnectTimeout := 8000;
  IdHTTP1.ReadTimeout := 8000;

  IdHTTP1.OnWorkBegin:=IdHTTP1WorkBegin;
  IdHTTP1.OnWork:=IdHTTP1Work;

  IdAntiFreeze1:=TIdAntiFreeze.Create(nil);

  Donwload_Page:=-1;
  cancel:=false;
end;

destructor TIndy_Thread.Destroy;
begin
  IdHTTP1.Free;
  IdAntiFreeze1.Free;
  inherited;
end;


procedure TIndy_Thread.Execute;
begin
  FreeOnTerminate:=True;
  if event='Refresh' then Refresh(songname_);
  if event='Download' then Download(DateiPfad_,URL_);
end;

procedure TIndy_Thread.Refresh(songname:string);
var download_str,buffer:string;
begin
  SetStatement('Getting the SongList, pls wait');

  case Donwload_Page of
  0:download_str:=MakeDownloadStr_musicloudDOTfm(songname);
  1:download_str:=MakeDownloadStr_mp3showDOTeu(songname);
  end;

  try
    buffer:=IdHTTP1.Get(download_str);
  except
    SetStatement('Error while Refreshing.');
    songcount:=0;
    //Finished('Refresh');
    exit;
  end;

  case Donwload_Page of
  0:GetSongList_musicloudDOTfm(buffer);
  1:GetSongList_mp3showDOTeu(buffer);
  end;

  Finished('Refresh');

end;

procedure TIndy_Thread.Download(DateiPfad,URL:string);
var Datei:TFileStream;
begin
  Datei:=TFilestream.create(DateiPfad, fmcreate);

  try
    idhttp1.Get(URL, Datei);
  except
    Datei.free;
    SetStatement('Song-Download Error :(');
    //CBSongs.ItemIndex:=-1;
    if FileExists(PChar(DateiPfad)) then DeleteFile(PChar(DateiPfad));
    //Finished('Download');
    exit;
  end;

  Datei.free;

  if (cancel=true) then begin
    //cancel:=false;
    if FileExists(PChar(DateiPfad)) then DeleteFile(PChar(DateiPfad));
    SetProzent(0);
  end;

  Finished('Download');

end;

procedure TIndy_Thread.SetProzent(Prozent:integer);
begin
  if Assigned(FOnProzentChange) then
  begin
    FOnProzentChange(Prozent);
  end;
end;

procedure TIndy_Thread.SetStatement(Statement:string);
begin
  if Assigned(FOnStatementEvent) then
  begin
    FOnStatementEvent(Statement);
  end;
end;

procedure TIndy_Thread.Finished(finished_event:string);
begin
  if Assigned(FOnFinishEvent) then
  begin
    FOnFinishEvent(finished_event);
  end;
end;

//Indy Funktionen:
procedure TIndy_Thread.IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  //Application.ProcessMessages;
  SetProzent(trunc((AWorkCount/AWorkCountMax_global)*100));
  if (cancel=true) then idHttp1.Disconnect;
end;

procedure TIndy_Thread.IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  AWorkCountMax_global:=AWorkCountMax;
  SetProzent(0);
end;

end.

