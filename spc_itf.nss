/*******************************************************************************
Package: Sistema Premio Combate - interface hacia otros sistemas
Author: Inquisidor
Descripcion: Encargado de determinar que y cuando premio dar por vencer un encuentro.
Esto incluye el loot y la XP.
Tambien maneja algunas penas en eventos varios.
*******************************************************************************/

/////////////////////////// constantes /////////////////////////////////////////

const float SPC_PREMIO_XP_NOMINAL = 50.0; // XP ganada por cada miembro de un party que vence un encuentro de dificultad relativa igual a la unidad (premioNominal = 1). La dificultad relativa vale uno cuando la relacion de poder entre el party y el encuentro es 5/RS_PODER_RELATIVO_BASE

const string SPC_Cofre_TAG = "SPC_cofre"; // tag que se pone a los cofres generados por este sistema
const string SPC_Cofre_RESREF_PREFIX = "spc_cofre_"; // prefijo de ResRef de los cofres. Estan en Custom/treasure/

//////////////////////////// propiedades de área ///////////////////////////////

const string SPC_Cofre_waypointsTagsList_PN = "SPCCwtl"; // lista separada por comas de los tags de los waypoints donde se generan los cofres destino de tesoro.
const string SPC_seAplicaPenaDescanso_PN = "SPCsapd"; // [bool] indica si en este area se aplica la pena del 6% a la XP transitoria acumulada cuando se descansa.

//////////////////////////// variables de Cofre ////////////////////////////////

const string SPC_Cofre_crTrampa_VN = "SPCCcrTrampa";
const string SPC_Cofre_crCerradura_VN = "SPCCcrCerradura";


//////////////////////////// variables de criatura /////////////////////////////

const string SPC_xpTransitoriaPorMil_VN = "xp"
    // experiencia transitoria del PJ multiplicada por mil
;
const string SPC_premioGanadoTotal_VN = "RSpgt"
 /* [float] suma del premio que ganaron los PJs que vencieron a la criatura. Cuando una criatura es matada, cada jugador del party ve un mensaje que indica cuanta XP recibió. La XP que le da a cada PJ varia si estos son de niveles distintos. Este valor, el premioGanadoTotal, es proporcional a la suma de las XPs que le mostró a cada jugador.
    El valor de esta variable depende de:
    - el poder del party que mató a esta criatura: el poder del party es función de la cantidad de PJs y henchs que conforman el party (los summons, familiars, y dominados, no se consideran), y de sus respectivos niveles. Las premisas son: un party de N miembros nivel X, tiene la mitad de poder que un party de 2*N miembros nivel X; un party de N miembros nivel 5 tiene el doble de poder que un party de N miembros nivel 3; un party de N miembros nivel 22 tiene el doble de poder que un party de N miembros de nivel 17.
    - el nivelPremio: CR del encuentro al que pertenece esta criatura
    - fraccionAporteEncuentro: fraccion del poder que esta criatura aporta al encuentro.
    - FTA del área donde fue generada esta criatura
    - el valor del parámetro 'factorPremio' pasado a la funcion 'RS_getDatosSGE(...)' en el SGE que generó a esta criatura.
    - la pena por ayuda externa: relación de poder entre el PJ de mayor nivel que haya visto/dañado a esta criatura, y el poder del PJ de mayor nivel del party.
    - la pena por buff ajeno: relacion de poder entre el PJ que aplicó el buff y el PJ de mayor nivel del party.
    La expresion usada para obtener este valor es: poderEncuentro/(poderPJs + poderHenchs) * fraccionAporteEncuentro * (100+FTA)/100 / penaAyudaExterna / penaBuffAjeno */
;


// Reduce la experiencia trancitoria en un 'porcentajeAQuitar' porciento.
// Si 'porcentajeAQuitar' vale 100, se quita toda la experiencia transitoria.
// Deuvelve la experiencia transitoria que le queda por mil
int SisPremioCombate_quitarPorcentajeXpTransitoria( object sujeto, int porcentajeAQuitar );
int SisPremioCombate_quitarPorcentajeXpTransitoria( object sujeto, int porcentajeAQuitar ) {
    int xpTrasitoriaPorMil = (100-porcentajeAQuitar) * GetLocalInt( sujeto, SPC_xpTransitoriaPorMil_VN );
    xpTrasitoriaPorMil /= 100;
    SetLocalInt( sujeto, SPC_xpTransitoriaPorMil_VN, xpTrasitoriaPorMil );
    SetCampaignInt( "tempxp", "xp", xpTrasitoriaPorMil, sujeto );
    return xpTrasitoriaPorMil;
}

