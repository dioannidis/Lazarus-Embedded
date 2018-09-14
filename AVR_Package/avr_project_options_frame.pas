unit AVR_Project_Options_Frame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Dialogs,
  LazIDEIntf, ProjectIntf, CompOptsIntf, IDEOptionsIntf, IDEOptEditorIntf, IDEExternToolIntf,

  Laz2_XMLCfg, // Für direkte *.lpi Zugriff

  AVR_IDE_Options;

const
  Key_SerialMonitorPort = 'SerialMonitorPort';
  Key_SerialMonitorBaud = 'COM_Port';

type

  { TProjectOptions }

  TProjectOptions = class
    AvrdudeCommand: record
      Path,
      Programmer: string;
    end;
    AVRType,
    SerialMonitorPort,
    SerialMonitorBaud: string;
    HexFile: boolean;
    procedure Save(AProject: TLazProject);
  end;

var
  ProjectOptions: TProjectOptions;


type

  { TAVR_Project_Options_Frame }

  TAVR_Project_Options_Frame = class(TAbstractIDEOptionsEditor)
    ProgrammerComboBox: TComboBox;
    AVR_Typ_ComboBox: TComboBox;
    HexFile_CheckBox: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SerialMonitorPort_ComboBox: TComboBox;
    SerialMonitorBaud_ComboBox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    avrdudePathComboBox: TComboBox;
  private

  public
    function GetTitle: string; override;
    procedure Setup({%H-}ADialog: TAbstractOptionsEditorDialog); override;
    procedure ReadSettings({%H-}AOptions: TAbstractIDEOptions); override;
    procedure WriteSettings({%H-}AOptions: TAbstractIDEOptions); override;
    class function SupportedOptionsClass: TAbstractIDEOptionsClass; override;
  end;

implementation

{$R *.lfm}

{ TProjectOptions }

procedure TProjectOptions.Save(AProject: TLazProject);
begin
  with AProject.LazCompilerOptions do begin
    CustomOptions := '-' + ProjectOptions.AVRType;
    if ProjectOptions.HexFile then begin
      CustomOptions := CustomOptions + LineEnding + '-al';
    end;
  end;

  AProject.LazCompilerOptions.ExecuteAfterCommand := ProjectOptions.AvrdudeCommand.Path + ' -v ' +
    '-patmega328p ' +
    '-c' + ProjectOptions.AvrdudeCommand.Programmer + ' ' +
    ' -P/dev/ttyUSB0 -b57600 -D -Uflash:w:Project1.hex:i';

  //    avrdude_ComboBox1.Text := 'avrdude -v -patmega328p -carduino -P/dev/ttyUSB0 -b57600 -D -Uflash:w:Project1.hex:i';

  //  AProject.LazCompilerOptions.ExecuteAfterCommand := ProjectOptions.AvrdudeCommand;

  AProject.CustomData[Key_SerialMonitorPort] := ProjectOptions.SerialMonitorPort;
  AProject.CustomData[Key_SerialMonitorBaud] := ProjectOptions.SerialMonitorBaud;
end;

{ TAVR_Project_Options_Frame }

function TAVR_Project_Options_Frame.GetTitle: string;
begin
  Result := 'AVR_Project Optionen';
end;

procedure TAVR_Project_Options_Frame.Setup(ADialog: TAbstractOptionsEditorDialog);
begin
  // Do nothing
end;

procedure TAVR_Project_Options_Frame.ReadSettings(AOptions: TAbstractIDEOptions);
var
  LazProject: TLazProject;
begin
  LazProject := LazarusIDE.ActiveProject;

  ProjectOptions.AVRType := LazProject.LazCompilerOptions.CustomOptions;

  ProjectOptions.SerialMonitorPort := LazProject.CustomData[Key_SerialMonitorPort];
  ProjectOptions.SerialMonitorBaud := LazProject.CustomData[Key_SerialMonitorBaud];

  SerialMonitorPort_ComboBox.Text := ProjectOptions.SerialMonitorPort;
  SerialMonitorBaud_ComboBox.Text := ProjectOptions.SerialMonitorBaud;
  AVR_Typ_ComboBox.Text := ProjectOptions.AVRType;

  Label3.Caption := LazProject.LazCompilerOptions.ExecuteBeforeCommand +
    LineEnding + LazProject.LazCompilerOptions.ExecuteAfterCommand;
end;

procedure TAVR_Project_Options_Frame.WriteSettings(AOptions: TAbstractIDEOptions);
var
  LazProject: TLazProject;
begin
  LazProject := LazarusIDE.ActiveProject;

  ProjectOptions.SerialMonitorPort := SerialMonitorPort_ComboBox.Text;
  ProjectOptions.SerialMonitorBaud := SerialMonitorBaud_ComboBox.Text;
  ProjectOptions.AVRType := AVR_Typ_ComboBox.Text;

  ProjectOptions.Save(LazProject);
end;

class function TAVR_Project_Options_Frame.SupportedOptionsClass: TAbstractIDEOptionsClass;
begin
  Result := TAbstractIDEProjectOptions;
end;

end.
