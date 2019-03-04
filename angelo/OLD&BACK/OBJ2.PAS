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

  TRectangle = object(TPoint)
    XX,YY: Integer;
    constructor Init(X1,Y1,X2,Y2,C1: Integer);
    procedure Point; virtual;
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


constructor TRectangle.Init(X1,Y1,X2,Y2,C1: Integer);
begin
  TPoint.Init(X1,Y1,C1);
  XX := X2;
  YY := Y2;
end;

procedure TRectangle.Point;
var S: String;
begin
  TextAttr := C;
  FillChar(S[1], XX-X, '*');
  S[0] := Char(XX-X);
  Write(S);
end;


var
  TAsk: TRectangle;

begin
  ClrScr;
  TAsk.Init(5,5,10,10,$4F);
  TAsk.Draw;
  TAsk.Init(10,10,20, 20,$4F);
  TAsk.Draw;
  ReadLn;
end.