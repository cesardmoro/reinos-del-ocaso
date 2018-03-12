/*******************************************************************************
Package: Sistema Premio Combate
Author: Inquisidor
Descripcion: Encargado de determinar que y cuando premio dar por vencer un encuentro.
Esto incluye el loot y la XP.
Tambien maneja algunas penas en eventos varios.
*******************************************************************************/
#include "SPC_itf"
#include "SPC_poderRel_inc"
#include "Experience_inc"
//#include "RTG_inc"
#include "RS_itf"
#include "Mercenario_Itf"
#include "ResourcesList"
#include "SPC_fastHandlers"

////////// nombres de las propiedades de una criatura concernientes al SPC /////////////////////////

const string SPC_topeFactorPremioPorDiezMil_PN = "SEtFP"
   /* El tope del factor premio esta para limitar el abuso de criaturas que
    tienen el CR mas alto de lo que corresponde, o que su AI no este funcionando
    apropiadamente.*/
;

////////// nombres de las variables de una criatura concernientes al SPC /////////////////////////

const string SPC_maximoNivelAgresor_VN = "SEmNA"
    // recuerda el nivel del sujeto de mas alto nivel que haya afectado o haya sido percibido por esta criatura
;
const string SPC_danioTotalAcumulado_VN = "SEdTA"
    /* Recuerda todo el danio que le fue hecho a esta criatura hasta llegar
    al MaxHitPoints de esta criatura. */
;

const string SPC_danioAcumulado_FIELD = ".SEdA"
    /* recuerda el danio realizado a la criatura por el equipo del que este campo es miembro */
;


const float PREMIO_INDIVIDUAL_TOPE_POR_DEFECTO = 2.0;

const int ES_XP_SOLO_PARA_PJS = TRUE
    /* Esta constante booleana determina si se calcula y otorga premio de XP a
    todos los miembros del equipo incluidos los henchmans y summons; o si solo
    se calcula y otorga a los PJs.
    Conciderar que cuando esta en FALSE, el hecho de calcular y otorgar premios
    para henchmans y summons, consume tiempo de procesamiento que seria en vano
    si no se ultiliza. */
;


// Da el premio en experiencia que gana cada personaje miembro del 'party' recibido, debido a vencer a la 'criatura'.
// Aqui se aplican las penas individuales de cada miembro.
float SisPremioCombate_darExperienciaAMiembros(
    object party,               // party a darle la experiencia
    object criatura,            // criatura oponente
    int nivelPremio,            // nivel del premio del encuentro. Equivale al grado de desafio (CR) del encuentro.
    float premioNominal,           // premio nominal que se dará a cada uno de los miembros, y equivale a la dificultad relativa que ofrece el encuentro respecto al party ( proporcional a poderEncuentro/poderParty ), afectado por penas y bonos que afectan al grupo entero por igual.
    float fraccionAporteEncuentro, // fraccion de aporte al encuentro dado por la criatura
    int danioRealizado,         // danio realizado a la criatura
    float poderMedio,           // poder promedio de los miembros del party respecto a la criatura oponente
    int mostrarPremio=FALSE     // si es TRUE, se muestra el premio que dará vencer a la criatura a cada miembro
);
float SisPremioCombate_darExperienciaAMiembros( object party, object criatura, int nivelPremio, float premioNominal, float fraccionAporteEncuentro, int danioRealizado, float poderMedio, int mostrarPremio=FALSE ) {
    float premioTotal = 0.0;
//    SendMessageToPC( GetFirstPC(), "darExperienciaAMiembros: premioNominal="+FloatToString(premioNominal) );
    // obtiene el tope del premio, que es una propiedad de la criatura.
    float premioIndividualTope = /*GetLocalFloat( criaturaAgredida, SPC_premioIndividualTope_PN );
    if( premioIndividualTope == 0.0 )
        premioIndividualTope =*/ PREMIO_INDIVIDUAL_TOPE_POR_DEFECTO;

    float fraccionDanio = IntToFloat(danioRealizado) / IntToFloat(GetMaxHitPoints( criatura ));

    // iteracion sobre todos los personajes para darles a cada uno la experiencia que merecen
    object miembro = GetFirstFactionMember( party, ES_XP_SOLO_PARA_PJS );
    while( GetIsObjectValid( miembro ) == TRUE ) {
        if(
            GetArea(miembro) == GetArea(criatura) && (
                GetRacialType( criatura ) != RACIAL_TYPE_ANIMAL ||
                GetLevelByClass( CLASS_TYPE_DRUID, miembro ) == 0
            )
        ) {
//            SendMessageToPC( miembro, "factor premio grupal=%" + FloatToString( premioNominal ) );

            float premioIndividual = premioNominal;
            int nivelMiembro = GetHitDice( miembro ) + GetLocalInt( miembro, RDO_modificadorNivelSubraza_PN );
            float poderMiembro = SisPremioCombate_poderRelativoSujeto( nivelMiembro, nivelPremio  ); // poder del miembro respecto al CR de la criatura.

            // aplicacion de la pena por inutil, la cual solo afecta a los miembros cuyo poder (respecto a la criatura) esta por debajo del poder promedio del party
            premioIndividual *= SisPremioCombate_factorPenaSuave( poderMiembro / poderMedio );
//            SendMessageToPC( miembro, "factor pena inutil=" + FloatToString( SisPremioCombate_factorPenaSuave( poderMiembro / poderMedio ) ) );

            // aplicacion del tope al premio. Este tope es necesario para limitar el abuso a criaturas que tengan mal puesto el CR o su AI no funcione como corresponda.
            if( premioIndividual > premioIndividualTope ) {
                premioIndividual = premioIndividualTope;
            }

            // considerar solo el aporte al premio correspondiente a la fraccion de poder que la criatura aporta al encuentro
            premioIndividual *= fraccionAporteEncuentro;

            float dificultadRelativa = 1.0/poderMiembro; // notar que la inversa de poderMiembro da la dificultadRelativa que ofrece el encuentro a un party de cinco sujetos del nivel del miembro

            // acumular el premio nominal ganado por todos los miembros del party, con la diferencia de que a la XP se le aplica pena severa por sobrenivel, y al tesoro se le aplica pena suave por sobre nivel
            premioTotal += premioIndividual * SisPremioCombate_factorPenaSuave(dificultadRelativa);

            // aplicacion de la pena por sobre nivel, la cual afecta solo cunado nivelPersonaje > nivelPremio. Notar que solo afectara al premio en XP
            if( nivelMiembro > nivelPremio )
                premioIndividual *= SisPremioCombate_factorPenaSevera(dificultadRelativa);

            float experienciaIndividual = SPC_PREMIO_XP_NOMINAL * premioIndividual; // un miembro de un party de 5 sujetos nivel X gana SPC_PREMIO_XP_NOMINAL de XP si el party vence a un encuentro de CR X
//            SendMessageToPC( miembro, "premio="+ IntToString( experienciaIndividualPorMil ) + "/1000" );
            int experienciaGanadaDesdeUltimoDescansoPorMil = GetLocalInt( miembro, SPC_xpTransitoriaPorMil_VN ) + FloatToInt( 1000.0 * experienciaIndividual * fraccionDanio );

            SetLocalInt( miembro, SPC_xpTransitoriaPorMil_VN, experienciaGanadaDesdeUltimoDescansoPorMil );
//            SendMessageToPC( miembro, "ganado desde ultimo descanso="+IntToString( experienciaGanadaDesdeUltimoDescansoPorMil )+"/1000" );

            if( mostrarPremio )
                SendMessageToPC( miembro, "XP: " + IntToString( FloatToInt( experienciaIndividual ) ) );

            if( GetPCPublicCDKey(miembro)=="RFJKFCQW" )
                SendMessageToPC( miembro, "pb="+IntToString(FloatToInt(1000.0*premioNominal))+", pi="+IntToString(FloatToInt(1000.0*premioIndividual))+", fae="+IntToString(FloatToInt(100.0*fraccionAporteEncuentro)) );
        }

        miembro = GetNextFactionMember( party, ES_XP_SOLO_PARA_PJS );
    } // end while

    return premioTotal;
}



// Funcion que se debe llamar desde el onPerception de las criaturas que den experiencia
// para que la pena por asistencia abarque tambien cuando el asistente no lastima
// a la criatura, o casteó algun hechizo sobre quien esta a la vista de la criatura.
void SisPremioCombate_onPerception();
void SisPremioCombate_onPerception() {
    object subject = GetLastPerceived();
    if( GetIsPC( subject ) && !GetIsDM( subject ) ) {
        int maximoNivelAgresor0 = GetLocalInt( OBJECT_SELF, SPC_maximoNivelAgresor_VN );
        int maximoNivelAgresor1;

        int testedLevel = GetHitDice( subject ) + GetLocalInt( subject, RDO_modificadorNivelSubraza_PN );
        if( testedLevel > maximoNivelAgresor1 )
            maximoNivelAgresor1 = testedLevel;

        effect effectIterator = GetFirstEffect( subject );
        object previousEffectCreator = OBJECT_INVALID; // esta variable se usa solo para eficiencia: logra que se cheque solo el primer efecto de una serie contigua de effectos creados por el mismo caster.
        while( GetIsEffectValid( effectIterator ) ) {
            object effectCreator = GetEffectCreator( effectIterator );
            if( GetIsObjectValid( effectCreator ) && effectCreator != previousEffectCreator ) {
                int effectCreatorLevel = GetHitDice( effectCreator ) + GetLocalInt( effectCreator, RDO_modificadorNivelSubraza_PN );
                if( effectCreatorLevel > maximoNivelAgresor1 )
                    maximoNivelAgresor1 = effectCreatorLevel;
            }
            previousEffectCreator = effectCreator;
            effectIterator = GetNextEffect( subject );
        }

        if( maximoNivelAgresor1 > maximoNivelAgresor0 )
            SetLocalInt( OBJECT_SELF, SPC_maximoNivelAgresor_VN, maximoNivelAgresor1 );
    }
}



// Funcion que se debe llamar desde el onDamage handler de las criaturas que den
// experiencia.
void SisPremioCombate_onDamage( object sujetoAgresor, int danioRealizado );
void SisPremioCombate_onDamage( object sujetoAgresor, int danioRealizado ) {
    object criaturaAgredida = OBJECT_SELF;

    // si la criatura no corresponde a un encuentro que da experiencia, saltear todo
    int nivelPremio = GetLocalInt( criaturaAgredida, RS_nivelPremio_LN );
    if( nivelPremio <= 0 )
        return;

//    SendMessageToPC( sujetoAgresor, "Premio_onCriaturaAfligida: 1" );

    int danioTotalAcumulado = GetLocalInt( criaturaAgredida, SPC_danioTotalAcumulado_VN ); // este es todo el danio que le fue hecho a la criatura (con maximo en MaxHitPoints).
    int danioMortal = GetMaxHitPoints( criaturaAgredida ) - danioTotalAcumulado; // este es el danio que falta hacer a la criatura para llegar a MaxHitPoints.

    // Una vez que el danio a la criatura acumulado supera MaxHitPoints (sea porque se regenero o curo), no se gana experiencia; asi que saletear todo lo referente al premio en experiencia
    if( danioMortal <= 0 )
        return;

//    SendMessageToPC( sujetoAgresor, "Premio_onCriaturaAfligida: 2" );

    // quita de danioRealizado el danio que no cuenta (porque supera a MaxHitPoints).
    if( danioRealizado > danioMortal )
        danioRealizado = danioMortal;

    // Actualiza el danio realizado a la criatura
    danioTotalAcumulado += danioRealizado;
    SetLocalInt( criaturaAgredida, SPC_danioTotalAcumulado_VN, danioTotalAcumulado );

    // si no hay agresor, no hay a quien darle premio, asi que saltear todo lo referente al premio en experiencia
    if( !GetIsObjectValid( sujetoAgresor ) )
        return;

//    SendMessageToPC( sujetoAgresor, "Premio_onCriaturaAfligida: 3" );

    // Registra en la criatura el nivel del sujeto de mas alto nivel que la haya afectado negativamente (asumiendo que 'sujetoAgresor' no es amigo de la 'criaturaAgredida' ).
    int maximoNivelAgresor = GetLocalInt( criaturaAgredida, SPC_maximoNivelAgresor_VN );
    int sujetoAgresorAssociateType = GetAssociateType( sujetoAgresor );
    if(
        sujetoAgresorAssociateType == ASSOCIATE_TYPE_NONE
        || (
            sujetoAgresorAssociateType == ASSOCIATE_TYPE_HENCHMAN
            && GetTag(sujetoAgresor) == Mercenario_ES_DE_TABERNA_TAG
        )
    ) {
        int nivelSujetoAgresor = GetHitDice( sujetoAgresor );
        if( nivelSujetoAgresor > maximoNivelAgresor ) {
            maximoNivelAgresor = nivelSujetoAgresor;
            SetLocalInt( criaturaAgredida, SPC_maximoNivelAgresor_VN, maximoNivelAgresor );
        }
    }

    // Determina el equipo que realizo el danio
    object liderEquipoAgresor = GetFactionLeader( sujetoAgresor );

    // Si el equipo no es de PCs, saltear premios.
    if( !GetIsPC( liderEquipoAgresor ) )
        return;

//    SendMessageToPC( sujetoAgresor, "Premio_onCriaturaAfligida: 4" );

    // Actualiza el danio realizado a la criatura correspondiente al equipo que hizo el danio que disparo la llamada a este handler
    string danioAcumuladoCorrespondienteAEsteEquipoAds = GetName( liderEquipoAgresor, TRUE ) + SPC_danioAcumulado_FIELD;
    int danioAcumuladoCorrespondienteAEsteEquipo = GetLocalInt( criaturaAgredida, danioAcumuladoCorrespondienteAEsteEquipoAds ) + danioRealizado;
    SetLocalInt( criaturaAgredida, danioAcumuladoCorrespondienteAEsteEquipoAds, danioAcumuladoCorrespondienteAEsteEquipo );

    // si este equipo no hizo danio, no recibe experiencia. Tampoco habra loot cosa que es injusta en ciertas condiciones poco probables.
    if( danioAcumuladoCorrespondienteAEsteEquipo == 0 )
        return;


    // Calculo del poder del party respecto a un sujeto de nivel igual al CR del encuentro.
    struct ResultadoPoderRelativoParty resultadoPoderRelativoParty = SisPremioCombate_poderRelativoParty( liderEquipoAgresor, nivelPremio );
    float poderRelativoParty = resultadoPoderRelativoParty.poderPersonajes + resultadoPoderRelativoParty.poderHenchmans;


    /* Estimacion del poder de este party relativo al poder total de todos los parties que combaten contra esta criatura.
    Esta estimacion parte de que la proporcion de danio realizada por los distintos parties es proporcional a sus poderes.*/
    float aporteEstimado = IntToFloat(danioAcumuladoCorrespondienteAEsteEquipo) / IntToFloat(danioTotalAcumulado);


    /* Una medida de la dificultad relativa que ofrece el encuentro a sus enemigos, es la relacion entre el poder total de las criaturas que forman el encuentro y el poder total de los parties que lo combaten.
    Como unidad de dificultad relativa se tomara al desafio que ofrece un encuentro de CR X hacia un grupo de cinco sujetos de nivel X.
    Usando poderes relativos al CR del encuentro, el poder relativo del grupo valdría cinco.
    Cuando hay mas de un party combatiendo a la criatura, la difucultad se reparte entre los parties ponderando con la relacion entre el poder del party y la suma de los poderes de todos los parties que colaboran.
    Para obtener el ponderador de esta party, en lugar de calcular el poder de todos los parties que colaboran (cosa que consume tiempo), se estima asumiendo que el poder de las parties es proporcional a la proporcion de danio que le hace cada party a la criatura (ver aporteEstimado mas arriba). */
    float dificultadRelativa = aporteEstimado * 5.0 / poderRelativoParty;
//    SendMessageToPC( GetFirstPC(), "dificultadRelativa grupal="+FloatToString(dificultadRelativa) );

    // Obtencion del factor premio del encuentro al que pertenece la criatura. En este factor estan las penas y bonos que modifican el premio.
    float factorPremioEncuentro = GetLocalFloat( criaturaAgredida, RS_factorPremioEncuentro_VN );

    // Aplicacion de la pena por asistencia externa
    if( maximoNivelAgresor > resultadoPoderRelativoParty.nivelMayor ) {
        float poderCombatienteMasPoderoso = SisPremioCombate_poderRelativoSujeto( maximoNivelAgresor, nivelPremio );
        factorPremioEncuentro *= SisPremioCombate_factorPenaSevera( poderRelativoParty / poderCombatienteMasPoderoso );
    }
//    SendMessageToPC( GetFirstPC(), "acum factores grupales="+FloatToString( factorPremioEncuentro ) );

    // El premio que recibe el party es proporcional a la dificultadRelativa, afectado por los bonos y penas.
    float premioNominal = dificultadRelativa * factorPremioEncuentro;

    // Darle a cada miembro la experiencia que se merece
    if( premioNominal > 0.0 && danioRealizado > 0 )
        SisPremioCombate_darExperienciaAMiembros(
            liderEquipoAgresor,
            criaturaAgredida,
            nivelPremio,
            premioNominal,
            GetLocalFloat( criaturaAgredida, RS_fraccionAporteEncuentro_LN ),
            danioRealizado,
            resultadoPoderRelativoParty.poderMedio
        );
}



// funcion privada usada por SisPremioCombate_onDeath
void SistemaPremioCombate_desvanecerCuerpo() {
    // Si pasado el lapzo de tiempo la criatura no fue devuelta a la vida, destruirla.
    if( GetIsDead( OBJECT_SELF ) ){

        // El siguiente if no es necesario. Sin embargo esta porque segun Zero hacerse esto, con el tiempo se alenta el servidor.
        if( GetHasInventory( OBJECT_SELF ) ) {
            TakeGoldFromCreature( GetGold(OBJECT_SELF), OBJECT_SELF, TRUE );
            object itemIterator = GetFirstItemInInventory(OBJECT_SELF);
            while( itemIterator != OBJECT_INVALID) {
                DestroyObject( itemIterator );
                itemIterator = GetNextItemInInventory(OBJECT_SELF);
            }
        }
        SetIsDestroyable(TRUE,TRUE,TRUE);
        DestroyObject(OBJECT_SELF);

//        AssignCommand( OBJECT_SELF, SistemaPremioCombate_autoDestruirse() );
    }
}


// Debe ser llamada desde el handler del evento Area_onEnter cuando el intruso es un PJ
void SisPremioCombate_onPjEnterArea( object sujeto );
void SisPremioCombate_onPjEnterArea( object sujeto ) {
    SetCampaignInt( "tempxp", "xp", GetLocalInt( sujeto, SPC_xpTransitoriaPorMil_VN ), sujeto );
}

// Debe ser llamada desde el handler del evento onModuleEnter cuando el intruso es un PJ
void SisPremioCombate_onPjEnterModule( object sujeto );
void SisPremioCombate_onPjEnterModule( object sujeto ) {
    SetLocalInt( sujeto, SPC_xpTransitoriaPorMil_VN, GetCampaignInt( "tempxp", "xp", sujeto ) );
}


// funcion privada usada solo por 'SisPremioCombate_onPcSuccessfullyRest(..)'
void SPC_mostrarExperienciaTransitoriaAcumulada( object sujeto ) {
    SendMessageToPC( sujeto, "Tu experiencia transitoria acumulada es "+IntToString(GetLocalInt(sujeto,SPC_xpTransitoriaPorMil_VN)/1000) );
}

// Debe ser llamada desde el handler el evento onPcSuccessfullyRest
void SisPremioCombate_onPcSuccessfullyRest( object sujeto );
void SisPremioCombate_onPcSuccessfullyRest( object sujeto ) {
    if( !GetIsPC( sujeto ) || GetIsDM( sujeto ) )
        return;

    int nivelSujeto = GetHitDice(sujeto);
    int xpSujeto = GetXP(sujeto);
    // si se tiene suficiente XP para subir de nivel (sin contar la XP transitoria), la xpTransitoria no se convierte en XP definitiva, pero se sigue acumulando.
    int tieneSuficienteXpParaPasarDeNivel =  ((nivelSujeto * (nivelSujeto + 1)) / 2 * 1000) <= xpSujeto;

    object area = GetArea(sujeto);

    // si se duerme en una mansion de Mordenkainen, se pierde el 6% de la experiencia transitoria acumulada
    if( GetTag( area ) == "MordenkainensMagnificentMansion" ) {
        SisPremioCombate_quitarPorcentajeXpTransitoria( sujeto, 6 );
        SendMessageToPC( sujeto, "Dormir dentro de una mansion de Mordenkainen resta un 6% a la experiencia transitoria acumulada desde el último descanso en sitio de asimilación de experiencia (poblado)." );
        SPC_mostrarExperienciaTransitoriaAcumulada(sujeto);
    }
    // si se duerme en un area poblada sin desafio
    else if( GetLocalInt( area, RS_crArea_PN ) == 0 ) {
        // si el area sin desafio es una carpa o taberna aislada, se pierde el 9% de la experiencia transitoria acumulada
        if( GetLocalInt( area, SPC_seAplicaPenaDescanso_PN ) ) {
            SisPremioCombate_quitarPorcentajeXpTransitoria( sujeto, 9 );
            SendMessageToPC( sujeto, "Dormir dentro de una carpa o taberna aislada resta un 9% a la experiencia transitoria acumulada desde el último descanso en sitio de asimilación de experiencia (poblado)." );
            SPC_mostrarExperienciaTransitoriaAcumulada(sujeto);
        }
        // si es un poblado amigable
        else {
            // si se tiene suficiente XP para subir de nivel (sin contar la XP transitoria), la xpTransitoria no se convierte en XP definitiva, pero se sigue acumulando.
            if( tieneSuficienteXpParaPasarDeNivel ) {
                SendMessageToPC( sujeto, "No puedes ganar mas XP hasta que subas de nivel." );
                SetCampaignInt( "tempxp", "xp", GetLocalInt( sujeto, SPC_xpTransitoriaPorMil_VN ), sujeto );
                SPC_mostrarExperienciaTransitoriaAcumulada(sujeto);
            }
            // si el 'sujeto' no tiene suficiente XP para subir de nivel (sin contar la XP transitoria), convertir la xpTransitoria a persistente.
            else {
                int xpTransitoriaAntes = GetLocalInt( sujeto, SPC_xpTransitoriaPorMil_VN )/1000;
                SisPremioCombate_quitarPorcentajeXpTransitoria( sujeto, 100 );
                Experience_dar( sujeto, xpTransitoriaAntes );
            }
        }
    }
    // si se duerme en cualquier otro lado, solo se refresca el valor de la experiencia transitoria en la DB.
    // los druidas convieren 15% de su XP transitoria en persistente
    else {
        int nivelesDeDruida = GetLevelByClass( CLASS_TYPE_DRUID, sujeto );
        if( nivelesDeDruida > 0 && GetIsAreaNatural( GetArea(sujeto) ) ) {
            if( tieneSuficienteXpParaPasarDeNivel ) {
                SendMessageToPC( sujeto, "No puedes ganar mas XP hasta que subas de nivel." );
                SetCampaignInt( "tempxp", "xp", GetLocalInt( sujeto, SPC_xpTransitoriaPorMil_VN ), sujeto );
            } else {
                int xpTransitoriaAntesX1000 = GetLocalInt( sujeto, SPC_xpTransitoriaPorMil_VN );
                int porcentajeConvertido = (15 * nivelesDeDruida) / nivelSujeto;
                int xpTransitoriaDespuesX1000 = SisPremioCombate_quitarPorcentajeXpTransitoria( sujeto, porcentajeConvertido );
                Experience_dar( sujeto, (xpTransitoriaAntesX1000 - xpTransitoriaDespuesX1000)/1000 );
                SPC_mostrarExperienciaTransitoriaAcumulada(sujeto);
            }
        } else {
            SPC_mostrarExperienciaTransitoriaAcumulada(sujeto);
        }
    }
}

