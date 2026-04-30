unit arch_cargainf_manejo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,crt;
const
  ruta_inf_car='C:\Users\BANGHO\Documents\UTN\Algoritmo\Scoring\archivo_inf_carga.DAT';
type
  t_dato_inf_car= record
    tipo_inf:string[100];
    puntos_asig:byte;
  end;
  t_arch_inf_car= file of t_dato_inf_car;
  procedure crear_arch_inf_car(var arch_inf_car:t_arch_inf_car );
  procedure abrir_arch_inf_car(var arch_inf_car:t_arch_inf_car);
  procedure cerrar_arch_inf_car(var arch_inf_car:t_arch_inf_car);
  procedure leer_dato_archinfcar (var arch_inf_car:t_arch_inf_car; var dato_inf_car:t_dato_inf_car; pos:byte);
  procedure escribir_dato_archinfcar(var arch_inf_car:t_arch_inf_car; dato_inf_car:t_dato_inf_car;var pos:byte);
implementation
 procedure crear_arch_inf_car(var arch_inf_car:t_arch_inf_car );
begin
  assign(arch_inf_car,ruta_inf_car);
  rewrite(arch_inf_car);
end;
procedure abrir_arch_inf_car(var arch_inf_car:t_arch_inf_car);
begin
  assign(arch_inf_car,ruta_inf_car);
  reset(arch_inf_car);
end;
procedure cerrar_arch_inf_car(var arch_inf_car:t_arch_inf_car);
begin
  close(arch_inf_car);
end;
procedure leer_dato_archinfcar (var arch_inf_car:t_arch_inf_car;var dato_inf_car:t_dato_inf_car; pos:byte);
begin
  seek(arch_inf_car,pos);
  read(arch_inf_car,dato_inf_car);
end;
procedure escribir_dato_archinfcar(var arch_inf_car:t_arch_inf_car; dato_inf_car:t_dato_inf_car;var pos:byte);
begin
  seek(arch_inf_car,pos);
  write(arch_inf_car,dato_inf_car);
end;
end.

