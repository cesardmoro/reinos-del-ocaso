/******************************************************************************
Package: RandomSpawn - include (not coupled)
Author: Inquisidor
Version: 0.1
Descripcon: nombres de variables locales usadas por el RandomSpawn
*******************************************************************************/

///////////// constantes ////////////////////////////////////

const float RS_PODER_RELATIVO_TIPICO_ENCUENTROS_INCIALES = 2.0;
const float RS_CANTIDAD_TIPICA_REFUERZOS = 8.0;
const float RS_PODER_RELATIVO_BASE = 2.0;
const int RS_PORCENTAJE_TIPICO_AUMENTO_PODER_ULTIMO_REFUERZO = 120; // da el porcentaje típico de aumento de poder entre el último refuerzo y el primero
const float RS_PODER_RELATIVO_TIPICO_DESPOJOS = 1.0;
const float RS_CNE_COEFICIENTE_PODER_RELATIVO = 0.12;
const int RS_CNE_UMBRAL_DIFICULTAD_ENCUENTRO = 13;

const float RS_RETARDO_TIPICO_PRIMER_ENCUENTRO = 120.0;
const int RS_PERIODO_TIPICO_ENTRE_ENCUENTROS_SUCESIVOS_CUANDO_CINCO_SUJETOS = 180;
const string RS_CRIATURA_TAG = "RSc";


///////////// Area properties names /////////////////////////

const string RS_scriptPreparacionArea_PN = "RSspa";   // [string] script que es ejecutado cuando el area pasa de estado RS_Estado_PASIVO a otro estado. Es ejecutado antes que el SGE que genera el primer encuentro inicial.
const string RS_crArea_PN = "Cr";               // [int] grado de desafio de este area. Determina tanto el nivel de dificultad del primer encuentro sucesivo (en opocicion a inicial), como el tope maximo del nivel del premio. Si es cero, no se genera spawn.
const string RS_modificadorCrSpawnInicial_PN = "RSmcrsi";    // [int=0] modificador del CR de los encuentros iniciales. La formula es: crSpawnInicial = crArea + RS_modificadorCrSpawnInicial_PN
const string RS_modificadorPeriodoSpawn_PN = "RSmps"; // [float=0] Modificador del perido entre spawn sucesivos. El porcentaje de variacion del periodo estandard sera el valor de esta propiead por 100. O sea que si vale -0.3, el periodo sera un 30% menor al estandard.
const string RS_distanciaMinima_PN = "RSdMin";    // [float] distancia minima entre el personaje y el sitio donde se genere el encuentro
const string RS_distanciaMaxima_PN = "RSdMax";    // [float=distanciaMinima+15] distancia maxima entre el personaje y el sitio donde se genere el encuentro
const string RS_superficieEncuentro_PN = "RSspe"; // [int] cantidad de baldosas por encuentro en el spawn inicial. El valor por defecto es 56 valdosas por encuentro para área sobre tierra, y 38 para areas bajo tierra.
const string RS_sge_PN = "RSsge";                 // [string] nombre del script generador de encuentros (SGE) correspondiente a este area
const string RS_tipoSpawn_PN = "RSts";            // [string=(RS_sge_PN)]
const string RS_factorTransitoArea_PN = "fta";  // Factor que afecta el valor del premio.  El objetivo es poder penar la experiencia ganada en los mapas cercanos a sitios seguros, y aumentar la experiencia en mapas bien alejados.
const string RS_porcentajeModificadorCantidadRefuerzos_PN = "RSpmcr";                       // [int=0] porcentaje de modificación de la cantidad de refuerzos. Debe ser mayor a -100. La formula es: cantidadRefuerzos = RS_CANTIDAD_REFUERZOS_TIPICA * ( 100 + RS_porcentajeModificadorCantidadRefuerzos_PN )/100.  Ver RS_getCantidadRefuerzos(..)
const string RS_procentajeModificadorPorcentajeAumentoPoderUltimoRefuerzo_PN = "RSpmpapur"; // [int=0] porcentaje de modificación del porcentaje de aumento del poder del último refuerzo respecto a crArea. Debe ser mayor a -100. La formula es: poderRelativoUltimoRefuerzo = RS_PODER_RELATIVO_BASE *(100 +  RS_PORCENTAJE_TIPICO_AUMENTO_PODER_ULTIMO_REFUERZO *( 100 + RS_procentajeModificadorPorcentajeAumentoPoderUltimoRefuerzo_PN )/100  )/100.0
const string RS_procentajeModificadorPoderDespojos_PN = "RSpmpd";                           // [int=0] porcentaje de modificacion del poder de los despojos. Debe ser mayor a -100. La formula es: poderRelativoDespojos = RS_PODER_RELATIVO_TIPICO_DESPOJOS * ( 100 + RS_procentajeModificadorPoderDespojos_PN )/100.

///////////// Area variables names ////////////////////

const string RS_numeroEncuentroSucesivo_VN = "RS_nes"; // [int] numero de encuentro sucesivo. Vale cero para todos los encuentros del spawn inicial, vale uno para el primer encuentro sucesivo, dos para el segundo, y asi sucesivamente. Vale -1 para un encuentro manual (generado con la RS_DMC_wand).
const string RS_cantSujetosEnArea_VN = "numero"; // [int] cantidad de PJs y henchmans en el area
const string RS_enteringPj_VN = "RSepj"; // [object] PJ que entro al area. Solo valido durante la generacion el spawn inicial. Luego, para el spawn sucesivo vale OBJECT_INVALID. Tambien usado para determinar la ubicacion de un encuentro manual (cuando 'RS_numeroEncuentroSucesivo_VN == -1' ).
const string RS_dadoCicloEstado_VN = "RSdce"; // [int] numero al azar de 0 a 999 que se genera en cada inicializacion de un area. Util para variar al azar la distribucion de los tipos de criaturas dentro de un area, entre inicializacion e inicalizacion.
const string RS_estado_VN = "RSe"; // [int]
   const int RS_Estado_PASIVO = 0;
   const int RS_Estado_ACTIVO = 1;
   const int RS_Estado_HOSTIL = 3; //  HOSTIL => ACTIVO

//const string RS_tiempoActivo_VN = "RSta"; // [float]
//const string RS_aumentoDificultadAreaAnteriorReducido_VN = "RSadaar"; // [int]


////////////// Placeable property names //////////////////
const string RS_puertaNoEsAbriblePorCriaturasGeneradasPorElRandoSpawn_PN = "RS_pnea"; // usado en 'nw_c2_defaulte'


////////////// Creature property names //////////////////

//const string RS_factorChanceLoot_PN = "RSfcl";  // [float=0] factor que multiplica a la chance de loot de la criatura.
const string RS_plantillaSeguidores_PN = "RSps"; // [string] palntilla de las criaturas seguidoras. Esta propiedad solo la tienen las criaturas líderes de grupo. Ver opcion 'L' de DVD.
const string RS_crSeguidor_PN = "RScrs"; // [int] cr de las criaturas seguidoras de este lider. Esta propiedad solo la tienen las criaturas líderes de grupo. Ver opcion 'L' de DVD.


///////////// Creature variable names //////////////////////

const string RS_nivelPremio_LN = "RSnp"; // [int] Guarda el nivel del premio a dar por vencer a esta criatura. El nivel del premio equivale al CR del encuentro del que esta criatura forma parte, excepto para los encuentros de despojo donde vale 1 (es 1 y no 0 porque esta variable se usa también para distinguir que la criatura fue generada por el RandomSpawn).
const string RS_fraccionAporteEncuentro_LN = "RSfae"; // [float] fraccion del poder que esta criatura aporta al encuentro. La suma de este valor en todas las criaturas de un encuentro da uno.
const string RS_factorPremioEncuentro_VN = "RSfpe"; // [float] Factor que multiplica al premio dado por el encuentro. Se obtiene de multiplicar el compenzador por transito en area y el factor premio recibido del SGE a getDatosSGE()
const string RS_isInitialSpawn_LN = "RSiis"; // [int] es TRUE si la criatura fue generada en el spawn inicial (el que sucede cuando un personaje entra a un area limpia)
const string RS_temporizadorInactividad_LN = "RSti"; // [int] usado en el hearbeat para contar el tiempo que la criatura lleva fuera de combate.
const string RS_tipoSpawn_VN = "RSts"; // [string] registro de a que tipo de spawn pertenece la criatura. Usado cuando la criatura muere para poner a todas areas con el tipo de spawn de la criatura muerta hostiles (se activa el spawn sucesivo) hacia los miembros del party.
const string RS_esUltimoRefuerzo_VN = "RSeur"; // [bool] indica si la criatura es miembro del último refuerzo
const string RS_onDeathHL_LN = "RSodh"; // [string] nombres del script que debe ser ejecutado al morir esta criatura. Es ejecutado despues de actualizar las variables que informan el premio dado por la criatura.
const string RS_isCleanExempt_VN = "RSice"; // [bool] cuando es TRUE la criatura no es destruida durante la limpieza del area ni por inactividad.

///////////// PJs local names ///////////////////////////

const string RS_areaAnterior_VN = "RSaa"; // [object] recuerda cual fue el area donde estuvo el PJ antes del area actual.
const string RS_tiposSpawnHostiles_VN = "RStsh"; // [string] concatenacion de los tipos de spawn que estan hostiles hacia este PJ. Un tipo de spawn se agrega cuando el PJ mata una criatura generada por el Random Spawn.



// Da el tipo de spawn del area dada, sino esta especificado toma el nombre del SGE.
string RS_getTipoSpawn( object area );
string RS_getTipoSpawn( object area ) {
    string tipoSpawn = GetLocalString( area, RS_tipoSpawn_PN );
    if( tipoSpawn == "" )
        tipoSpawn = GetLocalString( area, RS_sge_PN );
    return tipoSpawn;
}


// Da la cantidad de refuerzos que recibe el 'area' dada.
int RS_getCantidadRefuerzos( object area );
int RS_getCantidadRefuerzos( object area ) {
    return FloatToInt( RS_CANTIDAD_TIPICA_REFUERZOS * IntToFloat( 100 + GetLocalInt( area,  RS_porcentajeModificadorCantidadRefuerzos_PN ) )/100.0 );
}

// Da el porcentaje de aumento del poder del último refuerzo respecto del primero, correspondientes al 'area' dada.
int RS_getPorcentajeAumentoPoderUltimoRefuerzo( object area );
int RS_getPorcentajeAumentoPoderUltimoRefuerzo( object area ) {
    return ( RS_PORCENTAJE_TIPICO_AUMENTO_PODER_ULTIMO_REFUERZO * ( 100 + GetLocalInt( area, RS_procentajeModificadorPorcentajeAumentoPoderUltimoRefuerzo_PN ) ) )/100;
}

// Da la distancia a partir de la cual se puede ubicar un encuentro generado. Un encuentro nunca sería ubicado en un sitio tal que la distancia al PJ mas cercano sea menor a esta distancia. La excepción (y bastante frecuente) es cuando el motor desplaza al encuentro porque el la ubicación generada es invalida.
float RS_getDistanciaMinimaEntrePjYEncuentro( object area );
float RS_getDistanciaMinimaEntrePjYEncuentro( object area ) {
    float dMin = GetLocalFloat( area, RS_distanciaMinima_PN );
    if( dMin == 0.0 )
        return GetIsAreaInterior(area) ? 7.0 : GetIsAreaNatural(area) ? 25.0 : 12.0;
    else
        return dMin;
}

int RS_getSuperficiePorEncuentro( object area );
int RS_getSuperficiePorEncuentro( object area ) {
    int spe = GetLocalInt( area, RS_superficieEncuentro_PN );
    if( spe == 0 )
        return GetIsAreaInterior( area ) ? 32 : GetIsAreaNatural(area) ? 56 : 42;
    else
        return spe;
}

// Genera un encuentro con un poder igual al último encuentro sucesivo de refuerzo que haya sido generado.
// La ubicación es al azar usando el mismo criterio que los encuentros sucesivos.
// Si aún no fue generado ningun encuentro sucesivo, el poder será equivalene al primero que fuera generado.
// No se genera encuentro cuando:
// a) el CR del área es cero
// b) el último encuentro que haya sido generado fue de despojo
// c) el último encuentro que haya sido generado fue el último de refuerzo.
void RS_generarEncuentro( object area, float factorPremio=1.0 );
void RS_generarEncuentro( object area, float factorPremio=1.0 ) {
    if( GetLocalInt( area, RS_crArea_PN ) > 0 ) {

        int numeroEncuentroSucesivo = GetLocalInt( area, RS_numeroEncuentroSucesivo_VN );
        if( numeroEncuentroSucesivo < RS_getCantidadRefuerzos( area ) ) {

            if( numeroEncuentroSucesivo <= 0 )
                numeroEncuentroSucesivo = 1;
            SetLocalInt( area, RS_numeroEncuentroSucesivo_VN, numeroEncuentroSucesivo );

            // modificar el factorTransitoArea para que sea tal que aplique el factorPremio recibido
            // fp1 = ( 100 + fta1 )/100
            // fp2 = ( 100 + fta2 )/100
            // factorPremio = fp2/fp1
            // ==> fta2 = factorPremio * ( 100 + fta1 ) - 100
            int fta = GetLocalInt( area, RS_factorTransitoArea_PN );
            SetLocalInt( area, RS_factorTransitoArea_PN, FloatToInt( (100+fta)*factorPremio ) - 100 );

            ExecuteScript( GetLocalString( area, RS_sge_PN ), area );

            SetLocalInt( area, RS_factorTransitoArea_PN, fta );
        }
    }
}

