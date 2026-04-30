unit archconductores_manejo;

{$mode ObjFPC}{$H+}

interface

uses
   SysUtils,crt;
 const ruta_cond='C:\Users\BANGHO\Documents\UTN\Algoritmo\Scoring\archivo_conductores.DAT';  //cambiar
 TYPE
   t_dato_cond=record
     dni:string[8];
     apellido:string[30];
     nombre:string[30];
     fecha_nac:string[8];   //yyyy/mm/dd
     telefono:string[8];
     email:string[20];
     scoring:byte;
     habilitado:boolean;
     fecha_hab:string[8]; //yyyy/mm/dd
     estado:boolean;
     cant_reincidencia: byte;
   end;
 t_arch_cond=file of t_dato_cond;
  procedure crear_arch_cond(var arch_cond:t_arch_cond );
  procedure abrir_arch_cond(var arch_cond:t_arch_cond);
  procedure cerrar_arch_cond(var arch_cond:t_arch_cond);
  procedure leer_dato_archcond (var arch_cond:t_arch_cond; var dato_cond:t_dato_cond; pos:byte);
  procedure escribir_dato_archcond(var arch_cond:t_arch_cond; dato_cond:t_dato_cond;var pos:byte);
implementation
procedure crear_arch_cond(var arch_cond:t_arch_cond );
begin
  assign(arch_cond,ruta_cond);
  rewrite(arch_cond);
end;
procedure abrir_arch_cond(var arch_cond:t_arch_cond);
begin
  assign(arch_cond,ruta_cond);
  reset(arch_cond);
end;
procedure cerrar_arch_cond(var arch_cond:t_arch_cond);
begin
  close(arch_cond);
end;
procedure leer_dato_archcond (var arch_cond:t_arch_cond; var dato_cond:t_dato_cond; pos:byte);
begin
  seek(arch_cond,pos);
  read(arch_cond,dato_cond);
end;
procedure escribir_dato_archcond(var arch_cond:t_arch_cond; dato_cond:t_dato_cond;var pos:byte);
begin
  seek(arch_cond,pos);
  write(arch_cond,dato_cond);
end;
end.

