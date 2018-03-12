/*********************** SPC creature onDeath handler **************************
Package: Sistema Premio Combate
Author: Inquisidor
Descripcion: Encargado de determinar que y cuanto premio dar por vencer a esta criatura
Esto incluye el loot y la XP.
*******************************************************************************/
#include "SPC_inc"
#include "RTG_inc"

// Funcion que se debe llamar desde el onDeath handler de las criaturas que den experiencia.
void SisPremioCombate_onDeath( object sujetoAgresor );
void SisPremioCombate_onDeath( object sujetoAgresor ) {
    object criaturaAgredida = OBJECT_SELF;

    // si la criatura no corresponde a un encuentro que da experiencia, saltear todo
    int nivelPremio = GetLocalInt( criaturaAgredida, RS_nivelPremio_LN );
    if( nivelPremio <= 0 )
        return;

//    SendMessageToPC( sujetoAgresor, "Premio_onCriaturaAfligida: 1" );

    int danioTotalAcumulado = GetMaxHitPoints( criaturaAgredida ); // este es todo el danio que le fue hecho a la criatura (con maximo en MaxHitPoints).
    int danioRealizado =  danioTotalAcumulado - GetLocalInt( criaturaAgredida, SPC_danioTotalAcumulado_VN ); // este es el danio que faltaba hacer a la criatura para llegar a MaxHitPoints.

//    SendMessageToPC( sujetoAgresor, "Premio_onCriaturaAfligida: 2" );

    // si no hay agresor, no hay a quien darle premio, asi que saltear todo lo referente al premio, tanto de experiencia como de loot.
    if( GetIsObjectValid( sujetoAgresor ) ) {

//        SendMessageToPC( sujetoAgresor, "Premio_onCriaturaAfligida: 3" );

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
                   // la linea que el onDamage tiene acá no es necesaria en el onDeath
            }
        }

        // Determina el equipo que realizo el danio
        object liderEquipoAgresor = GetFactionLeader( sujetoAgresor );

        // Si el equipo no es de PCs, saltear premios.
        if( GetIsPC( liderEquipoAgresor ) ) {
//            SendMessageToPC( sujetoAgresor, "Premio_onCriaturaAfligida: 4" );

            // Actualiza el danio realizado a la criatura correspondiente al equipo que hizo el danio que disparo la llamada a este handler
            string danioAcumuladoCorrespondienteAEsteEquipoAds = GetName( liderEquipoAgresor, TRUE ) + SPC_danioAcumulado_FIELD;
            int danioAcumuladoCorrespondienteAEsteEquipo = GetLocalInt( criaturaAgredida, danioAcumuladoCorrespondienteAEsteEquipoAds ) + danioRealizado;
                // la linea que el onDamage tiene acá no es necesaria en el onDeath


            // si este equipo no hizo danio, no recibe experiencia. Tampoco habra loot cosa que es injusta en ciertas condiciones poco probables.
            if( danioAcumuladoCorrespondienteAEsteEquipo != 0 ) {

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
//                SendMessageToPC( GetFirstPC(), "dificultadRelativa grupal="+FloatToString(dificultadRelativa) );

                // Obtencion del factor premio del encuentro al que pertenece la criatura. En este factor estan las penas y bonos que modifican el premio.
                float factorPremioEncuentro = GetLocalFloat( criaturaAgredida, RS_factorPremioEncuentro_VN );

                // Aplicacion de la pena por asistencia externa
                if( maximoNivelAgresor > resultadoPoderRelativoParty.nivelMayor ) {
                    float poderCombatienteMasPoderoso = SisPremioCombate_poderRelativoSujeto( maximoNivelAgresor, nivelPremio );
                    factorPremioEncuentro *= SisPremioCombate_factorPenaSevera( poderRelativoParty / poderCombatienteMasPoderoso );
                }
//                SendMessageToPC( GetFirstPC(), "acum factores grupales="+FloatToString( factorPremioEncuentro ) );

                // El premio que recibe el party es proporcional a la dificultadRelativa, afectado por los bonos y penas.
                float premioNominal = dificultadRelativa * factorPremioEncuentro;
                if( premioNominal > 0.0 ) {

                    float factorAporteEncuentro = GetLocalFloat( criaturaAgredida, RS_fraccionAporteEncuentro_LN );

                    // Darle a cada miembro la experiencia que se merece
                    float premioTotal = SisPremioCombate_darExperienciaAMiembros(
                        liderEquipoAgresor,
                        criaturaAgredida,
                        nivelPremio,
                        premioNominal,
                        factorAporteEncuentro,
                        danioRealizado,
                        resultadoPoderRelativoParty.poderMedio,
                        TRUE
                    );
                    SetLocalFloat( OBJECT_SELF, SPC_premioGanadoTotal_VN, premioTotal );

                    SPC_Creature_onDeathFastHandlers( premioTotal );

                //    SendMessageToPC( GetFirstPC(), "dificultadRelativa="+FloatToString(dificultadRelativa)+", acumuladorFactores="+FloatToString( factorPremioEncuentro ) );
                    ///////////////////////// LOOT ////////////////////////////
                //    SendMessageToPC( GetFirstPC(), "d="+IntToString(FloatToInt(100.0*dificultadRelativa)), "f="+IntToString(FloatToInt(100.0*factorPremioEncuentro)), "c="+IntToString(FloatToInt(200.0*premioTotal)) );

                    if( GetLocalInt( OBJECT_SELF, RS_esUltimoRefuerzo_VN ) )
                        premioTotal *= 5;

                    // generar el tesoro
                    int reporte = RTG_determineLoot( OBJECT_SELF, Random_generateLevel( nivelPremio ), premioTotal, sujetoAgresor, 100.0 );

                    // si se generó algo de tesoro y el destino del tesoro es el mismo cuerpo de la criatura, hacer que no se desvanezca hasta pasado cierto tiempo.
                    if( (reporte&1)!=0 ) {
                        SetIsDestroyable( FALSE, TRUE, TRUE );
                        DelayCommand( 120.0, SistemaPremioCombate_desvanecerCuerpo() );
                    }
                }//if( premioNominal > 0.0 )
            }//if( danioAcumuladoCorrespondienteAEsteEquipo != 0 )
        }//if( GetIsPC( liderEquipoAgresor ) )
    }//if( GetIsObjectValid( sujetoAgresor ) )

    // ejecutar todos los handlers que se subscribieron al evento onCreatureDeath
    RL_fire( GetLocalString( OBJECT_SELF, RS_onDeathHL_LN ), OBJECT_SELF );
}



