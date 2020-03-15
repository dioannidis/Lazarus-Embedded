unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  SynHighlighterPas, SynEdit, AVR_CPUInfo, ARM_CPUInfo;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    SynEdit1: TSynEdit;
    SynPasSyn1: TSynPasSyn;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
//    procedure FindSubArch(Sub: String; l: TStrings);
    procedure GenerateAVR(sl: TStrings);
    procedure GenerateAVR_Table(sl: TStrings);
    procedure GenerateARM(sl: TStrings);
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  SynEdit1.ScrollBars := ssAutoBoth;

  Caption:={$I %FPCVERSION%};
  Caption:=LCLVersion;
end;

//procedure TForm1.FindSubArch(Sub: String; l: TStrings);
//var
//  AVR_List, SL_Source: TStringList;
//  SubArchList:String='';
//  SubArch, s, s2: string;
//  i:Integer;
//
//begin
//  SL_Source := TStringList.Create;
//  AVR_List := TStringList.Create;
//
//  SL_Source.LoadFromFile('/home/tux/fpc.src/fpc/rtl/embedded/Makefile');
//
//  i := 0;
//  repeat
//    s := SL_Source[i];
//    if pos('ifeq ($(SUBARCH),'+Sub, s) > 0 then begin
//      SubArch := s;
//      Delete(SubArch, 1, 17);
//      Delete(SubArch, Length(SubArch), 1);
//      SubArchList += SubArch + ',';
//
//      Inc(i);
//      s := SL_Source[i];
//      s2 := s;
//      Delete(s2, 1, 10);
//      if s2[Length(s2)] = '\' then begin
//        Delete(s2, Length(s2), 1);
//      end;
//      s2 := StringReplace(s2, ' ', ',', [rfReplaceAll]);
//      AVR_List.Add('    // ' + SubArch);
//      AVR_List.Add('    '#39 + s2 + #39' +');
//
//      while pos('\', s) > 0 do begin
//        Inc(i);
//        s := SL_Source[i];
//        s2 := s;
//        Delete(s2, 1, 3);
//        if s2[Length(s2)] = '\' then begin
//          Delete(s2, Length(s2), 1);
//        end;
//        s2 := StringReplace(s2, ' ', ',', [rfReplaceAll]);
//        AVR_List.Add('    '#39 + s2 + #39' +');
//      end;
//      AVR_List[AVR_List.Count - 1] := StringReplace(AVR_List[AVR_List.Count - 1], ' +', ',', []);
//      AVR_List.Add('');
//    end;
//    Inc(i);
//  until i >= SL_Source.Count;
//
//  s := AVR_List[AVR_List.Count - 2];
//  Delete(s, Length(s), 1);
//  AVR_List[AVR_List.Count - 2] := s;
//
//  AVR_List.Delete(AVR_List.Count - 1);
//  Delete(SubArchList, Length(SubArchList), 1);
//
//  L.Add('  ' + Sub + '_SubArch_List = ''' + SubArchList + ''';');
//  L.Add('');
//  L.Add('  ' + Sub + '_List: array of string = (');
//  L.Add('');
//
//  for i := 0 to AVR_List.Count - 1 do begin
//    L.Add(AVR_List[i]);
//  end;
//  L.Add(');');
//  L.Add('');
//
//  AVR_List.Free;
//  SL_Source.Free;
//end;

procedure TForm1.GenerateAVR(sl: TStrings);
var
  cpt: AVR_CPUInfo.tcputype;
  cdt: AVR_CPUInfo.tcontrollertype;
  s:String='';
  s2:String='';
  sarr:array[AVR_CPUInfo.tcputype] of String;
begin
  for cpt in AVR_CPUInfo.tcputype do begin
    Str(cpt, s);
    s2:=s2+Copy(s, 5)+',';
    sarr[cpt]:='';
  end;
  Delete(s2, Length(s2), 1);
  sl.Add('const');
  sl.Add('  AVR_SubArch_List = '#39 + s2 + #39 + ';');
  sl.Add('');
  for cdt in AVR_CPUInfo.tcontrollertype do begin
    sarr[AVR_CPUInfo.embedded_controllers[cdt].cputype] += AVR_CPUInfo.embedded_controllers[cdt].controllertypestr + ',';
  end;

  sl.Add('  AVR_List: array of string = (');
  for cpt in AVR_CPUInfo.tcputype do begin
    sl.Add('');
    Str(cpt, s);
    sl.Add('    // ' + Copy(s, 5));
    sl.Add('    '#39 +  Copy(sarr[cpt], 1, Length(sarr[cpt]) - 1) + #39 + ',');
  end;
  s := sl[sl.Count - 1];
  Delete(s, Length(s), 1);
  sl[sl.Count - 1] := s;

  sl.Add('  );');
  sl.Add('');
end;

procedure TForm1.GenerateARM(sl: TStrings);
var
  cpt: ARM_CPUInfo.tcputype;
  cdt: ARM_CPUInfo.tcontrollertype;
  s:String='';
  s2:String='';
  sarr:array[ARM_CPUInfo.tcputype] of String;
begin
  for cpt in ARM_CPUInfo.tcputype do begin
    Str(cpt, s);
    s2:=s2+Copy(s, 5)+',';
    sarr[cpt]:='';
  end;
  Delete(s2, Length(s2), 1);
  sl.Add('const');
  sl.Add('  ARM_SubArch_List = '#39 + s2 + #39 + ';');
  sl.Add('');
  for cdt in ARM_CPUInfo.tcontrollertype do begin
    sarr[ARM_CPUInfo.embedded_controllers[cdt].cputype] += ARM_CPUInfo.embedded_controllers[cdt].controllertypestr + ',';
  end;

  sl.Add('  ARM_List: array of string = (');
  for cpt in ARM_CPUInfo.tcputype do begin
    sl.Add('');
    Str(cpt, s);
    sl.Add('    // ' + Copy(s, 5));
    sl.Add('    '#39 +  Copy(sarr[cpt], 1, Length(sarr[cpt]) - 1) + #39 + ',');
  end;
  s := sl[sl.Count - 1];
  Delete(s, Length(s), 1);
  sl[sl.Count - 1] := s;

  sl.Add('  );');
  sl.Add('');
end;

procedure TForm1.GenerateAVR_Table(sl: TStrings);
const
  Digi = 4;
var
  cdt: AVR_CPUInfo.tcontrollertype;
  s:String;

  function getCPUType(cpu: AVR_CPUInfo.tcputype): String;
  begin
    Str(cpu, Result);
    Delete(Result, 1, 4);
  end;

  function getFPUType(cpu: AVR_CPUInfo.tfputype): String;
  begin
    Str(cpu, Result);
    Delete(Result, 1, 4);
  end;

  //controllertypestr:'AVRSIM';
  //controllerunitstr:'AVRSIM';
  //
  //cputype: cpu_avr5;
  //fputype: fpu_soft;
  //flashbase:0;
  //flashsize:$20000;
  //srambase:256;
  //sramsize:32*1024;
  //eeprombase:0;
  //eepromsize:4096;

begin
  sl.Add('type');
  sl.Add('  TAVRControllerDataList = array of array of String;');
  sl.Add('');
  sl.Add('const');
  sl.Add('  AVRControllerDataList : TAVRControllerDataList = (');
  sl.Add('  ('#39'controllertypestr'#39', '#39' controllerunitstr'#39', '#39' cputype'#39', '#39' fputype'#39', '#39' flashbase'#39',');
  sl.Add('   '#39'flashsize'#39', '#39' srambase'#39', '#39' sramsize'#39', '#39' eeprombase'#39', '#39' eepromsize'#39'),');

  for cdt in AVR_CPUInfo.tcontrollertype do begin
    s:= '  ('#39 + AVR_CPUInfo.embedded_controllers[cdt].controllertypestr + #39', ' +
             #39 + AVR_CPUInfo.embedded_controllers[cdt].controllerunitstr + #39', ' +
             #39 + getCPUType(AVR_CPUInfo.embedded_controllers[cdt].cputype) + #39', ' +
             #39 + getFPUType(AVR_CPUInfo.embedded_controllers[cdt].fputype) + #39', ' +
             #39 + IntToStr(AVR_CPUInfo.embedded_controllers[cdt].flashbase) + #39', ' +
             #39 + IntToStr(AVR_CPUInfo.embedded_controllers[cdt].flashsize) + #39', ' +
             #39 + IntToStr(AVR_CPUInfo.embedded_controllers[cdt].srambase) + #39', ' +
             #39 + IntToStr(AVR_CPUInfo.embedded_controllers[cdt].sramsize) + #39', ' +
             #39 + IntToStr(AVR_CPUInfo.embedded_controllers[cdt].eeprombase) + #39', ' +
             #39 + IntToStr(AVR_CPUInfo.embedded_controllers[cdt].eepromsize) + #39'),';
    sl.Add(s);
  end;
  s := sl[sl.Count - 1];
  Delete(s, Length(s), 1);
  sl[sl.Count - 1] := s + ');'
end;



procedure TForm1.Button1Click(Sender: TObject);
begin
  SynEdit1.Clear;

  SynEdit1.Lines.Add('');
  SynEdit1.Lines.Add('// Diese Unit wird automatisch durch das Tool "./Tool/Embedded_List_to_const" erzeugt.');
  SynEdit1.Lines.Add('// Die Arrays werden aus "./fpc.src/fpc/compiler/avr/cpuinfo.pas" und');
  SynEdit1.Lines.Add('// "./fpc.src/fpc/compiler/arm/cpuinfo.pas" importiert.');
  SynEdit1.Lines.Add('');
  SynEdit1.Lines.Add('unit');
  SynEdit1.Lines.Add('  Embedded_GUI_SubArch_List;');
  SynEdit1.Lines.Add('');
  SynEdit1.Lines.Add('interface');
  SynEdit1.Lines.Add('');

  GenerateAVR(SynEdit1.Lines);
  SynEdit1.Lines.Add('');
  GenerateARM(SynEdit1.Lines);
  SynEdit1.Lines.Add('');
  GenerateAVR_Table(SynEdit1.Lines);

//  FindSubArch('avr', SynEdit1.Lines);
//  FindSubArch('arm', SynEdit1.Lines);

  SynEdit1.Lines.Add('');
  SynEdit1.Lines.Add('implementation');
  SynEdit1.Lines.Add('');
  SynEdit1.Lines.Add('begin');
  SynEdit1.Lines.Add('end.');

  SynEdit1.Lines.SaveToFile('../../embedded_gui_subarch_list.pas');
end;

end.
