-- 统计各类行为用户数
select behavior_type,count(DISTINCT user_id)
from linshi
GROUP BY behavior_type;
-- 建表插入各类行为用户数
create table behavior_user_num(behavior_type varchar(5),user_num int);

insert into behavior_user_num
select behavior_type,count(DISTINCT user_id) user_num
from user_behavior
GROUP BY behavior_type;
-- 统计各类行为数
SELECT behavior_type,count(*)
from linshi
GROUP BY behavior_type;
-- 建表插入行为数
CREATE TABLE behavior_num(behavior_type varchar(5),behavior_count int);
SELECT * from behavior_num;

INSERT into behavior_num 
SELECT behavior_type,count(*)
from user_behavior
GROUP BY behavior_type;
-- 转化率
select 68235/99645 user_count,203897/9031494 behavior_count;
-- 0.6848用户维度购买转化率、最终购买转化率 | 0.0226行为维度购买转化率、购买转化率
select (559122+288385)/9031494 -- 0.0938 收藏加购率