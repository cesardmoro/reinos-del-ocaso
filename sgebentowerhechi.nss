/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebenoutercv
script author: Lobofiel
names of the areas this script is asociated with:
Benzor Outer Cave (3)
********************************************************************************/
#include "RS_sgeTools"
#include "RS_ade"


/*****Animales / Spider*/
void Spider() {
    string arregloDVDs = ADE_Insect_Spider_getVariado();
    struct RS_DatosSGE datosSGE = RS_getDatosSGE_sinUbicacion();
    float faeGenerado;
    float faeGeneradoAcumulado = 0.0;
    do {
        datosSGE = RS_generarUbicacionSGE( datosSGE );
        faeGenerado = RS_generarVariado( datosSGE, arregloDVDs, 1.0 - faeGeneradoAcumulado, 0.10 );
        faeGeneradoAcumulado += faeGenerado;
    } while( faeGeneradoAcumulado < 0.9 && faeGenerado != 0.0 );
}


/*****Insects / Bombard Beetle*/
void Beetle() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    RS_generarMezclado( datosSGE, ADE_Insects_Beetle_getVariado() );
}


/*****MAIN*/
void main()
    {
    switch(d4() ){
        case 1: Beetle(  );
            break;
        case 4: Spider(  );
            break;
    }
}
