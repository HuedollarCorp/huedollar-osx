#!/bin/bash

get_variable() {
  cat huedollar-stash | grep -w $1 | cut -d'=' -f2
}

set_variable() {
  remove_variable $1
  echo $1=$2 >> huedollar-stash
}

remove_variable() {
  sed -i.bak "/^$1=/d" huedollar-stash
}

# Check if should run
WEEKDAY=`date +%u`
HOUR=`date +%-H`
MIN=`date +%-M`
[ $WEEKDAY -eq 0 -o $WEEKDAY -eq 7 ] && exit
[ $HOUR -le 8 -o $HOUR -eq 9 -a $MIN -le 0 ] && exit
[ $HOUR -ge 18 -o $HOUR -eq 17 -a $MIN -ge 20 ] && exit

DOLLAR=`curl -s 'http://api.promasters.net.br/cotacao/v1/valores?moedas=USD&alt=json' | /usr/local/bin/jq -r '.valores.USD.valor'`

LAST_DAY_DOLLAR=`get_variable 'LAST_DAY_DOLLAR'`
OLD_DOLLAR_A=`get_variable 'OLD_DOLLAR_A'`
OLD_DOLLAR_B=`get_variable 'OLD_DOLLAR_B'`

if [ $DOLLAR == $OLD_DOLLAR_A ]; then
  OLD_DOLLAR=$OLD_DOLLAR_B
else
  OLD_DOLLAR=$OLD_DOLLAR_A

  set_variable OLD_DOLLAR_B $OLD_DOLLAR_A
  set_variable OLD_DOLLAR_A $DOLLAR
fi

if [ $HOUR -ge 17 ];
then
    set_variable LAST_DAY_DOLLAR $DOLLAR
fi

if [ $DOLLAR \> $OLD_DOLLAR ];
then
    SYMBOL="+"
else
    SYMBOL="-"
fi

if [ $DOLLAR == $OLD_DOLLAR ];
then
    SYMBOL="="
fi

if [ $DOLLAR \> $LAST_DAY_DOLLAR ];
then
    LAST_DAY_SYMBOL="+"
else
    LAST_DAY_SYMBOL="-"
fi

if [ $DOLLAR == $LAST_DAY_DOLLAR ];
then
    LAST_DAY_SYMBOL="="
fi

if [ $OLD_DOLLAR != "0.0000" ];
then
  VARIATION=`awk -v t1="$OLD_DOLLAR" -v t2="$DOLLAR" 'BEGIN{printf " (%.2f%%)", (t2-t1)/t1 * 100}'`
else
  VARIATION=''
fi

if [ "$LAST_DAY_DOLLAR" != "0.0000" ];
then
  LAST_DAY_VARIATION=`awk -v t1="$LAST_DAY_DOLLAR" -v t2="$DOLLAR" 'BEGIN{printf " (%.2f%%)", (t2-t1)/t1 * 100}'`
else
  LAST_DAY_VARIATION=''
fi

LAST_DAY_DIFFERENCE=`bc <<< "$DOLLAR-$LAST_DAY_DOLLAR"`

DOLLAR=`sed 's/\./,/' <<< $DOLLAR`
OLD_DOLLAR=`sed 's/\./,/' <<< $OLD_DOLLAR`
LAST_DAY_DOLLAR=`sed 's/\./,/' <<< $LAST_DAY_DOLLAR`

TITLE='Huedollar'
SUBTITLE='R$ '$DOLLAR' '$SYMBOL' R$ '$OLD_DOLLAR''"$VARIATION"''
if [ "$LAST_DAY_DOLLAR" != '0,0000' ]; then
  CONTENT='Ontem: R$ '$LAST_DAY_DOLLAR' '$LAST_DAY_SYMBOL' R$ '$LAST_DAY_DIFFERENCE''"$LAST_DAY_VARIATION"''
else
  CONTENT='Ontem: Não disponível'
fi

osascript -e 'display notification "'"$CONTENT"'" with title "'"$TITLE"'" subtitle "'"$SUBTITLE"'"'
