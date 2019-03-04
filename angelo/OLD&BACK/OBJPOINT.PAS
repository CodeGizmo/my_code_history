program Draw;

uses Crt;

type

  TLoc = object
    X,Y: Integer;
    constructor Init(X1,Y1: Integer);
    procedure Point; virtual;
  end;

  TPoint = object(TLoc)
    C: Integer;
    constructor Init(X1,Y1,C1: Integer);
    procedure Point; virtual;
    procedure Draw; virtual;
  end;

constructor TLoc.Init(X1,Y1: Integer);
begin
  X := X1;
  Y := Y1;
end;

procedure TLoc.Point;
begin
  GotoXY(X,Y);
end;

constructor TPoint.Init(X1,Y1,C1: Integer);
begin
  inherited Init(X1,Y1);
  C := C1;
end;

procedure TPoint.Point;
begin
  TextAttr := C;
  Write('*');
end;

procedure TPoint.Draw;
begin
  TLoc.Point;
  Point;
end;

var
  TAsk: TPoint;

begin
  ClrScr;
  TAsk.Init(5,5,$4F);
  TAsk.Draw;
  TAsk.Init(10,10,$4F);
  TAsk.Draw;
  ReadLn;
end.