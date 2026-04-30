unit menu_sco;

{$mode ObjFPC}{$H+}

interface

uses
  archconductores_manejo,archinfracciones_manejo,arbol_cond,abmc_conductores,listados_sco,est_archinf,validacion_datos_sco,arch_cargainf_manejo,carga_t_inf_paradesc,crt;
procedure menu() ;

implementation
procedure menu() ;
var op:char;
    raiz_dni,raiz_nom:t_puntero;
    arch_cond:t_arch_cond;
    arch_inf:t_arch_inf;
    arch_inf_car:t_arch_inf_car;
begin

 crear_arbol(raiz_dni);
 crear_arbol(raiz_nom);
 cargar_arbol_api(raiz_nom,arch_cond);
 writeln('');
 cargar_arbol_dni(raiz_dni,arch_cond);
 abrir_arch_inf_car(arch_inf_car);
 //CREA ARCHIVO
 //crear_arch_cond(arch_cond);
 //crear_arch_inf(arch_inf);
 //crear_arch_inf_car(arch_inf_car);
repeat
   clrscr; textcolor(yellow);
   gotoxy(15,1);
   write('////////////////////////////') ;
   gotoxy(15,2);
   write('///MENU PRINCIPAL SCORING///'); gotoxy(15,3);
   write('///////////////////////////');
   gotoxy(15,4);    textcolor(white);
   write('1-Conductores');
   gotoxy(15,5);
   write('2-Estadisticas');
   gotoxy(15,6);
   write('3-Listados');
   gotoxy(15,7);
   write('4-Administrador De Tipo de Infracciones');
   gotoxy(15,9);
   write('0-Salir');
   repeat
   gotoxy(15,13); textcolor(white);
   write( 'Ingresar Opcion:');  textcolor(3); readln(op);
   until (validar_menu(op,4,15,13));
   case op of
       '1': ABMC_c(arch_cond,raiz_dni,raiz_nom,arch_inf,arch_inf_car);
       '2': eleccion_est(arch_inf,arch_cond);
       '3': eleccion_listado(arch_cond,raiz_nom,arch_inf);
       '4': menu_inf_car(arch_inf_car);
   end;
 until op='0' ;
 cerrar_arch_inf_car(arch_inf_car);
end;

end.

