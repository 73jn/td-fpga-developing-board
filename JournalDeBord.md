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


Plot plot twist !
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
# Sources
Passe bas 2 ème ordre  http://www.bedwani.ch/electro/ch9/