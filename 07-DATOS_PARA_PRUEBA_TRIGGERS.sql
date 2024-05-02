insert into costos
(PRODUCTO_ID,PERIODO,CONCEPTO,PCIO_PROM_UNIT)
values
(1,202405,'Comercializador',1200),
(1,202405,'Seguro costo fijo',300),
(1,202405,'Cuponera',1020),
(2,202405,'Seguro costo fijo',200),
(3,202405,'Seguro costo fijo',300),
(4,202405,'Seguro costo fijo',300),
(4,202405,'Cuponera',1020);

UPDATE COSTOS
SET PCIO_PROM_UNIT=1250
WHERE CONCEPTO='COMERCIALIZADOR'
AND PERIODO=202405
AND PRODUCTO_ID=1;

set sql_safe_updates=0; ##no me deja borrar

DELETE FROM COSTOS
WHERE PERIODO=202405;

select * from tabla_aux_costos;
