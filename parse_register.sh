#!/bin/sh

csvf=reg.csv

#OL=''

while read yoo_pmnt; do
  echo "${yoo_pmnt%%;*}"
  ord="${yoo_pmnt%%;*}"
  if [ '+' == +"$OL" ]
  then
      OL="$ord"
  else
      OL="$OL","$ord"
  fi
done <$csvf

echo OL="$OL"

PG_SRV=vm-pg.arc.world

set -vx
SEL_YIDS="SELECT string_agg(order_id::varchar, ', ') FROM yampayment WHERE yam_id IN ($OL);"
echo $SEL_YIDS
ORDERS=$(psql -h $PG_SRV -U arc_energo -d arc_energo -A -t -c "$SEL_YIDS")

echo ORDERs="$ORDERS"
