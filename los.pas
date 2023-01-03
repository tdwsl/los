{ line-of-sight without trigonometry }

program LOS;

uses crt;

var
  px, py, gx, gy: integer;

const
  mapw = 8;
  maph = 9;
  map: array[1..mapw*maph] of integer = (
    0,0,1,0,0,0,0,0,
    0,0,1,0,0,0,0,0,
    1,0,1,0,1,0,1,0,
    0,0,0,0,1,0,0,0,
    0,1,0,0,1,0,0,0,
    0,0,0,1,1,1,1,0,
    0,1,0,0,0,0,0,0,
    0,1,1,0,1,1,0,1,
    0,1,0,0,0,0,0,0
  );

function sees(x1, y1, x2, y2: integer): boolean;
var
  xd, yd, x, y, i: integer;
begin
  xd := x2-x1;
  yd := y2-y1;
  for i := 1 to 100 do begin
    x := x1 + (xd*i) div 100;
    y := y1 + (yd*i) div 100;
    if (x < 0) or (y < 0) or (x >= mapw) or (y >= maph) then begin
      sees := false;
      exit;
    end;
    if map[y*mapw+x+1] = 1 then begin
      sees := false;
      exit;
    end;
    if (x = x2) and (y = y2) then begin
      sees := true;
      exit;
    end;
  end;
  sees := false;
end;

procedure draw;
var
  i: integer;
begin
  for i := 0 to mapw*maph-1 do begin
    gotoxy(i mod mapw + 1, i div mapw + 1);
    if map[i+1] = 1 then write('#')
    else if sees(px, py, i mod mapw, i div mapw) then write('.')
    else write(' ');
  end;
  gotoxy(px+1, py+1);
  write('@');
  gotoxy(gx+1, gy+1);
  if sees(gx, gy, px, py) then write('!') else write('?');
end;

procedure pmove(xd, yd: integer);
var
  x, y: integer;
begin
  x := px + xd;
  y := py + yd;
  if (x < 0) or (y < 0) or (x >= mapw) or (y >= maph) then exit;
  if map[y*mapw+x+1] = 1 then exit;
  px := x;
  py := y;
end;

function control: boolean;
begin
  control := true;
  case readkey of
    'h': pmove(-1, 0);
    'j': pmove(0, 1);
    'k': pmove(0, -1);
    'l': pmove(1, 0);
    'q': control := false;
  end;
end;

begin
  px := 0;
  py := 0;
  gx := 5;
  gy := 2;
  clrscr;
  draw;
  while control do draw;
end.
