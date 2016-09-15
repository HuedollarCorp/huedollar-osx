#!/bin/bash

echo "Esse software the avisará se está ficando mais rico ou mais pobre, de acordo com o intervalo que decidir."
echo " - Criado por Alan Sikora"
echo " - Não me responsabilizo por chororô referente a eventuais quedas do dólar, a culpa não é minha"
echo ""
read -p "De quantos em quantos minutos quer ser avisado [15]: " INTERVAL
INTERVAL=${INTERVAL:-15}
INTERVAL=`bc <<< "$INTERVAL*60"`
echo "Ok, instalando via Homebrew..."

sed "s/interval-placeholder/$INTERVAL/g" huedollar-template.rb > huedollar.rb

echo ""

brew tap homebrew/services

echo ""

brew install huedollar.rb

echo ""

brew services start huedollar.rb

echo ""

echo "Tudo instalado! Lembre-se, não é um pacote oficial, então para parar o serviço, utilize:"
echo "- [ brew services stop huedollar.rb ]"
echo "Estando na pasta onde clonou o software!"
echo ""
echo "Obrigado por utilizar os serviços de Alsik Labs"
