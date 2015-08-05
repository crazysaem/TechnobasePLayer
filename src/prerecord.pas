unit prerecord;

{$MODE Delphi}{$H+}

interface

uses
  Classes, SysUtils, Unit4, inistuff;

procedure PreRecordInit;
procedure PreRecordSetmaxlength(length: integer);
procedure PreRecordFill(buffer: Pointer; bufferlength: integer);
function PreRecordStop:boolean;
procedure PreReocrdReset;

type TPreRecord = record
       buffer: Pointer;
       bufferlength: integer;
     end;

function PreRecordGiveData:TPreRecord;

implementation

var Radiostream:TStream;
    maxlength,totallength:integer;
    internalstop:boolean;
    sendbuffer:array of byte;

// Pre Record:

procedure PreRecordInit;
begin
  Radiostream := TMemoryStream.Create;
  maxlength:=0;
  totallength:=0;
  internalstop:=false;
end;

procedure PreReocrdReset;
begin
  Radiostream.Free;
  Radiostream := TMemoryStream.Create;
  totallength:=0;
  internalstop:=false;
end;

procedure PreRecordSetmaxlength(length: integer);
begin
  maxlength:=length*1024*PreRecordTime;
end;

function PreRecordStop:boolean;
begin
  if internalstop=false then PreRecordStop:=true else PreRecordStop:=false;
  internalstop:=true;
end;

procedure PreRecordFill(buffer: Pointer; bufferlength: integer);
var differenz,wrotebytes:integer;
    shiftbuffer:array of byte;
begin
  if internalstop=true then exit;
  if (maxlength>=(totallength+bufferlength)) then begin
    try
      Radiostream.Write(buffer^,bufferlength);
    except
    end;
    totallength:=totallength+bufferlength;
    //form4.Memo1.Lines.Add('MaxLength: '+inttostr(maxlength)+' totallength: '+inttostr(totallength)+' length: '+inttostr(length));
  end else begin
    differenz:=totallength+bufferlength-maxlength;

    Radiostream.Seek(differenz,soFromBeginning);

    setlength(shiftbuffer,totallength-differenz);

    Radiostream.read(shiftbuffer[0],totallength);

    //form4.Memo1.Lines.Add('Read: '+inttostr(readbytes));
    Radiostream.Seek(0,soFromBeginning);

    Radiostream.Write(shiftbuffer[0],(totallength-differenz));

    Radiostream.Write(buffer^,bufferlength);


    totallength:=totallength-differenz+bufferlength;
  end;
end;

function PreRecordGiveData:TPreRecord;
var  count:integer;
     send:TPreRecord;
begin
  setlength(sendbuffer,totallength);
  Radiostream.Seek(0,soFromBeginning);

  Radiostream.read(sendbuffer[0],totallength);

  send.buffer:=@sendbuffer[0];
  send.bufferlength:=totallength;
  PreRecordGiveData:=send;
end;

end.

