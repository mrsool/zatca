
export FATOORA_HOME="${PWD}"

export PATH=$PATH:$FATOORA_HOME/Apps/
#export PATH
#export FATOORA_HOME



touch ~/.zshrc
touch ~/.bash-profile




SDK_CONFIG="${PWD}/Configuration/config.json"


echo "export PATH=$PATH:$FATOORA_HOME/Apps/" >> ~/.bash-profile
echo "export FATOORA_HOME=${PWD}/Apps" >> ~/.bash-profile
echo "export SDK_CONFIG=$SDK_CONFIG" >> ~/.bash-profile

echo "export PATH=$PATH:$FATOORA_HOME/Apps/" >> ~/.zshrc
echo "export FATOORA_HOME=${PWD}/Apps" >> ~/.zshrc
echo "export SDK_CONFIG=$SDK_CONFIG" >> ~/.zshrc





source ~/.bash-profile
source ~/.zshrc

cd Configuration

parentDir="$(dirname "$PWD")"

xsdPath=$(jq -r '.xsdPath' defaults.json)
xsdPathFileName="$(basename $xsdPath)"

enSchematron=$(jq -r '.enSchematron' defaults.json)
enSchematronFileName="$(basename $enSchematron)"

zatcaSchematron=$(jq -r '.zatcaSchematron' defaults.json)
zatcaSchematronFileName="$(basename $zatcaSchematron)"

certPath=$(jq -r '.certPath' defaults.json)
certPathFileName="$(basename $certPath)"

pkPath=$(jq -r '.privateKeyPath' defaults.json)
pkPathFileName="$(basename $pkPath)"

pihPath=$(jq -r '.pihPath' defaults.json)
pihPathFileName="$(basename $pihPath)"

certPassword=$(jq -r '.certPassword' defaults.json)
certPasswordValue="$(basename $certPassword)"

usagePath=$(jq -r '.usagePathFile' defaults.json)
usagePathFileName="$(basename $usagePath)"


jq -n '{"xsdPath":$one, "enSchematron":$two, "zatcaSchematron":$thr,"certPath":$fou, "privateKeyPath":$fiv  ,"pihPath":$six ,"certPassword":$sev ,"inputPath":$eight,"usagePathFile":$nine}' \
  --arg one "${parentDir}/Data/Schemas/xsds/UBL2.1/xsd/maindoc/$xsdPathFileName" \
  --arg two "${parentDir}/Data/Rules/schematrons/$enSchematronFileName"   \
  --arg thr "${parentDir}/Data/Rules/schematrons/$zatcaSchematronFileName" \
  --arg fou "${parentDir}/Data/Certificates/$certPathFileName" \
  --arg fiv "${parentDir}/Data/Certificates/$pkPathFileName" \
  --arg six "${parentDir}/Data/PIH/$pihPathFileName"  \
  --arg sev "$certPasswordValue"  \
  --arg eight "${parentDir}/Data/Input"  \
  --arg nine "${parentDir}/Configuration/$usagePathFileName"  >config.json

cd ../
