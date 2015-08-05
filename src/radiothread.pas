unit RadioThread;

{$MODE Delphi}{$H+}

interface

uses
  messages, dialogs, forms, Classes, SysUtils, bass, bass_aac, prerecord, inistuff;

function StartRecord(loc:string):boolean;
function StopRecord:boolean;

type
    TShowIcontypeEvent = procedure(Icontype: String) of Object;
    PHSTREAM = ^HSTREAM;

    TRadioThread = class(TThread)
    private
      Icontype:string;
      FOnIconChange: TShowIcontypeEvent;
      procedure SetPlayIcon;
    protected
      procedure Execute; override;
    public
      Pstream:PHSTREAM;
      URL:string;
      aac:boolean;
      volume:double;
      Constructor Create;
      property OnIconChange: TShowIcontypeEvent read FOnIconChange write FOnIconChange;
    end;

implementation

  uses unit4;

var
  recstream:boolean;
  TBRecord:TFileStream;
  location:string;

Constructor TRadioThread.Create;
begin
  //Initialisirungsteil...
  FreeOnTerminate := True;
  inherited Create(true);
  volume:=0.5;

  recstream:=false;
end;

procedure TRadioThread.SetPlayIcon;
// Diese Methode wird vom MainThread ausgeführt und kann deshalb auf alle GUI Elemente zugreifen
begin
  if Assigned(FOnIconChange) then
  begin
    FOnIconChange(Icontype);
  end;
end;

procedure DownloadProc(buffer: Pointer; length: DWORD; user: DWORD); stdcall;
var PreRecord:TPreRecord;
    wrotebyte:integer;
begin
  if (recstream=true) then begin
    if (PreRecordStop=true) and (AktivatePreRecord=true) then begin

      PreRecord:=PreRecordGiveData;
      wrotebyte:=TBRecord.Write(PreRecord.buffer^,PreRecord.bufferlength);

    end;
    try
      TBRecord.Write(buffer^,length);
    except
    end;
  end else begin
    if AktivatePreRecord=true then PreRecordFill(buffer,length);
  end;
end;

procedure TRadioThread.Execute;
var  Len, Progress: DWORD;
begin
     Icontype:='buffer';
     Synchronize(SetPlayIcon);

     if Pstream^ <> 0 then BASS_StreamFree(Pstream^);

     if aac then begin
       Pstream^:=BASS_AAC_StreamCreateURL(PCHAR(URL), 0, 0, @DownloadProc, 0);
     end else begin
       Pstream^:=BASS_StreamCreateUrl(PCHAR(URL), 0, 0, @DownloadProc, 0);
     end;

     repeat
           len := BASS_StreamGetFilePosition(Pstream^, BASS_FILEPOS_END);
           if (len = DW_Error) then break; // something's gone wrong! (eg. BASS_Free called)
           progress := (BASS_StreamGetFilePosition(Pstream^, BASS_FILEPOS_DOWNLOAD) - BASS_StreamGetFilePosition(Pstream^, BASS_FILEPOS_CURRENT))
                    * 100 div len;
     until progress >= 100;

     if (len = DW_Error) then begin
        PreRecordStop;
        Icontype:='play';
        Synchronize(SetPlayIcon);
        exit;
     end;

     BASS_ChannelSetAttribute(Pstream^,BASS_ATTRIB_VOL,volume);

     BASS_CHANNELPlay(Pstream^, false);

     Icontype:='stop';
     Synchronize(SetPlayIcon);
end;

function StartRecord(loc:string):boolean;
begin
  location:=loc;

  try
    TBRecord:=TFileStream.Create(location, fmCreate);
  except
    StartRecord:=false;
    exit;
  end;

  recstream:=true;
  StartRecord:=true;
end;

function StopRecord:boolean;
var locationlog,text:string;
    LogFile:TextFile;
    lauf:integer;
begin
  recstream:=false;
  TBRecord.Free;

  if SaveLog=true then begin
    locationlog:=copy(location,0,length(location)-4)+' Log.txt';
    AssignFile(LogFile, locationlog);
    ReWrite(LogFile);

    if AktivatePreRecord=true then WriteLn(LogFile, 'PreRecordTime: '+inttostr(PreRecordTime)+' Sekunden');

    for lauf:=3 to form4.Memo1.Lines.Count-1 do begin
      text:=form4.Memo1.Lines[lauf];
      WriteLn(LogFile, text);
    end;

    CloseFile(LogFile);

  end;

end;

end.

