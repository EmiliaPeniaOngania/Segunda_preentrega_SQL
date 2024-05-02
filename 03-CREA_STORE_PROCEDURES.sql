# CREA STORE PROCEDURE 1 PARA ACTUALIZAR FECHA DE VENTA EN TABLA VENTAS

USE `ent_fciera`;
DROP procedure IF EXISTS `01-ACT_F_VTA_TABLA_VTA`;

DELIMITER $$
USE `ent_fciera`$$
CREATE PROCEDURE `01-ACT_F_VTA_TABLA_VTA` ()
BEGIN
create temporary table TEMP_PROX_VTO 
	Select
    c.N_PRESTAMO,
    min(c.F_VTO) as PROX_VTO
    from caida_prestamos c
    where  concat(c.N_PRESTAMO,'_',c.N_CUOTA) not in (select concat(p.N_PRESTAMO,'_',p.N_CUOTA) from pagos p)
    group by (c.N_PRESTAMO);
    
    update ventas v, TEMP_PROX_VTO p
    set v.F_ULT_VTO_IMPAGO=p.PROX_VTO 
    where v.N_PRESTAMO=P.N_PRESTAMO;

    drop temporary table if exists TEMP_PROX_VTO;
    
END$$

DELIMITER ;

# CREA STORE PROCEDURE 2 PARA ACTUALIZAR ATRASO EN TABLA VENTAS

USE `ent_fciera`;
DROP procedure IF EXISTS `02-ACT_ATR_TABLA_VENTAS`;

DELIMITER $$
USE `ent_fciera`$$
CREATE PROCEDURE `02-ACT_ATR_TABLA_VENTAS` ()
BEGIN

drop temporary table if exists TEMP_ATRASO;

create temporary table TEMP_ATRASO
	Select
    V.N_PRESTAMO,
    IF(datediff(curdate(),v.F_ULT_VTO_IMPAGO)<0,0,datediff(curdate(),v.F_ULT_VTO_IMPAGO)) AS ATR
    from ventas v;
    
update ventas v, TEMP_ATRASO a
    set v.atraso=a.atr
    where v.N_PRESTAMO=a.N_PRESTAMO;

END$$

DELIMITER ;



# CREA STORE PROCEDURE 3 PARA CREAR LA TABLA DE DEUDA

USE `ent_fciera`;
DROP procedure IF EXISTS `03-TABLA_DEUDA`;

DELIMITER $$
USE `ent_fciera`$$
CREATE PROCEDURE `03-TABLA_DEUDA` ()
BEGIN
drop table if exists DEUDA;
create table DEUDA 
select
curdate() as FECHA_PROCESO,
d.N_PRESTAMO,
round(SUM(d.CAPITAL),2) AS DEUDA_CAPITAL,
round(SUM(d.INT_DEV),2) AS DEUDA_INTERES,
round(SUM(d.IVA_DEV),2) AS DEUDA_IVA,
round(SUM(d.CAPITAL) + SUM(d.INT_DEV) + SUM(d.IVA_DEV),2) AS DEUDA_TOTAL
from VW_INT_DEVENGADO d
where d.ESTADO_CUOTA!='CANCELADA'
group by d.N_PRESTAMO;
END$$

DELIMITER ;

