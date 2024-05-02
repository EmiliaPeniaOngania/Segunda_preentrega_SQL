# CREA VISTA 1 CON EL DETALLE DEL PAGO POR CONCEPTO

drop view if exists `VW_DETALLE_PAGOS`;

create view `VW_DETALLE_PAGOS` as
select c.N_PRESTAMO,
c.N_CUOTA,
c.F_VTO,
c.CAPITAL,
c.INTERES,
c.IVA,
p.F_PAGO,
p.IMPORTE
from caida_prestamos c 
inner join pagos p on p.N_PRESTAMO=c.N_PRESTAMO and p.N_CUOTA=c.N_CUOTA;

# CREA VISTA 2 DONDE CALCULA EL COSTO DE CADA PRESTAMO

drop view if exists `VW_COSTO_PRESTAMOS`;

create view `VW_COSTO_PRESTAMOS` as
select 
c.PERIODO,
v.N_PRESTAMO,
p.NOMBRE_PRODUCTO,
sum(c.PCIO_PROM_UNIT) as COSTO
from ventas v 
left join costos c on v.PRODUCTO_ID=c.PRODUCTO_ID and c.PERIODO=concat(year(v.FECHA_LIQUIDACION),if(length(month(v.FECHA_LIQUIDACION))=1,concat('0',month(v.FECHA_LIQUIDACION)),month(v.FECHA_LIQUIDACION)))
left join producto p on p.PRODUCTO_ID=c.PRODUCTO_ID
group by v.N_PRESTAMO,c.PERIODO,p.NOMBRE_PRODUCTO;

# CREA VISTA 3 DONDE MUESTRA EL INTERES DEVENGADO AL DIA DE HOY DE CADA CUOTA,

drop view if exists `VW_INT_DEVENGADO`;

create view `VW_INT_DEVENGADO` as
select 
CURDATE() AS FECHA_PROCESO,
c.N_PRESTAMO,
c.N_CUOTA,
date_add(c.F_VTO,interval(-1) month) as F_INICIO,
c.F_VTO,
p.F_PAGO,
c.CAPITAL,
case
	when curdate()>c.F_VTO then round(c.INTERES,2)
	when curdate()>p.F_PAGO then round(c.INTERES,2)
    when curdate()< date_add(c.F_VTO,interval(-1) month) then 0
	else round(c.INTERES/datediff(c.F_VTO,date_add(c.F_VTO,interval(-1) month))*datediff(curdate(),date_add(c.F_VTO,interval(-1) month)),2)
    end as INT_DEV,
case
	when curdate()>c.F_VTO then round(c.IVA,2)
	when curdate()>p.F_PAGO then round(c.IVA,2)
    else 0
    end as IVA_DEV,
case 
	when p.F_PAGO is not null then 'CANCELADA'
    when curdate()>c.F_VTO then 'VENCIDA'
	when curdate()< date_add(c.F_VTO,interval(-1) month) then 'NO VIGENTE'
	else 'VIGENTE'
    end as ESTADO_CUOTA,
case
	when p.F_PAGO is not null then 0
    when curdate()>c.F_VTO then datediff(curdate(),c.F_VTO)
	else 0 end as ATRASO_CUOTA
from caida_prestamos c 
left join VW_DETALLE_PAGOS p on p.N_PRESTAMO=c.N_PRESTAMO and p.N_CUOTA=c.N_CUOTA;

# CREA VISTA 4 TABLON 

drop view if exists `VW_TABLON`;

create view `VW_TABLON` as
select distinct
CURDATE() AS FECHA_PROCESO,
v.N_PRESTAMO,
p.NOMBRE_PRODUCTO,
v.FECHA_LIQUIDACION,
v.PLAZO,
v.TNA,
v.CAP_FINANCIADO,
d.DEUDA_CAPITAL,
d.DEUDA_INTERES,
d.DEUDA_IVA,
d.DEUDA_TOTAL,
v.ATRASO,
round(d.DEUDA_TOTAL * I.PORCENT_INCOB,2) as CARGO_INCOB,
c.PERIODO as PERIODO_COSTO,
c.COSTO
from ventas v
left join VW_COSTO_PRESTAMOS c on c.N_PRESTAMO=v.N_PRESTAMO
left join DEUDA d on c.N_PRESTAMO=v.N_PRESTAMO
left join incobrabilidad i on v.ATRASO=V.ATRASO
left join producto p on p.PRODUCTO_ID=v.PRODUCTO_ID;

 # CREA VISTA 5 DONDE MUESTAR UN RESUMEN DE LAS VENTAS CON SUS COSTOS 

drop view if exists `VW_RESUMEN_TABLON`;

create view `VW_RESUMEN_TABLON` as
select distinct
t.FECHA_PROCESO,
t.NOMBRE_PRODUCTO,
round(count(t.N_PRESTAMO),0),
round(sum(t.DEUDA_CAPITAL),2),
round(sum(t.DEUDA_INTERES),2),
round(sum(t.DEUDA_IVA),2),
round(sum(t.DEUDA_TOTAL),2),
round(sum(t.CARGO_INCOB),2)
from vw_tablon t
where t.DEUDA_TOTAL!=0
group by (t.NOMBRE_PRODUCTO);
