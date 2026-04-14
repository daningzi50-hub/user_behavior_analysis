-- 进行漏斗分析
-- 按用户id商品id对各行为类型进行计数
create view behavior_count as
SELECT user_id,item_id,count(if(behavior_type='pv',behavior_type,null)) as 'pv',
count(if(behavior_type='fav',behavior_type,null)) as 'fav',
count(if(behavior_type='cart',behavior_type,null)) as 'cart',
count(if(behavior_type='buy',behavior_type,null)) as 'buy'
from user_behavior
GROUP BY user_id,item_id;
drop view behavior_count;

SELECT sum(buy)-count(*) from behavior_count where buy>0;
-- 计算收藏加购转化率
SELECT sum(buy) s1-- 154256
from behavior_count-- 
where buy>0 and fav=0 and cart=0;
SELECT sum(buy) s2 from behavior_count;-- 203897
select 203897-154256-- 49641
SELECT (203897-154256)/(559122+288385)-- 0.0586收藏加购转化率  
-- 筛选出购买行为的用户
create view buy_count as
SELECT user_id,item_id,if(pv>0,1,0) 浏览了,if(fav>0,1,0) 收藏了,
if(cart>0,1,0) 加购了,if(buy>0,1,0) 购买了,concat(if(pv>0,1,0),if(fav>0,1,0),if(cart>0,1,0),if(buy>0,1,0)) path_type
from behavior_count
where buy>0;
drop view buy_count;
-- 行为路径各类数量--8条购买路径
create view path_count as
SELECT path_type,count(*) num
from buy_count
GROUP BY path_type
order by count(*) desc;
drop view path_count;
-- 建立行为路径解说表
CREATE table path_description(path char(4),description varchar(50));
insert into path_description values('1001','浏览后购买'),('0001','直接购买'),('1011','浏览加购后购买'),
('1101','浏览收藏后购买'),('0011','加购后购买'),('0101','收藏后购买'),('1111','浏览收藏加购后购买'),
('0111','收藏加购后购买')
-- 联立两表生成类型描述数量表
create table path_result(path_type char(4),description varchar(50),num int);
insert into path_result
select path,description,num 
from path_description p 
join path_count c 
on p.path=c.path_type;
SELECT sum(num) FROM path_result;-- 194945