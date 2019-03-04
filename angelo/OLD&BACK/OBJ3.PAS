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
    S: String;
    constructor Init(X1,Y1,X2,Y2,C1: Integer);
    procedure Point; virtual;
  end;

  TRMove = Object(TRectangle)
    OldX, OldY: Integer;
    constructor Init(X1,Y1,X2,Y2,C1: Integer);
    procedure Show;
    procedure Hide;
    Procedure Move(XN,YN: Integer);
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
  FillChar(S[1], XX-X, '*');
  S[0] := Char(XX-X);
end;

procedure TRectangle.Point;
begin
  TextAttr := C;
  Write(S);
end;

constructor TRMove.Init(X1,Y1,X2,Y2,C1: Integer);
begin
  TRectangle.Init(X1,Y1,X2,Y2,C1);
  OldX := X1;
  OldY := Y1;
end;


procedure TRMove.Show;
begin
  TextAttr := C;
  GoToXY(X,Y); Write(S);
end;

procedure TRMove.Hide;
begin
  TextAttr := 0;
  GoToXY(X,Y); ClrEol;
end;

procedure TRMove.Move(XN, YN: Integer);
begin
  Hide;
  X := XN;
  Y := YN;
  Show;
end;


var
  TAsk: TRMove;

begin
  ClrScr;
  TAsk.Init(5,5,10,10,$4F);
  TAsk.Draw;
  ReadLn;
  TAsk.Move(10,10);
  ReadLn;
end.