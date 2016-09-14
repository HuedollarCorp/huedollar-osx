#!/bin/bash

# Check if should run
WEEKDAY=$(date +%u)
HOUR=$(date +%-H)
MIN=$(date +%-M)
[ $WEEKDAY -eq 0 -o $WEEKDAY -eq 7 ] && exit
[ $HOUR -le 8 -o $HOUR -eq 9 -a $MIN -le 0 ] && exit
[ $HOUR -ge 18 -o $HOUR -eq 17 -a $MIN -ge 20 ] && exit

DOLLAR=`curl -s 'http://api.promasters.net.br/cotacao/v1/valores?moedas=USD&alt=json' | /usr/local/bin/jq -r '.valores.USD.valor'`

read LAST_DAY_DOLLAR < last_day_dollar.txt
read OLD_DOLLAR < dollar.txt
echo $DOLLAR > dollar.txt

if [ $HOUR \> 5 ];
then
    echo $DOLLAR > last_day_dollar.txt
fi;

if [ $DOLLAR \> $OLD_DOLLAR ];
then
    SYMBOL="+"
else
    SYMBOL="-"
fi;

if [ $DOLLAR == $OLD_DOLLAR ];
then
    SYMBOL="="
fi;

if [ $DOLLAR \> $LAST_DAY_DOLLAR ];
then
    LAST_DAY_SYMBOL="+"
else
    LAST_DAY_SYMBOL="-"
fi;

if [ $DOLLAR == $LAST_DAY_DOLLAR ];
then
    LAST_DAY_SYMBOL="="
fi;

VARIATION=`awk -v t1="$OLD_DOLLAR" -v t2="$DOLLAR" 'BEGIN{printf "%.2f", (t2-t1)/t1 * 100}'`
LAST_DAY_VARIATION=`awk -v t1="$LAST_DAY_DOLLAR" -v t2="$DOLLAR" 'BEGIN{printf "%.2f", (t2-t1)/t1 * 100}'`
LAST_DAY_DIFFERENCE=`bc <<< "$DOLLAR-$LAST_DAY_DOLLAR"`

DOLLAR=`sed 's/\./,/' <<< $DOLLAR`
OLD_DOLLAR=`sed 's/\./,/' <<< $OLD_DOLLAR`
LAST_DAY_DOLLAR=`sed 's/\./,/' <<< $LAST_DAY_DOLLAR`

osascript -e 'display notification "Ontem: R$ '$LAST_DAY_DOLLAR' '$LAST_DAY_SYMBOL' R$ '$LAST_DAY_DIFFERENCE' ('$LAST_DAY_VARIATION'%)" with title "Dollarific" subtitle "R$ '$DOLLAR' '$SYMBOL' R$ '$OLD_DOLLAR' ('$VARIATION'%)"'
