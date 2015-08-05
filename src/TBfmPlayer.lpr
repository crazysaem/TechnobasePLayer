program TBfmPlayer;

{$AppType Gui}

{$MODE Delphi}

{$R 'font.res' 'font.rc'}

uses
  Forms, LResources, Interfaces,
  main in 'main.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Unit1 in 'Unit1.pas', Unit4 in 'Unit4.pas', RadioThread, Hotkey, prerecord,
  inistuff, indylaz, Plugins;

{$R *.res}

{$IFDEF WINDOWS} {$R TBfmPlayer.rc} {$ENDIF}

begin
  Application.Title:='TB-PLayer';
  {$I TBfmPlayer.lrs}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
