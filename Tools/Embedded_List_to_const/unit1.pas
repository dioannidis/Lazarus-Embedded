unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  //    Embedded_GUI_SubArch_List,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn,
  Buttons, FileUtil, SynEdit, SynHighlighterPas;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DirectoryEdit1: TDirectoryEdit;
    SynEdit1: TSynEdit;
    SynPasSyn1: TSynPasSyn;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function AddSubArch(sl: TStrings; cpu: string): TStringList;
    procedure AddCPUData(sl, SubArchList: TStrings; cpu: string);
    procedure AddControllerDataList(sl: TStrings; cpu: string);
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
  DirectoryEdit1.Directory := '/home/tux/fpc.src/fpc';
end;

function TForm1.AddSubArch(sl: TStrings; cpu: string): TStringList;
var
  source_SL: TStringList;
  p: integer;
  s, s1: string;
  sa: TStringArray;
begin
  Result := TStringList.Create;
  if Pos('generic', cpu) > 0 then begin
    Exit;
  end;
  source_SL := TStringList.Create;
  source_SL.LoadFromFile(cpu);
  s := source_SL.Text;
  source_SL.Free;
  p := Pos('cputypestr', s);
  if p > 0 then begin
    while s[p] <> ')' do begin
      Inc(p);
      if s[p] = #39 then begin
        Inc(p);
        if s[p] <> #39 then begin
          s1 := '';
          repeat
            s1 += s[p];
            Inc(p);
          until s[p] = #39;
          Result.Add(s1);
        end;
      end;
    end;

    sa := cpu.Split('/');
    if Length(sa) >= 2 then begin
      sl.Add('const');
      sl.Add('  ' + sa[Length(sa) - 2] + '_SubArch_List = ');
      sl.Add('    '#39 + Result.CommaText + #39 + ';');
    end;

  end;
end;

procedure TForm1.AddCPUData(sl, SubArchList: TStrings; cpu: string);
var
  source_SL: TStringList;
  SubArchData: array of TStringList;
  p, i: integer;
  s, s1, s2: string;
  sa: TStringArray;
begin
  if Pos('generic', cpu) > 0 then begin
    Exit;
  end;
  source_SL := TStringList.Create;
  source_SL.LoadFromFile(cpu);
  s := source_SL.Text;
  source_SL.Free;
  SetLength(SubArchData, SubArchList.Count);
  for i := 0 to Length(SubArchData) - 1 do begin
    SubArchData[i] := TStringList.Create;
  end;
  p := Pos('embedded_controllers', s);
  if p > 0 then begin
    Delete(s, 1, p + 19);
    while p > 0 do begin
      p := Pos('controllertypestr', s);
      if p > 0 then begin
        Delete(s, 1, p + 15);
        p := 0;
        s1 := '';
        s2 := '';
        repeat
          Inc(p);
        until s[p] = #39;
        Inc(p);
        if s[p] <> #39 then begin
          repeat
            s1 += s[p];
            Inc(p);
          until s[p] = #39;

          p := Pos('cpu_', s);
          Inc(p, 4);
          repeat
            s2 += s[p];
            Inc(p);
          until not (s[p] in ['0'..'9', 'a'..'z', '_']);

          i := 0;

          while UpCase(s2) <> UpCase(SubArchList[i]) do begin
            Inc(i);
          end;

          SubArchData[i].Add(s1);
        end;
      end;
    end;

    sa := cpu.Split('/');
    if Length(sa) >= 2 then begin
      sl.Add('');
      sl.Add('  ' + sa[Length(sa) - 2] + '_List: array of string = (');
    end;

    for i := 0 to Length(SubArchData) - 1 do begin
      sl.Add('');
      sl.Add('    // ' + SubArchList[i]);
      sl.Add('    ' + #39 + SubArchData[i].CommaText + #39 + ',');
    end;
    s := sl[sl.Count - 1];
    Delete(s, Length(s), 1);
    sl[sl.Count - 1] := s + ');';
    sl.Add('');
  end;

  for i := 0 to Length(SubArchData) - 1 do begin
    SubArchData[i].Free;
  end;
end;

procedure TForm1.AddControllerDataList(sl: TStrings; cpu: string);
var
  source_SL, sl1: TStringList;
  p, i: integer;
  s, s1, s2: string;
  sa: TStringArray;
begin
  if Pos('generic', cpu) > 0 then begin
    Exit;
  end;
  source_SL := TStringList.Create;
  sl1 := TStringList.Create;
  source_SL.LoadFromFile(cpu);
  s := source_SL.Text;
  source_SL.Free;

  sa := cpu.Split('/');
  if Length(sa) >= 2 then begin
    sl.Add('');
    s1 := sa[Length(sa) - 2];
    sl.Add('type');
    sl.Add('  T' + s1 + 'ControllerDataList = array of array of String;');
    sl.Add('');
    sl.Add('const');
    sl.Add('  ' + s1 + 'ControllerDataList : T' + s1 + 'ControllerDataList = (');
  end;

  p := Pos('embedded_controllers', s);
  if p > 0 then begin
    repeat
      Inc(p);
    until s[p] = '(';
    repeat
      Inc(p);
    until s[p] = '(';

    repeat
      repeat
        Inc(p);
      until s[p] in ['0'..'9', 'a'..'z', '_'];
      s1 := '';
      repeat
        s1 += s[p];
        Inc(p);
      until not (s[p] in ['0'..'9', 'a'..'z', '_']);
      sl1.Add(s1);
      repeat
        Inc(p);
      until s[p] in [';', ')'];
      Write(s[p]);
    until s[p] = ')';

  end;

  sl.Add('  ('#39 + sl1.CommaText + #39);
  sl.Add('  );');


  sl1.Free;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  i: integer;
  CPU_SL, SubArchList: TStringList;
begin
  CPU_SL := TStringList.Create;
  FindAllFiles(CPU_SL, DirectoryEdit1.Directory, 'cpuinfo.pas', True);
  SynEdit1.Clear;

  SynEdit1.Lines.Add('');
  SynEdit1.Lines.Add(
    '// Diese Unit wird automatisch durch das Tool "./Tool/Embedded_List_to_const" erzeugt.');
  SynEdit1.Lines.Add('// Die Arrays werden aus "./fpc.src/fpc/compiler/avr/cpuinfo.pas" und');
  SynEdit1.Lines.Add('// "./fpc.src/fpc/compiler/arm/cpuinfo.pas" importiert.');
  SynEdit1.Lines.Add('');
  SynEdit1.Lines.Add('unit');
  SynEdit1.Lines.Add('  Embedded_GUI_SubArch_List;');
  SynEdit1.Lines.Add('');
  SynEdit1.Lines.Add('interface');
  SynEdit1.Lines.Add('');

  for i := 0 to CPU_SL.Count - 1 do begin
    AddControllerDataList(SynEdit1.Lines, CPU_SL[i]);
  end;

  for i := 0 to CPU_SL.Count - 1 do begin
    SubArchList := AddSubArch(SynEdit1.Lines, CPU_SL[i]);
    AddCPUData(SynEdit1.Lines, SubArchList, CPU_SL[i]);
    SubArchList.Free;
  end;

  SynEdit1.Lines.Add('');
  SynEdit1.Lines.Add('implementation');
  SynEdit1.Lines.Add('');
  SynEdit1.Lines.Add('begin');
  SynEdit1.Lines.Add('end.');

  SynEdit1.Lines.SaveToFile('embedded_gui_subarch_list.pas');
  // SynEdit1.Lines.SaveToFile('../../Lazarus_Arduino_AVR_GUI_Package/embedded_gui_subarch_list.pas');
  CPU_SL.Free;
end;

end.
