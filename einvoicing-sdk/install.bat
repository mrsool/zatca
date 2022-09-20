
@echo off

SET MY_PATH=%~dp0

setx /U %USERDOMAIN%/%USERNAME% /S %COMPUTERNAME% SDK_CONFIG %MY_PATH%Configuration/config.json
setx /U %USERDOMAIN%/%USERNAME% /S %COMPUTERNAME% FATOORA_HOME %MY_PATH%Apps\ 
SETX PATH ""
SETX PATH "%MY_PATH%Apps\;%PATH%"

cd Configuration

set "CURRENT=%~dp0"
set "_path=%CURRENT%Configuration"

for %%a in (%_path:~0,-1%) do set "p2_dir=%%~dpa"\

set p2_dir=%p2_dir:\=\\%

SET XSD=
FOR /F %%I IN ('jq .xsdPath defaults.json ') DO set "XSD=%%I"

SET XSD_filename=
for %%F in (%XSD%) do  set "XSD_filename=%%~nxF"

SET EN_SCHEMA=
FOR /F %%I IN ('jq .enSchematron defaults.json ') DO set "EN_SCHEMA=%%I"
SET EN_SCHEMA_filename=
for %%F in (%EN_SCHEMA%) do  set "EN_SCHEMA_filename=%%~nxF"


SET ZATCA_SCHEMA=
FOR /F %%I IN ('jq .zatcaSchematron defaults.json ') DO set "ZATCA_SCHEMA=%%I"
SET ZATCA_SCHEMA_filename=
for %%F in (%ZATCA_SCHEMA%) do  set "ZATCA_SCHEMA_filename=%%~nxF"

SET CERT=
FOR /F %%I IN ('jq .certPath defaults.json ') DO set "CERT=%%I"
SET CERT_filename=
for %%F in (%CERT%) do  set "CERT_filename=%%~nxF"

SET PK=
FOR /F %%I IN ('jq .privateKeyPath defaults.json ') DO set "PK=%%I"
SET PK_filename=
for %%F in (%PK%) do  set "PK_filename=%%~nxF"

SET PIH=
FOR /F %%I IN ('jq .pihPath defaults.json ') DO set "PIH=%%I"
SET PIH_filename=
for %%F in (%PIH%) do  set "PIH_filename=%%~nxF"

SET CERT_PASSWORD=
FOR /F %%I IN ('jq .certPassword defaults.json ') DO set "CERT_PASSWORD=%%I"
SET CERT_PASSWORD_VALUE=
for %%F in (%CERT_PASSWORD%) do  set "CERT_PASSWORD_VALUE=%%~nxF"

SET usage=
FOR /F %%I IN ('jq .usagePathFile defaults.json ') DO set "usage=%%I"
SET usage_filename=
for %%F in (%usage%) do  set "usage_filename=%%~nxF"


echo {	"xsdPath" : "%p2_dir%Data\\Schemas\\xsds\\UBL2.1\\xsd\\maindoc\\%XSD_filename%",  ^
		"enSchematron":"%p2_dir%Data\\Rules\\schematrons\\%EN_SCHEMA_filename%", ^
		"zatcaSchematron":"%p2_dir%Data\\Rules\\schematrons\\%ZATCA_SCHEMA_filename%", ^
		"certPath":"%p2_dir%Data\\Certificates\\%CERT_filename%",^
		"privateKeyPath":"%p2_dir%Data\\Certificates\\%PK_filename%",^
		"pihPath" : "%p2_dir%Data\\PIH\\%PIH_filename%",^
        	"certPassword" : "%CERT_PASSWORD_VALUE%",^
		"inputPath" : "%p2_dir%Data\\Input",^
		"usagePathFile":"%p2_dir%Configuration\\%usage_filename%"^
     } > config.json

cd ../