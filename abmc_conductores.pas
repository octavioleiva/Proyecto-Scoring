unit abmc_conductores;

interface

uses
 arbol_cond,SysUtils,validacion_datos_sco,crt,archconductores_manejo,amc_infraccciones,archinfracciones_manejo,arch_cargainf_manejo;

procedure alta_cond(var arch_cond:t_arch_cond;dni:string;var nodo_dni,nodo_nom:t_puntero);
procedure baja_cond(posi:byte;var arch_cond:t_arch_cond) ;
procedure modificacion_cond(var arch_cond:t_Arch_cond; pos:byte );
procedure consulta_c(var pos:byte;var arch_cond:t_arch_cond);
procedure reincidir_cond(var arch_cond:t_arch_cond;pos:byte);
procedure ABMC_c2(pos:byte;dni:string;var arch_cond:t_arch_cond;var arch_inf:t_arch_inf;var arch_inf_car:t_arch_inf_car);
procedure ABMC_c(var arch_cond:t_arch_cond;var raiz_dni,raiz_nomb:t_puntero;var arch_inf:t_arch_inf;var arch_inf_car:t_arch_inf_car);

implementation
procedure alta_cond(var arch_cond:t_arch_cond;dni:string;var nodo_dni,nodo_nom:t_puntero);
var dato_cond:t_dato_cond;
    pos:byte;
    op,op2:char;
    dato_dni_arbol,dato_apynom_arbol:t_dato_arb_cond;

    begin
         clrscr;
      dato_cond.dni:=dni;
      writeln('DAR DE ALTA');
      writeln('INGRESE LOS DATOS:');
      write('Apellido:');readln(dato_cond.apellido);
      dato_cond.apellido:=LowerCase(dato_cond.apellido);
      write('Nombre:');readln(dato_cond.nombre);
      dato_cond.nombre:=Lowercase(dato_cond.nombre);
      repeat
       write('Fecha de nacimiento(aaaa/mm/dd):');readln(dato_cond.fecha_nac);
      until validar_fecha(dato_cond.fecha_nac,5);
      repeat
       write('Telefono:');readln(dato_cond.telefono);
      until validar_num(dato_cond.telefono,6);
      write('Email:');readln(dato_cond.email);
      dato_cond.email:=LowerCase(dato_cond.email);
      dato_cond.scoring:=20;
      dato_cond.estado:=true;
      dato_cond.habilitado:=true;
      repeat
       write('Fecha de Habilitacion(aaaa/mm/dd):');readln(dato_cond.fecha_hab);
      until validar_fecha(dato_cond.fecha_hab,8);
      dato_cond.cant_reincidencia:=0;
      repeat
      write('LOS DATOS INGRESADOS SON CORRECTOS?(0.SI/1.NO):');readln(op);
      until validar_menu(op,2,1,9);
      pos:=filesize(arch_cond);
      if op='0' then
         begin
         escribir_dato_archcond(arch_cond,dato_cond,pos);
         end
          else if op='1' then
             begin
             repeat
             write('Desea modificar algun dato?(0.SI/1.NO)?');readln(op2);
             until validar_menu(op,2,1,10);
             if op2='1' then
                begin
                escribir_dato_archcond(arch_cond,dato_cond,pos);
                modificacion_cond(arch_cond,pos);
                end;
             end;
  if (op = '0') or (op2 = '0') then
		begin
		    dato_dni_arbol.dato:= dato_cond.dni;
		    dato_dni_arbol.posi:= pos;
		    agregar_nodo(nodo_dni,dato_dni_arbol);

		    dato_apynom_arbol.dato:= dato_cond.apellido + dato_cond.nombre;
		    dato_apynom_arbol.posi:= pos;
		    agregar_nodo(nodo_nom,dato_apynom_arbol);
		end;
	clrscr;
    end;
procedure baja_cond(posi:byte;var arch_cond:t_arch_cond);
var     pos:byte;
	x:t_dato_cond;
	resp:char;
	begin
	pos:=posi;
	leer_dato_archcond(arch_cond,x,pos);
        consulta_c(pos,arch_cond);
	writeln('');
	textcolor(lightred);
	write('Seguro que quiere dar de BAJA? ');
	textcolor(white);
        repeat
	write('? (0.si/1.no): ');
        textcolor(white);
	readln(resp);
        until validar_menu(resp,2,1,2);
		    	if (x.estado = true) and (resp = '0')then
		    	begin
		    		x.estado:= false;
		    		textcolor(14);
		    		writeln('');
                                escribir_dato_archcond(arch_cond,x,pos);
		    		writeln('----Baja EXITOSA----');
		    	end;

		clrscr;
	end;
procedure modificacion_cond(var arch_cond:t_arch_cond; pos:byte );
 var dato,aux:t_dato_cond;   op,op2:char;
     begin
       repeat
       clrscr;
       consulta_c(pos,arch_cond);
       textcolor(yellow);
       writeln('///////////////////////////////////////////////////////////');
       writeln('////////////MODIFICACION DE DATOS DE CONDUCTOR////////////');
       leer_dato_archcond(arch_cond,dato,pos);
       aux:=dato;   textcolor(white);
       textcolor(white);
       writeln('1.Nombre');
       writeln('2.Apellido');
       writeln('3.Fecha De Nacimiento');
       writeln('4.Telefono');
       writeln('5.Email');
       writeln('0.Salir');
       repeat gotoxy(2,22);  textcolor(white);
       write('Ingrese Opcion: ');textcolor(3); readln(op);
       until validar_menu(op,5,2,22); clrscr; consulta_c(pos,arch_cond); gotoxy(2,15);
       writeln('---Ingrese el nuevo---');
       case op of
       '1':begin  textcolor(white);
           write('Nombre:');textcolor(3);readln(aux.nombre);
             aux.nombre:=LowerCase(aux.nombre);
             end;
       '2':   begin               textcolor(white);
              write('Apellido:');textcolor(3);readln(aux.apellido);
              aux.apellido:=LowerCase(aux.apellido);
              end;
       '3':begin
           repeat
           textcolor(white);
           write('Fecha de nacimiento(aaaa/mm/dd):');textcolor(3);readln(aux.fecha_nac);
           until  (validar_fecha(aux.fecha_nac,16));
           end;
       '4': begin
           repeat
           textcolor(white);
           write('Telefono:');textcolor(3);readln(aux.telefono);
           until (validar_num(aux.telefono,3));
           end;
       '5': begin
           textcolor(white);
           write('Email:');textcolor(3);readln(aux.email);
           aux.email:=LowerCase(aux.email);
           end;
           end;

       if aux.apellido<>''then
          dato.apellido:=aux.apellido;
        if aux.nombre<>''then
          dato.nombre:=aux.nombre;
       if aux.fecha_nac<>''then
          dato.fecha_nac:=aux.fecha_nac;
       if aux.telefono<>'' then
          dato.telefono:=aux.telefono;
       if aux.email<>'' then
          dato.email:=aux.email;
       escribir_dato_archcond(arch_cond,dato,pos);

       until op ='0';
       CLRSCR;
     end;
procedure consulta_c(var pos:byte;var arch_cond:t_arch_cond);
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
		textcolor(14);write('ESTADO: ');
                if dato.estado then
                begin
                textcolor(lightgreen);
                writeln(dato.estado)
                end
                else
                begin
                textcolor(red);
                writeln(dato.estado);
                end;
                textcolor(14);write('Habilitacion: ');textcolor(13);writeln(dato.habilitado);
                textcolor(white);

	end;
procedure reincidir_cond(var arch_cond:t_arch_cond;pos:byte);
var
    x:t_dato_cond;
    op:char;
    begin
     consulta_c(pos,arch_cond);
     leer_dato_archcond(arch_cond,x,pos);
     repeat
     gotoxy(2,16);textcolor(yellow);
     write('Quiere reincidir?(0.SI/1.NO): '); textcolor(3); readln(op);
     until validar_menu(op,2,2,16);
     if (op='0') and (x.scoring=0) then
     begin
     x.cant_reincidencia:=x.cant_reincidencia + 1;
     x.habilitado:=true;
     x.scoring:=20;
     escribir_dato_archcond(arch_cond,x,pos)
     end
     else
     begin
     gotoxy(2,15); textcolor(yellow);
     writeln('No es posible reincidir este conductor');
     readkey;
     end;
    end;

procedure ABMC_c2(pos:byte;dni:string;var arch_cond:t_arch_cond;var arch_inf:t_arch_inf;var arch_inf_car:t_arch_inf_car);
var op:char; x:t_Dato_cond;
begin
 repeat
     consulta_c(pos,arch_cond);
      leer_dato_archcond(arch_cond,x,pos);
    if x.estado then
	begin
		writeln('--ELIJA OPCION--');
		writeln('');
		writeln('1. Baja.');
		writeln('2. Modificacion.');
                writeln('3. Alta de Infraccion.');
                writeln('4. Reincidir Conductor.');
                writeln('5. Consulta de Infracciones.');
		writeln('0. SALIR.');
		writeln('');
                repeat
                write('Opcion -> ');
		readln(op);
                until validar_menu(op,5,1,25)=true ;
                clrscr;
		case op of
		'1':baja_cond(pos,arch_cond);
		'2':modificacion_cond(arch_cond,pos);
                '3':alta_inf(arch_inf,dni, arch_cond,pos,arch_inf_car);
                '4':reincidir_cond(arch_cond,pos);
                '5':consulta_inf(arch_inf,arch_cond,dni,pos);
		end;
	end
	else begin
             writeln('Conductor dado de Baja, Enter para salir');
			op:= '0';
			readkey;
		end;
	until op='0';
	end;
 procedure ABMC_c(var arch_cond:t_arch_cond;var raiz_dni,raiz_nomb:t_puntero;var arch_inf:t_arch_inf;var arch_inf_car:t_arch_inf_car);
var
     op,op2:char;
     pos:byte;
     encontrado: t_puntero;
     dni:string[8];
	begin
	  	abrir_arch_cond(arch_cond);
                abrir_arch_inf(arch_inf);
                //abrir_arch_inf_car(arch_inf_car);            //revisar donde abrirlo pq no me anda nada
	  	repeat
		encontrado:=nil;
		clrscr;
		textcolor(14);
		writeln('----Para salir presione ENTER sin ingresar datos----');
		textcolor(white);
		repeat
		write('Ingrese DNI: ');
		readln(dni);
		until ((dni='')or(validar_dni(dni,2)));

		if (dni<> '') then
		begin
			encontrado:= preorden(raiz_dni,dni);
			if encontrado=nil then
			begin
			textcolor(14);
			writeln('--NO EXISTE--');
				if (dni <> '')then
				begin

					writeln('Va a agregar?');
					writeln('0. SI');
					writeln('1. NO');
                                        repeat
					write('Opcion -> ');
					readln(op2);
                                        until validar_menu(op2,1,1,7);
                                        if op2 = '0' then
					begin
					alta_cond(arch_cond,dni,raiz_dni,raiz_nomb);
                                        pos:=(filesize(arch_cond)-1);
				        ABMC_c2(pos,dni,arch_cond,arch_inf,arch_inf_car);
					end;
				end;
			end
			else if (dni <> '') and (encontrado <>nil) then
			begin
				pos:=encontrado^.info.posi;
				ABMC_c2(pos,dni,arch_cond,arch_inf,arch_inf_car);
			end;
		end;
			if (dni = '')then
				op:='0';
				clrscr;
		until ((dni='')or(op = '1'));
                cerrar_arch_inf(arch_inf);
                cerrar_arch_cond(arch_cond);
               // cerrar_arch_inf_car(arch_inf_car);
	end;

end.
