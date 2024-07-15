CREATE OR REPLACE FUNCTION arc_energo.fntr_set_bxorder_status()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
-- 2: оплачен
-- OLD before aub_parted  UPDATE "Счета" SET "Статус" = 2 WHERE "ИнтернетЗаказ" = NEW.order_id AND ("Статус" < 2 OR "Статус" IS NULL);
UPDATE "Счета" SET "Статус" = 2 WHERE 
-- "№ счета" = (SELECT "№ счета" FROM "Счета" WHERE "ИнтернетЗаказ" = NEW.order_id ORDER BY "№ счета" ASC LIMIT 1)
"№ счета" = (SELECT "Счет" FROM bx_order WHERE "Номер" = NEW.order_id)
AND ("Статус" < 2 OR "Статус" IS NULL);
PERFORM "fn_InetOrderNewStatus"(2, NEW.order_id);
RETURN NEW;
END;
$function$
