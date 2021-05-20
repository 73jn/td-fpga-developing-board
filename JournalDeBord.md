# Journal de Bord
## 10.05.2021
Séance avec Mr. Corthay. Revue du schéma de la board FPGA de l'école. Entretien avec Alain Germanier pour discuter du schéma de la carte processeur, il veut plus que 4 DAC, FPGA doit être énorme. Entretien avec Steve Gallay.
Googler les FPGA, j'ai compris les bank. Il faudrait prendre la version SPARTAN 7. Il y a un processeur dans le SPARTAN 7 incroyable !

## 11.05.2021
J'ai été voir Carmine, il faut échantillonner des signaux de 200KHz, ==> ADC rapides !
Donc ca part sur 20 ADC LTC1420 ou 12 et 8 autres sur les entrées analogiques du spartan 7. Les LTC1420 echantillonnes a 10MHz (10MSPS) et sortent du parallele donc 20 x (12 bits de data + 1 bit overflow + 1 bit de clock) = 280 bits pour des ADC !


Finalement on part sur un ADS805 pour que ce soit enorme ! 20MSPS

La il va falloir partir sur le spartant 7 avec 400 IO minimum !

## 12.05.2021
J'ai discuté avec Corthay. Il faudrait connecter tous les ADC sur le même bus ==> OUTPUT ENABLE (tri state). Le problème c'est que l'ADS805 à un TOE de 40ns ce qui est bien trop long !
Je regarde alors pour partir sur un ADC12020, plus récent avec un TOE de 4ns.

Plot twist !
Le ADC12020 indique (j'imagine que c'est la même chose pour l'ADS805) qu'il faut utiliser un driver de ligne externe !
SN74ABT5402A pour le driver de ligne !
74LVC16241A ==> Fastest
==> Cooooooooooooooool
==> Plus besoin d'une grosse FPGA !
J'ai effectué des calculs. On peut au MAX regroupper 3 ADC avec le 74LVC16241A... Car il y a des delais dans les portes TRI-STATE. On commence a parler de nano secondes...
Donc la FPGA devrais tourner encore plus vite pour être plus précise. Ce n'est pas la bonne solution.


Plot plot twist !
LVDS est un bus série bas voltage. Souvent utilisé pour transmettre des infos a haute vitesse.
ADC12QS065 Quad 12-Bit 65 MSPS A/D Converter with LVDS Serialized Outputs datasheet (Rev. I)


## 13.05.2021
ferié (brunière)

## 14.05.2021
Plot plot plot twist :AD3421QRWETQ1, 25MSPS, 4 channel, spi, output en LVDS ! Il est en 2 wire LVDS de base !
Le ADC12QS065 n'est pas en stock !

Selon : https://www.reddit.com/r/FPGA/comments/kryxny/how_to_interface_an_lvds_adc_with_a_zynq_fpga/
Il faut connecter le clock de l'ADC sur une pin de la FPGA.
Il faut aussi connecter le clock des data qui vient depuis l'ADC sur un clock capable pin, donc un MRCC (multiple region clock capable) ou un SRCC (single region clock capable) (https://forums.xilinx.com/t5/Implementation/How-to-find-clock-compatible-pin/td-p/767038)
Le DFO (celui qui indique quand une nouvelle trame de data est envoyé) doit être connecté sur la même bank

## 17.05.2021

Schéma bloc le matin ! Ca rends bien. Les CLOCKs des ADC sont en différentiel.
Il faut que j'aille voir Alain !
Il faut mettre une flash, une ram je pense pour stocker les valeurs mesurées peut etre

Alors, 25MSPS est beaucoup trop. Chaque 400ns le processeur effectues 4 mesures, ==> donc il faudrait echantillonner 500KSPS par canal au minimum.
==>>>>>>>>>>ADS7886SBDCKT, 1MSPS, 1 canal, serie ==> peu de connexions
en stock sur mouser, environ 4CHF/pce

## 18.05.2021

J'ai commencé a refaire le schéma block avec ADS7886SBDCKT.
J'ai connecté les clocks ensemble car ils ont tous besoin de 20MHz constamment.
Pour leur alimentation, il faut utiliser une référence de tension de préférence. J'ai trouvé LT1461CCS8-3#PBF sur mouser qui est ultra précis et qui pourrait alimenter tous les chips. Un chip consomme 1.5mA. Il faut donc 30mA en tout.
Il en faudrait deux en tout pour limiter les erreurs de tensions.
Il faut l'alimenter en 5V !
Mettre pleins de condos !


Pour les 8 sorties DAC, on peut intervertir des connecteurs SMA traversant; un fois au top une fois au bot. Il faudra peut etre changer l'USBA en micro USB



J'ai cherché des FPGA, aucun stock pour les SPARTAN 7...
Chez mouser il n'y a que le 
XC6SLX100-3FG484C (n° mouser : 217-C6SLX100-3FG484C)
en stock...

https://octopart.com/search?q=XC6S&currency=USD&specs=1&sort=numberofi_os&sort-dir=desc&distributor_id=2401&manufacturer_id=404&in_stock_only=1&numberofpins=484&case_package=FBGA

La FPGA drive 24mA au max !

## 19.05.2021
J'ai cherché FPGA, discuté avec Alain, Fabien Matter, Silvan Zahno

## 20.05.2021
Les référence de 3V doivent être alimentés en 5V
La FPGA doit avoir du 1.2V et le 3.3V des banks
Les Ampli-Op doivent être alimenté en 3.3V
Les AD sont alimenté par la référence de tension et le niveau n'a pas besoin d'être adapté : https://datasheet.lcsc.com/szlcsc/XILINX-XC6SLX16-2FTG256C_C39313.pdf

# Sources
Passe bas 2 ème ordre  http://www.bedwani.ch/electro/ch9/

ADC AD3421QRWETQ1 : https://www.ti.com/lit/ds/symlink/adc3421-q1.pdf

# Pour le rapport
Mesure sur la référence de tension !
Expliquer pourquoi pas besoin d'un adapteur de tension entre AD et FPGA