unit Download_musicloudDOTfm;

{$MODE Delphi}{$H+}

interface

uses
  Classes, SysUtils, windows;

function MakeDownloadStr_musicloudDOTfm(songname:string):string;
procedure GetSongList_musicloudDOTfm(buffer:string);

implementation
  uses Indy_Thread;

function MakeDownloadStr_musicloudDOTfm(songname:string):string;
var download_str:string;
begin
  songname:=StringReplace(songname, ' ', '+', [rfReplaceAll, rfIgnoreCase]);
  songname:=StringReplace(songname, '&', '', [rfReplaceAll, rfIgnoreCase]);

  download_str:='http://musicloud.fm/result.php?query='+songname;

  result:=download_str;
end;

procedure GetSongList_musicloudDOTfm(buffer:string);
var search_str1,name,delete:string;
begin
  search_str1:='<li class="name"><a href="';
  songcount:=0;

  buffer:=copy(buffer,pos(search_str1,buffer),length(buffer));
  buffer:=copy(buffer,pos('<a href="',buffer)+11,length(buffer));

  while pos(search_str1,buffer)<>0 do begin
    songcount:=songcount+1;

    buffer:=copy(buffer,pos(search_str1,buffer)+10,length(buffer));
    buffer:=copy(buffer,pos('<a href="http://musicloud.fm/dl/',buffer)+32,length(buffer));

    setlength(DownloadSongs,songcount);
    DownloadSongs[songcount-1].Download_URL:='http://musicloud.fm/dl.php?id='+copy(buffer,1,pos('/',buffer)-1);
    //MessageBox(0,PChar(DownloadSongs[songcount-1].Download_URL), 'Error', MB_OK);
    //DownloadSongs[songcount-1].Download_URL:=StringReplace(DownloadSongs[songcount-1].Download_URL, 'info.php?', 'download.php?', [rfReplaceAll, rfIgnoreCase]);

    buffer:=copy(buffer,pos('">',buffer)+2,length(buffer));
    name:=copy(buffer,1,pos('</a>',buffer)-1);

    while pos('&#',name)<>0 do begin
      delete:=copy(name,pos('&#',name),6);
      name:=StringReplace(name, delete, '', [rfReplaceAll, rfIgnoreCase]);
    end;

    DownloadSongs[songcount-1].Songname:=name;

    buffer:=copy(buffer,pos('<li class="details">',buffer)+20,length(buffer));
    buffer:=copy(buffer,pos('Length: ',buffer)+8,length(buffer));
    //MessageBox(0,PChar(copy(buffer,1,100)), 'Error', MB_OK);
    DownloadSongs[songcount-1].song_length:=copy(buffer,1,5);
    if songcount>100 then break;
  end;

end;

end.

