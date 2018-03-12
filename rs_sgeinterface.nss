/******************************************************************************
Package: RandomSpawn - SGE interface
Author: Inquisidor
Descripcon: Toda area que pretenda generar RandomSpawn tiene un scrip asociado que
se encarga de generar encuentros con criaturas correspondientes al area. Este script,
que llamaremos SGE (Script Generador de Encuentros), es llamado por el RandomSpawn
system cada vez que se genera un encuentro en el area.
Las funciones definidas aqui son la interface entre el SGE y el sistema de RandomSpawn.
IMPORTATE: todas las funciones aqui definidas deben ser llamadas con OBJECT_SELF == area del encuentro
*******************************************************************************/

#include "RS_itf"
#include "location_tools"
#include "Area_generic"
#include "Dice_Roll_Check"
#include "ResourcesList"


struct RS_DatosSGE {
    int numeroEncuentroSucesivo;    // vale: 0 para los encuentros del spawn inicial, 1 para el primer refuerzo, 2 para el segundo refuerzo, y asi sucesivamente para todos los refuerzos y los despojos. Es menor a cero para encuentros forzados (el SGE no fue llamado desde RS_onEnter)
    int cantidadRefuerzos;          // cantidad total de refuerzos que hubo o habrá. A los encuentros cuyo 'numeroEncuentroSucesivo > cantidadRefuerzos' se los llama despojos.
    int dificultadEncuentro;        // Es igual a dificultadSpawnInicial para los encuentros del spawn inicial, e igual a crArea para los encuentros sucesivos.
    float poderRelativoEncuentro;   // poder relativo del encuentro. Vale 'RS_PODER_RELATIVO_ENCUENTROS_INCIALES' para los encuentros del spawn inicial, 'RS_PODER_RELATIVO_BASE para el primer refuerzo, aumenta progresivamente para los siguientes refuerzos, y luego baja abruptamente para los despojos. Tambien es modificado por el parámetro 'factorPoderEncuentro'.
    string onCreatureGeneratedHL;   // HandlersList para el evento onCreatureGenerated. Este evento lo dispara 'RS_marcarCriatura(..)', o sea que sucede para todas las criaturas generadas por el RandomSpawn.
    string onCreatureDeathHL;       // HandlersList para el evento onCreatureDeath. Este evento lo dispara 'SisPremioCombate_onDeath(...)', o sea que sucede cuando una criatura del random spawn es matada.

    object enteringPj;              // personaje que entro al area y provoco la generacion del spawn inicial. Vale OBJECT_IVALID si el encuentro a generar no es para el spawn inicial.
    location ubicacionEncuentro;    // location donde el SGE debe dejar las criatura que genere para el encuentro.
    object pjSorteado;              // personaje sorteado como blanco inicial de los ataques de las criaturas del encuentro. Solo valido cuando numeroEncuentroSucesivo > 0
    int pjSorteadoTiradaIniciativa; // tirada de iniciativa del pj sorteado. Usada por RS_marcarCriatura()
    int pjSorteadoTiradaHide;
    int pjSorteadoTiradaMoveSilently;
    int faccionId;                  // si es >= 0, determinara la faccion de las criaturas generadas
    float factorPremio;             // multiplica el premio en XP y la esperanza del valor en oro de los bienes, sin alterar el poder del encuentro ni la calidad de los ítems. O sea que modifica la XP, la cantidad de oro, y la chance de que suelte ítems.
};


float RS_getPoderRelativoBase( int crArea ) {
    float prb;
    if( crArea <=5 ) switch(crArea) {
        case 3: prb = 0.6; break;
        case 4: prb = 0.9; break;
        case 5: prb = 1.2; break;
        default: prb = 0.5; break;
    }
    else if( crArea <= 14 )
        prb = 1.0 + IntToFloat(crArea)/15.0;
    else // crArea >= 15
        prb = 2.0 + IntToFloat(crArea-14)/3;
    return prb;
}

// Da toda la informacion que el SGE requiere excepto lo concerniente a la ubicacion. (ver struct RS_DatosSGE arriba).
// El ‘factorPoderEncuentro’ (por defecto es 1) modifica el poder del encuentro a generar. Este parámetro, aunque también modifica el premio en XP y bienes, esta pensado para modificar la dificultad del encuentro (junto con el premio), y no solo el premio.
// El ‘factorPremio’ (por defecto es 1) multiplica el premio en XP y la esperanza del valor en oro de los bienes, sin alterar el poder del encuentro ni la calidad de los ítems. O sea que modifica la XP, la cantidad de oro, y la chance de que suelte ítems.
struct RS_DatosSGE RS_getDatosSGE_sinUbicacion( float factorPoderEncuentro=1.0, float factorPremio=1.0 );
struct RS_DatosSGE RS_getDatosSGE_sinUbicacion( float factorPoderEncuentro=1.0, float factorPremio=1.0 ) {
    struct RS_DatosSGE datosSGE;

    datosSGE.dificultadEncuentro = GetLocalInt( OBJECT_SELF, RS_crArea_PN );
    datosSGE.numeroEncuentroSucesivo = GetLocalInt( OBJECT_SELF, RS_numeroEncuentroSucesivo_VN );

    // si es un encuentro forzado (el SGE no fue llamado desde RS_onEnter)
    if( datosSGE.numeroEncuentroSucesivo < 0 ) {
        datosSGE.poderRelativoEncuentro = RS_PODER_RELATIVO_TIPICO_ENCUENTROS_INCIALES;
    }
    // si es un encuentro del spawn inicial
    else if( datosSGE.numeroEncuentroSucesivo == 0 ) {
        datosSGE.dificultadEncuentro += GetLocalInt( OBJECT_SELF, RS_modificadorCrSpawnInicial_PN );
        datosSGE.poderRelativoEncuentro = RS_PODER_RELATIVO_TIPICO_ENCUENTROS_INCIALES;
        datosSGE.enteringPj = GetLocalObject( OBJECT_SELF, RS_enteringPj_VN );
    }
    // si es un encuentro sucesivo
    else {
        datosSGE.cantidadRefuerzos = RS_getCantidadRefuerzos( OBJECT_SELF );
        if( datosSGE.numeroEncuentroSucesivo <= datosSGE.cantidadRefuerzos ) {
            float poderRelativoUltimoRefuerzo = RS_PODER_RELATIVO_BASE * IntToFloat(100 + RS_getPorcentajeAumentoPoderUltimoRefuerzo( OBJECT_SELF ))/100.0;
            float coeficienteCuadratico = (poderRelativoUltimoRefuerzo - RS_PODER_RELATIVO_BASE)/IntToFloat( datosSGE.cantidadRefuerzos * datosSGE.cantidadRefuerzos );
            datosSGE.poderRelativoEncuentro = RS_PODER_RELATIVO_BASE + coeficienteCuadratico * IntToFloat( datosSGE.numeroEncuentroSucesivo * datosSGE.numeroEncuentroSucesivo );
        }
        else
            datosSGE.poderRelativoEncuentro = RS_PODER_RELATIVO_TIPICO_DESPOJOS * IntToFloat( 100 + GetLocalInt( OBJECT_SELF, RS_procentajeModificadorPoderDespojos_PN ) )/100.0;
    }
    datosSGE.poderRelativoEncuentro *= factorPoderEncuentro;
    if( datosSGE.dificultadEncuentro > RS_CNE_UMBRAL_DIFICULTAD_ENCUENTRO )
        datosSGE.poderRelativoEncuentro *= 1.0 + RS_CNE_COEFICIENTE_PODER_RELATIVO * IntToFloat( datosSGE.dificultadEncuentro - RS_CNE_UMBRAL_DIFICULTAD_ENCUENTRO );
    datosSGE.factorPremio = factorPremio;
    datosSGE.faccionId = -1;

    return datosSGE;
}


// Modifica los datos del SGE concernientes a la ubicacion del encuentro con una nueva ubicacin generada al azar.
struct RS_DatosSGE RS_generarUbicacionSGE( struct RS_DatosSGE datosSGE );
struct RS_DatosSGE RS_generarUbicacionSGE( struct RS_DatosSGE datosSGE ) {

    // obtencion de la distancia minima entre PJs y encuentros
    float distanciaMinima = RS_getDistanciaMinimaEntrePjYEncuentro( OBJECT_SELF );

    // si es un encuentro forzado (el SGE no fue llamado desde RS_onEnter)
    if( datosSGE.numeroEncuentroSucesivo < 0 ) {
        datosSGE.ubicacionEncuentro = GetLocation( GetLocalObject( OBJECT_SELF, RS_enteringPj_VN ) ); // en este caso RS_enteringPj_VN es un objeto cualquiera (no necesariamente una criatura) que determina la ubicacion del encuentro
    }
    // si es para un encuentro inicial
    else if( datosSGE.numeroEncuentroSucesivo == 0 ) {
        float marco = GetIsAreaNatural( OBJECT_SELF ) && !GetIsAreaInterior(OBJECT_SELF) ? 0.15 : 0.01;
        datosSGE.ubicacionEncuentro = Location_createRandomAllAreaExcludingCircle( GetLocation( datosSGE.enteringPj ), distanciaMinima, marco );
    // si es para un encuentro sucesivo
    } else {

        float distanciaMaxima = GetLocalFloat( OBJECT_SELF, RS_distanciaMaxima_PN );
        if( distanciaMaxima == 0.0 )
            distanciaMaxima = distanciaMinima + 15.0;
        struct Location_CreateRandomAwayFromPjsResult pjSorteadoYUbicacion = Location_createRandomAwayFromPjs( OBJECT_SELF, distanciaMinima, distanciaMaxima );
        datosSGE.ubicacionEncuentro = pjSorteadoYUbicacion.ubicacionGenerada;

    // personaje sorteado como blanco de los ataques de las criaturas del encuentro que le ganan en iniciativa.
        datosSGE.pjSorteado = pjSorteadoYUbicacion.pjSorteado;
        datosSGE.pjSorteadoTiradaIniciativa = d20() + DRC_initiativeModifier( pjSorteadoYUbicacion.pjSorteado );
        datosSGE.pjSorteadoTiradaHide = d20() + DRC_hideModifier( pjSorteadoYUbicacion.pjSorteado );
        datosSGE.pjSorteadoTiradaMoveSilently = d20() + DRC_moveSilentlyModifier( pjSorteadoYUbicacion.pjSorteado );
    }
    return datosSGE;
}


// Da toda la informacion que el SGE requiere (ver struct RS_DatosSGE arriba).
// El ‘factorPoderEncuentro’ (por defecto es 1) modifica el poder del encuentro a generar. Este parámetro, aunque también modifica el premio en XP y bienes, esta pensado para modificar la dificultad del encuentro (junto con el premio), y no solo el premio.
// El ‘factorPremio’ (por defecto es 1) multiplica el premio en XP y la esperanza del valor en oro de los bienes, sin alterar el poder del encuentro ni la calidad de los ítems. O sea que modifica la XP, la cantidad de oro, y la chance de que suelte ítems.
struct RS_DatosSGE RS_getDatosSGE( float factorPoderEncuentro=1.0, float factorPremio=1.0 );
struct RS_DatosSGE RS_getDatosSGE( float factorPoderEncuentro=1.0, float factorPremio=1.0 ) {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE_sinUbicacion( factorPoderEncuentro, factorPremio );
//    SendMessageToPC( GetFirstPC(), "RS_getDatosSGE: CR="+IntToString( datosSGE.dificultadEncuentro )+", PR="+FloatToString( datosSGE.poderRelativoEncuentro ) );
    return RS_generarUbicacionSGE( datosSGE );
}


// Crea una criatura. Debe ser usada para crear toda criatura que se concidere parte del spawn
object RS_crearCriatura( string plantilla, location ubicacion );
object RS_crearCriatura( string plantilla, location ubicacion ) {
    return CreateObject( OBJECT_TYPE_CREATURE, plantilla, ubicacion, FALSE, RS_CRIATURA_TAG );
}


// Determina la faccion de las criaturas generadas durante la ejecucion de este SGE
// Por ahora solo se puede elegir una faccion estandard (STANDARD_FACTION_*).
// Nota: si 'factionId' es menor a cero, la faccion de las criaturas no es modificada (queda la que indique su ResRef.)
struct RS_DatosSGE RS_setFaccion( struct RS_DatosSGE datosSGE, int faccionId );
struct RS_DatosSGE RS_setFaccion( struct RS_DatosSGE datosSGE, int faccionId ) {
    datosSGE.faccionId = faccionId;
    return datosSGE;
}


// funcion privada a RS_marcarCriatura().
void RS_setInitalBehavior( object target, int initiativeDc, int spotDc, int listenDc ) {

    if(
        d20(1) + DRC_initiativeModifier( OBJECT_SELF ) >= initiativeDc && (
            d20(1) + DRC_spotModifier( OBJECT_SELF ) >= spotDc ||
            d20(1) + DRC_listenModifier( OBJECT_SELF ) >= listenDc
        )
    ) {
        ActionDoCommand( ActionAttack( target ) );
//        DelayCommand( 1.0, SpeakString( "gane la iniciativa" ) );
    }
    else {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), OBJECT_SELF, 6.0 );
//        DelayCommand( 1.0, SpeakString( "perdi la iniciativa" ) );
    }
}

// funcion privada a RS_marcarCriatura().
void RS_setLootCorpseMethod() {
    SetIsDestroyable(TRUE, TRUE, TRUE);
    SetLootable(OBJECT_SELF, TRUE);
}


// El SGE debe llamar a esta funcion por cada criatura que genere.
// El parametro 'porcentajeAporte' le indica al sistema de premios cuanto aporta la criatura al
// grupo generado para que determine de manera justa el premio por vencer a cada criatura
// del grupo, tanto en experiencia como en chance de loot.
// Si los grupos generados por el SGE son de solo una criatura, porcentajeAporte debe valer 100.
// Si en cambio los grupos son de tres criaturas, la suma de los porcentajeAporte de las tres
// debe dar un total de 100.
// El parametros 'datosSGE' deben ser obtenidos llamando a 'RS_getDatosSGE()'
void RS_marcarCriatura( struct RS_DatosSGE datosSGE, object criatura, float fraccionAporteEncuentro );
void RS_marcarCriatura( struct RS_DatosSGE datosSGE, object criatura, float fraccionAporteEncuentro ) {

    // Registrar en la criatura su fraccion de aporte al encuentro del que es miembro
    SetLocalFloat( criatura, RS_fraccionAporteEncuentro_LN, fraccionAporteEncuentro );

    // Registrar en la criatura el compenzador por transito del area y el factor premio del encuentro.
    int factorTransitoArea = GetLocalInt( OBJECT_SELF, RS_factorTransitoArea_PN );
    if( factorTransitoArea > 10 )
        factorTransitoArea = 10;
    SetLocalFloat( criatura, RS_factorPremioEncuentro_VN, datosSGE.factorPremio * IntToFloat( factorTransitoArea + 100 ) / 100.0 );

    // registrar en la criatura a que tipo de spawn pertenece. Esto lo usa cuando la criatura muere para hacer hostil a este tipo de spawn hacia los miembros del party que la mato.
    SetLocalString( criatura, RS_tipoSpawn_VN, RS_getTipoSpawn( OBJECT_SELF ) );

    // cambia la faccion de la criatura a la especificada en el SGE llamando a la funcion RS_setFaccion(..).
    if( datosSGE.faccionId >= 0 )
        ChangeToStandardFaction( criatura, datosSGE.faccionId );

    // hacer que al morir la criatura, su cuerpo sea looteable y se desvanezca cuando sea vaciado.
    AssignCommand( criatura, RS_setLootCorpseMethod() ); // El AssignCommand es necesario para que funcione.

    // el nivel del premio equivale al CR del encuentro, excepto para los despojos donde vale 1 (es 1 y no 0 porque 0 significa que la criatura no fue generada por el RandomSpawn).
    int nivelPremio = (datosSGE.numeroEncuentroSucesivo <= datosSGE.cantidadRefuerzos) ? datosSGE.dificultadEncuentro : 1;
    SetLocalInt( criatura, RS_nivelPremio_LN, nivelPremio );

//    SetName( criatura, "DE="+IntToString(datosSGE.dificultadEncuentro)+ ", %"+IntToString( FloatToInt( 100.0*fraccionAporteEncuentro ) )+", PR="+FloatToString(datosSGE.poderRelativoEncuentro)  );

    // si es una criatura miembro de un encuentro forzado (el SGE no fue llamado desde RS_onEnter)
    if( datosSGE.numeroEncuentroSucesivo < 0 ) {
        SetLocalInt( criatura, RS_temporizadorInactividad_LN, 1200 ); // 120 minutos
         // si el SGE fue llamado desde la RandomSpawnControlWand, evitar que la criatura sea destruida en la limpieza del area
        if( datosSGE.numeroEncuentroSucesivo == -2 )
            SetLocalInt( criatura, RS_isCleanExempt_VN, TRUE ); // evita que la criatura sea destruida durante la limpieza del area.
    }
    // si es una criatura miembro de un encuentro del spawn inical
    if( datosSGE.numeroEncuentroSucesivo == 0 ) {
        SetLocalInt( criatura, RS_temporizadorInactividad_LN, 300 );  // 30 minutos
        SetLocalInt( criatura, RS_isInitialSpawn_LN, TRUE );
    }
    // si es una criatura miembro de un encuentro del spawn sucesivo
    else {
        SetLocalInt( criatura, RS_temporizadorInactividad_LN, 100 ); // 10 minutos
        AssignCommand( criatura, RS_setInitalBehavior( datosSGE.pjSorteado, datosSGE.pjSorteadoTiradaIniciativa, datosSGE.pjSorteadoTiradaHide, datosSGE.pjSorteadoTiradaMoveSilently ) );
        // marcar las criaturas miembro del último refuerzo
        if( datosSGE.numeroEncuentroSucesivo == datosSGE.cantidadRefuerzos )
            SetLocalInt( criatura, RS_esUltimoRefuerzo_VN, TRUE );

    }

    // ejecutar todos los handlers que se subscribieron al evento onCreatureGenerated
    RL_fire( datosSGE.onCreatureGeneratedHL, criatura );

    // Guardar en la criatura la lista de handlers que se subscribieron para ejecutarse al morir la criatura. Tales handlers se ejecutarán al morir la criatura, después de actualizar las variables que informan el premio dado por la criatura a los PJs.
    SetLocalString( criatura, RS_onDeathHL_LN, datosSGE.onCreatureDeathHL );
}


// copia las todas las variables que setea la funcion 'RS_marcarCriatura(..)', desde 'criaturaOrigen' a 'criaturaDestino'.
// Util para criaturas que generan otra criatura al morir, como por ejemplo los huargos montados.
void RS_copiarMarcasCriatura( object criaturaOrigen, object criaturaDestino );
void RS_copiarMarcasCriatura( object criaturaOrigen, object criaturaDestino ) {

    // Registrar en la criatura su fraccion de aporte al encuentro del que es miembro
    SetLocalFloat( criaturaDestino, RS_fraccionAporteEncuentro_LN, GetLocalFloat( criaturaOrigen, RS_fraccionAporteEncuentro_LN ) );

    // Registrar en la criatura el compenzador por transito del area y el factor premio del encuentro.
    SetLocalFloat( criaturaDestino, RS_factorPremioEncuentro_VN, GetLocalFloat( criaturaOrigen, RS_factorPremioEncuentro_VN ) );

    // registrar en la criatura a que tipo de spawn pertenece. Esto lo usa cuando la criatura muere para hacer hostil a este tipo de spawn hacia los miembros del party que la mato.
    SetLocalString( criaturaDestino, RS_tipoSpawn_VN, GetLocalString( criaturaOrigen, RS_tipoSpawn_VN ) );

    // el nivel del premio equivale al CR del encuentro, excepto para los despojos donde vale 1 (es 1 y no 0 porque 0 significa que la criatura no fue generada por el RandomSpawn).
    SetLocalInt( criaturaDestino, RS_nivelPremio_LN, GetLocalInt( criaturaOrigen, RS_nivelPremio_LN ) );

    SetLocalInt( criaturaDestino, RS_isInitialSpawn_LN, GetLocalInt( criaturaOrigen, RS_isInitialSpawn_LN ) );

    // marcar las criaturas miembro del último refuerzo
    SetLocalInt( criaturaDestino, RS_esUltimoRefuerzo_VN, GetLocalInt( criaturaOrigen, RS_esUltimoRefuerzo_VN ) );

    // Guardar en la criatura la lista de handlers que se subscribieron para ejecutarse al morir la criatura. Tales handlers se ejecutarán al morir la criatura, después de actualizar las variables que informan el premio dado por la criatura a los PJs.
    SetLocalString( criaturaDestino, RS_onDeathHL_LN, GetLocalString( criaturaOrigen, RS_onDeathHL_LN ) );

    ChangeFaction( criaturaDestino, criaturaOrigen );
}

