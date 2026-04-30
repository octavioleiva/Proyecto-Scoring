unit amc_infraccciones;

interface

uses
  validacion_datos_sco,archconductores_manejo,archinfracciones_manejo,arbol_cond,arch_cargainf_manejo,crt;
procedure alta_inf(var arch_inf:t_arch_inf; dni:string;var arch_cond:t_arch_cond;pos_cond:byte;var arch_inf_car:t_arch_inf_car);
procedure descuento_puntos(var arch_cond:t_arch_cond; var arch_inf_car:t_arch_inf_car;var dato_inf:t_dato_inf;pos_cond:byte; pos1:byte);
procedure busqueda (var arch_cond:t_arch_cond;var posc:integer; dato:string);
procedure busqueda_inf (var arch_inf:t_arch_inf;dni:string);
procedure consulta_inf(var arch_inf:t_arch_inf;var arch_cond:t_arch_cond;dni:string;pos_cond:byte);
procedure lista_t_inf(var arch_inf_car:t_arch_inf_car);
procedure busqueda_infra(inf:string;var arch_inf_car:t_arch_inf_car;var posc:byte;var encontrado:boolean);
procedure consulta_con(var pos:byte;var arch_cond:t_arch_cond);



implementation
  procedure alta_inf(var arch_inf:t_arch_inf; dni:string;var arch_cond:t_arch_cond;pos_cond:byte;var arch_inf_car:t_arch_inf_car);
  var dato_inf:t_dato_inf; op:char; pos:byte; pos1:byte; dato_t_inf:t_dato_inf_car; encontrado:boolean;
  begin
       dato_inf.dni:=dni;
       pos:=(filesize(arch_inf));
       encontrado:= false;
  repeat
  repeat
        consulta_con(pos_cond,arch_cond);
        lista_t_inf(arch_inf_car);
        gotoxy(2,15); textcolor(white);
        write('Fecha de Infraccion(aaaammdd): '); textcolor(3);readln(dato_inf.fecha_inf);
  until validar_fecha(dato_inf.fecha_inf,15) ;textcolor(white);
        write('Tipo de infraccion: '); textcolor(3); readln(dato_inf.tipo_inf);
        busqueda_infra(dato_inf.tipo_inf,arch_inf_car,pos1,encontrado);
        until encontrado = true;
      if encontrado then
         begin
          repeat
          textcolor(white);
         write('Haz ingresado los datos correctamente?(0.si/1.no)');  textcolor(3);readln(op);
          until validar_menu(op,1,2,18);
          if (op='0')  then
           begin
               descuento_puntos(arch_cond,arch_inf_car,dato_inf,pos_cond,pos1);
               escribir_dato_archinf(arch_inf,dato_inf,pos);
              clrscr;
           end
         end;
  end;

procedure descuento_puntos(var arch_cond:t_arch_cond;var arch_inf_car:t_arch_inf_car;var dato_inf:t_dato_inf;pos_cond:byte; pos1:byte);
var
          x:t_dato_inf_car;
          dni:string[8];
          dato_cond:t_dato_cond;
begin
   leer_dato_archcond(arch_cond,dato_cond,pos_cond);
   leer_dato_archinfcar (arch_inf_car,x,pos1);
   dato_cond.scoring:=dato_cond.scoring-x.puntos_asig;
   dato_inf.tipo_inf:= x.tipo_inf;
   dato_inf.puntos_desc:=x.puntos_asig;
   if (dato_cond.scoring<=0) then
    begin
    dato_cond.scoring:=0;
    dato_cond.habilitado:=false;
    end;
  escribir_dato_archcond(arch_cond,dato_cond,pos_cond);
end;
 procedure busqueda (var arch_cond:t_arch_cond;var posc:integer; dato:string);
 var encontrado:boolean;
   dato_cond:t_dato_cond;
   begin
     posc:=0;
     encontrado:=false;
     while not(EOF(arch_cond)) and(encontrado=false) do
    begin
     leer_dato_archcond(arch_cond,dato_cond,posc);
       if (dato_cond.dni=dato) then
          encontrado:=true
         else
           posc:=posc+1;
     end;
     if encontrado=false then
       posc:=-1;
     end;
 procedure busqueda_inf (var arch_inf:t_arch_inf; dni:string);
 var
   dato_inf:t_dato_inf;
   posc:byte;
   begin
    posc:=0;
    reset(arch_inf);
     while not(EOF(arch_inf)) do
      begin
     leer_dato_archinf(arch_inf,dato_inf,posc);
       if (dato_inf.dni=dni) then
        begin
          writeln('Fecha de Infraccion: ',mostrar_fecha(dato_inf.fecha_inf));
          writeln('Puntos que desconto: ',dato_inf.puntos_desc);
          writeln('|--------------------------------------------|');
          readkey;
          posc:=posc+1;
        end
       else
       posc:=posc+1;
      end;
     end;
procedure consulta_inf(var arch_inf:t_arch_inf;var arch_cond:t_arch_cond;dni:string;pos_cond:byte);
var
  x_cond:t_dato_cond;
   begin
    clrscr;
    leer_dato_archcond(arch_cond,x_cond,pos_cond);textcolor(yellow);
    writeln('|---Presione Enter para ir avanzando---|');   textcolor(3);
    writeln('|---',x_cond.apellido,'---',x_cond.nombre,'---|');  textcolor(white);
    busqueda_inf(arch_inf,dni);
    write('|---NO HAY MAS, ENTER PARA SALIR---|');
    readkey;
    CLRSCR;
  end;
procedure lista_t_inf(var arch_inf_car:t_arch_inf_car);
var
   x:t_dato_inf_car;
   pos:byte;
   i:byte;
begin
reset(arch_inf_car);
  //clrscr;
  pos:=0;
gotoxy(60,2);  textcolor(yellow);
write('TIPO DE INFRACCION', '---------','PUNTOS');
i:=3; textcolor(white);
while not(EOF(arch_inf_car)) do
begin
leer_dato_archinfcar (arch_inf_car,x,pos);
gotoxy(60,i);
write('|',x.tipo_inf,'--------- ',x.puntos_asig);
pos:=pos+1;
i:=i+1;
end;
end;
procedure busqueda_infra(inf:string; var arch_inf_car:t_arch_inf_car;var posc:byte;var encontrado:boolean);
var
x:t_dato_inf_car;
begin
posc:=0;
reset(arch_inf_car);
while not(EOF(arch_inf_car)) and (encontrado=false) do
begin
leer_dato_archinfcar (arch_inf_car,x,posc);
if (x.tipo_inf=inf) then
   encontrado:=true
   else
       posc:=posc+1;
end ;
if (encontrado=false) then
begin
     posc:= -1;    textcolor(yellow);
     write('No se encontro tipo, Presione enter para ingresar de nuevo');
     readkey;
 end;
end;
 procedure consulta_con(var pos:byte;var arch_cond:t_arch_cond);
var dato:t_dato_cond;
    fecha_con_barras1,fecha_con_barras2:string[10];
	begin
                clrscr;
		leer_dato_archcond(arch_cond,dato,pos);
		textcolor(14);
		writeln('----',dato.apellido,' ',dato.nombre,'----');
		writeln('');
		textcolor(14);write('Apellido: ');textcolor(white);writeln(dato.apellido);
		textcolor(14);write('Nombre: ');textcolor(white);writeln(dato.nombre);
		textcolor(14);write('DNI: ');textcolor(white);writeln(dato.dni);
		fecha_con_barras1:= mostrar_fecha(dato.fecha_nac);
		textcolor(14);write('Fecha de Nacimiento: ');textcolor(white);writeln(fecha_con_barras1);
                fecha_con_barras2:= mostrar_fecha(dato.fecha_hab) ;
		textcolor(14);write('Fecha de Habilitacion: ');textcolor(white);writeln(fecha_con_barras2);
		textcolor(14);write('Telefono: ');textcolor(white);writeln(dato.telefono);
		textcolor(14);write('Email: ');textcolor(white);writeln(dato.email);
                textcolor(14);write('Scoring: ');textcolor(white);writeln(dato.scoring);
                textcolor(14);write('Cantidad de Reincidencias: ');textcolor(white);writeln(dato.cant_reincidencia);
		textcolor(14);write('ESTADO: ');textcolor(lightgreen);writeln(dato.estado);
                textcolor(14);write('Habilitacion: ');textcolor(13);writeln(dato.habilitado);

	end;




end.
