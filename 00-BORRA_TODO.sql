drop table IF EXISTS producto,
costos,
incobrabilidad,
ventas,
caida_prestamos,
pagos,
tabla_aux_costos,
deuda;

drop view IF EXISTS vw_costo_prestamos,
vw_detalle_pagos,
vw_int_devengado,
vw_resumen_tablon,
vw_tablon;

DROP procedure IF EXISTS `01-ACT_F_VTA_TABLA_VTA`;
DROP procedure IF EXISTS `02-ACT_ATR_TABLA_VENTAS`;
DROP procedure IF EXISTS `03-TABLA_DEUDA`;

drop function IF EXISTS COSTO_POR_PERIODO;
drop function IF EXISTS total_ventas;
