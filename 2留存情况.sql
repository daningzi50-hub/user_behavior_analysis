select * from retention_rate;
-- uv和一日留存用户 留存率=次日仍然活跃的用户/当日活跃用户
select dates,
count(DISTINCT if(datediff(next_date,dates)=1,user_id,null))/COUNT(DISTINCT user_id) as 'retention_rate1',
count(DISTINCT if(datediff(next_date,dates)=3,user_id,null))/COUNT(DISTINCT user_id) as 'retention_rate3'
from (SELECT user_id,dates,lead(dates) over (partition by user_id order by dates) as next_date from linshi GROUP BY user_id,dates) as d
GROUP BY dates;
-- 建表
create table retention_rate(dates date,retention_1 float);alter table retention_rate add column retention_3 FLOAT;
insert into retention_rate select dates,
count(DISTINCT if(datediff(next_date,dates)=1,user_id,null))/COUNT(DISTINCT user_id) as 'retention_rate1',
count(DISTINCT if(datediff(next_date,dates)=3,user_id,null))/COUNT(DISTINCT user_id) as 'retention_rate3'
from (SELECT user_id,dates,lead(dates) over (partition by user_id order by dates) as next_date from user_behavior GROUP BY user_id,dates) as d
GROUP BY dates;

-- 流失率 某一天活跃的人，后面再也没回来
select count(distinct user_id)
from user_behavior; -- 10_0000 --
select user_id
from user_behavior
group by user_id having count(behavior_type)=1;-- 7 只发生过一次用户行为
select count(user_id) 
from 
(select user_id,max(dates) dates from user_behavior group by user_id) as d1
where dates<'2017-12-03'; -- 2085 用户最大活动日期小于采集最大日期