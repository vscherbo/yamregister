CREATE TABLE arc_energo.yamreturn (
	yam_id int8 NOT NULL,
	amount numeric NULL,
	currency varchar NULL,
	return_ts timestamp NULL,
	yam_wallet varchar NULL,
	goods_amount numeric NULL,
	goods_currency varchar NULL,
    order_id varchar,
	phone_number varchar NULL,
	payment_type varchar NULL,
	return_id text,
	yaregister_date date NULL,
	CONSTRAINT yamreturn_pk PRIMARY KEY (yam_id)
) ;
