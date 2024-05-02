drop table if exists tabla_aux_costos;

create table tabla_aux_costos (FECHA_PROCESO date,
PRODUCTO_ID int ,
PERIODO int,
CONCEPTO_ANTERIOR varchar(20),
CONCEPTO_NUEVO varchar(20),
PCIO_PROM_UNIT_ANT float,
PCIO_PROM_UNIT_NUEVO float,
ACCION varchar(20));

drop trigger if exists LOG_COSTOS_NUEVOS;

delimiter $$
create trigger LOG_COSTOS_NUEVOS 
after insert on costos
for each row
insert into tabla_aux_costos (fecha_proceso,producto_id,periodo,concepto_anterior,concepto_nuevo,pcio_prom_unit_ant,pcio_prom_unit_nuevo,accion)
values (curdate(),new.producto_id,new.periodo,'',new.concepto,0,new.pcio_prom_unit,'CARGA_DATOS');
$$
delimiter ;

drop trigger if exists LOG_COSTOS_MODIF;

delimiter $$
create trigger LOG_COSTOS_MODIF 
before update on costos
for each row
insert into tabla_aux_costos (fecha_proceso,producto_id,periodo,concepto_anterior,concepto_nuevo,pcio_prom_unit_ant,pcio_prom_unit_nuevo,accion)
values (curdate(),old.producto_id,old.periodo,old.concepto,new.concepto,old.pcio_prom_unit,new.pcio_prom_unit,'MODIFICA_DATOS');
$$
delimiter ;

drop trigger if exists LOG_COSTOS_BORRA;

delimiter $$
create trigger LOG_COSTOS_BORRA 
before delete on costos
for each row
insert into tabla_aux_costos (fecha_proceso,producto_id,periodo,concepto_anterior,concepto_nuevo,pcio_prom_unit_ant,pcio_prom_unit_nuevo,accion)
values (curdate(),old.producto_id,old.periodo,old.concepto,'',old.pcio_prom_unit,0,'BORRAR_DATOS');
$$
delimiter ;

