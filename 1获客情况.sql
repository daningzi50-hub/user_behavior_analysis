create table linshi like user_behavior;
insert into linshi select * from user_behavior LIMIT 50000;
select * from linshi limit 5;
-- 点击量，点击用户数量
SELECT dates,count(*) as 'pv',count(DISTINCT user_id) as 'uv',round(count(*)/count(distinct user_id),1) as 'pv/uv'
from user_behavior
where behavior_type='pv'
GROUP BY dates;
-- 新建表puv
create table puv(dates date,pv int,uv int,pv_uv decimal(10,1));
select * from puv;
start TRANSACTION;
INSERT into puv SELECT dates,count(*) as 'pv',count(DISTINCT user_id) as 'uv',round(count(*)/count(distinct user_id),1) as 'pv/uv'
from user_behavior
where behavior_type='pv'
GROUP BY dates;
COMMIT;