unit carga_t_inf_paradesc;

interface

uses
  crt,arch_cargainf_manejo,validacion_datos_sco;

procedure menu_inf_car(var arch_inf_car:t_arch_inf_car);
procedure cargar_inf(var arch_inf_car:t_arch_inf_car);
procedure mostrar_inf_cargadas(var arch_inf_car:t_arch_inf_car);

implementation
procedure menu_inf_car(var arch_inf_car:t_arch_inf_car);
var op:char;
begin
repeat
clrscr;
gotoxy(4,2);textcolor(yellow);
writeln('|---Administrador de Tipos de Infracciones---|'); textcolor(white);
writeln('1.Listado de Tipos de Infracciones Existentes.');
writeln('2.Cargar un Nuevo Tipo de Infraccion.');
writeln('0.Salir.');
repeat
gotoxy(4,7);     textcolor(white);
write('Ingrese Opcion: ');textcolor(3); readln(op);
until (validar_menu(op,2,4,7));
case op of
'1':mostrar_inf_cargadas(arch_inf_car);
'2':cargar_inf(arch_inf_car);
end;
until op='0' ;
end;

procedure cargar_inf(var arch_inf_car:t_arch_inf_car);
var
   pos:byte;
   inf:t_dato_inf_car;
   op: char;
begin
  reset(arch_inf_car);
  repeat
  clrscr;
  pos:=(filesize(arch_inf_car));    textcolor(white);
  writeln('Ingresar tipo de infraccion: ');     textcolor(3);
  readln(inf.tipo_inf);     textcolor(white);
  writeln('Ingresar puntos que descuenta la infraccion: '); textcolor(3);
  readln(inf.puntos_asig);
  escribir_dato_archinfcar(arch_inf_car,inf,pos);   textcolor(white);
  writeln( 'Desea seguir cargando?(1.SI/2.NO)' );    textcolor(3);
  readln(op);
  until (op='2') ;
  cerrar_arch_inf_car(arch_inf_car);

end;
procedure mostrar_inf_cargadas(var arch_inf_car:t_arch_inf_car);
var
   x:t_dato_inf_car;
   pos:byte;
begin
  clrscr;
reset(arch_inf_car);
  pos:=0;           textcolor(yellow);
writeln('TIPO DE INFRACCION', '---------','PUNTOS');   textcolor(white);
while not(EOF(arch_inf_car)) do
begin
leer_dato_archinfcar (arch_inf_car,x,pos);
writeln(x.tipo_inf,'--------- ',x.puntos_asig);
pos:=pos+1;
end;
textcolor(red);
write('---Presione ENTER para salir---|');
readkey;
cerrar_arch_inf_car(arch_inf_car);
end;

end.

