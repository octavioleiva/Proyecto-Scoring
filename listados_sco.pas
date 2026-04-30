unit listados_sco;

{$mode ObjFPC}{$H+}

interface

uses
  archconductores_manejo,arbol_cond,validacion_datos_sco,archinfracciones_manejo,crt;

procedure inorden(var raiz:t_puntero;var arch_cond:t_arch_cond);
procedure lista_apynom(var arch_cond:t_arch_cond;var raiz_nom:t_puntero);
procedure listado_scocero(var arch_cond:t_arch_cond);
 procedure eleccion_listado(var arch_cond:t_arch_cond;var raiz_nom:t_puntero;var arch_inf:t_arch_inf);
 procedure ORDENAR(var arch_inf:t_arch_inf);
 procedure lista_por_fecha(var arch_inf:t_arch_inf);
 procedure lista_por_fecha_conductor(var arch_inf:t_arch_inf);
implementation
procedure inorden(var raiz:t_puntero;var arch_cond:t_arch_cond);        //lista ordenada de conductores
var i,pos:word;
    dato_cond:t_dato_cond;
begin

        if raiz <> nil then
        begin
        inorden(raiz^.SAI,arch_cond);
        pos:=raiz^.info.posi;
        leer_dato_archcond(arch_cond,dato_cond,pos);
            if dato_cond.estado = true then
            begin
            textcolor(11);
            writeln('|--------------------------------------------------------------------');
            writeln('|',dato_cond.apellido,' ',dato_cond.nombre,' --- ','---',dato_cond.dni,'---',dato_cond.estado,'---',dato_cond.scoring,'|');
            writeln('|--------------------------------------------------------------------');
            //readkey;
            end;
        if (dato_cond.estado=false) then
        begin
        textcolor(11);
        write('|',dato_cond.apellido,' ',dato_cond.nombre,' --- ','---',dato_cond.dni,'---');textcolor(red); write(dato_cond.estado);textcolor(11);writeln('---','0','|');
        end;
        inorden(raiz^.SAD,arch_cond);
        end;
end;
procedure lista_apynom(var arch_cond:t_arch_cond;var raiz_nom:t_puntero);
begin
        clrscr;
        textcolor(14);
        writeln('------LISTADO POR APELLIDO Y NOMBRE------');
        writeln('');   textcolor(14);
            writeln('|----Apellido----Nombre----Dni----Estado-----Scoring----|');
        abrir_arch_cond(arch_cond);
        if filesize(arch_cond)<>0 then
        begin
         if not(arbol_vacio(raiz_nom))then
            begin
                 inorden(raiz_nom,arch_cond);
                 textcolor(14);
                 writeln('|--------------------------------------------------------------------')
            end
                    else
                        writeln('NO HAY DATO');
        end;
writeln('|---NO HAY MAS, ENTER PARA SALIR---|');
readkey;
cerrar_arch_cond(arch_cond);

end;
procedure listado_scocero(var arch_cond:t_arch_cond);
var x:t_dato_cond;
    pos:byte;
    cont:byte;
    begin
    clrscr;           textcolor(yellow);
    writeln('|---LISTADO DE CONDUCTORES CON SCORING = 0---|'); textcolor(white);
     writeln('|----Apellido----Nombre----Dni----Estado-----Cantidad De Reincidencias----|');
    pos:=0;
    cont:=0;
    abrir_arch_cond(arch_cond);
    while not(EOF(arch_cond)) do
    begin
      leer_dato_archcond(arch_cond,x,pos);
      if (x.scoring = 0) then
      begin
           textcolor(3);
          writeln('|',x.apellido,' ',x.nombre,' --- ','---',x.dni,'---',x.estado,'---',x.cant_reincidencia,'|');
         cont:=cont+1;
      end;
      pos:=pos+1;
      if EOF(arch_cond) AND (cont<>0) then
      begin
      textcolor(red);
      write('|---NO HAY MAS,ENTER PARA SALIR---|');
      end;
    end;
    if (cont = 0) then
    begin
    writeln('NO HAY CONDUCTORES CON SCORING = 0');
    end;
    readkey;
    close(arch_cond);
 end;
procedure eleccion_listado(var arch_cond:t_arch_cond;var raiz_nom:t_puntero;var arch_inf:t_arch_inf);
var op:char;
    begin
     repeat
     clrscr;
     textcolor(14); gotoxy(1,7);
     writeln('---ELEGIR LISTADO---'); textcolor(white);
     writeln('1.Listado Ordenado de Conductores.');
     writeln('2.Listado de conductores con scoring = 0.');
     writeln('3.Listado de Infracciones Ordenado entre dos fechas.');
     writeln('4.Listado Ordenado por fecha de infraccion de un conductor en un periodo.');
     writeln('0.SALIR.');
     repeat
     write('Ingrese Opcion:'); readln(op);
     until validar_menu(op,4,1,12);
     case op of
     '1': lista_apynom(arch_cond,raiz_nom);
     '2': listado_scocero(arch_cond);
     '3': lista_por_fecha(arch_inf);
     '4': lista_por_fecha_conductor(arch_inf);
     end;
     until (op='0');
    end;
procedure ORDENAR(var arch_inf:t_arch_inf);
VAR
reg_dato,reg_dat_I,reg_dat_J:t_dato_inf;
i,j,posi,posj:byte;
fecha_i,fecha_j:string;
  begin
    for i:=1 to (filesize(arch_inf)-1)-1 do
      begin
        for  j:=i+1 to filesize(arch_inf)-1 do
        begin
        leer_dato_archinf(arch_inf,reg_dato,i);
        fecha_i:=reg_dato.fecha_inf;
        reg_dat_I:=reg_dato;
        leer_dato_archinf(arch_inf,reg_dato,j);
        fecha_j:=reg_dato.fecha_inf ;
        reg_dat_J:=reg_dato;
          if fecha_i > fecha_j  then
          begin
           posi:=i;
           posj:=j;
          reg_dato := reg_dat_J;
          escribir_dato_archinf(arch_inf,reg_dato,posi);
          reg_dato :=reg_dat_I;
          escribir_dato_archinf(arch_inf,reg_dato,posj);
           end;
        end;
      end;
  end;
procedure lista_por_fecha(var arch_inf:t_arch_inf);
var
 fechain, fechafin:string[10]; //fecha inicio y final
 pos:byte;
 x:t_dato_inf;
begin
  clrscr;
  pos:=0;
  abrir_arch_inf(arch_inf);
  writeln('INGRESAR FECHAS DE LA SIGUIENTE FORMA: aaaammdd');
  repeat
  write('Ingrese fecha inicial (aaaa/mm/dd): ');
  textcolor(11);
  readln(fechain);
  textcolor(white);
  until validar_fecha(fechain,2) ;
  repeat
  write('Ingrese fecha final (aaaa/mm/dd): ');
  textcolor(11);
  readln(fechafin);
  textcolor(white);
  until validar_fecha(fechafin,3);    gotoxy(2,8);
  writeln('|---LISTADO ORDENADO DE INFRACCIONES ENTRE DOS FECHAS---|');
  writeln(' ');    textcolor(yellow);
   writeln('|---Fecha de Infraccion---DNI---Tipo De Infraccion---Puntos que desconto---|');
   writeln('|--------------------------------------------------------------------------|');
  while not (EOF(arch_inf)) do
        begin
          leer_dato_archinf(arch_inf,x,pos);
          if (x.fecha_inf <= fechafin) and (x.fecha_inf >= fechain) then
             begin
               x.fecha_inf:=mostrar_fecha(x.fecha_inf);
               textcolor(white);
               writeln('|---',x.fecha_inf,'---',x.dni,'---',x.tipo_inf,'---',x.puntos_desc,'---|');
             end;
          pos:=pos+1;
        end;
  cerrar_arch_inf(arch_inf);
  textcolor(11);
  writeln('|---------------------------------------------------------');
  readkey;
end;
procedure lista_por_fecha_conductor(var arch_inf:t_arch_inf);  //listado ordenado por fecha de infraccion de un condurcor en un periodo
var
 fechain, fechafin:string[10]; //fecha inicio y final
 pos:byte;
 x:t_dato_inf;
 dni:string[8];
begin
  clrscr;
  pos:=0;
  abrir_arch_inf(arch_inf);
  writeln('Ingrese DNI: ');
  readln(dni);
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
  writeln('|---LISTADO ORDENADO DE INFRACCIONES DEL CONDUCTOR CON DNI ',dni,' ENTRE DOS FECHAS---|');
  while not (EOF(arch_inf)) do
        begin
          leer_dato_archinf(arch_inf,x,pos);
          if (x.dni = dni) then
             begin
                  if (x.fecha_inf <= fechafin) and (x.fecha_inf >= fechain) then
                     begin
                       x.fecha_inf:=mostrar_fecha(x.fecha_inf);
                       textcolor(yellow);
                       writeln('|---Fecha de Infraccion---Puntos que desconto---|');
                       textcolor(white);
                       writeln('|---',x.fecha_inf,'---',x.puntos_desc,'---|');
                     end;
                  pos:=pos+1;
        end;
        end;
  cerrar_arch_inf(arch_inf);
  textcolor(11);
  writeln('|---------------------------------------------------------');
  readkey;
end;

end.

