/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgedeswamptt
script author: Lobofiel
names of the areas this script is asociated with:
Desolation Swamp, Ten Taulil Ruins (2)
********************************************************************************/
#include "RS_FGE_inc"


/*****Animales / Serpientes*/
void Serpent() {
    string arregloDVDs = ADE_Animales_SerpentSwamp_getVariado();
    struct RS_DatosSGE datosSGE = RS_getDatosSGE_sinUbicacion();
    float faeGenerado;
    float faeGeneradoAcumulado = 0.0;
    do {
        datosSGE = RS_generarUbicacionSGE( datosSGE );
        faeGenerado = RS_generarVariado( datosSGE, arregloDVDs, 1.0 - faeGeneradoAcumulado, 0.10 );
        faeGeneradoAcumulado += faeGenerado;
    } while( faeGeneradoAcumulado < 0.9 && faeGenerado != 0.0 );
}


/*****Giant / Troll*/
void Troll( struct RS_DatosSGE datosSGE ) {
    RS_generarMezclado( datosSGE, ADE_Giant_Troll_getVariado() );
}


/*****Humanoid / Lizardmen*/
void Lizard( struct RS_DatosSGE datosSGE ) {
    float faeCasters = RS_generarGrupo( datosSGE, ADE_Humanoid_Lizardmen_getCaster(), 0.3, 0.15, 0 );
    RS_generarGrupo( datosSGE, ADE_Humanoid_Lizardmen_getMelee(), 1.0 - faeCasters );
}


/*****Insect / Green Scorpions*/
void Scorpion( struct RS_DatosSGE datosSGE ) {
    float faeGrupo = RS_generarGrupo( datosSGE, ADE_Insects_ScorpionGreen_getVariado() );
}


/*****Insect / Bombard Beetle*/
void Beetle( struct RS_DatosSGE datosSGE ) {
    RS_generarMezclado( datosSGE, ADE_Insects_Beetle_getVariado() );
}



/*****MAIN*/
void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    FGE_Humanoid_Lizardmen( datosSGE );

/*  QUITADO por Inquisidor: excepto por los Lizards, el resto de los arreglos son de CR muy bajo para el CR de las areas donde se usa este SGE
    switch( Random(8) ){
        case 0: Scorpion(  );
            break;
        case 1: Beetle(  );
            break;
        case 2: Lizard(  );
            break;
        case 3: Lizard(  );
            break;
        case 4: Lizard(  );
            break;
        case 5: Serpent(  );
            break;
        case 7: Lizard(  );
            break;
        case 6: Troll(  );
            break;
    }
*/
}


