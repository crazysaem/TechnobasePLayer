unit Unit4;

{$MODE Delphi}

interface

uses
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LResources, inistuff;

type
  TForm4 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form4: TForm4;

implementation

uses Unit2, main;


procedure TForm4.FormCreate(Sender: TObject);
begin
  if endee=true then exit;
  form4.Memo1.Lines.Add('AppStart');
  form4.Memo1.Lines.Add('Viel Spass :)');

  form4.Left:=trunc(screen.Width/2-form4.Width/2);
  form4.top:=trunc(screen.Height/2-form4.Height/2);

  IniLoadAllSettings;
end;

initialization
  {$i Unit4.lrs}
  {$i Unit4.lrs}

end.
