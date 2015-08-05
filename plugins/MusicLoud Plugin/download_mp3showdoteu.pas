unit Download_mp3showDOTeu;

{$MODE Delphi}{$H+}

interface

uses
  Classes, SysUtils;

function MakeDownloadStr_mp3showDOTeu(songname:string):string;
procedure GetSongList_mp3showDOTeu(buffer:string);

implementation
  uses Indy_Thread;

function MakeDownloadStr_mp3showDOTeu(songname:string):string;
var download_str:string;
begin
  songname:=StringReplace(songname, ' ', '-', [rfReplaceAll, rfIgnoreCase]);
  songname:=StringReplace(songname, '&', '', [rfReplaceAll, rfIgnoreCase]);

  download_str:='http://mp3show.eu/index.php?search='+songname+'&page=1&type=mp3';

  result:=download_str;
end;

procedure GetSongList_mp3showDOTeu(buffer:string);
var search_str1,name,delete:string;
    //Datei:TextFile;
begin
  //search_str1:='<table border="1" style="border: 2px solid #FFFFFF" width="750" align="center"';
  search_str1:='<table border="1" style="border:';
  songcount:=0;
  (*
  AssignFile(Datei, 'Test.txt');
  ReWrite(Datei);

  WriteLn(Datei, buffer);

  CloseFile(Datei);*)

  while pos(search_str1,buffer)<>0 do begin
    songcount:=songcount+1;

    buffer:=copy(buffer,pos(search_str1,buffer)+10,length(buffer));
    buffer:=copy(buffer,pos('<a href="',buffer)+9,length(buffer));

    setlength(DownloadSongs,songcount);
    //DownloadSongs[songcount-1].Download_URL:=copy(buffer,1,pos('">',buffer)-1);
    //DownloadSongs[songcount-1].Download_URL:=StringReplace(DownloadSongs[songcount-1].Download_URL, 'info.php?', 'download.php?', [rfReplaceAll, rfIgnoreCase]);

    buffer:=copy(buffer,pos('">',buffer)+2,length(buffer));
    name:=copy(buffer,1,pos('</a>',buffer)-1);

    while pos('&#',name)<>0 do begin
      delete:=copy(name,pos('&#',name),6);
      name:=StringReplace(name, delete, '', [rfReplaceAll, rfIgnoreCase]);
    end;

    DownloadSongs[songcount-1].Songname:=name;

    buffer:=copy(buffer,pos('Playtime:',buffer)+10,length(buffer));
    DownloadSongs[songcount-1].song_length:=copy(buffer,pos(':',buffer)-2,5);

    DownloadSongs[songcount-1].Download_URL:=copy(buffer,pos('http://mp3show.eu/download.php?',buffer),length(buffer));
    DownloadSongs[songcount-1].Download_URL:=copy(DownloadSongs[songcount-1].Download_URL,1,pos('">',DownloadSongs[songcount-1].Download_URL)-1);

    if songcount>100 then break;
  end;

end;

end.

