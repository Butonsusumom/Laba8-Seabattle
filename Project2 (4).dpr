program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils,windows;

TYPE
 TMAP=array[1..12]of array[1..12]of integer;
const translate1='МКРУП';
const translate2='ММРУП';

   procedure isAlive(var t,r,b,l:Boolean;var res:boolean;x,y:Integer;var m:TMAP);
   begin
    if(m[x+1][y]=1)or(m[x-1][y]=1)or(m[x][y+1]=1)or(m[x][y-1]=1) then res:=True
    else
    begin
      if(res=false)and(m[x+1][y]=2)and(t=true)then
          isAlive(t,r,b,l,res,x+1,y,m) else if((m[x+1][y]=4)or(m[x+1][y]=0)) then t:=False;
      if(res=false)and(m[x-1][y]=2)and(b=true)then
         isAlive(t,r,b,l,res,x-1,y,m) else if((m[x-1][y]=4)or(m[x-1][y]=0)) then b:=False;
      if(res=false)and(m[x][y+1]=2)and(r=true) then
        isAlive(t,r,b,l,res,x,y+1,m)else if ((m[x][y+1]=4)or(m[x][y+1]=0)) then r:=False;
      if(res=false)and(m[x][y-1]=2)and(l=true)then
        isAlive(t,r,b,l,res,x,y-1,m)else if ((m[x][y-1]=4)or(m[x][y-1]=0)) then l:=false
     end;
     end;


    procedure obnulay(var m:tmap);
    var tempi,tempj:Integer;
   begin
    for tempi:=2 to 11 do begin
      for tempj:=2 to 11 do begin
        if(m[tempi][tempj]=3)then begin
        if(m[tempi+1][tempj]<>3)then m[tempi+1][tempj]:=4;
        if(m[tempi-1][tempj]<>3)then m[tempi-1][tempj]:=4;
        if(m[tempi][tempj+1]<>3)then m[tempi][tempj+1]:=4;
        if(m[tempi][tempj-1]<>3)then m[tempi][tempj-1]:=4;
        if(m[tempi+1][tempj+1]<>3)then m[tempi+1][tempj+1]:=4;
        if(m[tempi-1][tempj+1]<>3)then m[tempi-1][tempj+1]:=4;
        if(m[tempi+1][tempj-1]<>3)then m[tempi+1][tempj-1]:=4;
        if(m[tempi-1][tempj-1]<>3)then m[tempi-1][tempj-1]:=4;
        end;
      end;
    end;
   end;

   procedure killAShip(var t,r,b,l:Boolean;x,y:Integer;var m:tmap);
   begin
    m[x][y]:=3;
    if(t=false)or((m[x][y+1]=4)or(m[x][y+1]=0)) then t:=False else killAShip(t,r,b,l,x,y+1,m);
    if(r=false)or((m[x+1][y]=4)or(m[x+1][y]=0)) then r:=False else killAShip(t,r,b,l,x+1,y,m);
    if(b=false)or((m[x][y-1]=4)or(m[x][y-1]=0)) then b:=False else killAShip(t,r,b,l,x,y-1,m);
    if(l=false)or((m[x-1][y]=4)or(m[x-1][y]=0)) then l:=False else killAShip(t,r,b,l,x-1,y,m);
   end;

 function  Vistrel(var M:TMAp; var count:Integer; x,y:integer):boolean;
var
alive1,r,l,t,b:Boolean;
  begin
        if M[x,y]=0 then
        begin
        M[x,y]:=4;
        result:=False;
        end else
      if M[x,y]=1 then
      begin
        Dec(count);
        result:=True;
             M[x,y]:=2;
         alive1:=False;
         r:=True;l:=True;t:=True;b:=True;
         isAlive(t,r,b,l,alive1,x,y,m);
         if(alive1=true)then
         else begin
          r:=True;l:=True;t:=True;b:=True;
          killAShip(t,r,b,l,x,y,m);
          obnulay(m);
         end;
          end;
          end;

 procedure ReadFile(path:string; var M:TMAP );
  var temp: string;
      t1:textfile;
      i,j:integer;
  begin
    if FileExists(path) then
    begin
      temp:='';
      assignfile(t1,path);
      reset(t1); i:=1;
      while not eof(t1) do
      begin
        readln(t1,temp);
          j:=1;
          while j<=10 do
          begin
            if temp[j]='К' then M[i+1,j+1]:=1 else
            if temp[j]='М' then M[i+1,j+1]:=0;
            inc(j);
          end;
         inc(i);
        end;
      end;
      closefile(t1);
    end;

  procedure drawField(m:tmap);
  var tempi,tempj:Integer;
  begin
    write('   а б в г д е ж з и к');
  tempi:=2;
 while(tempi<=11) do begin
  Writeln;write(tempi-1:2,' ');
  tempj:=2;
  while(tempj<=11) do begin
  write(translate1[m[tempi][tempj]+1],' ');
  inc(tempj);
  end;
  inc(tempi);
  end;
  end;

  procedure drawenemyField(m:tmap);
  var tempi,tempj:Integer;
  begin
     write('   а б в г д е ж з и к');
     tempi:=2;
 while(tempi<=11) do begin

  Writeln;write(tempi-1:2,' ');
  tempj:=2;
  while(tempj<=11) do begin
  write(translate2[m[tempi][tempj]+1],' ');
  inc(tempj);
  end;
  inc(tempi);
  end;
  end;

  procedure getCoordsletter(var firstco:integer;var secondco:integer);
   var letter:String;
   begin
    repeat writeln;
    writeln('введите координаты');
    Readln(letter);
    until(((Length(letter)<=3)and(pos(letter[1],'абвгдежзик')<>0)and(Pos(letter[2],'12345678910')<>0)));//
 if(Copy(letter,2,2)<>'10')then
  secondco:=1+StrToInt(Copy(letter,2,1))else secondco:=10+1;
   firstco:=1+pos(letter[1],'абвгдежзик');
   end;

 var
   gameover,h1st:Boolean;
   player1ships,player2ships,c1t,c2t:integer;

     f1,f2:tmap;

begin
  { TODO -oUser -cConsole Main : Insert code here }
    SetConsoleOutputCP(1251);  SetConsoleCP(1251);
   gameover:=False;

   h1st:=True;
    readfile('1.txt',f1);
    readfile('2.txt',f2);
     player1ships:=0;player2ships:=0;
    for c1t:=2 to 11 do for c2t:=2 to 11 do if (f1[c1t][c2t]=1)then inc(player1ships);
     for c1t:=2 to 11 do for c2t:=2 to 11 do if (f2[c1t][c2t]=1)then inc(player2ships);

   while(not gameover)do begin
         //4+6+6+4
   if(h1st)then Writeln('ход 1 игрока(нажмите ентер чтобы увидеть поле) у вас ',player1ships,' клеток, у противника ',player2ships,' клеток')else Writeln('ход 2 игрока(нажмите ентер чтобы увидеть поле) у вас ',player2ships,' клеток, у противника ',player1ships,' клеток');
     if (h1st)then begin Readln;drawenemyField(f2);writeln;writeln;drawField(f1) ; end else begin Readln; drawEnemyField(f1);writeln;writeln;drawField(f2) end;
    getCoordsletter(c1t,c2t);
    if(h1st=true)then
    BEGIN
     if(not(vistrel(f2,player2ships,c2t,c1t)))
      then
       begin
        Writeln('промах');
        h1st:=False
       end
      else
    if(f2[c2t][c1t]=2)
    then
      Writeln('попадание!')
    else if(f2[c2t][c1t]=3)
    then
      Writeln('убил!')
    END
    else
    if(not(vistrel(f1,player1ships,c2t,c1t)))then begin Writeln('промах'); h1st:=true end else if(f1[c2t][c1t]=2)then Writeln('попадание!')else if(f1[c2t][c1t]=3)then Writeln('убил!');

    if(player1ships<0)or (player2ships<0) then gameover:=True;
   end;
    if player1ships<=0 then Writeln('победа 2!') else if (player2ships<=0)then Writeln('победа 1'); readln;
end.
