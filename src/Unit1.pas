unit Unit1;

{$MODE Delphi}

interface

uses
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, {bass, bass_aac,} StdCtrls, ExtCtrls, Menus, {CoolTrayIcon,} ShellApi,
  IdURI, Unit4;

function TBDateiLesen():longint;
function PosInFile(Str,FileName:string):integer;
function bLeseClick(ausw:integer;trackl:string):string;
function unescape(test:string):string;

implementation

function TBDateiLesen():longint;
var Stream:TStream;buffer:longint;
begin
Stream := TFileStream.Create('C:\temp\tracklist.txt', fmOpenRead);
Stream.Read(buffer,23563);
Stream.Free;
TBDateiLesen:=buffer;
end;

function unescape(test:string):string;
var buffer1,buffer2:string;
    escap:integer;
begin
escap:=100;
if pos('%26',test)<>0 then begin repeat
buffer1:=copy(test,1,pos('%26',test)-1);
buffer2:=copy(test,pos('%26',test)+3,length(test));
test:=buffer1+'&&'+buffer2;escap:=escap-1;
until (pos('%26',test)=0) or (escap<0) end;
unescape:=TIdURI.Urldecode(test);
end;

function bLeseClick(ausw:integer;trackl:string):string;
var
  stream : TFileStream;
  i,laenge      : integer;
  b      : byte;
  tbstr,buffer1,buffer2,buffer3:string;
begin
  if ausw=1 then begin
  //laenge:=PosInFile('%3c%66%6f%6e%74%20%63%6f%6c%6f%72%3d%22%23%46%46%44%44%38%32%22%3e','C:\temp\tracklist.txt');
  laenge:=pos('%3c%66%6f%6e%74%20%63%6f%6c%6f%72%3d%22%23%46%46%44%44%38%32%22%3e',trackl)+66;
  //stream := TFileStream.Create('C:\temp\tracklist.txt',fmOpenRead);
  tbstr:='';

  {for i := 1 to (laenge+66) do
  begin
    //stream.read(b,1);
    stream.ReadBuffer(b,1);
    //tbstr:=tbstr+char(b);//IntToStr(b);
    //lbEin.Items.Add(IntToStr(b));
  end;
    for i := 1 to 600 do
  begin
    //stream.read(b,1);
    stream.ReadBuffer(b,1);
    tbstr:=tbstr+char(b);//IntToStr(b);
     //lbEin.Items.Add(IntToStr(b));
  end;  }
  tbstr:=copy(trackl,laenge,600);
  //stream.Free;
  bLeseClick:=tbstr;
  end;
  if ausw=2 then begin
  laenge:=240+Pos('%3c%64%69%76%20%73%74%79%6c%65%3d%22%77%69%64%74%68%3a%33%34%35%70%78%3b%66%6c%6f%61%74%3a%6c%65%66%74%3b%20%6d%61%72%67%69%6e%2d%74%6f%70%3a%31%31%70%78%3b%20%6f%76%65%72%66%6c%6f%77%3a%68%69%64%64%65%6e%22%3e',trackl);
  //stream := TFileStream.Create('C:\temp\tracklist.txt',fmOpenRead);
  //tbstr:='';
  {
  for i := 1 to (laenge+240) do
  begin
    //stream.read(b,1);
    stream.ReadBuffer(b,1);
    //tbstr:=tbstr+char(b);//IntToStr(b);
    //lbEin.Items.Add(IntToStr(b));
  end;
    for i := 1 to 150 do
  begin
    //stream.read(b,1);
    stream.ReadBuffer(b,1);
    tbstr:=tbstr+char(b);//IntToStr(b);
    //lbEin.Items.Add(IntToStr(b));
  end;
  stream.Free; }
  tbstr:=copy(trackl,laenge,150);
  bLeseClick:=tbstr;
  end;

  if ausw=3 then begin
  laenge:=Pos('Zuhörer',trackl)+176;
  //stream := TFileStream.Create('C:\temp\tracklist.txt',fmOpenRead);
  //tbstr:='';
  {
  for i := 1 to (laenge+176) do
  begin
    //stream.read(b,1);
    stream.ReadBuffer(b,1);
    //tbstr:=tbstr+char(b);//IntToStr(b);
    //lbEin.Items.Add(IntToStr(b));
  end;
    for i := 1 to 4 do
  begin
    //stream.read(b,1);
    stream.ReadBuffer(b,1);
    tbstr:=tbstr+char(b);//IntToStr(b);
    //lbEin.Items.Add(IntToStr(b));
  end;
  stream.Free; }
  tbstr:=copy(trackl,laenge,15);
  tbstr:=copy(tbstr,1,pos('<',tbstr)-1);
  bLeseClick:=tbstr;
  end;

  if ausw=4 then begin
  //form4.memo1.lines.add(trackl);
  buffer1:=copy(trackl,Pos('%3c%61%20%68%72%65%66%3d%22%2f%6d%65%6d%62%65%72%2f',trackl),600);
  buffer2:=copy(buffer1,pos('%3e',buffer1)+3,length(buffer1));

  bLeseClick:=buffer2;
  end;

  if ausw=5 then begin
  //form4.memo1.lines.add(trackl);
  buffer1:='';
  buffer1:=copy(trackl,Pos('%3c%64%69%76%20%73%74%79%6c%65%3d%22%77%69%64%74%68%3a%33%34%35%70%78%3b',trackl)-600,1200);
  //buffer2:=copy(buffer1,pos('%3e',buffer1)+3,length(buffer1));

  bLeseClick:=buffer1;
  end;

  if ausw=6 then begin
  buffer1:=copy(trackl,Pos('Zuhörer',trackl),600);
  buffer2:=copy(buffer1,Pos('HouseTime',buffer1),length(buffer1));
  buffer3:=copy(buffer2,pos('&nbsp;&nbsp;',buffer2)+12,length(buffer2));

  bLeseClick:=buffer3;
  end;

  if ausw=7 then begin
  buffer1:=copy(trackl,180+Pos('%3c%64%69%76%20%69%64%3d%22%6f%6e%41%69%72%22%20',trackl),600);
  buffer2:=copy(buffer1,pos('%6d%65%6d%62%65%72',buffer1),length(buffer1));

  //form4.Memo1.Lines.Add(unescape(buffer2));

  bLeseClick:=buffer2;
  end;

  if ausw=8 then begin
  laenge:=240+Pos('%3c%64%69%76%20%73%74%79%6c%65%3d%22%77%69%64%74%68%3a%33%34%35%70%78%3b%66%6c%6f%61%74%3a%6c%65%66%74%3b%20%6d%61%72%67%69%6e%2d%74%6f%70%3a%31%31%70%78%3b%20%6f%76%65%72%66%6c%6f%77%3a%68%69%64%64%65%6e%22%3e',trackl);

  tbstr:=copy(trackl,laenge,150);
  bLeseClick:=tbstr;
  end;

  if ausw=9 then begin
  buffer1:=copy(trackl,Pos('Zuhörer',trackl),600);
  buffer2:=copy(buffer1,Pos('HardBase',buffer1),length(buffer1));
  buffer3:=copy(buffer2,pos('&nbsp;&nbsp;',buffer2)+12,length(buffer2));

  bLeseClick:=buffer3;
  end;

  if ausw=10 then begin
  buffer1:=copy(trackl,180+Pos('%3c%64%69%76%20%69%64%3d%22%6f%6e%41%69%72%22%20',trackl),600);
  buffer2:=copy(buffer1,pos('%6d%65%6d%62%65%72',buffer1),length(buffer1));

  form4.Memo1.Lines.Add(unescape(buffer1));
  form4.Memo1.Lines.Add(unescape(buffer2));

  bLeseClick:=buffer2;
  end;

  if ausw=11 then begin
  laenge:=240+Pos('%3c%64%69%76%20%73%74%79%6c%65%3d%22%77%69%64%74%68%3a%33%34%35%70%78%3b%66%6c%6f%61%74%3a%6c%65%66%74%3b%20%6d%61%72%67%69%6e%2d%74%6f%70%3a%31%31%70%78%3b%20%6f%76%65%72%66%6c%6f%77%3a%68%69%64%64%65%6e%22%3e',trackl);

  tbstr:=copy(trackl,laenge,150);
  bLeseClick:=tbstr;
  end;

  if ausw=12 then begin
  buffer1:=copy(trackl,Pos('Zuhörer',trackl),600);
  buffer2:=copy(buffer1,Pos('TranceBase',buffer1),length(buffer1));
  buffer3:=copy(buffer2,pos('&nbsp;&nbsp;',buffer2)+12,length(buffer2));

  bLeseClick:=buffer3;
  end;

end;

function PosInFile(Str,FileName:string):integer;
var
   Buffer : array [0..1023] of char;
   BufPtr,BufEnd:integer;
   F:File;
   Index : integer;
   Increment : integer;
   c : char;

function NextChar : char;
 begin
   if BufPtr>=BufEnd then
   begin
     BlockRead(F,Buffer,1024,BufEnd);
     BufPtr := 0;
     //Form1.ProgressBar1.Position := FilePos(F);
     Application.ProcessMessages;
   end;
   Result := Buffer[BufPtr];
   Inc(BufPtr);
 end;

 begin
   Result := -1;
   AssignFile(F,FileName);
   Reset(F,1);
   //Form1.ProgressBar1.Max := FileSize(F);
   BufPtr:=0;
   BufEnd:=0;
   Index := 0;
   Increment := 1;
   repeat
     c:=NextChar;
     if c=Str[Increment] then
       Inc(Increment)
     else
     begin
       Inc(Index,Increment);
       Increment := 1;
     end;
     if Increment=(Length(Str)+1) then
     begin
       Result := Index;
       break;
     end;
   until BufEnd = 0;
   CloseFile(F);
   //Form1.ProgressBar1.Position := 0;
 end;         

end.
 
