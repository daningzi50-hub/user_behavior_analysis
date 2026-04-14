-- 商品转化率
create table item_user_rate(item_id int,pv int,fav int,cart int,buy int,商品转化率 float);
insert into item_user_rate
SELECT item_id,count(if(behavior_type='pv',behavior_type,null)) 'pv',
count(if(behavior_type='fav',behavior_type,null)) 'fav',
count(if(behavior_type='cart',behavior_type,null)) 'cart',
count(if(behavior_type='buy',behavior_type,null)) 'buy',
count(distinct if(behavior_type='buy',user_id,null))/count(DISTINCT user_id) as '商品转化率'
from user_behavior
GROUP BY item_id
ORDER BY 商品转化率 desc;
-- 品类转化率
create table category_user_rate(category_id int,pv int,fav int,cart int,buy int,品类转化率 float);
insert into category_user_rate
SELECT category_id,count(if(behavior_type='pv',behavior_type,null)) 'pv',
count(if(behavior_type='fav',behavior_type,null)) 'fav',
count(if(behavior_type='cart',behavior_type,null)) 'cart',
count(if(behavior_type='buy',behavior_type,null)) 'buy',
count(distinct if(behavior_type='buy',user_id,null))/count(DISTINCT user_id) as '品类转化率'
from user_behavior
GROUP BY category_id
ORDER BY 品类转化率 desc;
