/********************
Author: Inquisidor
Descripcion: genera un encuentro tal que el 80% del poder es una banshee, y el 20% restante compuesto por uno a siete undeads cualesquiera.
Ubicacion: Bosque de los susurros centro sur
*********************/
#include "RS_FGE_inc"
#include "RS_ADE"


void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    float faeBanshee = RS_generarSolitario( datosSGE, ADE_Undead_Banshees_get(), 0.8 );
    RS_generarGrupo( datosSGE, FGE_Undead_get(), 1.0-faeBanshee, 0.02, 1, 1.0, 0, 0.03 );
}
