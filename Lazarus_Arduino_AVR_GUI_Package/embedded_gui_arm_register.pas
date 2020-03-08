unit Embedded_GUI_ARM_Register;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,

  // LCL
  Forms, Controls, StdCtrls, Dialogs, ExtCtrls,
  // LazUtils
  LazLoggerBase,
  // IdeIntf
  ProjectIntf, CompOptsIntf, LazIDEIntf, IDEOptionsIntf, IDEOptEditorIntf, MenuIntf,

  // Embedded ( Eigene Units )
  Embedded_GUI_IDE_Options,
  Embedded_GUI_ARM_Common,
  Embedded_GUI_ARM_Project_Options_Form;

type

  { TProjectARMApp }

  TProjectARMApp = class(TProjectDescriptor)
  public
    constructor Create; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function InitProject(AProject: TLazProject): TModalResult; override;
    function CreateStartFiles(AProject: TLazProject): TModalResult; override;
    function DoInitDescriptor: TModalResult; override;
  end;



implementation

{ TProjectARMApp }

constructor TProjectARMApp.Create;
begin
  inherited Create;
  Name := 'ARM-Embedded-Project (STM32)';
  Flags := DefaultProjectNoApplicationFlags - [pfRunnable];
end;

function TProjectARMApp.GetLocalizedName: string;
begin
  Result := 'ARM-Embedded-Project (STM32)';
end;

function TProjectARMApp.GetLocalizedDescription: string;
begin
  Result := 'Erstellt ein ARM-Embedded-Project (STM32)';
end;

function TProjectARMApp.DoInitDescriptor: TModalResult;
var
  Form: TARM_Project_Options_Form;
begin
  Form := TARM_Project_Options_Form.Create(nil);

  Form.LoadDefaultMask;

  Result := Form.ShowModal;
  if Result = mrOk then begin
    Form.MaskToProjectOptions;
  end;

  Form.Free;
end;

function TProjectARMApp.InitProject(AProject: TLazProject): TModalResult;
const
  ProjectText =
    'program Project1;' + LineEnding + LineEnding + '{$H-,J-,O-}' +
    LineEnding + LineEnding + 'uses' + LineEnding + '  cortexm3;' +
    LineEnding + LineEnding + 'begin' + LineEnding + '  // Setup' +
    LineEnding + '  repeat' + LineEnding + '    // Loop;' + LineEnding +
    '  until false;' + LineEnding + 'end.';

var
  MainFile: TLazProjectFile;

begin
  inherited InitProject(AProject);

  MainFile := AProject.CreateProjectFile('Project1.pas');
  MainFile.IsPartOfProject := True;
  AProject.AddFile(MainFile, False);

  AProject.MainFileID := 0;
  AProject.MainFile.SetSourceText(ProjectText, True);

  AProject.LazCompilerOptions.TargetFilename := 'Project1';
  AProject.LazCompilerOptions.Win32GraphicApp := False;
  AProject.LazCompilerOptions.GenerateDebugInfo := False;
  AProject.LazCompilerOptions.UnitOutputDirectory :=
    'lib' + PathDelim + '$(TargetCPU)-$(TargetOS)';

  AProject.Flags := AProject.Flags + [pfRunnable];

  AProject.LazCompilerOptions.TargetCPU := 'avr';
  AProject.LazCompilerOptions.TargetOS := 'embedded';
  AProject.LazCompilerOptions.TargetProcessor := 'avr5';

  AProject.LazCompilerOptions.ExecuteAfter.CompileReasons := [crRun];

  ARM_ProjectOptions.Save(AProject);

  Result := mrOk;
end;

function TProjectARMApp.CreateStartFiles(AProject: TLazProject): TModalResult;
begin
  Result := LazarusIDE.DoOpenEditorFile(AProject.MainFile.Filename,
    -1, -1, [ofProjectLoading, ofRegularFile]);
end;

end.

