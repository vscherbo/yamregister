DROP FUNCTION arc_energo.yakassa_to_bill_item();

CREATE OR REPLACE FUNCTION arc_energo.yakassa_to_bill_item(arg_min_bx_order integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
rec RECORD;
id_1c varchar;
BEGIN
FOR rec in select "№ счета" as bill_no, "ПозицияСчета" item_no, "в счёте" as bill_item, "фискальное" as fiscal_name from vrf_ya_kassa_item_name(arg_min_bx_order)
LOOP
    raise notice '%/% bill_item=%, fiscal_name=%', rec.bill_no, rec.item_no, rec.bill_item, rec.fiscal_name;
    select "Артикул1С" INTO id_1c from "Содержание счета" where "№ счета" = rec.bill_no AND "ПозицияСчета" = rec.item_no;
    IF id_1c is NOT NULL THEN
        RAISE NOTICE 'Артикул1С=%', id_1c;
        update "Содержание счета" set "Артикул1С" = NULL where "№ счета" = rec.bill_no AND "ПозицияСчета" = rec.item_no;
    END IF;

    update "Содержание счета" set "Наименование" = rec.fiscal_name where "№ счета" = rec.bill_no AND "ПозицияСчета" = rec.item_no;
    update "Содержание счета" set "Артикул1С" = id_1c where "№ счета" = rec.bill_no AND "ПозицияСчета" = rec.item_no;

END LOOP;

END;    
/***
select 
-- , md5(trim("Содержание счета"."Наименование")), md5(i.item_name)
trim("Содержание счета"."Наименование") as "в счёте", i.item_name "фискальное"
, Счета."ИнтернетЗаказ", Счета."№ счета", p.yam_id
from "Содержание счета"
join "Счета" on Счета."№ счета" = "Содержание счета"."№ счета" 
join yampayment p on p.order_id = Счета."ИнтернетЗаказ"
left join yam_item i on p.yam_id = i.yam_id 
where -- Счета.ps_id=3 and
"Содержание счета"."Кол-во" = item_qnt
-- and "Содержание счета"."ЦенаНДС" = item_price
and substring("Содержание счета".Наименование from '^[0-9]+') = substring(item_name from '^[0-9]+')
and trim("Содержание счета".Наименование) <> trim(item_name)
and Счета."ИнтернетЗаказ" > coalesce(arg_last_bx_order, 24227)
order by Счета."ИнтернетЗаказ"
, "Содержание счета"."КодПозиции";
***/
$function$
