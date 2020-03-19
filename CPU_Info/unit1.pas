unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ValEdit, Grids,
  StdCtrls, Embedded_GUI_SubArch_List;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    procedure Load(Table: array of TStringArray);

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

const
  Item = 'AVR,ARM';

procedure TForm1.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.ComboBox1Select(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
    0: begin
      Load(AVRControllerDataList);
    end;
    1: begin
      Load(ARMControllerDataList);
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  StringGrid1.FixedCols := 0;
  StringGrid1.DoubleBuffered := True;
  StringGrid1.TitleFont.Style := [fsBold];
  ComboBox1.Text := 'AVR';
  ComboBox1.Items.AddCommaText(Item);
  Load(AVRControllerDataList);
end;

procedure TForm1.Load(Table: array of TStringArray);
var
  x, y: integer;
begin
  StringGrid1.RowCount := Length(Table);
  StringGrid1.ColCount := Length(Table[0]);
  for y := 0 to Length(Table) - 1 do begin
    for x := 0 to Length(Table[y]) - 1 do begin
      StringGrid1.Cells[x, y] := Table[y, x];
    end;
  end;
  StringGrid1.AutoSizeColumns;
  StringGrid1.SortColRow(True, 0, 1, StringGrid1.RowCount-1);
  StringGrid1.SortColRow(True, 2, 1, StringGrid1.RowCount-1);
end;

end.