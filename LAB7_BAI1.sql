/*cau 1a*/
if OBJECT_ID('fn_tuoi_nv') is not null
drop function fn_tuoi_nv
go
create function fn_tuoi_nv( @MaNhanVien nvarchar(9))
returns int
as
begin
return(select year(getdate())-year (ngsinh)
from NHANVIEN where MANV=@MaNhanVien)
end
print N'Tuổi của nhân viên :' + cast (dbo.fn_tuoi_nv('001') as varchar(5))
select * from nhanvien 
go
/*cau 1b*/
select count (mada)	from phancong where ma_nvien='001'
select * from phancong
if OBJECT_ID('fn_dean_nv') is not null
drop function fn_dean_nv
go
create function fn_dean_nv( @MaNhanVien nvarchar(9))
returns int
as
begin
return(select count (mada)	from phancong where MA_NVIEN=@MaNhanVien)
end
print N'Số lượng đề án của nhân viên :' + cast (dbo.fn_dean_nv('001') as varchar(5))
select * from nhanvien 
go
/*cau 1c*/
if OBJECT_ID('fn_phai_nv') is not null
drop function fn_phai_nv
go
create function fn_phai_nv( @gt nvarchar(4))
returns int
as
begin
return(select count (*)	from nhanvien where upper(phai)=upper(@gt))
end
select * from nhanvien
print N'Số lượng nhân viên nam :' + cast (dbo.fn_phai_nv('Nam') as varchar(5))
print N'Số lượng nhân viên nữ :' + cast (dbo.fn_phai_nv(N'Nữ') as varchar(5))
go
/*cau 1d*/
declare @luongtb float 
select @luongtb=avg(luong) from nhanvien
inner join phongban on phongban.maphg=nhanvien.phg
where upper(tenphg)=upper(@tenphongban)
insert into @listnv
select concat(honv, ' ', tenlot,' ',tennv), luong from nhanvien 
where luong>@luongtb
if OBJECT_ID('fn_luong_nv_pb') is not null
drop function fn_luong_nv_pb
go
create function fn_luong_nv_pb(@tenphongban nvarchar(15))
returns @listnv table(Hoten nvarchar(60), luong float)
as 
begin
declare @luongtb float 
select @luongtb=avg(luong) from nhanvien
inner join phongban on phongban.maphg=nhanvien.phg
where upper(tenphg)=upper(@tenphongban)
return
end
select * from PHONGBAN
select * from dbo.fn_luong_nv_pb(N'Điều hành')
/*cau 1d*/
select PHONGBAN.TENPHG, concat(honv,'', tenlot, '', tennv), count(mada) 
from PHONGBAN inner join dean on dean.PHONG=PHONGBAN.MAPHG 
inner join NHANVIEN on NHANVIEN.PHG=PHONGBAN.MAPHG 
where PHONGBAN.MAPHG=@MaPB
group by tenphg, honv, TENLOT, tennv
if OBJECT_ID('fn_PB_NV_dean') is not null
drop function fn_PB_NV_dean
go
create function fn_PB_NV_dean (@MaPB int)
returns @listPB table (TenPhong nvarchar(20), HoTenNV nvarchar(60),slDuan int)
as 
begin
insert into @listPB
select PHONGBAN.TENPHG, concat(honv,'', tenlot, '', tennv), count(mada) 
from PHONGBAN inner join dean on dean.PHONG=PHONGBAN.MAPHG 
inner join NHANVIEN on NHANVIEN.PHG=PHONGBAN.MAPHG 
where PHONGBAN.MAPHG=@MaPB
group by tenphg, honv, TENLOT, tennv
return
end
select * from dbo.fn_PB_NV_dean('001');
