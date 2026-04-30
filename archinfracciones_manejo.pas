unit archinfracciones_manejo;


{$mode ObjFPC}{$H+}

interface

uses
   SysUtils,crt;
const ruta_inf='C:\Users\BANGHO\Documents\UTN\Algoritmo\Scoring\archivo_infracciones.DAT';
type
  t_dato_inf=record
    dni:string[8];
    fecha_inf:string[8];   //
    tipo_inf:string[100];
    puntos_desc:byte;
  end;
  t_arch_inf=file of t_dato_inf;
  procedure crear_arch_inf(var arch_inf:t_arch_inf );
  procedure abrir_arch_inf(var arch_inf:t_arch_inf);
  procedure cerrar_arch_inf(var arch_inf:t_arch_inf);
  procedure leer_dato_archinf (var arch_inf:t_arch_inf; var dato_inf:t_dato_inf; pos:byte);
  procedure escribir_dato_archinf(var arch_inf:t_arch_inf; dato_inf:t_dato_inf;var pos:byte);
implementation
 procedure crear_arch_inf(var arch_inf:t_arch_inf );
begin
  assign(arch_inf,ruta_inf);
  rewrite(arch_inf);
end;
procedure abrir_arch_inf(var arch_inf:t_arch_inf);
begin
  assign(arch_inf,ruta_inf);
  reset(arch_inf);
end;
procedure cerrar_arch_inf(var arch_inf:t_arch_inf);
begin
  close(arch_inf);
end;
procedure leer_dato_archinf (var arch_inf:t_arch_inf;var dato_inf:t_dato_inf; pos:byte);
begin
  seek(arch_inf,pos);
  read(arch_inf,dato_inf);
end;
procedure escribir_dato_archinf(var arch_inf:t_arch_inf; dato_inf:t_dato_inf;var pos:byte);
begin
  seek(arch_inf,pos);
  write(arch_inf,dato_inf);
end;
end.

