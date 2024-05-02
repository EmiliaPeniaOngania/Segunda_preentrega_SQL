create table producto (
PRODUCTO_ID int auto_increment primary key,
NOMBRE_PRODUCTO varchar (20));

create table costos (
PRODUCTO_ID int ,
PERIODO int,
CONCEPTO varchar(20),
primary key(CONCEPTO,PERIODO,PRODUCTO_ID),
PCIO_PROM_UNIT float,
foreign key(PRODUCTO_ID) references producto(PRODUCTO_ID));
	
create table incobrabilidad (
ATRASO int primary key ,
PORCENT_INCOB float);

create table ventas (
N_CLIENTE int ,
N_PRESTAMO int auto_increment primary key,
FECHA_LIQUIDACION date,
PRODUCTO_ID int,
PLAZO int,
TNA float,
CAP_FINANCIADO float,
ATRASO int,
F_ULT_VTO_IMPAGO date,
foreign key(ATRASO) references incobrabilidad(ATRASO),
foreign key(PRODUCTO_ID) references producto(PRODUCTO_ID));

create table caida_prestamos (
N_PRESTAMO int,
N_CUOTA int,
primary key(N_PRESTAMO,N_CUOTA),
F_VTO date,
CAPITAL float,
INTERES float,
IVA float,
foreign key(N_PRESTAMO) references ventas(N_PRESTAMO));


create table pagos (
PERIODO int,
COMP_PAGO int auto_increment primary key,
N_PRESTAMO int,
N_CUOTA int,
F_PAGO date,
IMPORTE int,
foreign key(N_PRESTAMO) references ventas(N_PRESTAMO));

