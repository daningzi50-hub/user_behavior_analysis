-- RFM模型
-- 查看购买频率和最近购买日期
SELECT user_id,count(*) ,max(dates)
FROM linshi
where behavior_type='buy'
GROUP BY user_id
order by 2 desc,3 desc;
-- 存储
create table rfm_model(user_id int,frequency int,recent date);
insert into rfm_model SELECT user_id,count(*) ,max(dates)
FROM user_behavior
where behavior_type='buy'
GROUP BY user_id
order by 2 desc,3 desc;
select * from rfm_model ;
-- 根据购买频率划分等级
alter table rfm_model add column fscore int;
update rfm_model t join
(SELECT user_id,frequency,ntile(5) over (order by frequency ) as fscore
from rfm_model) tmp
on t.user_id=tmp.user_id
set t.fscore=tmp.fscore;
-- 根据最近购买日期划分等级
alter table rfm_model add column rscore int;
update rfm_model t join
(SELECT user_id,recent,ntile(5) over (order by recent ) as rscore
from rfm_model) tmp
on t.user_id=tmp.user_id
set t.rscore=tmp.rscore;
-- 用户分层
set @f_avg=null;
set @r_avg=null;
SELECT avg(fscore) into @f_avg from rfm_model;
SELECT avg(rscore) into @r_avg from rfm_model;

ALTER table rfm_model add column class varchar(50);
update rfm_model set class=case when fscore>=4 and rscore>=4 then '价值用户'
when fscore>=4 and rscore<4 then '保持用户'
when fscore<4 and rscore>=4 then '发展用户'
else '挽留用户' end
-- 计算各用户类型的数量
SELECT class ,count(user_id) from rfm_model GROUP BY class;