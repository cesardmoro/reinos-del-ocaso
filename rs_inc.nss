/******************************************************************************
Package: RandomSpawn - include (very coupled)
Author: Inquisidor
Version: 0.1
Descripcon: nombres de variables locales usadas por el RandomSpawn
*******************************************************************************/
#include "NPC_inc"
#include "Mercenario_Itf"
#include "IPS_basic_inc"
#include "RS_itf"


// Debe ser llamada desde el handler del evento onSuccessfullyRest
// Lo que hace es borrar la lista de tipos de spawns que estan hostiles hacia el sujeto.
void RS_onPcSuccessfullyRest( object sujeto );
void RS_onPcSuccessfullyRest( object sujeto ) {
    // si se duerme en un area segura, convertir la experiencia transitoria en persistente
    if( GetLocalInt( GetArea( sujeto ), RS_crArea_PN ) == 0 ) {
        // borrar los tipos de spawn hostiles hacia el PJ
        DeleteLocalString( sujeto, "RStsh" );
    }
}


// Debe ser llamado desde el onDeath handler de las criaturas generadas por el sistema de Random Spawn.
void RS_creatureOnDeath( object partyDescriptor );
void RS_creatureOnDeath( object partyDescriptor ) {
    object lider = GetFactionLeader( partyDescriptor );
    if( GetIsPC( lider ) && !GetIsDM( lider )  ) {
        string tipoSpawnCriatura = GetLocalString( OBJECT_SELF, RS_tipoSpawn_VN );
        if( tipoSpawnCriatura != "" ) {

            // marcar a todos los miembros del party que mato a la criatura como hostiles desde las criaturas generadas por spawn del mismo tipo que el que genero a la criatura asesinada.
            object memberIterator = GetFirstFactionMember( partyDescriptor, TRUE );
            while( memberIterator != OBJECT_INVALID ) {
                string tiposSpawnHostiles = GetLocalString( memberIterator, RS_tiposSpawnHostiles_VN );
                if( FindSubString( tiposSpawnHostiles, tipoSpawnCriatura ) == -1 )
                    SetLocalString( memberIterator, RS_tiposSpawnHostiles_VN, tiposSpawnHostiles + "," + tipoSpawnCriatura );
                memberIterator = GetNextFactionMember( partyDescriptor, TRUE );
            }

            // si la criatura asesinada corresponde a un spawn del mismo tipo que el del area donde muere, hacer hostil el area.
            object area = GetArea(OBJECT_SELF);
            if( tipoSpawnCriatura == RS_getTipoSpawn( area ) )
                SetLocalInt( area, RS_estado_VN, RS_Estado_HOSTIL );
        }
    }
}


// Funcion que debe ser llamada desde el hearbeat de las criaturas que se vayan a usar para el RandomSpawn.
// Se encarga de eliminar las criaturas que permanecen inactivas (fuera de combate) por mas de 8 minutos.
void RS_onHeartbeat();
void RS_onHeartbeat() {
    if( GetTag( OBJECT_SELF ) == RS_CRIATURA_TAG && !GetLocalInt( OBJECT_SELF, RS_isCleanExempt_VN) ) {
        if( GetIsInCombat() ) {
            if( GetLocalInt( OBJECT_SELF, RS_temporizadorInactividad_LN ) < 100 )
                SetLocalInt( OBJECT_SELF, RS_temporizadorInactividad_LN, 100 );
        } else {
            int temporizadorIncatividad = GetLocalInt( OBJECT_SELF, RS_temporizadorInactividad_LN ) - 1;
            SetLocalInt( OBJECT_SELF, RS_temporizadorInactividad_LN, temporizadorIncatividad );
            if( temporizadorIncatividad == 0 ) {

//                NPC_destruirTodosLosItemsEquipados( OBJECT_SELF );
//                NPC_destruirTodosLosItemsContenidos( OBJECT_SELF );
                SetIsDestroyable( TRUE, FALSE, FALSE ); // no hace falta porque se hace en RS_marcarCriatura(), pero por las dudas
                SetPlotFlag( OBJECT_SELF, FALSE );
                SetImmortal( OBJECT_SELF, FALSE );
                SetLootable( OBJECT_SELF, FALSE );
                DestroyObject( OBJECT_SELF );
            }
        }
    }
}


// Pone al area en estado RS_Estado_PASIVO y la limpia de todos los restos que hayan quedado producto del RandomSpawn.
void RS_Area_clean( object area );
void RS_Area_clean( object area ) {
//    SendMessageToPC( GetFirstPC(), "clean: begin for "+GetTag(OBJECT_SELF) );

    // if this area is already in the RS_Estado_PASIVO state, do nothing.
    if( GetLocalInt( area, RS_estado_VN ) == RS_Estado_PASIVO )
        return;

    SetLocalInt( area, RS_estado_VN, RS_Estado_PASIVO );
    DeleteLocalInt( area, RS_numeroEncuentroSucesivo_VN );


    // Destruir todas las criaturas generadas por el RandomSpawm que haya en el area, esten vivas o muertas.
    object objectIterator = GetFirstObjectInArea(area);
    while( objectIterator != OBJECT_INVALID) {
//        if( GetObjectType(objectIterator) == OBJECT_TYPE_CREATURE && RS_isRandomSpawn( objectIterator ) )
//            DestroyObject( objectIterator, 1.0 );    // se destruye recien cuando termina de correr el handler
        switch( GetObjectType(objectIterator) ) {

            case OBJECT_TYPE_CREATURE:
                // destruir cualquier criatura muerta
                if( GetIsDead( objectIterator ) )
                    AssignCommand( objectIterator, NPC_destruirse() );
                // si no esta muerta solo destruirla si fue generara por el random spawn, es un cuerpo de PJ, o es un mercenario.
                else if(
                    (
                        GetTag( objectIterator ) == RS_CRIATURA_TAG || // Tag que tienen todas las criaturas generadas por el RandomSpawn
                        GetTag( objectIterator ) == "cuerpoPj" ||
                        GetTag( objectIterator ) == Mercenario_ES_DE_TABERNA_TAG // Tag que tienen los mercenarios generados en las tabernas.
                    ) && !GetLocalInt( objectIterator, RS_isCleanExempt_VN )
                ) {
                    SetLootable( objectIterator, FALSE );
                    AssignCommand( objectIterator, NPC_destruirse() );
                }
                break;

            case OBJECT_TYPE_PLACEABLE:
                if( GetTag( objectIterator ) == "BodyBag" || GetResRef( objectIterator ) == "cofre" ) { // "cofre" es el nombre del ResRef del cofre que esta en Custom/Treasure/?  Ojo, no es el mismo ResRef que el de los cofres generados por SPC_Cofre
                    NPC_destruirTodosLosItemsContenidos( objectIterator );
                    DestroyObject( objectIterator );
                }
                break;

            case OBJECT_TYPE_ITEM:
                if(
                    IPS_Item_getIsAdept( objectIterator )
                    || GetTag( objectIterator ) == Tesoro_ITEM_TAG
                )
                    DestroyObject( objectIterator );
                break;
        }
        objectIterator = GetNextObjectInArea(area);
    }
//    SendMessageToPC( GetFirstPC(), "clean: end for "+GetTag(OBJECT_SELF) );
}

