program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Embedded_GUI_Serial_Monitor, Input, Baud, Embedded_GUI_Find_Comports
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TSerial_Monitor_Form, Serial_Monitor_Form);
  Application.CreateForm(TInputForm, InputForm);
  Application.CreateForm(TBaudForm, BaudForm);
  Application.Run;
end.
