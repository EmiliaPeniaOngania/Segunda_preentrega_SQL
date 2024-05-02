#FUNCION 1 TOTAL DE VENTAS POR PERIODO Y PRODUCTO

USE `ent_fciera`;
DROP function IF EXISTS `TOTAL_VENTAS`;

DELIMITER $$
USE `ent_fciera`$$
create function `TOTAL_VENTAS` (PRODUCTO_ID int, PERIODO int)
returnS decimal (20,2) deterministic
begin
declare TOTAL decimal(20,2);
select sum(CAP_FINANCIADO) into TOTAL
from ventas where PRODUCTO_ID=PRODUCTO_ID
and PERIODO=concat(year(FECHA_LIQUIDACION),if(length(month(FECHA_LIQUIDACION))=1,concat('0',month(FECHA_LIQUIDACION)),month(FECHA_LIQUIDACION)));
return TOTAL;
end;$$

DELIMITER ;

#FUNCION 1 COSTO POR PERIODO

USE `ent_fciera`;
DROP function IF EXISTS `COSTO_POR_PERIODO`;

DELIMITER $$
USE `ent_fciera`$$
create function `COSTO_POR_PERIODO` (PERIODO int)
returnS decimal (20,2) deterministic
begin
declare TOTAL decimal(20,2);
select sum(COSTO) into TOTAL
from vw_costo_prestamos where PERIODO=PERIODO;
return TOTAL;
end;$$

DELIMITER ;
