#!/bin/bash

echo '######## translate'

pushd ./lib/src > /dev/null
dart ./translator_tool.dart
popd > /dev/null

flutter gen-l10n
 
echo '######## translate done'
