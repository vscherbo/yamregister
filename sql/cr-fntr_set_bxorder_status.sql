CREATE OR REPLACE FUNCTION arc_energo.fntr_set_bxorder_status()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
PERFORM "fn_InetOrderNewStatus"(2, NEW.order_id); -- оплачен
RETURN NEW;
END;
$function$
