DROP FUNCTION arc_energo.vrf_ya_kassa_item_name(integer);

CREATE OR REPLACE FUNCTION arc_energo.vrf_ya_kassa_item_name(arg_last_bx_order integer DEFAULT NULL::integer, OUT "в счёте" character varying, OUT "фискальное" character varying, OUT bx_order numeric, OUT "№ счета" integer, OUT "YaMoney_id" bigint, OUT "ПозицияСчета" integer)
 RETURNS SETOF record
 LANGUAGE sql
AS $function$
select 
-- /smb/system/Scripts/yamregister/devel/sql
-- , md5(trim("Содержание счета"."Наименование")), md5(i.item_name)
trim("Содержание счета"."Наименование") as "в счёте", i.item_name "фискальное"
, Счета."ИнтернетЗаказ", Счета."№ счета", p.yam_id, "Содержание счета"."ПозицияСчета"
from "Содержание счета"
join "Счета" on Счета."№ счета" = "Содержание счета"."№ счета" 
join yampayment p on p.order_id = Счета."ИнтернетЗаказ"
left join yam_item i on p.yam_id = i.yam_id 
where -- Счета.ps_id=3 and
"Содержание счета"."Кол-во" = item_qnt
-- and "Содержание счета"."ЦенаНДС" = item_price
and substring("Содержание счета".Наименование from '^[0-9]+') = substring(item_name from '^[0-9]+')
and trim("Содержание счета".Наименование) <> trim(item_name)
and Счета."ИнтернетЗаказ" >= coalesce(arg_last_bx_order, 70520)
order by Счета."ИнтернетЗаказ"
, "Содержание счета"."КодПозиции";
$function$

