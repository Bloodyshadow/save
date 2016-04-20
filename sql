
create database myssmsdb;
use myssmsdb;

sno=student no;tno=teacher no;dmno=dormitory manager no;ano=admin no;dno=dormitory no;
rno=room no;tt=teacher title;fno=faculty no;ctno=charging teacherno;pwd=password;
fano=facility no;

create table student_info(sno int not null unique primary key,
name varchar(20) not null,
sex varchar(4),
sstatus int,
dstatus int,
cname varchar(32)
);

create table student_info_extra(sno int not null unique primary key,
birthday int,
nation varchar(32),
cno int,

);

create table teacher_info(tno int not null unique primary key,
name varchar(20) not null,
sex varchar(4),
fno int,
tt varchar(20),
stt varchar(20)


);

create table dormitorymanager_info(dmno int not null unique primary key,
name varchar(20) not null,
sex varchar(4),
dno int not null
);

create table account(no int not null unique primary key,
password vachar(20) not null

);

create table dormitory_info(dno int not null unique primary key,
rno int not null,
bno int not null,
sno int

);


create table hygienism_checkup(dno int,
rno int,
point int,
time date,
comment varchar(100)
)

create table facility_service(dno int,
rno int,
status int,
sort int,
fano int,
comment varchar(100)
)

create table leave_record(sno int not null primary key,
time date,
comment varchar(100),
status int,
ctno int,
ctcomment varchar(60),
resultcomment varchar(60)
)

create table attendance_check(dno int,
rno int,
bno int,
sno int,
time date,
status int
)

create table message_system(sno int,
type int,
status int)

create table rate(dno int,
rno int,
date int,
powerrate double
)
