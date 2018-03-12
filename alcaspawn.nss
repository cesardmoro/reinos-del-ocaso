/************** Script Generador de Encuentros - Grupales simples *******************
template author: Inquisidor
script name: sgebensewer
script author: Inquisidor
names of the areas this script is asociated with: alcantarillas de benzor
********************************************************************************/
#include "RS_sgeTools"


void main() {

    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    string arregloDMDs;

    switch( Random(7) ) {
    case 0:
    case 1:
        arregloDMDs += "001,A,????????????????,rata001          "; // "animal / other / Rata"
        arregloDMDs += "002,A,????????????????,rata003          "; // "animal / other / Rata(Terrible)"
        RS_generarGrupo( datosSGE, arregloDMDs, 1.0, 0.1, 1, 0.5, 1, 0.2 );
        break;

    case 2:
    case 3:
        arregloDMDs += "001,A,????????????????,spid001          "; // "Insects / Spiders / Arania"
        arregloDMDs += "003,A,????????????????,spid002          "; // "Insects / Spiders / Arania Gigante"
        RS_generarGrupo( datosSGE, arregloDMDs, 1.0, 0.1, 1, 0.5, 1, 0.2 );
        break;

    case 4:
    case 5:
        RS_generarCriatura( datosSGE, 3, "cubo" );
        break;

    case 6:
        RS_generarGrupoHomogeneo( datosSGE, 1, "in002" );  // vermin 1   "Insects / Beetles / Escarabajo de Fuego Gigante D&D"
        break;
    }
}

