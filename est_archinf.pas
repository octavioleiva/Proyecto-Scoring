unit est_archinf;

interface

uses
  archinfracciones_manejo,archconductores_manejo,validacion_datos_sco,amc_infraccciones,SysUtils,crt;
procedure cantidad_infracciones(var arch_inf:t_arch_inf);
procedure rango_inf_edad(var arch_cond:t_arch_cond; var arch_inf:t_arch_inf);
procedure cond_rein (var arch_cond:t_arch_cond);
procedure cond_scocero(var arch_cond:t_arch_cond);
procedure eleccion_est(var arch_inf:t_arch_inf;var arch_cond:t_arch_cond);

implementation
procedure cantidad_infracciones(var arch_inf:t_arch_inf);               //cantidad de infracciones entre 2 fechas
var
 fechain, fechafin:string[10]; //fecha inicio y final
 pos:byte;
 x:t_dato_inf;
 cant_fecha:word;
begin
  clrscr;
  pos:=0;
  cant_fecha:=0;
  abrir_arch_inf(arch_inf);
  writeln('INGRESAR FECHAS DE LA SIGUIENTE FORMA: aaaammdd');
  repeat
  write('Ingrese fecha inicial (aaaa/mm/dd): ');
  textcolor(11);
  readln(fechain);
  textcolor(white);
  until validar_fecha(fechain,2) = true ;
  repeat
  write('Ingrese fecha final (aaaa/mm/dd): ');
  textcolor(11);
  readln(fechafin);
  textcolor(white);
  until validar_fecha(fechafin,3) = true;
  while not (EOF(arch_inf)) do
        begin
          leer_dato_archinf(arch_inf,x,pos);
          if (x.fecha_inf <= fechafin) and (x.fecha_inf >= fechain) then
             begin
               cant_fecha:=cant_fecha+1;
             end;
          pos:=pos+1;
        end;
  cerrar_arch_inf(arch_inf);
  textcolor(11);
  writeln('|---------------------------------------------------------');
  textcolor(white);
  fechain:= mostrar_fecha(fechain);
  fechafin:= mostrar_fecha(fechafin);
  writeln('|La cantidad de infracciones entre ',fechain, ' y ',fechafin,' es de: ',cant_fecha,'|');
  readkey;
end;
procedure rango_inf_edad(var arch_cond:t_arch_cond; var arch_inf:t_arch_inf);
var
 cont1,cont2,cont3:byte;//cont1:menor 30, cont2:31<=x<=50, cont3:mayor50
 dato_cond:t_dato_cond;
 dato_inf:t_dato_inf;
 aaaa,edad:integer;
 dni:string[8];
 posc,posc2:integer;   //posc:para arch_inf, posc2:para arch_cond

 begin
 abrir_arch_inf(arch_inf);
 abrir_arch_cond(arch_cond);
 clrscr;
 textcolor(yellow);
 writeln('////////////////////////////////////////////////////////////////////////////////');
 writeln('/////////// ESTADISTICA RANGO ETARIO CON MAYOR CANTIDAD DE INFRACCIONES/////////');
 writeln('////////////////////////////////////////////////////////////////////////////////');
 posc:=0;
 posc2:=0;
 edad:=0;
 aaaa:=0;
 cont1:=0;
 cont2:=0;
 cont3:=0;         textcolor(white);
 while NOT(EOF(arch_inf)) do
       begin
       leer_dato_archinf (arch_inf,dato_inf,posc);
       dni:=dato_inf.dni;
       busqueda (arch_cond,posc2,dni);
       if posc2>=0 then
          begin
            leer_dato_archcond(arch_cond,dato_cond,posc2);
            aaaa:=StrToInt(copy(dato_cond.fecha_nac, 1,4));
          end;
       edad:=2024-aaaa;
       if (edad<=30) then
          cont1:= cont1+1
       else
        begin
        if (edad>=31) and (edad<=50)then
           cont2:=cont2+1
           else
            cont3:=cont3+1;
        end;
        posc:=posc+1;
        //posc2:=posc2+1;
       end;
 if (cont1>cont2)and (cont1>cont3) then
    writeln('El rango etario con mayor infracciones: Menores de 30')
 else
 begin
  if (cont2>cont1)and(cont2>cont3)then
    writeln('El rango etario con mayor infracciones: Mayores de 31 y Menores de 50')
   else
    if (cont3>cont1)and(cont3>cont2) then
      writeln('El rango etario con mayor infracciones: Mayores de 50')
    else
        if (cont1=cont2) then
          writeln('Los rangos etario con mayor infracciones: Menores de 30 y Mayores de 31 y Menores de 50')
        else
            if (cont1=cont3) then
              writeln('Los rangos etario con mayor infracciones: Menores de 30 y Mayores de 50')
            else
                if (cont2=cont3) then
                  writeln('Los rangos etario con mayor infracciones: Mayores de 31 y Menores de 50 y Mayores de 50');
 end;
 textcolor (yellow);
 write('|---PRESIONE ENTER PARA VOLVER AL MENU---|');
 readkey;
 cerrar_arch_inf(arch_inf);
 cerrar_arch_cond(arch_cond);
 end;
procedure cond_rein (var arch_cond:t_arch_cond);    //Porcentaje de conductores con reincidencia
var
 x:t_dato_cond;
 pos:byte;
 porcentaje:real;
 contador,total:integer;
 begin
 clrscr;
 abrir_arch_cond(arch_cond);
 pos:=0;
 porcentaje:=0;
 contador:=0;
 while not(EOF(arch_cond))do
       begin
       leer_dato_archcond (arch_cond,x,pos);
       if (x.cant_reincidencia>=1)then
         begin
         contador:=contador+1;
         pos:=pos+1
         end
         else
             pos:=pos+1 ;
         end;
 total:=(filesize(arch_cond)-1);
 porcentaje:=((contador * 100)/total);
 textcolor(white); gotoxy(2,5);
 writeln('El porcentaje de conductores con reicidencia: ');  gotoxy(47,5);
 textcolor(yellow);write(porcentaje:0:2);  textcolor(red); gotoxy(4,8);
 writeln('---Presione enter para salir----');
 readkey;
 cerrar_arch_cond(arch_cond);
 end;
 procedure cond_scocero(var arch_cond:t_arch_cond);               //porcentje de conductores con scoring 0
 var
  pos:byte;
  x:t_dato_cond;
  porc:real;
  cont,total:integer;
  begin
  clrscr;
  pos:=0;
  porc:=0;
  cont:=0;
  abrir_arch_cond(arch_cond);
  while not(EOF(arch_cond)) do
        begin
       leer_dato_archcond (arch_cond,x,pos);
       if (x.scoring=0)then
         begin
          cont:=cont+1;
          pos:=pos+1
         end
          else
             pos:=pos+1 ;
         end;
 total:=(filesize(arch_cond)-1);
 porc:=((cont * 100)/total);
 textcolor(white); gotoxy(2,5);
 writeln('El porcentaje de conductores con Scoring = 0:  ');
 gotoxy(49,5);
 textcolor(yellow);writeln(porc:0:2);
 textcolor(red); gotoxy(4,8);
 writeln('---Presione enter para salir----');
 readkey;
 cerrar_arch_cond(arch_cond);
  end;

 procedure eleccion_est(var arch_inf:t_arch_inf;var arch_cond:t_arch_cond); //menu estadisticas
 var op:char;
  begin
  repeat
  clrscr;
  textcolor(14); gotoxy(1,7);
  writeln('ELEGIR ESTADISTICA');
  textcolor(white);
  writeln('1-Cantidad de Infracciones entre dos fechas');
  writeln('2-Rango etario con mas infracciones');
  writeln('3-Porcentaje de conductores con reincidencia');
  writeln('4-Porcentaje de conductores con Scoring = 0');
  writeln('0-SALIR');
  repeat
  write('Ingrese Opcion: ');
  readln(op);
  until validar_menu(op,4,1,13)=true;
  case op of
    '1':  cantidad_infracciones(arch_inf);
    '2':  rango_inf_edad(arch_cond,arch_inf);
    '3':  cond_rein(arch_cond);
    '4':  cond_scocero(arch_cond);
  end;
  until op='0' ;
 end;
end.

