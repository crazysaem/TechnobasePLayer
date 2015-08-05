unit hotkey;

{$mode delphi}{$H+}

interface

uses
  windows, Classes, SysUtils;

function Hotkey_TO_Text(key:word):string;
function Text_TO_Hotkey(text:string):word;

type

  THotkey = class(TObject)
  private
    HotkeyID:Word;
    key1,key2:word;
    key1set:boolean;
    EditText,editk1:string;
  public
    Hotkeyp1,Hotkeyp2:word;
    constructor Create;
    function SetEditText:string;                 //In Edit.OnChange einfügen
    procedure RegognizeKeys(key:word);           //In Edit.OnKeyDown setzen
    procedure ResetKeys(key:word);               //In Edit.OnKeyUp  reintun
    function SetHotkey(Handle:HWND):boolean;
    function HotkeyPressed(OHotkeyID:Word):boolean;
    procedure DeleteHotkey(Handle:HWND);
    procedure SetHotkeyKeysManually(key1,key2:word);
    procedure ResetEditText;
  end;

var GHotkeyIDCount:Word;

implementation

function Text_TO_Hotkey(text:string):word;
begin
if text[1]='' then begin
  result:=-1;
  exit;
end;
result:=0;
if text='LBUTTON' then result:=1;
if text='RBUTTON' then result:=2;
if text='CANCEL' then result:=3;
if text='MBUTTON' then result:=4;
if text='XBUTTON1' then result:=5;
if text='XBUTTON2' then result:=6;
if text='BACK' then result:=8;
if text='TAB' then result:=9;
if text='CLEAR' then result:=12;
if text='RETURN' then result:=13;
if text='SHIFT' then result:=16;
if text='STRG' then result:=17;
if text='ALT' then result:=18;
if text='PAUSE' then result:=19;
if text='CAPITAL' then result:=20;
if text='KANA' then result:=21;
if text='HANGUEL' then result:=21;
if text='HANGUL' then result:=21;
if text='JUNJA' then result:=23;
if text='FINAL' then result:=24;
if text='HANJA' then result:=25;
if text='KANJI' then result:=25;
if text='ESCAPE' then result:=27;
if text='CONVERT' then result:=28;
if text='NONCONVERT' then result:=29;
if text='ACCEPT' then result:=30;
if text='MODECHANGE' then result:=31;
if text='SPACE' then result:=32;
if text='PRIOR' then result:=33;
if text='NEXT' then result:=34;
if text='END' then result:=35;
if text='HOME' then result:=36;
if text='LEFT' then result:=37;
if text='UP' then result:=38;
if text='RIGHT' then result:=39;
if text='DOWN' then result:=40;
if text='SELECT' then result:=41;
if text='PRINT' then result:=42;
if text='EXECUTE' then result:=43;
if text='SNAPSHOT' then result:=44;
if text='INSERT' then result:=45;
if text='DELETE' then result:=46;
if text='HELP' then result:=47;
if text='LWIN' then result:=91;
if text='RWIN' then result:=92;
if text='APPS' then result:=93;
if text='SLEEP' then result:=95;
if text='NUMPAD0' then result:=96;
if text='NUMPAD1' then result:=97;
if text='NUMPAD2' then result:=98;
if text='NUMPAD3' then result:=99;
if text='NUMPAD4' then result:=100;
if text='NUMPAD5' then result:=101;
if text='NUMPAD6' then result:=102;
if text='NUMPAD7' then result:=103;
if text='NUMPAD8' then result:=104;
if text='NUMPAD9' then result:=105;
if text='MULTIPLY' then result:=106;
if text='ADD' then result:=107;
if text='SEPARATOR' then result:=108;
if text='SUBTRACT' then result:=109;
if text='DECIMAL' then result:=110;
if text='DIVIDE' then result:=111;
if text='F1' then result:=112;
if text='F2' then result:=113;
if text='F3' then result:=114;
if text='F4' then result:=115;
if text='F5' then result:=116;
if text='F6' then result:=117;
if text='F7' then result:=118;
if text='F8' then result:=119;
if text='F9' then result:=120;
if text='F10' then result:=121;
if text='F11' then result:=122;
if text='F12' then result:=123;
if text='F13' then result:=124;
if text='F14' then result:=125;
if text='F15' then result:=126;
if text='F16' then result:=127;
if text='F17' then result:=128;
if text='F18' then result:=129;
if text='F19' then result:=130;
if text='F20' then result:=131;
if text='F21' then result:=132;
if text='F22' then result:=133;
if text='F23' then result:=134;
if text='F24' then result:=135;
if text='NUMLOCK' then result:=144;
if text='SCROLL' then result:=145;
if text='LSHIFT' then result:=160;
if text='RSHIFT' then result:=161;
if text='LCONTROL' then result:=162;
if text='RCONTROL' then result:=163;
if text='LMENU' then result:=164;
if text='RMENU' then result:=165;
if text='BROWSER_BACK' then result:=166;
if text='BROWSER_FORWARD' then result:=167;
if text='BROWSER_REFRESH' then result:=168;
if text='BROWSER_STOP' then result:=169;
if text='BROWSER_SEARCH' then result:=170;
if text='BROWSER_FAVORITES' then result:=171;
if text='BROWSER_HOME' then result:=172;
if text='VOLUME_MUTE' then result:=173;
if text='VOLUME_DOWN' then result:=174;
if text='VOLUME_UP' then result:=175;
if text='MEDIA_NEXT_TRACK' then result:=176;
if text='MEDIA_PREV_TRACK' then result:=177;
if text='MEDIA_STOP' then result:=178;
if text='MEDIA_PLAY_PAUSE' then result:=179;
if text='LAUNCH_MAIL' then result:=180;
if text='LAUNCH_MEDIA_SELECT' then result:=181;
if text='LAUNCH_APP1' then result:=182;
if text='LAUNCH_APP2' then result:=183;
if text='OEM_1' then result:=186;
if text='OEM_PLUS' then result:=187;
if text='OEM_COMMA' then result:=188;
if text='OEM_MINUS' then result:=189;
if text='OEM_PERIOD' then result:=190;
if text='OEM_2' then result:=191;
if text='OEM_3' then result:=192;
if text='OEM_4' then result:=219;
if text='OEM_5' then result:=220;
if text='OEM_6' then result:=221;
if text='OEM_7' then result:=222;
if text='OEM_8' then result:=223;
if text='OEM_102' then result:=226;
if text='PROCESSKEY' then result:=229;
if text='PACKET' then result:=231;
if text='ATTN' then result:=246;
if text='CRSEL' then result:=247;
if text='EXSEL' then result:=248;
if text='EREOF' then result:=249;
if text='PLAY' then result:=250;
if text='ZOOM' then result:=251;
if text='NONAME' then result:=252;
if text='PA1' then result:=253;
if text='OEM_CLEAR' then result:=254;
if (result=0) and (text[1]<>'') then begin
  result:=ord(text[1]);
end;
end;

function Hotkey_TO_Text(key:word):string;
begin

if ((key>=65) and (key<=90)) or ((key>=48) and (key<=57)) then begin
  result:=chr(key);
  exit;
end;

  case key of
1:result:='LBUTTON';
2:result:='RBUTTON';
3:result:='CANCEL';
4:result:='MBUTTON';
5:result:='XBUTTON1';
6:result:='XBUTTON2';
8:result:='BACK';
9:result:='TAB';
12:result:='CLEAR';
13:result:='RETURN';
16:result:='SHIFT';
17:result:='STRG';
18:result:='ALT';
19:result:='PAUSE';
20:result:='CAPITAL';
21:result:='KANA';
23:result:='JUNJA';
24:result:='FINAL';
25:result:='HANJA';
27:result:='ESCAPE';
28:result:='CONVERT';
29:result:='NONCONVERT';
30:result:='ACCEPT';
31:result:='MODECHANGE';
32:result:='SPACE';
33:result:='PRIOR';
34:result:='NEXT';
35:result:='END';
36:result:='HOME';
37:result:='LEFT';
38:result:='UP';
39:result:='RIGHT';
40:result:='DOWN';
41:result:='SELECT';
42:result:='PRINT';
43:result:='EXECUTE';
44:result:='SNAPSHOT';
45:result:='INSERT';
46:result:='DELETE';
47:result:='HELP';
91:result:='LWIN';
92:result:='RWIN';
93:result:='APPS';
95:result:='SLEEP';
96:result:='NUMPAD0';
97:result:='NUMPAD1';
98:result:='NUMPAD2';
99:result:='NUMPAD3';
100:result:='NUMPAD4';
101:result:='NUMPAD5';
102:result:='NUMPAD6';
103:result:='NUMPAD7';
104:result:='NUMPAD8';
105:result:='NUMPAD9';
106:result:='MULTIPLY';
107:result:='ADD';
108:result:='SEPARATOR';
109:result:='SUBTRACT';
110:result:='DECIMAL';
111:result:='DIVIDE';
112:result:='F1';
113:result:='F2';
114:result:='F3';
115:result:='F4';
116:result:='F5';
117:result:='F6';
118:result:='F7';
119:result:='F8';
120:result:='F9';
121:result:='F10';
122:result:='F11';
123:result:='F12';
124:result:='F13';
125:result:='F14';
126:result:='F15';
127:result:='F16';
128:result:='F17';
129:result:='F18';
130:result:='F19';
131:result:='F20';
132:result:='F21';
133:result:='F22';
134:result:='F23';
135:result:='F24';
144:result:='NUMLOCK';
145:result:='SCROLL';
160:result:='LSHIFT';
161:result:='RSHIFT';
162:result:='LCONTROL';
163:result:='RCONTROL';
164:result:='LMENU';
165:result:='RMENU';
166:result:='BROWSER_BACK';
167:result:='BROWSER_FORWARD';
168:result:='BROWSER_REFRESH';
169:result:='BROWSER_STOP';
170:result:='BROWSER_SEARCH';
171:result:='BROWSER_FAVORITES';
172:result:='BROWSER_HOME';
173:result:='VOLUME_MUTE';
174:result:='VOLUME_DOWN';
175:result:='VOLUME_UP';
176:result:='MEDIA_NEXT_TRACK';
177:result:='MEDIA_PREV_TRACK';
178:result:='MEDIA_STOP';
179:result:='MEDIA_PLAY_PAUSE';
180:result:='LAUNCH_MAIL';
181:result:='LAUNCH_MEDIA_SELECT';
182:result:='LAUNCH_APP1';
183:result:='LAUNCH_APP2';
186:result:='OEM_1';
187:result:='OEM_PLUS';
188:result:='OEM_COMMA';
189:result:='OEM_MINUS';
190:result:='OEM_PERIOD';
191:result:='OEM_2';
192:result:='OEM_3';
219:result:='OEM_4';
220:result:='OEM_5';
221:result:='OEM_6';
222:result:='OEM_7';
223:result:='OEM_8';
226:result:='OEM_102';
229:result:='PROCESSKEY';
231:result:='PACKET';
246:result:='ATTN';
247:result:='CRSEL';
248:result:='EXSEL';
249:result:='EREOF';
250:result:='PLAY';
251:result:='ZOOM';
252:result:='NONAME';
253:result:='PA1';
254:result:='OEM_CLEAR';
  end;
end;

constructor THotkey.Create;
begin
  if GHotkeyIDCount=0 then GHotkeyIDCount:=1;//$FF;
  HotkeyID:=GHotkeyIDCount;
  GHotkeyIDCount:=GHotkeyIDCount+1;
  key1:=0;
  key2:=0;
  Hotkeyp1:=0;
  Hotkeyp2:=0;
  key1set:=false;
  EditText:='';
end;

function THotkey.SetEditText():string;
begin
  SetEditText:=EditText;
end;

procedure THotkey.RegognizeKeys(key:word);
begin
  if key1set=false then begin
    key1:=key;
    key1set:=true;
  end;

  if (key<>key1) or (key2=0) then key2:=key;

  if (key2>=16) and (key2<=18) then begin
    key1:=key2;
    key2:=0;
  end;

  //if key2<>0 then begin
    if key1=16 then begin editk1:='SHIFT'; Hotkeyp1:=MOD_SHIFT; end;
    if key1=17 then begin editk1:='STRG';  Hotkeyp1:=MOD_CONTROL; end;
    if key1=18 then begin editk1:='ALT';   Hotkeyp1:=MOD_ALT; end;
    //if (key1>=16) and (key1<=18) and (key2>=65) and (key2<=90) then begin
    if (key1>=16) and (key1<=18) then begin
      if (key2>=16) and (key2<=18) then  EditText:=editk1+' + ' else
      EditText:=editk1+' + '+Hotkey_TO_Text(key2);

      //Hotkeyp1:=key1;
      Hotkeyp2:=key2;
    end else begin
      EditText:=Hotkey_TO_Text(key2);
      key1:=0;

      Hotkeyp1:=key1;
      Hotkeyp2:=key2;
    end;
  //end;
end;

procedure THotkey.ResetKeys(key:word);
begin
  if (key=16) or (key=17) or (key=18) then begin
    key1:=0;
    key2:=0;
    key1set:=false;
  end;
end;

function THotkey.SetHotkey(Handle:HWND):boolean;
begin
  if (Hotkeyp1<>-1) and (Hotkeyp2<>0) then begin
    If not RegisterHotkey(Handle, HotkeyID, Hotkeyp1, Hotkeyp2) then begin
      SetHotkey:=false;
      exit;
    end else SetHotkey:=true;
  end else begin
    SetHotkey:=false;
    exit;
  end;
end;

function THotkey.HotkeyPressed(OHotkeyID:Word):boolean;
begin
  if HotkeyID=OHotkeyID then HotkeyPressed:=true else HotkeyPressed:=false;
end;

procedure THotkey.DeleteHotkey(Handle:HWND);
begin
  UnRegisterHotKey(Handle, HotkeyID);
  GlobalDeleteAtom(HotkeyID);
end;

//Hotkeys manuell setzen (benutzt wenn die Settings geladen werden).
procedure THotkey.SetHotkeyKeysManually(key1,key2:word);
var key1text:string;
begin
  Hotkeyp1:=key1;
  Hotkeyp2:=key2;

  key1text:='XXX';

  case key1 of
    0:           key1text:='XXX';
    MOD_SHIFT:   key1text:='SHIFT';
    MOD_CONTROL: key1text:='STRG';
    MOD_ALT:     key1text:='ALT';
  end;

  if (key1<>0) then EditText:=key1text+' + '+Hotkey_TO_Text(key2) else
    EditText:=Hotkey_TO_Text(key2);
end;

procedure THotkey.ResetEditText;
var key1text:string;
begin
  //if (Hotkeyp1<>0) then EditText:=Hotkey_TO_Text(Hotkeyp1)+' + '+Hotkey_TO_Text(Hotkeyp2) else
  //  EditText:=Hotkey_TO_Text(Hotkeyp2);

  key1text:='XXX';

  case Hotkeyp1 of
    0:           key1text:='XXX';
    MOD_SHIFT:   key1text:='SHIFT';
    MOD_CONTROL: key1text:='STRG';
    MOD_ALT:     key1text:='ALT';
  end;

  if (Hotkeyp1<>0) then EditText:=key1text+' + '+Hotkey_TO_Text(Hotkeyp2) else
    EditText:=Hotkey_TO_Text(Hotkeyp2);
end;

end.

