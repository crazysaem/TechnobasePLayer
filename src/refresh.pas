unit Refresh;

{$MODE Delphi}{$H+}

interface

uses
  Classes, SysUtils, dialogs, inistuff;

type

  TTBPack = record
    tbdjname,tbsongname,tbzuhorer,tbdjpicurl:string;
  end;

function XMLFilter(buffer:string):TTBPack;
function DownloadDJPic(path,url:string):string;

implementation

  uses Unit4, main;

function XMLFilter(buffer:string):TTBPack;
var buffer1,buffer2,buffer3,datetime,djpicurl,releaseurl,djprofilurl:string;
begin

  //DJ aus der XML filtern

  djname:=copy(buffer,pos('<moderator>',buffer)+11,pos('</moderator>',buffer));
  djname:=copy(djname,1,pos('</moderator>',djname)-1);

  buffer2:=copy(buffer,pos('<show>',buffer)+6,pos('</show>',buffer));
  buffer2:=copy(buffer2,1,pos('</show>',buffer2)-1);

  buffer3:=copy(buffer,pos('<style>',buffer)+7,pos('</style>',buffer));
  buffer3:=copy(buffer3,1,pos('</style>',buffer3)-1);

  if djname='' then begin
    djname:='Playlist mit Mixed Styles';
  end else begin
    djname:=djname+' mit "'+buffer2+'" ('+buffer3+')';
  end;

  //exit;

  if length(djname)>70 then djname:=copy(djname,1,70);

  //Song aus der XML filtern

  songname:=copy(buffer,pos('<artist>',buffer)+8,pos('</artist>',buffer));
  songname:=copy(songname,1,pos('</artist>',songname)-1);

  buffer2:=copy(buffer,pos('<song>',buffer)+6,pos('</song>',buffer));
  buffer2:=copy(buffer2,1,pos('</song>',buffer2)-1);

  // Song & Artist zusammenführen:

  if songname='' then begin
    songname:='k.A.';
  end else begin
    songname:=songname+' - '+buffer2;
  end;

  if length(songname)>70 then songname:=copy(songname,1,70);

  //Zuhörer aus XML filtern

  zuhorer:=copy(buffer,pos('<listener>',buffer)+10,pos('</listener>',buffer));
  zuhorer:=copy(zuhorer,1,pos('</listener>',zuhorer)-1);

  case  Form1.CBSender.ItemIndex of
    0:zuhorer:='TechnoBase: '+zuhorer;
    1:zuhorer:='HouseTime: '+zuhorer;
    2:zuhorer:='HardBase: '+zuhorer;
    3:zuhorer:='TranceBase: '+zuhorer;
    4:zuhorer:='CoreTime: '+zuhorer;
  end;

  //Sonderzeichen aussortieren:

  djname:=StringReplace(djname,'&amp;','&',[rfReplaceAll]);
  songname:=StringReplace(songname,'&amp;','&',[rfReplaceAll]);

  djname:=StringReplace(djname,'&auml;','ä',[rfReplaceAll]);
  songname:=StringReplace(songname,'&auml;','ä',[rfReplaceAll]);

  djname:=StringReplace(djname,'&Auml;','Ä',[rfReplaceAll]);
  songname:=StringReplace(songname,'&Auml;','Ä',[rfReplaceAll]);

  djname:=StringReplace(djname,'&ouml;','ö',[rfReplaceAll]);
  songname:=StringReplace(songname,'&ouml;','ö',[rfReplaceAll]);

  djname:=StringReplace(djname,'&Ouml;','Ö',[rfReplaceAll]);
  songname:=StringReplace(songname,'&Ouml;','Ö',[rfReplaceAll]);

  djname:=StringReplace(djname,'&uuml;','ü',[rfReplaceAll]);
  songname:=StringReplace(songname,'&uuml;','ü',[rfReplaceAll]);

  djname:=StringReplace(djname,'&Uuml;','Ü',[rfReplaceAll]);
  songname:=StringReplace(songname,'&Uuml;','Ü',[rfReplaceAll]);

  djname:=StringReplace(djname,'&szlig;','ß',[rfReplaceAll]);
  songname:=StringReplace(songname,'&szlig;','ß',[rfReplaceAll]);

  //DJ-Bild-URL ausfiltern:
  djpicurl:=copy(buffer,pos('<picture>',buffer)+9,pos('</picture>',buffer)-1);
  djpicurl:=copy(djpicurl,1,pos('</picture>',djpicurl)-1);

  //Release-Link aus der URL filtern:
  releaseurl:=copy(buffer,pos('<release>',buffer)+9,pos('</release>',buffer)-1);
  releaseurl:=copy(releaseurl,1,pos('</release>',releaseurl)-1);
  global_releaseurl:=releaseurl;

  //DJ Profil-Link rausfiltern:
  djprofilurl:=copy(buffer,pos('<link>',buffer)+6,pos('</link>',buffer)-1);
  djprofilurl:=copy(djprofilurl,1,pos('</link>',djprofilurl)-1);
  global_djprofilurl:=djprofilurl;

  //In Memo füllen (Um nachzuguckn ne .. ? )

  datetime:=DateToStr( Date ) + ' ' + TimeToStr( Time );
  if form4.Memo1.Lines[form4.Memo1.Lines.Count-2]<>songname then begin
    form4.Memo1.Lines.Add('');
    form4.Memo1.Lines.Add(datetime);
    form4.Memo1.Lines.Add(djname);
    form4.Memo1.Lines.Add(songname);
    form4.Memo1.Lines.Add(zuhorer);
  end;

  //Fertige Strings zurückggeben:

  djname:=StringReplace(djname,'&','&&',[rfReplaceAll]);
  songname:=StringReplace(songname,'&','&&',[rfReplaceAll]);

  XMLFilter.tbdjname:=djname;
  XMLFilter.tbsongname:=songname;
  XMLFilter.tbzuhorer:=zuhorer;
  XMLFilter.tbdjpicurl:=djpicurl;

end;

function DownloadDJPic(path,url:string):string;
var TBDJPic:TFileStream;
    ext:string;
    buffer:Array[0..9] of byte;
begin
  TBDJPic:=TFileStream.Create(path+'.xxx', fmCreate);
  //Idhttp1.Request.UserAgent := 'Mozilla/4.0';
  //Idhttp1.Request.Connection := 'Keep-Alive';
  try
    Form1.Idhttp1.Get(url,TBDJPic);
  except
    result:='error';
    TBDJPic.free;
    exit;
  end;
  TBDJPic.free;

  TBDJPic:=TFileStream.Create(path+'.xxx',fmOpenRead);
  TBDJPic.Read(buffer[0],10);

  //if copy(read_data,2,3)='PNG' then ext:='png';
  //if copy(read_data,6,4)='JFIF' then ext:='jpg';
  if (chr(buffer[1])='P') and (chr(buffer[2])='N') and (chr(buffer[3])='G') then ext:='png';
  if (chr(buffer[6])='J') and (chr(buffer[7])='F') and (chr(buffer[8])='I') and (chr(buffer[9])='F') then ext:='jpg';
  TBDJPic.free;
  //sleep(10);
  //showmessage(booltostr(RenameFile(filename+'.xxx',filename+'.'+ext)));
  RenameFile(path+'.xxx',path+'.'+ext);
  sleep(1);
  result:=ext;

end;

end.

