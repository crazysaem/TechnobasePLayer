library project1;

{$MODE Delphi}{$H+}

uses
  SysUtils, Classes, Dialogs, Interfaces, Forms, StdCtrls, Controls, ComCtrls, windows,
  FileUtil, LResources, Graphics, ExtCtrls;

{$IFDEF WINDOWS}{$R project1.rc}{$ENDIF}

type

  TTBPack = record
    tbdjname,tbsongname,tbzuhorer,tbdjpicurl:string;
  end;

  TFormNew = class(TForm)

    procedure BClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  private
  public
    constructor create(AOwner : TComponent);
  end;

var
  FormNew:TFormNew;
  BButton: TButton;
  EEdit: TEdit;
  TBPack:TTBPack;

// FormFunktions:

constructor TFormNew.create(AOwner : TComponent);
begin
  inherited Create(AOwner);
end;

procedure TFormNew.BClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  EEdit.text:='Hello World!';
end;

//Export Funktions:

//Wird aufgerufen, wenn der Player gestartet wird, und das Plugin gerade geladen wurde
function Initialisierung():boolean; stdcall;
begin

  FormNew:=TFormNew.Create(nil);
  FormNew.Caption:='Test Plugin';
  FormNew.width:=232;
  FormNew.height:=100;
  FormNew.Left:=trunc(screen.Width/2-FormNew.Width/2);
  FormNew.top:=trunc(screen.Height/2-FormNew.Height/2);
  FormNew.BorderStyle:=bsSingle;

  //Little Note:
  //OnClick doesnt seem to work, tried it for hours, no kidding :(
  //But OnMouseDown ist the same thing, almost
  BButton:=TButton.Create(nil);
  BButton.left:=80;
  BButton.Top:=24;
  BButton.Caption:='Click me';
  BButton.Parent:=FormNew;
  BButton.OnMouseDown:=FormNew.BClick;

  EEdit:=TEdit.Create(nil);
  EEdit.left:=68;
  EEdit.top:=64;
  EEdit.text:='Click the Button';
  EEdit.width:=100;
  EEdit.Parent:=FormNew;
  EEdit.Visible:=true;

  Result:=true;
end;

//Immer wenn der Player "Refreshed", kriegt das Plugin die neusten Daten
procedure Give_TBPack(djname,songname,zuhorer,djpicurl:string); stdcall;
begin
  TBPack.tbdjname:=djname;
  TBPack.tbsongname:=songname;
  TBPack.tbzuhorer:=zuhorer;
  TBPack.tbdjpicurl:=djpicurl;
end;

//Wird aufgerufen, wenn bei Extras geklickt wurde
function Aufruf():boolean; stdcall;
begin
  FormNew.Visible:=true;
  Result:=true;
end;

//Wird aufgerufen wenn der Player beendet wurde/wird:
function Ende():boolean; stdcall;
begin
  FormNew.Free;
  Result:=true;
end;

function GetName():string; stdcall;
begin
  //Dieser String wird bei Extras im PopUpMenü angezeigt:
  Result:='Test 1234';
end;

exports
  Initialisierung index 1,
  Give_TBPack index 2,
  Aufruf index 3,
  Ende index 4,
  GetName index 5;

begin
end.

