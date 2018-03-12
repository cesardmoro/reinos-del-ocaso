/*******************************************************************************
Package: Sistema Premio Combate - Generacion de cofres para ubicar el premio
Author: Inquisidor
*******************************************************************************/
#include "ctnr_VectorObj"
#include "SPC_itf"
#include "SPC_poderRel_inc"
#include "SPC_fastHandlers"
#include "RS_itf"
#include "RdO_races_itf"
#include "Random_inc"
#include "RTG_itf"
#include "RegGan_inc"

const string SPC_Cofre_contenedorReceptorTesoro_VN = "SPCcrt"; // contenedor asociado al waypoint receptor de tesoro


//Gives TRUE if 'creature' has the 'searchedEffect'.
int hasEffectType( object creature, int searchedEffect );
int hasEffectType( object creature, int searchedEffect ) {
    effect iteratedEffect = GetFirstEffect(creature);
    while( GetIsEffectValid(iteratedEffect) ) {
        if( GetEffectType(iteratedEffect) == searchedEffect )
            return TRUE;
        iteratedEffect = GetNextEffect(creature);
    }
    return FALSE;
}


// obtiene el cofre asociado al waypoint 'cofreWP'
object SPC_CofreWP_getCofre( object cofreWP );
object SPC_CofreWP_getCofre( object cofreWP ) {
    object cofre = GetLocalObject( cofreWP, SPC_Cofre_contenedorReceptorTesoro_VN );
    if( !GetIsObjectValid( cofre ) ) {
        cofre = CreateObject( OBJECT_TYPE_PLACEABLE, SPC_Cofre_RESREF_PREFIX + IntToString(d4()), GetLocation(cofreWP), FALSE, SPC_Cofre_TAG );
        SetLocalObject( cofreWP, SPC_Cofre_contenedorReceptorTesoro_VN, cofre );
    }
    return cofre;
}


// De tener éxito la tiada de dados, monta en 'placeable' una trampa y/o una traba tales que el nivel de dificultad
// sea 'crIngeniero + 3 + Random(20)' para detectarla, 'crIngeniero + 11 + Random(20)' para desarmarla y destrabarla.
// Una de cada ocho trampas es recuperable.
void SPC_Placeable_montarObstaculo( object placeable, int crIngeniero, int invChanceTrampa=10, int invChanceTraba=5 );
void SPC_Placeable_montarObstaculo( object placeable, int crIngeniero, int invChanceTrampa=10, int invChanceTraba=5 ) {
    if( !GetIsObjectValid(placeable) )
        return;

    // Calcular el modificador mas alto que puede lograr un PJ especializado de nivel igual a crIngeniero.
    // skill: 3 + nivelPJ + 2; habilidad: 2 + nivlPJ/8; el último término aproxima lo que se obtiene con ítems
    int modificadorMaximoPj = crIngeniero + 7 + crIngeniero/8 + FloatToInt( pow( IntToFloat(crIngeniero), 0.7 ) );

    // armado de la trampa
    if( !GetIsTrapped(placeable) && Random(invChanceTrampa)==0 ) {
        int trapBaseType;

        if( crIngeniero < 3 )
            trapBaseType = Random(11)*4;
        else if( crIngeniero < 23 )  // 23 = 3 + 4*5
            trapBaseType = Random(11)*4 + (crIngeniero-3)/5;
        else
            trapBaseType = TRAP_BASE_TYPE_EPIC_ELECTRICAL + Random(4);

        CreateTrapOnObject( trapBaseType, placeable, STANDARD_FACTION_HOSTILE, "SPC_cdisarm", "" );
    }
    if( GetIsTrapped(placeable) ) {
        int isRecoverable = d8()==1 ? TRUE : FALSE;
        SetTrapDetectDC( placeable, Random_challengeDistribution(modificadorMaximoPj) + 12 );
        SetTrapDisarmDC( placeable, Random_challengeDistribution(modificadorMaximoPj) + 20 );
        SetTrapDetectable( placeable, TRUE );
        SetTrapDisarmable( placeable, TRUE );
        SetTrapRecoverable( placeable, isRecoverable );
        SetTrapOneShot( placeable, FALSE );
        SetLocalInt( placeable, SPC_Cofre_crTrampa_VN, crIngeniero );
//        SetName( placeable, GetName(placeable) + " trapped" );
    }

    // armado de la traba
    SetLockKeyRequired( placeable, FALSE );
    SetLockLockable( placeable, TRUE );
    SetLockLockDC( placeable, Random_challengeDistribution(modificadorMaximoPj) + 15 );
    if( !GetLocked( placeable ) && Random(invChanceTraba)==0 ) {
        SetLocked( placeable, TRUE );
    }
    if( GetLocked( placeable ) ) {
        SetLockUnlockDC( placeable, Random_challengeDistribution(modificadorMaximoPj) + 20 );
        SetLocalInt( placeable, SPC_Cofre_crCerradura_VN, crIngeniero );
//        SetName( placeable, GetName(placeable) + " locked" );
    }

    // seteo de la cantiad de hitpoints
    int desvioResistencia = GetCurrentHitPoints( placeable ) - crIngeniero * (GetIsTrapped(placeable) ? 10:50);
    if( desvioResistencia > 0 )
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( desvioResistencia ), placeable );
    else if( desvioResistencia < 0 )
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( -desvioResistencia ), placeable );

//    SetName( placeable, " desvioResistencia="+IntToString(desvioResistencia)+", hp=" + IntToString( GetCurrentHitPoints(placeable) ) );
}


// funcion privada usada solo por 'SPC_Cofre_determinarDestinoTesoro(..)'
void SPC_Cofre_agregarWaypoint( struct Address waypointsReceptoresTesoro, string tagWaypointReceptorTesoroIterado ) {
    object waypointReceptorTesoroIterado = GetWaypointByTag( tagWaypointReceptorTesoroIterado );
    if( waypointReceptorTesoroIterado != OBJECT_INVALID )
        VectorObj_pushBack( waypointsReceptoresTesoro, waypointReceptorTesoroIterado );
    else
        WriteTimestampedLogEntry( "Error, waypoint receptor de tesoro no encontrado: tag="+tagWaypointReceptorTesoroIterado+", area="+GetName(waypointsReceptoresTesoro.nbh) );
}


// Sortea un sitio de entre los especificados por la propiedad de area 'SPC_Cofre_waypointsTagsList_PN' donde se encuentra 'criaturaMatada'.
// Si no hay un cofre en tal sitio (nunca fue creado o fue destruido), se genera uno nuevo.
// Además hay una chance de que sea se le ponga una traba y/o una trampa. De ser asi, el DC depende del mayor entre el 'RS_nivelPremio_LN' de la criatura y el CR del área donde se encuentre el cofre.
object SPC_Cofre_determinarDestinoTesoro( object criaturaMatada );
object SPC_Cofre_determinarDestinoTesoro( object criaturaMatada ) {
    object areaMuerte = GetArea( criaturaMatada );
    string listaTagsWaypointsReceptoresTesoro = GetLocalString( areaMuerte, SPC_Cofre_waypointsTagsList_PN );

    // si el área no indica los waypoints donde poner el tesoro, ponerlo en la criatura misma.
    if( listaTagsWaypointsReceptoresTesoro == "" )
        return OBJECT_INVALID;

    // obtener el vector con los waypoints donde poner el tesoro
    struct Address waypointsReceptoresTesoro = Address_create( areaMuerte, "SPCwrt" );
    // si el vector aún no fue construido, construirlo y llenarlo con los waypoints correspondientes a los tags que haya en la lista 'listaTagsWaypointsReceptoresTesoro'.
    if( !Instance_isConstructed( waypointsReceptoresTesoro ) ) {
        VectorObj_constructor( waypointsReceptoresTesoro );
        int longitudTextoRestante = GetStringLength( listaTagsWaypointsReceptoresTesoro );
        while( longitudTextoRestante > 0 ) {
            int posSiguienteComa = FindSubString( listaTagsWaypointsReceptoresTesoro, "," );
            if( posSiguienteComa < 0 )
                posSiguienteComa = longitudTextoRestante;
            string tagWaypointReceptorTesoroIterado = GetStringLeft( listaTagsWaypointsReceptoresTesoro, posSiguienteComa );
            // obtenido el tag, averiguar el waypoint que le corresponde y agregarlo al vector
            SPC_Cofre_agregarWaypoint( waypointsReceptoresTesoro, tagWaypointReceptorTesoroIterado );

            // si el último caracter del tag es un número del 2 al 9, averiguar y agregar los waypoint correspondientes al mismo tag pero cambiando el último caracter desde el que tenia hasta '1'.
            int multiplicity = StringToInt( GetStringRight(tagWaypointReceptorTesoroIterado,1) );
            if( multiplicity > 1 ) {
                tagWaypointReceptorTesoroIterado = GetStringLeft( tagWaypointReceptorTesoroIterado, posSiguienteComa-1);
                for( ; --multiplicity > 0; ) {
                    SPC_Cofre_agregarWaypoint( waypointsReceptoresTesoro, tagWaypointReceptorTesoroIterado+IntToString(multiplicity) );
                }
            }

            longitudTextoRestante -= posSiguienteComa + 1;
            listaTagsWaypointsReceptoresTesoro = GetStringRight( listaTagsWaypointsReceptoresTesoro, longitudTextoRestante );
        }
    }

    // si por algun error no se obtuvo ningún waypoint, devolver OBJECT_INVALID
    int cantidadWaypointsReceptoresTesoro = VectorObj_getSize( waypointsReceptoresTesoro );
    if( cantidadWaypointsReceptoresTesoro == 0 )
        return OBJECT_INVALID;

    // elegir uno de los waypoints al azar
    int indiceSorteado = Random( cantidadWaypointsReceptoresTesoro );
    object waypointReceptorTesoroElegido = VectorObj_getAt( waypointsReceptoresTesoro, indiceSorteado );

    // obtener el contenedor asociado al waypoint elegido
    object contenedorReceptorTesoroElegido = SPC_CofreWP_getCofre( waypointReceptorTesoroElegido );

    // el DC para abrir cerraduras y detectar/desactivar trampas estará basado en el 'crIngeniero', que es el máximo entre el CR del encuentro y el CR del área donde esta el contenedor receptor del tesoro
    int crAreaWaypointReceptor = GetLocalInt( GetArea(waypointReceptorTesoroElegido), RS_crArea_PN );
    int nivelPremioCriatura = GetLocalInt( criaturaMatada, RS_nivelPremio_LN );
    int crIngeniero = crAreaWaypointReceptor > nivelPremioCriatura ? crAreaWaypointReceptor : nivelPremioCriatura;
    SPC_Placeable_montarObstaculo( contenedorReceptorTesoroElegido, crIngeniero, 10, 5 );
    return contenedorReceptorTesoroElegido;
}


// Debe ser llamada desde el onDeath handler de los cofres creados por 'SPC_Cofre_determinarDestinoTesoro(..)'.
void SPC_Cofre_onDeath( object cofre );
void SPC_Cofre_onDeath( object cofre ) {
//    SendMessageToPC( GetFirstPC(), "cofre_death: called");

    // destruir un tercio de los ítems que haya dentro del cofre
    object itemIterator = GetFirstItemInInventory( cofre );
    while( itemIterator != OBJECT_INVALID ) {
        if( Random(3)==0 ) {
            object restos = CreateItemOnObject( "x2_it_amt_spikes", cofre );
            SetName( restos, "restos de un/a " + GetName(itemIterator) );
            DestroyObject( itemIterator );
        }
        itemIterator = GetNextItemInInventory( cofre );
    }
}


// Debe ser llamada desde el onUnlock handler de los placeables a los cuales se le monto una traba
// usando 'SPC_Placeable_montarObstaculo()', y que se pretenda den experiencia al ser destrabados.
void SPC_Placeable_onUnlock( object placeable, object cerrajero );
void SPC_Placeable_onUnlock( object placeable, object cerrajero ) {
    if( hasEffectType( cerrajero, EFFECT_TYPE_INVISIBILITY ) ) {
        SendMessageToPC( cerrajero, "La accion de quitar una traba no es premiada si quien la realiza esta invisible" );
    } else {
        int crCerradura = GetLocalInt( placeable, SPC_Cofre_crCerradura_VN );
        if( crCerradura > 0 ) {
            DeleteLocalInt( placeable, SPC_Cofre_crCerradura_VN );

            int nivelCerrajero = GetHitDice( cerrajero ) + GetLocalInt( cerrajero, RDO_modificadorNivelSubraza_PN );
            float dificultad = SisPremioCombate_poderRelativoSujeto( crCerradura, nivelCerrajero );
            dificultad *= SisPremioCombate_factorPenaSevera( dificultad );

            float factorPena = IntToFloat( 100 + GetLocalInt( GetArea(placeable), RS_factorTransitoArea_PN ) )/100.0; // recordar que 'factorTransitoArea' es un numero negativo entre 0 y -100
            float premioNominal = 0.25 * dificultad * factorPena; // para que de un 25% del premio nominal cuando la dificultad es la unidad y la pena es nula.
            SPC_Placeable_onUnlockFastHandlers( placeable, premioNominal );

            int xpDestrabePorMil = FloatToInt( 1000.0 * SPC_PREMIO_XP_NOMINAL * premioNominal );
            int experienciaGanadaDesdeUltimoDescansoPorMil = xpDestrabePorMil + GetLocalInt( cerrajero, SPC_xpTransitoriaPorMil_VN );
            SetLocalInt( cerrajero, SPC_xpTransitoriaPorMil_VN, experienciaGanadaDesdeUltimoDescansoPorMil );

            SendMessageToPC( cerrajero, "XP: " + IntToString( (xpDestrabePorMil+500)/1000 ) );
    //        SendMessageToPC( GetFirstPC(), "SPC_cofre_inc: self="+GetName(placeable)+", crCerradura="+IntToString(crCerradura)+", dificultad="+FloatToString(dificultad) );
        }
    }
}


// Debe ser llamadad desde el onTrapDisarmed handler de los placeables a los que se les haya montado un trampa usando 'SPC_Placeable_montarObstaculo(..)',
// si se pretende que la accion de desarmar la trampa de experiencia.
void SPC_Placeable_onTrapDisarmed( object placeable );
void SPC_Placeable_onTrapDisarmed( object placeable ) {
    object desarmador = GetLastDisarmed();
    SetTrapOneShot( placeable, TRUE );
    if( hasEffectType( desarmador, EFFECT_TYPE_INVISIBILITY ) ) {
        SendMessageToPC( desarmador, "La accion de desarmar una trampa no es premiada si quien la realiza esta invisible" );
    } else {
        int crTrampa = GetLocalInt( placeable, SPC_Cofre_crTrampa_VN );
        if( crTrampa > 0 ) {
            DeleteLocalInt( placeable, SPC_Cofre_crTrampa_VN );

            int nivelDesarmador = GetHitDice( desarmador ) + GetLocalInt( desarmador, RDO_modificadorNivelSubraza_PN );
            float dificultad = SisPremioCombate_poderRelativoSujeto( crTrampa, nivelDesarmador );
            dificultad *= SisPremioCombate_factorPenaSevera( dificultad );

            float factorPena = IntToFloat( 100 + GetLocalInt( GetArea(placeable), RS_factorTransitoArea_PN ) )/100.0; // recordar que 'factorTransitoArea' es un numero negativo entre 0 y -100
            float premioNominal = 0.50 * dificultad * factorPena; // para que de un 50% del premio nominal cuando la dificultad es la unidad y la pena es nula.
            SPC_Placeable_onDisarmFastHandlers( placeable, premioNominal );

            int xpDesarmePorMil = FloatToInt( 1000.0 * SPC_PREMIO_XP_NOMINAL * premioNominal );
            int experienciaGanadaDesdeUltimoDescansoPorMil = xpDesarmePorMil + GetLocalInt( desarmador, SPC_xpTransitoriaPorMil_VN );
            SetLocalInt( desarmador, SPC_xpTransitoriaPorMil_VN, experienciaGanadaDesdeUltimoDescansoPorMil );

            SendMessageToPC( desarmador, "XP: " + IntToString( (xpDesarmePorMil+500)/1000 ) );
    //        SendMessageToPC( GetFirstPC(), "SPC_cofre_inc: self="+GetName(placeable)+", crTrampa="+IntToString(crTrampa)+", dificultad="+FloatToString(dificultad) );

            int oroADar = FloatToInt( premioNominal * crTrampa * RTG_TOKEN_VALUE_PER_CR );
            GiveGoldToCreature( desarmador, oroADar );
            RegGan_registrarOro( desarmador, oroADar );
        }
    }
}
