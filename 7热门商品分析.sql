-- 各品类浏览量前十
CREATE table category_rank(category_id int,品类浏览量 varchar(50));
insert into category_rank
SELECT category_id,count(if(behavior_type='pv',behavior_type,null)) '品类浏览量'
from user_behavior
GROUP BY category_id
ORDER BY 2 desc
limit 10;
-- 各商品浏览量前十
CREATE table item_rank(item_id int,商品浏览量 varchar(50));
INSERT into item_rank
SELECT item_id,count(if(behavior_type='pv',behavior_type,null)) '商品浏览量'
from user_behavior
GROUP BY item_id
ORDER BY 2 desc
limit 10;
-- 各品类商品浏览量前十
CREATE table cateitem_rank(category_id int,item_id int,品类商品浏览量 varchar(100));
insert into cateitem_rank
SELECT category_id,item_id,品类商品浏览量
from (
SELECT category_id,item_id,count(if(behavior_type='pv',behavior_type,null)) as 品类商品浏览量,
rank() over (partition by category_id order by count(if(behavior_type='pv',behavior_type,null)) desc) as r
from user_behavior
GROUP BY category_id,item_id
ORDER BY 3 desc) as a
where r=1
limit 10;
