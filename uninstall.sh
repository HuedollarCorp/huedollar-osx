#!/bin/bash

echo "Desinstalando..."

brew services stop huedollar.rb

echo ""

brew uninstall huedollar.rb

echo ""

rm -rf huedollar.rb

echo "Tudo pronto! Viva na cegueira, se é assim que prefere..."
