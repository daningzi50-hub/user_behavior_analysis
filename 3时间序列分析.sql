select * from linshi limit 5;
-- 各日期时间的用户行为
insert into date_hour_behavior 
select dates,hours,
count(if(behavior_type='pv',behavior_type,null)) as 'pv',
count(if(behavior_type='buy',behavior_type,null)) as 'buy',
count(if(behavior_type='cart',behavior_type,null)) as 'cart',
count(if(behavior_type='fav',behavior_type,null)) as 'fav'
from user_behavior GROUP BY dates,hours
order by dates,hours;
-- 建表保存数据
create table date_hour_behavior(dates date,hours int,pv int,buy int,cart int,fav int);
select * from date_hour_behavior;