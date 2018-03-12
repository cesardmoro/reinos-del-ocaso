/********************* Funciones Generadoras de Encuentro **********************
Package: Random Spawn - Funciones Generadoras de Encuentro - include
Autor: Inquisidor
*******************************************************************************/
#include "RS_sgeTools"
#include "RS_ADE"

//*******************************
//**** ANIMALES VARIOS **********
//*******************************

//**** Animales / Bosque Diurno
// CRs: 2,3,4,5,6,10,12,17,18       Factions: ?
string FGE_Animal_BosqueDiurno_getVariado();
string FGE_Animal_BosqueDiurno_getVariado() {
    return
        ADE_Animales_Campo_getVariado()
        + ADE_Animales_FelinoCalido_getVariado()
        + ADE_Animales_Osos_getVariado()
        ;
}

//**** Animales / Bosque Nocturno
// CRs: 1,2,3,4,5,7,13       Factions: ?
string FGE_Animal_BosqueNocturno_getVariado();
string FGE_Animal_BosqueNocturno_getVariado() {
    return
        ADE_Animales_Alimanias_getVariado()
        + ADE_Animales_Lobos_getVariado()
        + ADE_Animales_FelinoTemplado_getVariado()
        ;
}

//**** Animales / Frio
// CRs: 2,4,7   Factions: ?
string FGE_Animales_Frio_getVariado();
string FGE_Animales_Frio_getVariado() {
    return  // TODO: agregar mas arreglos
        ADE_Animales_FelinosInvernal_getVariado()
        + ADE_Animales_OsosW_getVariado()
        ;
}

//**** Animales / Pantano
// CRs: 1,2,4,5,8   Factions: ?
string FGE_Animales_Pantano_getVariado();
string FGE_Animales_Pantano_getVariado() {
    return  // TODO: agregar mas arreglos
        ADE_Animales_SerpentSwamp_getVariado()
        ;
}

//**** Animales / Jungla
// CRs: 1,2,4,5,8   Factions: ?
string FGE_Animales_Jungla_getVariado();
string FGE_Animales_Jungla_getVariado() {
    return  // TODO: agregar mas arreglos
        ADE_Animales_SerpentJungle_getVariado()
        ;
}


//**** Elementals / Mixed1 _____________________________________
// CRs: 2,3,5,7,9,11        Factions: ?
string FGE_Elemental_Mixed1_getVariado();
string FGE_Elemental_Mixed1_getVariado() {
    // uso un switch en lugar de sumar porque todos los arreglos tienen conjuntos de CRs parecidos. Entonces la ventaja de sumar (que es aumentar el rango de CR) no aplica, pero si su desventaja (la ineficiencia).
    switch( Random(4) ) {
        case 0: return ADE_Elemental_Air_getVariado();
        case 1: return ADE_Elemental_Earth_getVariado();
        case 2: return ADE_Elemental_Fire_getVariado();
        case 3: return ADE_Elemental_Water_getVariado();
    }
    return ""; // nunca llega. Esta para que no tire error el compilador
}

// CRs: 7,8,10,11,12,13,16      Factions: ?
string FGE_Golem_Mixed1_getVariado();
string FGE_Golem_Mixed1_getVariado() {
    return
        ADE_Golem_Arcilla_getVariado()
        + ADE_Golem_Emeral_getVariado()
        + ADE_Golem_Flesh_getVariado()
        + ADE_Golem_Iron_getVariado()
        + ADE_Golem_Stone_getVariado()
        + ADE_Golem_Ruby_getVariado()
        + ADE_Golem_Guard_getVariado()
        ;
}

///////////////////////////////////////////////////////////////////////////////
/*** PLANAR ******/
////////////////////////////////////////////////////////////////////////////////

// CRs: 2,3,7,8,9,10,13,17,18,20        Factions: ?
void FGE_Planar_Demon( struct RS_DatosSGE datosSGE );
void FGE_Planar_Demon( struct RS_DatosSGE datosSGE ) {
    if( d4()==1 ) {
        datosSGE.faccionId = STANDARD_FACTION_HOSTILE; // esta linea esta por temor a que haya demonios de facciones distintas
        RS_generarGrupo( datosSGE, ADE_Planar_Demon_get(), 1.0, 0.1, 1, 1.1, 0, 0.18 ); // valores cambiados para aumentar la varianza dado que los CR de los miembros estan muy separados
    }
    else
        RS_generarMezclado( datosSGE, ADE_Planar_Demon_get() );
}

/***************************/
/**** PLANAR / FORMIAN *****/
/***************************/

// CRs: 1,3,7,10,15      Factions: ?
void FGE_Planar_Formicida( struct RS_DatosSGE datosSGE );
void FGE_Planar_Formicida( struct RS_DatosSGE datosSGE ) {
    float faeCasters = RS_generarGrupo( datosSGE, ADE_Planar_Formicida_getCaster(), 0.3, 0.15, 0 );
    RS_generarGrupo( datosSGE, ADE_Planar_Formicida_getMelee(), 1.0 - faeCasters, 0.08 );
}

////////////////////////////////////////////////////////////////////////////////
/** ABERRATIONS ***/
////////////////////////////////////////////////////////////////////////////////

/*** BEHOLDERS **** LOCAL ****/

// CRs: 1,13      Factions: Hostil
void FGE_Aberrations_Beholder( struct RS_DatosSGE datosSGE );
void FGE_Aberrations_Beholder( struct RS_DatosSGE datosSGE ) {
    RS_generarGrupo( datosSGE, ADE_Aberrations_Beholder_getVariado() );
}


////////////////////////////////////////////////////////////////////////////////
/***** GIANTS *****/
////////////////////////////////////////////////////////////////////////////////

//**** GIANT / Ettins
// CRs: 6-10       Factions: Ogros / Orcos
void FGE_Giant_Ettin( struct RS_DatosSGE datosSGE );
void FGE_Giant_Ettin( struct RS_DatosSGE datosSGE ) {
    if( d2() == 1 ) {
        datosSGE.faccionId = STANDARD_FACTION_HOSTILE; // esta linea es porque el arreglo de ettings tiene elementos de facciones enemigas.
        RS_generarGrupo( datosSGE, ADE_Giant_Ettin_getVariado() );
    }
    else
        RS_generarMezclado( datosSGE, ADE_Giant_Ettin_getVariado() );
}

// CRs: 7,9,11      Factions: ?
void FGE_Giant_Hill( struct RS_DatosSGE datosSGE );
void FGE_Giant_Hill( struct RS_DatosSGE datosSGE ) {
    // TODO: faltan los casters?
    RS_generarGrupo( datosSGE, ADE_Giant_Hill_get() );
}

// CRs: 4,5,8      Factions: ?
void FGE_Giant_Ogro( struct RS_DatosSGE datosSGE );
void FGE_Giant_Ogro( struct RS_DatosSGE datosSGE ) {
    float faeCasters =
        RS_generarGrupo( datosSGE, ADE_Giant_Ogro_getCaster(), 0.25            , 0.10, 0, 0.35 );   // de 15% a 35% del poder del encuentro estaria comprendido por casters. No poner casters cuya FAE sea superior al 30%. Ignorar el filtro de FAE minima para el ultimo DMD.
        RS_generarGrupo( datosSGE, ADE_Giant_Ogro_getMelee() , 1.0 - faeCasters, 0.1 , 1, 0.5 ); // el resto del poder del encuentro estara comprendido por luchadores. No poner luchadores cuya FAE sea superior al 40% del encuentro excepto para el primer DMD. Ignorar el filtro de FAE minima para el ultimo DMD.
}


//*****Humanoid / Kobold*/
// CRs: 3,4,5,6      Factions: ?
void FGE_Humanoid_Kobold( struct RS_DatosSGE datosSGE );
void FGE_Humanoid_Kobold( struct RS_DatosSGE datosSGE ) {
    float faeCasters =
        RS_generarGrupo( datosSGE, ADE_Humanoid_Kobold_getCaster(), 0.25            , 0.15, 0, 0.3, 2, 0.10 );   // de 10% a 40% del poder del encuentro estaria comprendido por casters. No poner ningun casters cuya FAE supere al 30%. No poner casters cuya FAE sea menor a 10% excepto si para los ultimos 2 DMDs.
        RS_generarGrupo( datosSGE, ADE_Humanoid_Kobold_getMelee() , 1.0 - faeCasters, 0.1 , 1, 0.5, 2, 0.25 );  // el resto del poder del encuentro estaria comprendido por fighters. No poner fighters cuya FAE supere al 45% excepto si es alguno de los 2 primeros DMDs. No poner fighter cuya FAE este por debajo del 25% excepto para los ultimos dos DMDs.
}


////////////////////////////////////////////////////////////////////////////////
/*****HUMANOID*****/
////////////////////////////////////////////////////////////////////////////////

/***************************/
/*****HUMANOID / GNOLL *****/
/***************************/
// CRs: 3,4,5,6     FActons: gnoll
void FGE_Humanoid_Gnoll( struct RS_DatosSGE datosSGE );
void FGE_Humanoid_Gnoll( struct RS_DatosSGE datosSGE ) {
    float faeCasters = RS_generarGrupo( datosSGE, ADE_Humanoid_Gnoll_getCaster(), 0.30, 0.2, 0 );   // de 10% a 50% del poder del encuentro estaria comprendido por casters.
    RS_generarGrupo( datosSGE, ADE_Humanoid_Gnoll_getMelee(), 1.0 - faeCasters, 0.08, 1, 0.50 );  // el resto del poder del encuentro estaria comprendido por fighters. No poner fighters cuya FAE sea superior al 50% excepto el ultimo. No poner fighters cuya FAE sea inferios al 23%, excepto el primero.
}

/**************************/
/*******HUMANOID / HUMANS */
/**************************/

/******* Human Outlaws *********/

// CRs: 3-16      Factions: Hostile
void FGE_Humanoid_HuOutLaw( struct RS_DatosSGE datosSGE );
void FGE_Humanoid_HuOutLaw( struct RS_DatosSGE datosSGE ){
    datosSGE.onCreatureGeneratedHL = RL_addBack( datosSGE.onCreatureGeneratedHL, "rs_fge_henchname" );
    datosSGE.faccionId = STANDARD_FACTION_HOSTILE;
    float faeCasters = RS_generarGrupo( datosSGE, ADE_Merc_HuSorc_get(), 0.3, 0.15, 0 );
    string sumaHuBandit = RS_ArregloDMDs_sumar( ADE_Merc_HuRogue_get(), ADE_Merc_HuFight_get() );
    RS_generarGrupo( datosSGE, sumaHuBandit, 1.0 - faeCasters, 0.08 );
    datosSGE.onCreatureGeneratedHL = RL_removeBack( datosSGE.onCreatureGeneratedHL );
}

/******* Human Barbarians *******/

// CRs: 3-16      Factions: Hostile
void FGE_Humanoid_HuBarbarian( struct RS_DatosSGE datosSGE );
void FGE_Humanoid_HuBarbarian( struct RS_DatosSGE datosSGE ){
    datosSGE.onCreatureGeneratedHL = RL_addBack( datosSGE.onCreatureGeneratedHL, "rs_fge_henchname" );
    datosSGE.faccionId = STANDARD_FACTION_HOSTILE;
    float faeCasters = RS_generarGrupo( datosSGE, ADE_Merc_HuSorc_get(), 0.3, 0.15, 0 );
    RS_generarGrupo( datosSGE, ADE_Merc_HuBarb_get(), 1.0 - faeCasters, 0.08 );
    datosSGE.onCreatureGeneratedHL = RL_removeBack( datosSGE.onCreatureGeneratedHL );
}

/***************************/
/*****HUMANOID / LIZARDFOLK*/
/***************************/

/*****Humanoid / Lizardmen*/
// CRs: 2-18      Factions: Dragones
void FGE_Humanoid_Lizardmen( struct RS_DatosSGE datosSGE );
void FGE_Humanoid_Lizardmen( struct RS_DatosSGE datosSGE ) {
    float faeCasters = RS_generarGrupo( datosSGE, ADE_Humanoid_Lizardmen_getCaster(), 0.3, 0.15, 0 );
    RS_generarGrupo( datosSGE, ADE_Humanoid_Lizardmen_getMelee(), 1.0 - faeCasters );
}

/**********************/
/*****HUMANOID / ORCOS*/
/**********************/

/******* ORCOS ********/

// CRs: 3-20      Factions: ORCOS
void FGE_Humanoid_Orco( struct RS_DatosSGE datosSGE );
void FGE_Humanoid_Orco( struct RS_DatosSGE datosSGE ) {
    float faeCasters = RS_generarGrupo( datosSGE, ADE_Humanoid_Orco_getCaster(), 0.3, 0.15, 0 );
    RS_generarGrupo( datosSGE, ADE_Humanoid_Orco_getMelee(), 1.0 - faeCasters, 0.08 );
}

// CRs: 4,7,8,9      Factions: Orco
void FGE_Humanoid_Minotauro( struct RS_DatosSGE datosSGE );
void FGE_Humanoid_Minotauro( struct RS_DatosSGE datosSGE ) {

    // falta el getCaster
    RS_generarGrupo( datosSGE, ADE_Humanoid_Minotauro_get(), 1.0, 0.08, 1, 0.7 );

}

/****************************/
/*****HUMANOID / MOUNTRUOSOS*/
/****************************/

/****** AGUIJONEADORES ******/

// CRs: 4-18      Factions: Aracnidos
void FGE_Humanoid_Stinger( struct RS_DatosSGE datosSGE );
void FGE_Humanoid_Stinger( struct RS_DatosSGE datosSGE ) {
    float faeCasters =
        RS_generarGrupo( datosSGE, ADE_Humanoid_Stinger_getCaster(), 0.35            , 0.15, 0, 0.5, 1 );   // de 20% a 50% del poder del encuentro estaria comprendido por casters. No poner casters cuya FAE sea superior al 50%.
    RS_generarGrupo( datosSGE, ADE_Humanoid_Stinger_getMelee() , 1.0 - faeCasters, 0.10, 1, 0.5, 1, 0.23 );  // el resto del poder del encuentro estaria comprendido por fighters
}

//***** Humanoid / Saurion (Trogloditas)
// CRs: 5,6,7      Factions: ?
void FGE_Humanoid_Saurion( struct RS_DatosSGE datosSGE );
void FGE_Humanoid_Saurion( struct RS_DatosSGE datosSGE ) {
    float faeCasters =
        RS_generarGrupo( datosSGE, ADE_Humanoid_Saurion_getCaster(), 0.35            , 0.15, 0, 0.5, 1 );   // de 20% a 50% del poder del encuentro estaria comprendido por casters. No poner casters cuya FAE sea superior al 50%.
    RS_generarGrupo( datosSGE, ADE_Humanoid_Saurion_getMelee() , 1.0 - faeCasters, 0.10, 1, 0.5, 1, 0.23 );  // el resto del poder del encuentro estaria comprendido por fighters
}

/**************************/
/*****HUMANOID / SEMIORCOS*/
/**************************/

/******* HalfOrc Outlaws *********/

// CRs: 4,6,8,10,13,16,18      Factions: Hostile
void FGE_Humanoid_HOrcOutLaw( struct RS_DatosSGE datosSGE );
void FGE_Humanoid_HOrcOutLaw( struct RS_DatosSGE datosSGE ){
    datosSGE.onCreatureGeneratedHL = RL_addBack( datosSGE.onCreatureGeneratedHL, "rs_fge_henchname" );
    datosSGE.faccionId = STANDARD_FACTION_HOSTILE;
    float faeCasters = RS_generarGrupo( datosSGE, ADE_Merc_HOrcSorcerer_get(), 0.3, 0.15, 0 );
    RS_generarGrupo( datosSGE, ADE_Merc_HOrcBarbarians_get(), 1.0 - faeCasters, 0.08 );
    datosSGE.onCreatureGeneratedHL = RL_removeBack( datosSGE.onCreatureGeneratedHL );
}

/**************************/
/****HUMANOID / WILD ELVES*/
/**************************/

/**** Wild Elves Tribe ****/

// CRs: 4,6,8,10,13,16,18      Factions: Hostile
void FGE_Humanoid_WElfTribe( struct RS_DatosSGE datosSGE );
void FGE_Humanoid_WElfTribe( struct RS_DatosSGE datosSGE ){
    datosSGE.onCreatureGeneratedHL = RL_addBack( datosSGE.onCreatureGeneratedHL, "rs_fge_henchname" );
    datosSGE.faccionId = STANDARD_FACTION_HOSTILE;
    float faeCasters = RS_generarGrupo( datosSGE, ADE_WildElves_Sorcerer_getCaster(), 0.3, 0.15, 0 );
    RS_generarGrupo( datosSGE, ADE_WildElves_Barbarian_getMelee(), 1.0 - faeCasters, 0.08 );
    datosSGE.onCreatureGeneratedHL = RL_removeBack( datosSGE.onCreatureGeneratedHL );
}

/****************************/
/******HUMANOID / TRASGOIDES*/
/****************************/

/******** TRASGOIDES ********/

// CRs: 3,4,5,6,7      Factions: ?
void FGE_Humanoid_Trasgo( struct RS_DatosSGE datosSGE );
void FGE_Humanoid_Trasgo( struct RS_DatosSGE datosSGE ) {
    float faeCasters =
        RS_generarGrupo( datosSGE, ADE_Humanoid_Trasgo_getCaster(), 0.25            , 0.15, 0, 0.35, 2, 0.10 );   // de 10% a 40% del poder del encuentro estaria comprendido por casters. No poner ningun casters cuya FAE supere al 35%. No poner casters cuya FAE sea menor a 10% excepto si para los ultimos 2 DMDs.
    RS_generarGrupo( datosSGE, ADE_Humanoid_Trasgo_getMelee() , 1.0 - faeCasters, 0.1 , 2, 0.45, 2, 0.25 );  // el resto del poder del encuentro estaria comprendido por fighters. No poner fighters cuya FAE supere al 45% excepto si es alguno de los 2 primeros DMDs. No poner fighter cuya FAE este por debajo del 25% excepto para los ultimos dos DMDs.
}

//*****Humanoid / Trasgo Caverna */
// CRs: 6,7,8      Factions: ?
void FGE_Humanoid_TrasgoCaverna( struct RS_DatosSGE datosSGE );
void FGE_Humanoid_TrasgoCaverna( struct RS_DatosSGE datosSGE ) {
    float faeCasters =
        RS_generarGrupo( datosSGE, ADE_Humanoid_TrasgoCaverna_getCaster(), 0.25            , 0.15, 0, 0.35, 2 );   // de 20% a 40% del poder del encuentro estaria comprendido por casters. No poner casters cuya FAE sea superior al 40%. Ignorar el filtro de FAE minima para los dos últimos DMDs.
    RS_generarGrupo( datosSGE, ADE_Humanoid_TrasgoCaverna_getMelee() , 1.0 - faeCasters, 0.1 , 2, 0.5 , 1, 0.24 ); // el resto del poder del encuentro estara comprendido por luchadores. No poner luchadores cuya FAE sea superior al 40% del encuentro excepto para los primeros dos DMD. Ignorar el filtro de FAE minima para el ultimo DMD.
}


/**********************/
/*****HUMANOID / Yuanti*/
/**********************/

/******* Yuanti ********/

// CRs: 17-25      Factions: Yuanti
void FGE_Humanoid_YuanTi( struct RS_DatosSGE datosSGE );
void FGE_Humanoid_YuanTi( struct RS_DatosSGE datosSGE ) {
    float faeCasters = RS_generarGrupo( datosSGE, ADE_Humanoid_YuanTis_getCaster(), 0.3, 0.15, 0 );
    RS_generarGrupo( datosSGE, ADE_Humanoid_YuanTis_getMelee(), 1.0 - faeCasters, 0.08 );
}


////////////////////////////////////////////////////////////////////////////////
//*********** NPCs ***********
////////////////////////////////////////////////////////////////////////////////

//CRs: 1,2,3,4,5,6,7,8,9,10,11,12,13     Faction: hostile
string FGE_NPC_mercenary_get();
string FGE_NPC_mercenary_get() {
    return RS_ArregloDMDs_sumar(
        RS_ArregloDMDs_sumar(
            RS_ArregloDMDs_sumar(
                ADE_NPC_ElfMercenary_get(),
                ADE_NPC_DwarfMercenary_get()
            ),
            ADE_NPC_HalflingMercenary_get()
        ),
        ADE_NPC_HumanMercenary_get()
    );
}


////////////////////////////////////////////////////////////////////////////////
//*********** UNDEADS ***********
////////////////////////////////////////////////////////////////////////////////

//**** Esqueletos
//CRs: 2,3,4,5,7
string FGE_Esqueletos_get();
string FGE_Esqueletos_get() {
    return RS_ArregloDMDs_sumar(
        RS_ArregloDMDs_sumar(
            ADE_Undead_EsqueletoH_getMelee()
            , ADE_Undead_EsqueletoE_getMelee()
        )
        , ADE_Undead_EsqueletoO_getMelee()
    );
}


//Todos los undeads ordenados
string FGE_Undead_get();
string FGE_Undead_get() {
    return
        RS_ArregloDMDs_sumar(
            RS_ArregloDMDs_sumar(
                RS_ArregloDMDs_sumar(
                    RS_ArregloDMDs_sumar(
                        RS_ArregloDMDs_sumar(
                            FGE_Esqueletos_get(),
                            ADE_Undead_Zombi_getMelee()
                        ),
                        ADE_Undead_Momias_get()
                    ),
                    ADE_Undead_Tumulo_getMelee()
                ),
                ADE_Undead_Fantasma_getCaster()
            ),
            ADE_Undead_Fantasma_getMelee()
        )
    ;
}


//**** FANTASMAS
// CRs: 3,4,5,6,7,8,10      Factions: ?
float FGE_Undead_Fantasma( struct RS_DatosSGE datosSGE );
float FGE_Undead_Fantasma( struct RS_DatosSGE datosSGE ) {
    float faeCasters =
        RS_generarGrupo( datosSGE, ADE_Undead_Fantasma_getCaster(), 0.25            , 0.10, 0, 0.3 , 3 );   // de 15% a 35% del poder del encuentro estaria comprendido por casters. No poner casters cuya FAE sea superior al 30%. Ignorar el filtro de FAE minima para los ultimos tres DMDs (o sea para todos).
    return faeCasters + RS_generarGrupo( datosSGE, ADE_Undead_Fantasma_getMelee() , 1.0 - faeCasters, 0.1 , 1, 0.50 ); // el resto del poder del encuentro estara comprendido por luchadores. No poner luchadores cuya FAE sea superior al 40% del encuentro excepto para el primer DMD. Ignorar el filtro de FAE minima para los ultimos 2 DMDs.
}


/*****Undead / Esqueletos*/
// CRs: 2,3,4,5,7       Factions: ?
float FGE_Undead_Esqueleto( struct RS_DatosSGE datosSGE );
float FGE_Undead_Esqueleto( struct RS_DatosSGE datosSGE ) {
    // falta el getCaster
    return RS_generarGrupo( datosSGE, FGE_Esqueletos_get() );
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//**** AMBIENTES ****************
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//*******************************
//**** AMBIENTE BosqueCalido ****
//*******************************

//**** Bosque Calido Dia
string FGE_BosqueCalidoDia_getVariado();
string FGE_BosqueCalidoDia_getVariado() {
    return
        ADE_Animales_Lobos_getVariado()
        +ADE_Animales_FelinoCalido_getVariado()
        +ADE_Animales_SerpentJungle_getVariado()
        +ADE_Insects_Avispa_getVariado()
        +ADE_Plantas_getVariado()
        ;
}

//**** Bosque Calido Dia Wild
string FGE_BosqueCalidoDiaWild_getVariado();
string FGE_BosqueCalidoDiaWild_getVariado() {
    return
        FGE_BosqueCalidoDia_getVariado()
        +ADE_Bestias_ForestS_getVariado()
        ;
}

//**** Bosque Calido Noche
string FGE_BosqueCalidoNoche_getVariado();
string FGE_BosqueCalidoNoche_getVariado() {
    return
        ADE_Animales_AveNocturna_getVariado()
        +ADE_Animales_Lobos_getVariado()
        +ADE_Animales_FelinoCalido_getVariado()
        +ADE_Animales_SerpentJungle_getVariado()
        +ADE_Insects_ScorpionGreen_getVariado()
        +ADE_Insect_Spider_getVariado()
        +ADE_Plantas_getVariado()
        ;
}

//**** Bosque Calido Noche Wild
string FGE_BosqueCalidoNocheWild_getVariado();
string FGE_BosqueCalidoNocheWild_getVariado() {
    return
        FGE_BosqueCalidoNoche_getVariado()
        +ADE_Bestias_ForestS_getVariado()
        ;
}

//**** Bosque Calido Under
string FGE_BosqueCalidoUnder_getVariado();
string FGE_BosqueCalidoUnder_getVariado() {
    return
        ADE_Animales_Lobos_getVariado()
        +ADE_Animales_FelinoCalido_getVariado()
        +ADE_Insects_ScorpionGreen_getVariado()
        +ADE_Insect_Spider_getVariado()
        ;
}

//**** Bosque Calido Under Wild
string FGE_BosqueCalidoUnderWild_getVariado();
string FGE_BosqueCalidoUnderWild_getVariado() {
    return
        FGE_BosqueCalidoUnder_getVariado()
        +ADE_Bestias_ForestS_getVariado()
        ;
}

//**** Bosque Calido ****
string FGE_BosqueCalido_getVariado();
string FGE_BosqueCalido_getVariado() {
    string grupo;
    if( GetLocalInt( OBJECT_SELF, "RSwild") ) {
        if( GetIsAreaAboveGround( OBJECT_SELF ) ) {
            if( GetIsDay() )
                grupo = FGE_BosqueCalidoDiaWild_getVariado();
            else
                grupo = FGE_BosqueCalidoNocheWild_getVariado();
        }
        else
            grupo = FGE_BosqueCalidoUnderWild_getVariado();
    }
    else  {
        if (GetIsAreaAboveGround( OBJECT_SELF ) ) {
            if( GetIsDay() )
                grupo = FGE_BosqueCalidoDia_getVariado();
            else
                grupo = FGE_BosqueCalidoNoche_getVariado();
        }
        else
            grupo = FGE_BosqueCalidoUnder_getVariado();
    }
    return grupo;
}

//*******************************
//**** AMBIENTE BosqueTemplado **
//*******************************

//**** Bosque Templado Dia
string FGE_BosqueTempladoDia_getVariado();
string FGE_BosqueTempladoDia_getVariado() {
    return
        ADE_Animales_Lobos_getVariado()
        +ADE_Animales_FelinoCalido_getVariado()
        +ADE_Animales_Osos_getVariado()
        +ADE_Animales_SerpentJungle_getVariado()
        +ADE_Insects_Avispa_getVariado()
        +ADE_Plantas_getVariado()
        +ADE_Giant_Ettin_getVariado()
    ;
}

//**** Bosque Templado Dia Wild
string FGE_BosqueTempladoDiaWild_getVariado();
string FGE_BosqueTempladoDiaWild_getVariado() {
    return
        FGE_BosqueTempladoDia_getVariado()
        +ADE_Bestias_ForestS_getVariado()
    ;
}

//**** Bosque Templado Noche
string FGE_BosqueTempladoNoche_getVariado();
string FGE_BosqueTempladoNoche_getVariado() {
    return
        ADE_Animales_AveNocturna_getVariado()
        +ADE_Animales_Lobos_getVariado()
        +ADE_Animales_FelinoCalido_getVariado()
        +ADE_Animales_SerpentJungle_getVariado()
        +ADE_Insects_ScorpionGreen_getVariado()
        +ADE_Insect_Spider_getVariado()
        +ADE_Plantas_getVariado()
        +ADE_Giant_Ettin_getVariado()
    ;
}

//**** Bosque Templado Noche Wild
string FGE_BosqueTempladoNocheWild_getVariado();
string FGE_BosqueTempladoNocheWild_getVariado() {
    return
        FGE_BosqueTempladoNoche_getVariado()
        +ADE_Bestias_ForestS_getVariado()
    ;
}

//**** Bosque Templado Under
string FGE_BosqueTempladoUnder_getVariado();
string FGE_BosqueTempladoUnder_getVariado() {
    return
        ADE_Animales_Lobos_getVariado()
        +ADE_Animales_FelinoCalido_getVariado()
        +ADE_Animales_Osos_getVariado()
        +ADE_Insects_ScorpionGreen_getVariado()
        +ADE_Insect_Spider_getVariado()
        ;
}

//**** Bosque Templado Under Wild
string FGE_BosqueTempladoUnderWild_getVariado();
string FGE_BosqueTempladoUnderWild_getVariado() {
    return
        FGE_BosqueTempladoUnder_getVariado()
        +ADE_Bestias_ForestS_getVariado()
    ;
}

//**** Bosque Templado ****
string FGE_BosqueTemplado_getVariado();
string FGE_BosqueTemplado_getVariado() {
    string grupo;
    if( GetLocalInt( OBJECT_SELF, "RSwild") ) {
        if (GetIsAreaAboveGround( OBJECT_SELF ) ) {
            if( GetIsDay() )
                grupo = FGE_BosqueTempladoDiaWild_getVariado();
            else
                grupo = FGE_BosqueTempladoNocheWild_getVariado();
        }
        else
            grupo = FGE_BosqueTempladoUnderWild_getVariado();
    }
    else {
        if (GetIsAreaAboveGround( OBJECT_SELF ) ) {
            if( GetIsDay() )
                grupo = FGE_BosqueTempladoDia_getVariado();
            else
                grupo = FGE_BosqueTempladoNoche_getVariado();
        }
        else
            grupo = FGE_BosqueTempladoUnder_getVariado();
    }
    return grupo;
}

//*******************************
//**** AMBIENTE Bosque Frio *****
//*******************************

//**** Bosque Frio
string FGE_BosqueFrioBase_getVariado();
string FGE_BosqueFrioBase_getVariado() {
    return
        ADE_Animales_Lobos_getVariado()
        +ADE_Animales_FelinosInvernal_getVariado()
        +ADE_Animales_OsosW_getVariado()
        +ADE_Plantas_getVariado()
        ;
}

//**** Bosque Frio Wild
string FGE_BosqueFrioWild_getVariado();
string FGE_BosqueFrioWild_getVariado() {
    return
        FGE_BosqueFrioBase_getVariado()
        +ADE_Bestias_ForestW_getVariado()
        ;
}

//**** Bosque Frio Under
string FGE_BosqueFrioUnder_getVariado();
string FGE_BosqueFrioUnder_getVariado() {
    return
        ADE_Animales_Lobos_getVariado()
        +ADE_Animales_FelinosInvernal_getVariado()
        +ADE_Animales_OsosW_getVariado()
        ;
}

//**** Bosque Frio Under Wild
string FGE_BosqueFrioUnderWild_getVariado();
string FGE_BosqueFrioUnderWild_getVariado() {
    return
        FGE_BosqueFrioUnder_getVariado()
        +ADE_Bestias_ForestW_getVariado()
        ;
}

//**** Bosque Frio ****
string FGE_BosqueFrio_getVariado();
string FGE_BosqueFrio_getVariado() {
    string grupo;
    if( GetLocalInt( OBJECT_SELF, "RSwild" ) ) {
        if (GetIsAreaAboveGround(OBJECT_SELF) )
            grupo = FGE_BosqueFrioWild_getVariado();
        else
            grupo = FGE_BosqueFrioUnderWild_getVariado();
    }
    else {
        if (GetIsAreaAboveGround(OBJECT_SELF) )
            grupo = FGE_BosqueFrioBase_getVariado();
        else
            grupo = FGE_BosqueFrioUnder_getVariado();
    }
    return grupo;
}

//*******************************
//**** AMBIENTE Pantano *********
//*******************************

//**** Pantano Dia
string FGE_PantanoDia_getVariado();
string FGE_PantanoDia_getVariado() {
    return
        ADE_Animales_SerpentSwamp_getVariado()
        +ADE_Animales_SerpentJungle_getVariado()
        +ADE_Cienos_getVariado()
        +ADE_Plantas_getVariado()
        ;
}

//**** Pantano Dia Wild
string FGE_PantanoDiaWild_getVariado();
string FGE_PantanoDiaWild_getVariado() {
    return
        FGE_PantanoDia_getVariado()
        +ADE_Bestias_Swamp_getVariado()
        ;
}

//**** Pantano Noche
string FGE_PantanoNoche_getVariado();
string FGE_PantanoNoche_getVariado() {
    return
        ADE_Animales_SerpentSwamp_getVariado()
        +ADE_Animales_SerpentJungle_getVariado()
        +ADE_Insects_Beetle_getVariado()
        +ADE_Insects_ScorpionGreen_getVariado()
        +ADE_Cienos_getVariado()
        +ADE_Plantas_getVariado()
        ;
}

//**** Pantano Noche Wild
string FGE_PantanoNocheWild_getVariado();
string FGE_PantanoNocheWild_getVariado() {
    return
        FGE_PantanoNoche_getVariado()
        +ADE_Bestias_Swamp_getVariado()
        ;
}

//**** Pantano Under
string FGE_PantanoUnder_getVariado();
string FGE_PantanoUnder_getVariado() {
    return
        ADE_Insects_Beetle_getVariado()
        +ADE_Insects_ScorpionGreen_getVariado()
        +ADE_Cienos_getVariado()
        ;
}

//**** Pantano Under Wild
string FGE_PantanoUnderWild_getVariado();
string FGE_PantanoUnderWild_getVariado() {
    return
        FGE_PantanoUnderWild_getVariado()
        +ADE_Bestias_Swamp_getVariado()
        ;
}

//**** Pantano ****
string FGE_Pantano_getVariado();
string FGE_Pantano_getVariado() {
    string grupo;
    if (GetLocalInt( OBJECT_SELF, "RSwild") ==1)
    {
        if (GetIsAreaAboveGround(OBJECT_SELF) ) {
            if( GetIsDay() )
                grupo = FGE_PantanoDiaWild_getVariado();
            else
                grupo = FGE_PantanoNocheWild_getVariado();
        }
        else
            grupo = FGE_PantanoUnderWild_getVariado();
    }
    else
    {
        if (GetIsAreaAboveGround(OBJECT_SELF) ) {
            if( GetIsDay() )
                grupo = FGE_PantanoDia_getVariado();
            else
                grupo = FGE_PantanoNoche_getVariado();
        }
        else
            grupo = FGE_PantanoUnder_getVariado();
    }
    return grupo;
}


//*******************************
//**** AMBIENTE Pradera *********
//*******************************

//**** Pradera Dia
string FGE_PraderaDia_getVariado();
string FGE_PraderaDia_getVariado() {
    return
        ADE_Animales_AveDiurna_getVariado()
        +ADE_Animales_FelinoTemplado_getVariado()
        +ADE_Animales_Campo_getVariado()
        +ADE_Animales_Lobos_getVariado()
        ;
}

//**** Pradera Noche
string FGE_PraderaNoche_getVariado();
string FGE_PraderaNoche_getVariado() {
    return
        ADE_Animales_AveNocturna_getVariado()
        +ADE_Animales_Campo_getVariado()
        +ADE_Animales_FelinoTemplado_getVariado()
        +ADE_Animales_Lobos_getVariado()
        +ADE_Animales_SerpentDesert_getVariado()
        +ADE_Insects_Ants_get()
        +ADE_Insects_Beetle_getVariado()
        ;
}

//**** Pradera Under
string FGE_PraderaUnder_getVariado();
string FGE_PraderaUnder_getVariado() {
    return
        ADE_Animales_Lobos_getVariado()
        +ADE_Animales_FelinoTemplado_getVariado()
        +ADE_Insects_Ants_get()
        +ADE_Insects_Beetle_getVariado()
        ;
}

//**** Pradera ****
string FGE_Pradera_getVariado();
string FGE_Pradera_getVariado() {
    string grupo;
    if (GetIsAreaAboveGround(OBJECT_SELF) ) {
        if( GetIsDay() )
            grupo = FGE_PraderaDia_getVariado();
        else
            grupo = FGE_PraderaNoche_getVariado();
    }
    else
        grupo = FGE_PraderaUnder_getVariado();
    return grupo;
}

//*******************************
//**** AMBIENTE Colinas *********
//*******************************

//**** Colinas Dia
string FGE_ColinasDia_getVariado();
string FGE_ColinasDia_getVariado() {
    return
        ADE_Animales_AveDiurna_getVariado()
        +ADE_Animales_FelinoTemplado_getVariado()
        +ADE_Animales_Lobos_getVariado()
        +ADE_Animales_Osos_getVariado()
        +ADE_Giant_Ettin_getVariado()
        +ADE_Giant_Hill_get()
        ;
}

//**** Colinas Dia Wild
string FGE_ColinasDiaWild_getVariado();
string FGE_ColinasDiaWild_getVariado() {
    return
        FGE_ColinasDia_getVariado()
        +ADE_Bestias_Hills_getVariado()
        ;
}

//**** Colinas Noche
string FGE_ColinasNoche_getVariado();
string FGE_ColinasNoche_getVariado() {
    return
        ADE_Animales_AveNocturna_getVariado()
        +ADE_Animales_FelinoTemplado_getVariado()
        +ADE_Animales_Lobos_getVariado()
        +ADE_Animales_SerpentDesert_getVariado()
        +ADE_Insects_Ants_get()
        +ADE_Insects_Beetle_getVariado()
        +ADE_Giant_Ettin_getVariado()
        +ADE_Giant_Hill_get()
        ;
}

//**** Colinas Noche Wild
string FGE_ColinasNocheWild_getVariado();
string FGE_ColinasNocheWild_getVariado() {
    return
        FGE_ColinasNoche_getVariado()
        +ADE_Bestias_Hills_getVariado()
        ;
}

//**** Colinas Under
string FGE_ColinasUnder_getVariado();
string FGE_ColinasUnder_getVariado() {
    return
        ADE_Animales_Lobos_getVariado()
        +ADE_Animales_FelinoTemplado_getVariado()
        +ADE_Animales_Osos_getVariado()
        +ADE_Insects_Ants_get()
        +ADE_Insects_Beetle_getVariado()
        ;
}

//**** Colinas Under Wild
string FGE_ColinasUnderWild_getVariado();
string FGE_ColinasUnderWild_getVariado() {
    return
        FGE_ColinasUnder_getVariado()
        +ADE_Bestias_Hills_getVariado()
        ;
}

//**** Colinas ****
string FGE_Colinas_getVariado();
string FGE_Colinas_getVariado() {
    string grupo;
    if (GetLocalInt( OBJECT_SELF, "RSwild") ==1) {
        if (GetIsAreaAboveGround(OBJECT_SELF) ) {
            if( GetIsDay() )
                grupo = FGE_ColinasDiaWild_getVariado();
            else
                grupo = FGE_ColinasNocheWild_getVariado();
        }
        else
            grupo = FGE_ColinasUnderWild_getVariado();
    }
    else
    {
        if (GetIsAreaAboveGround(OBJECT_SELF) )
        {
            if( GetIsDay() )
                grupo = FGE_ColinasDia_getVariado();
            else
                grupo = FGE_ColinasNoche_getVariado();
        }
        else
            grupo = FGE_ColinasUnder_getVariado();
    }
    return grupo;
}

//*******************************
//**** AMBIENTE Montañas ********
//*******************************

//**** Montanas Dia
string FGE_MontanasDia_getVariado();
string FGE_MontanasDia_getVariado() {
    return
        ADE_Animales_AveDiurna_getVariado()
        +ADE_Animales_Lobos_getVariado()
        +ADE_Giant_Hill_get()
        ;
}

//**** Montanas Dia Wild
string FGE_MontanasDiaWild_getVariado();
string FGE_MontanasDiaWild_getVariado() {
    return
        FGE_MontanasDia_getVariado()
        +ADE_Bestias_Hills_getVariado()
    ;
}

//**** Montanas Noche
string FGE_MontanasNoche_getVariado();
string FGE_MontanasNoche_getVariado() {
    return
        ADE_Animales_Lobos_getVariado()
        +ADE_Insects_Beetle_getVariado()
        +ADE_Insects_ScorpionBlack_getVariado()
        +ADE_Giant_Hill_get()
        ;
}

//**** Montanas Noche Wild
string FGE_MontanasNocheWild_getVariado();
string FGE_MontanasNocheWild_getVariado() {
    return
        FGE_MontanasNoche_getVariado()
        +ADE_Bestias_Hills_getVariado()
    ;
}

//**** Montanas Under
string FGE_MontanasUnder_getVariado();
string FGE_MontanasUnder_getVariado() {
    return
        ADE_Animales_Lobos_getVariado()
        +ADE_Insects_Beetle_getVariado()
        +ADE_Insects_ScorpionBlack_getVariado()
        ;
}

//**** Montanas Under Wild
string FGE_MontanasUnderWild_getVariado();
string FGE_MontanasUnderWild_getVariado() {
    return
        FGE_MontanasUnder_getVariado()
        +ADE_Bestias_Hills_getVariado()
    ;
}

//**** Montanas ****
string FGE_Montanas_getVariado();
string FGE_Montanas_getVariado() {
    string grupo;
    if (GetLocalInt( OBJECT_SELF, "RSwild") ==1)
    {
        if (GetIsAreaAboveGround(OBJECT_SELF) ) {
            if( GetIsDay() )
                grupo = FGE_MontanasDiaWild_getVariado();
            else
                grupo = FGE_MontanasNocheWild_getVariado();
        }
        else
            grupo = FGE_MontanasUnderWild_getVariado();
    }
    else
    {
        if (GetIsAreaAboveGround(OBJECT_SELF) ) {
            if( GetIsDay() )
                grupo = FGE_MontanasDia_getVariado();
            else
                grupo = FGE_MontanasNoche_getVariado();
        }
        else
            grupo = FGE_MontanasUnder_getVariado();
    }
    return grupo;
}

//*******************************
//**** AMBIENTE Quebradas *******
//*******************************

//**** Quebradas Dia
string FGE_QuebradasDia_getVariado();
string FGE_QuebradasDia_getVariado() {
    return
        ADE_Animales_AveDiurna_getVariado()
        +ADE_Animales_Osos_getVariado()
        +ADE_Insects_Avispa_getVariado()
        +ADE_Giant_Ettin_getVariado()
        ;
}

//**** Quebradas Dia Wild
string FGE_QuebradasDiaWild_getVariado();
string FGE_QuebradasDiaWild_getVariado() {
    return
        FGE_QuebradasDia_getVariado()
        +ADE_Bestias_Hills_getVariado()
        ;
}

//**** Quebradas Noche
string FGE_QuebradasNoche_getVariado();
string FGE_QuebradasNoche_getVariado() {
    return
        ADE_Animales_SerpentDesert_getVariado()
        +ADE_Insects_Beetle_getVariado()
        +ADE_Insects_ScorpionBlack_getVariado()
        +ADE_Giant_Ettin_getVariado()
        ;
}

//**** Quebradas Noche Wild
string FGE_QuebradasNocheWild_getVariado();
string FGE_QuebradasNocheWild_getVariado() {
    return
        FGE_QuebradasNoche_getVariado()
        +ADE_Bestias_Hills_getVariado()
        ;
}

//**** Quebradas Under
string FGE_QuebradasUnder_getVariado();
string FGE_QuebradasUnder_getVariado() {
    return
        ADE_Animales_Osos_getVariado()
        +ADE_Insects_Beetle_getVariado()
        +ADE_Insects_ScorpionBlack_getVariado()
        ;
}

//**** Quebradas Under Wild
string FGE_QuebradasUnderWild_getVariado();
string FGE_QuebradasUnderWild_getVariado() {
    return
        FGE_QuebradasUnder_getVariado()
        +ADE_Bestias_Hills_getVariado()
        ;
}

//**** Quebradas ****
string FGE_Quebradas_getVariado();
string FGE_Quebradas_getVariado() {
    string grupo;
    if (GetLocalInt( OBJECT_SELF, "RSwild") ==1)
    {
        if (GetIsAreaAboveGround(OBJECT_SELF) ) {
            if( GetIsDay() )
                grupo = FGE_QuebradasDiaWild_getVariado();
            else
                grupo = FGE_QuebradasNocheWild_getVariado();
        }
        else
            grupo = FGE_QuebradasUnderWild_getVariado();
    }
    else
    {
        if (GetIsAreaAboveGround(OBJECT_SELF) )
        {
            if( GetIsDay() )
                grupo = FGE_QuebradasDia_getVariado();
            else
                grupo = FGE_QuebradasNoche_getVariado();
        }
        else
            grupo = FGE_QuebradasUnder_getVariado();
    }
    return grupo;
}

//*******************************
//**** AMBIENTE Desierto ********
//*******************************

//**** Desierto Dia
string FGE_DesiertoDia_getVariado();
string FGE_DesiertoDia_getVariado() {
    return
        ADE_Animales_Hiena_getVariado()
        +ADE_Animales_FelinoTemplado_getVariado()
        ;
}

//**** Desierto Dia Wild
string FGE_DesiertoDiaWild_getVariado();
string FGE_DesiertoDiaWild_getVariado() {
    return
        FGE_DesiertoDia_getVariado()
        +ADE_Bestias_Dry_getVariado()
        ;
}

//**** Desierto Noche
string FGE_DesiertoNoche_getVariado();
string FGE_DesiertoNoche_getVariado() {
    return
        ADE_Animales_AveNocturna_getVariado()
        +ADE_Animales_FelinoTemplado_getVariado()
        +ADE_Animales_Hiena_getVariado()
        +ADE_Animales_SerpentDesert_getVariado()
        +ADE_Insects_Beetle_getVariado()
        +ADE_Insects_ScorpionBlack_getVariado()
        ;
}

//**** Desierto Noche Wild
string FGE_DesiertoNocheWild_getVariado();
string FGE_DesiertoNocheWild_getVariado() {
    return
        FGE_DesiertoNoche_getVariado()
        +ADE_Bestias_Dry_getVariado()
        ;
}

//**** Desierto Under
string FGE_DesiertoUnder_getVariado();
string FGE_DesiertoUnder_getVariado() {
    return
        ADE_Animales_Hiena_getVariado()
        +ADE_Animales_FelinoTemplado_getVariado()
        +ADE_Insects_Beetle_getVariado()
        +ADE_Insects_ScorpionBlack_getVariado()
        ;
}

//**** Desierto Under Wild
string FGE_DesiertoUnderWild_getVariado();
string FGE_DesiertoUnderWild_getVariado() {
    return
        FGE_DesiertoUnder_getVariado()
        +ADE_Bestias_Dry_getVariado()
        ;
}

//**** Desierto ****
string FGE_Desierto_getVariado();
string FGE_Desierto_getVariado() {
    string grupo;
    if (GetLocalInt( OBJECT_SELF, "RSwild") ==1)
    {
        if (GetIsAreaAboveGround(OBJECT_SELF) )
        {
            if( GetIsDay() )
                grupo = FGE_DesiertoDiaWild_getVariado();
            else
                grupo = FGE_DesiertoNocheWild_getVariado();
        }
        else
            grupo = FGE_DesiertoUnderWild_getVariado();
    }
    else
    {
        if (GetIsAreaAboveGround(OBJECT_SELF) )
        {
            if( GetIsDay() )
                grupo = FGE_DesiertoDia_getVariado();
            else
                grupo = FGE_DesiertoNoche_getVariado();
        }
        else
            grupo = FGE_DesiertoUnder_getVariado();
    }
    return grupo;
}

//*******************************
//**** AMBIENTE Tundra **********
//*******************************

//**** Tundra Dia
string FGE_TundraDia_getVariado();
string FGE_TundraDia_getVariado() {
    return
        ADE_Animales_AveDiurna_getVariado()
        +ADE_Animales_Lobos_getVariado()
        +ADE_Animales_FelinosInvernal_getVariado()
        +ADE_Animales_OsosW_getVariado()
        ;
}

//**** Tundra Noche
string FGE_TundraNoche_getVariado();
string FGE_TundraNoche_getVariado() {
    return
        ADE_Animales_Lobos_getVariado()
        +ADE_Animales_FelinosInvernal_getVariado()
        +ADE_Animales_OsosW_getVariado()
        ;
}

//**** Tundra Under
string FGE_TundraUnder_getVariado();
string FGE_TundraUnder_getVariado() {
    return
        ADE_Animales_Lobos_getVariado()
        +ADE_Animales_FelinosInvernal_getVariado()
        +ADE_Animales_OsosW_getVariado()
        ;
}

//**** Tundra ****
string FGE_Tundra_getVariado();
string FGE_Tundra_getVariado() {
    string grupo;
    if (GetIsAreaAboveGround(OBJECT_SELF) )
    {
        if( GetIsDay() )
            grupo = FGE_TundraDia_getVariado();
        else
            grupo = FGE_TundraNoche_getVariado();
    }
    else
        grupo = FGE_TundraUnder_getVariado();
    return grupo;
}

//*******************************
//**** AMBIENTE Dungeon Ciudad **
//*******************************

//**** Dungeon Ciudad
string FGE_DungeonCity_getVariado();
string FGE_DungeonCity_getVariado() {
    return
        ADE_Animales_Alimanias_getVariado()
        +ADE_Insects_Beetle_getVariado()
        +ADE_Insect_Spider_getVariado()
        +ADE_Cienos_getVariado()
        ;
}

//*******************************
//**** AMBIENTE Dungeon Wilder **
//*******************************

//**** Dungeon Wilderness
string FGE_DungeonWild_getVariado();
string FGE_DungeonWild_getVariado() {
    return
        ADE_Animales_Alimanias_getVariado()
        +ADE_Insects_Beetle_getVariado()
        +ADE_Insects_ScorpionGreen_getVariado()
        +ADE_Insect_Spider_getVariado()
        +ADE_Cienos_getVariado()
        ;
}

//*******************************
//**** AMBIENTE Infraoscuridad **
//*******************************

//**** Infraoscuridad
string FGE_Infraoscuridad_getVariado();
string FGE_Infraoscuridad_getVariado() {
    return
        ADE_Animales_Alimanias_getVariado()
        +ADE_Insects_Ants_get()
        +ADE_Insects_Beetle_getVariado()
        +ADE_Insects_ScorpionBlack_getVariado()
        +ADE_Insect_Spider_getVariado()
        +ADE_Cienos_getVariado()
        +ADE_Bestias_Under_getVariado()
        +ADE_Aberrations_Underground_getVariado()
        +ADE_Aberrations_Beholder_getVariado()
        ;
}

//************************
//************************
//******* GUARDIAS *******
//************************
//************************

//******** BENZOR ********

// CRs: 3-11      Factions: Defensor
void FGE_Guardia_Benzor( struct RS_DatosSGE datosSGE );
void FGE_Guardia_Benzor( struct RS_DatosSGE datosSGE ) {
    float faeCasters = RS_generarGrupo( datosSGE, ADE_Iglesia_Ilmater_get(), 0.3, 0.15, 0 );
    RS_generarGrupo( datosSGE, ADE_Guardia_Benzor_get(), 1.0 - faeCasters, 0.08 );
}

//********* MROR *********
void FGE_Guardia_Mror( struct RS_DatosSGE datosSGE );
void FGE_Guardia_Mror( struct RS_DatosSGE datosSGE ) {
    float faeCasters = RS_generarGrupo( datosSGE, ADE_Iglesia_Waukin_get(), 0.3, 0.15, 0 );
    RS_generarGrupo( datosSGE, ADE_Guardia_Mror_get(), 1.0 - faeCasters, 0.08 );
}

//************************
//************************
//******* IGLESIAS *******
//************************
//************************

//******** MALAR ********

// CRs: 3-20      Factions: Plebeyo
void FGE_Iglesia_Malar( struct RS_DatosSGE datosSGE );
void FGE_Iglesia_Malar( struct RS_DatosSGE datosSGE ) {
    // modificado por Inquisidor para que compile, manteniendo los grupos que habia.
    datosSGE.faccionId = STANDARD_FACTION_HOSTILE;
    string sumaMalar = RS_ArregloDMDs_sumar( ADE_Iglesia_Malar_get(), ADE_Merc_HOrcSorcerer_get() );
    float faeCasters = RS_generarGrupo( datosSGE, sumaMalar, 0.3, 0.2, 0, 0.5, 0, 0.1  );
    RS_generarGrupo( datosSGE, ADE_Merc_HOrcBarbarians_get(), 1.0-faeCasters );
}
