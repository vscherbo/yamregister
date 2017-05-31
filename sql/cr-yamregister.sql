CREATE TABLE arc_energo.yamregister (
	yam_id int8 NOT NULL,
	order_id text NOT NULL,
	amount numeric NULL,
	currency varchar NULL,
	net_amount numeric NULL,
	payment_ts timestamp NULL,
	yam_wallet varchar NULL,
	description varchar NULL,
	payment_type varchar NULL,
	yaregister_date date NULL,
	CONSTRAINT yamregister_pk PRIMARY KEY (yam_id),
	CONSTRAINT yamregister_un UNIQUE (order_id)
)
WITH (
	OIDS=FALSE
) ;
