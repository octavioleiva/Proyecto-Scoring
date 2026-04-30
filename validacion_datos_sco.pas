unit validacion_datos_sco;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,crt;
function validar_fecha(fecha:string; elim_lin:byte):boolean;
function validar_num(dato:string;elim_lin:byte):boolean;
function mostrar_fecha(fecha:string):string;
function validar_menu(op:char;fin,x,y:byte):boolean;
function validar_dni (dni:string; elim_lin:byte):boolean;
implementation
function validar_fecha(fecha:string; elim_lin:byte):boolean;
var
yyyy:string[4];
mm:string[2];
dd:string[2];

begin
yyyy:=copy(fecha, 1,4);
mm:=copy(fecha, 5,6);
dd:=copy(fecha, 7,8);
  if (yyyy<='2024') and (mm<='12') then
   	begin
   		if (mm='01') or (mm='03') or (mm='05') or (mm='07') or (mm='08') or (mm='10') or (mm='12') then
   			validar_fecha:= (dd<='31') and (dd > '00')
   		else validar_fecha:= (dd<='30')and (dd > '00');

   	end
   else validar_fecha:= false;
   if validar_fecha = false then
   	begin
   	gotoxy(1,elim_lin);
   	DelLine;
   	end;
end;
function validar_num(dato:string;elim_lin:byte):boolean;
var pos,cont:byte;
	car:string[1];
	begin
	pos:=1;
	cont:=0;
	while (pos<=length(dato)) do
		begin
		car:= copy(dato,pos,pos);
		if ((car <= char(57))and(car >= char(48))) and (dato <>'') then
		begin
		validar_num:= true;
		cont:= cont+1;
		end;
		pos:= pos +1;
		end;
		if cont < length(dato) then
		validar_num:=false;
		if validar_num = false then
		begin
		gotoxy(1,elim_lin);
		DelLine;
		end;
	end;
function mostrar_fecha(fecha:string):string;
var yyyy:string[4];
    mm,dd:string[2];
	begin
		yyyy:=copy(fecha, 1,4);
		mm:=copy(fecha, 5,6);
		dd:=copy(fecha, 7,8);
		mostrar_fecha:= yyyy + CHR(47) + mm + CHR(47) + dd;   //CHR(47) = '/'
	end;
function validar_menu(op:char;fin,x,y:byte):boolean;
     begin
       if (op>=CHR(48)) and (op<=CHR(48+fin)) then
       validar_menu:=true
       else validar_menu:=false;
       gotoxy(x,y);
       DelLine;
     end;
function validar_dni (dni:string; elim_lin:byte):boolean;
begin
 if validar_num(dni,elim_lin) and (length(dni)=8) then
 validar_dni:=true
 else
   begin
   gotoxy(1,elim_lin);
   DelLine;

   end;
 end;
end.

