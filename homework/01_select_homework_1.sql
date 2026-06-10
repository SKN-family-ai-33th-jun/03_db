# Q1.
select
    tbl_category.category_code,
    tbl_category.category_name
from
    tbl_category
order by
    category_name desc

# Q2.
select
    tbl_menu.menu_name,
    tbl_menu.menu_price
from
    tbl_menu
where
    menu_price between 20000 and 30000
and
    tbl_menu.menu_name like '%밥%'

# Q3.
select
    *
from
    tbl_menu
where
    menu_price < 10000
and
    menu_name like '%김치%'
order by
    menu_price asc,
    menu_name desc

# 04.
select
    *
from
    tbl_menu
where
    category_code not in (10,9,8)
and
    menu_price = 13000
