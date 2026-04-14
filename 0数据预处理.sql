-- 建表
CREATE table user_behavior like taobao.user_behavior;
SELECT * from user_behavior LIMIT 5;
-- 查null--无null
select * from user_behavior 
where user_id is null or item_id is null or category_id is null or behavior_type is null or timestamps is null;
-- 查重--
select user_id,item_id,timestamps from user_behavior
 group by user_id,item_id,timestamps  having count(*)>1;
-- 去重--10088301（去重前数据）删除7条数据
alter table user_behavior add column id int primary key auto_increment first;
start TRANSACTION;
delete user_behavior 
from user_behavior,
(select user_id,item_id,timestamps,min(id) id 
from user_behavior
group by user_id,item_id,timestamps
having count(*)>1) as t1
where user_behavior.user_id=t1.user_id 
and user_behavior.item_id=t1.item_id 
and user_behavior.timestamps=t1.timestamps 
and user_behavior.id>t1.id;
commit;
-- 去异常  删除5303行
start transaction;
update user_behavior set datetimes=FROM_UNIXTIME(timestamps);
SAVEPOINT p1;
select * from user_behavior 
where  datetimes>'2017-12-03 23:59:59' or datetimes<'2017-11-25 00:00:00';
delete from user_behavior 
where  datetimes>'2017-12-03 23:59:59' or datetimes<'2017-11-25 00:00:00';
commit;
-- 删除时间戳小于0的行 删除93行
select * from user_behavior where timestamps<0;
start transaction;
DELETE from user_behavior where timestamps<0;
commit;
-- 添加dates,times,hours数据
start TRANSACTION;
update user_behavior set dates=substr(datetimes,1,10),
times=substr(datetimes,12,8),
hours=substr(datetimes,12,2);
commit;
-- 剩余数据10082898