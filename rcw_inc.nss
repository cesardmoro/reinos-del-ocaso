/************************ Reputation Control Wand ******************************
Package: reputation control wand - include
Author: Inquisidor
*******************************************************************************/
#include "DM_inc"

/////////////////////////// constants /////////////////////////////////////////

const string RCW_item_RN = "rcw_item";
const string RCW_item_TAG = "RCW_item";
const string RCW_conversation_RN = "rcw_conversation";

const int RCW_WandState_setFirstTargetCreatureBeMutualFriendWithSecondTargetCreature_CN = 1;
const int RCW_WandState_setFirstTargetCreatureBeMutualEnemyWithSecondTargetCreature_CN = 2;
const int RCW_WandState_setFirstTargetFactionBeMutualFriendWithSecondTargetFaction_CN = 3;
const int RCW_WandState_setFirstTargetFactionBeMutualEnemyWithSecondTargetFaction_CN = 4;
const int RCW_WandState_setFirstTargetFactionBeMutualFriendWithSecondTargetCreature_CN = 5;
const int RCW_WandState_setFirstTargetFactionBeMutualEnemyWithSecondTargetCreature_CN = 6;
const int RCW_WandState_add50ToFirstTargetFactionReputationTowardSecondTargetCreature_CN = 7;
const int RCW_WandState_substract50ToFirstTargetFactionReputationTowardSecondTargetCreature_CN = 8;
const int RCW_WandState_clearFirstTargetCreaturePersonalFeelingsTowardSecondTargetCreature_CN = 9;
const int RCW_WandState_clearFirstTargetFactionPersonalFeelingsTowardSecondTargetCreature_CN = 10;
const int RCW_WandState_clearFirstTargetFactionPersonalFeelingsTowardSecondTargetFaction_CN = 11;
const int RCW_WandState_lastStateThatRequiresTargetsBeOfDifferentFactions_CN = 19;
const int RCW_WandState_makeFirstTargetBeMasterOfSecondTarget_CN = 20;
//////////////////////////// wand variable names //////////////////////////////

const string RCW_targetObject_VN = "RCWto";
const string RCW_targetLocation_VN = "RCWtl";
const string RCW_wandState_VN = "RCWs";


void RCW_refreshTokens( object user );
void RCW_refreshTokens( object user ) {
    object targetObject = GetLocalObject(user, RCW_targetObject_VN);
    if( GetIsObjectValid( targetObject ) )
        SetCustomToken( 5800, GetName( targetObject ) );
    else {
        location targetLocation = GetLocalLocation(user, RCW_targetLocation_VN);
        SetCustomToken( 5800, GetName( GetAreaFromLocation(targetLocation) ) );
    }
}

// Hace que todas las criaturas en el 'area' muestren sobre su cabeza la reputacion hacia 'target'.
void RCW_showReputationOfTargetAgainstAllCreaturesInArea( object target, object area );
void RCW_showReputationOfTargetAgainstAllCreaturesInArea( object target, object area ) {
    object objectIterator = GetFirstObjectInArea( area );
    while( objectIterator != OBJECT_INVALID ) {
        if( GetObjectType( objectIterator ) == OBJECT_TYPE_CREATURE ) {
            string message;
            if( objectIterator == target )
                message = "Target";
            else if( GetFactionEqual( objectIterator, target ) )
                message = "same faction";
            else {
                int targetTowardOther = GetReputation( target, objectIterator );
                int otherTowardTarget = GetReputation( objectIterator, target );
                if( targetTowardOther == otherTowardTarget )
                    message = IntToString( targetTowardOther );
                else
                    message = "T->X "+IntToString( targetTowardOther ) + "\nT<-X "+ IntToString( otherTowardTarget );
            }
            AssignCommand( objectIterator, SpeakString( message ) );
        }
        objectIterator = GetNextObjectInArea( area );
    }
}


void RCW_cancelAllActionOfFactionInArea( object affectedArea, object factionMember );
void RCW_cancelAllActionOfFactionInArea( object affectedArea, object factionMember ) {
    object objectIterator = GetFirstObjectInArea( affectedArea );
    while( objectIterator != OBJECT_INVALID ) {
        if( GetObjectType( objectIterator ) == OBJECT_TYPE_CREATURE && GetFactionEqual( objectIterator, factionMember ) )
            AssignCommand( objectIterator, ClearAllActions( TRUE ) );
        objectIterator = GetNextObjectInArea( affectedArea );
    }
}

void RCW_setMembersOfFactionInAreaBeFriendsWithCreature( object area, object factionMember, object creature );
void RCW_setMembersOfFactionInAreaBeFriendsWithCreature( object area, object factionMember, object creature ) {
    object affectedArea = GetArea( factionMember );
    object objectIterator = GetFirstObjectInArea( affectedArea );
    while( objectIterator != OBJECT_INVALID ) {
        if( GetObjectType( objectIterator ) == OBJECT_TYPE_CREATURE && GetFactionEqual( objectIterator, factionMember ) ) {
            if( !GetIsPC( objectIterator ) ) {
                SetIsTemporaryFriend( creature, objectIterator );
                AssignCommand( objectIterator, ClearAllActions( TRUE ) );
            }
            if( !GetIsPC( creature ) )
                SetIsTemporaryFriend( objectIterator, creature );
        }
        objectIterator = GetNextObjectInArea( affectedArea );
    }
    if( !GetIsPC( creature ) )
        AssignCommand( creature, ClearAllActions( TRUE ) );
}


void RCW_setMembersOfFactionInAreaBeEnemiesWithCreature( object area, object factionMember, object creature );
void RCW_setMembersOfFactionInAreaBeEnemiesWithCreature( object area, object factionMember, object creature ) {
    object affectedArea = GetArea( factionMember );
    object objectIterator = GetFirstObjectInArea( affectedArea );
    while( objectIterator != OBJECT_INVALID ) {
        if( GetObjectType( objectIterator ) == OBJECT_TYPE_CREATURE && GetFactionEqual( objectIterator, factionMember ) ) {
            if( !GetIsPC( objectIterator ) ) {
                SetIsTemporaryEnemy( creature, objectIterator );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectBlindness(), objectIterator, 10.0 ); // esto es para que se dispare algún evento del NPC que inicie el ataque, pero parece que no funca.
            }
            if( !GetIsPC( creature ) )
                SetIsTemporaryEnemy( objectIterator, creature );
        }
        objectIterator = GetNextObjectInArea( affectedArea );
    }
    if( !GetIsPC(creature) )
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectBlindness(), creature, 10.0 );// esto es para que se dispare algún evento del NPC que inicie el ataque, pero parece que no funca.
}


// se asume que 'factionMember' es un NPC
void RCW_clearPersonalFeelingsOfFactionInAreaTowardCreature( object area, object factionMember, object creature );
void RCW_clearPersonalFeelingsOfFactionInAreaTowardCreature( object area, object factionMember, object creature ) {
    object affectedArea = GetArea( factionMember );
    object objectIterator = GetFirstObjectInArea( affectedArea );
    while( objectIterator != OBJECT_INVALID ) {
        if( GetObjectType( objectIterator ) == OBJECT_TYPE_CREATURE && GetFactionEqual( objectIterator, factionMember ) ) {
            ClearPersonalReputation( creature, objectIterator );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectBlindness(), objectIterator, 10.0 ); // esto es para que se dispare algún evento del NPC que inicie el ataque, pero parece que no funca.
            AssignCommand( objectIterator, ClearAllActions( TRUE ) );
        }
        objectIterator = GetNextObjectInArea( affectedArea );
    }
    if( !GetIsPC(creature) ) {
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectBlindness(), creature, 10.0 );// esto es para que se dispare algún evento del NPC que inicie el ataque, pero parece que no funca.
        AssignCommand( creature, ClearAllActions( TRUE ) );
    }
}


void RCW_onActivated( object wand, object activator, object targetObject, location targetLocation );
void RCW_onActivated( object wand, object activator, object targetObject, location targetLocation ) {
//    SendMessageToPC( GetFirstPC(), "RCW_onWandActivated: activator="+GetName(activator)+", targetName="+GetName(targetObject) );
    int wandState = GetLocalInt( activator, RCW_wandState_VN );
    if( wandState == 0 && GetIsAllowedDM( activator ) ) {
        SetLocalObject( activator, RCW_targetObject_VN, targetObject );
        SetLocalLocation( activator, RCW_targetLocation_VN, targetLocation );
        AssignCommand( activator, ActionStartConversation( activator, RCW_conversation_RN, TRUE, FALSE ) );
    }
    else {
        object previousTargetObject = GetLocalObject( activator, RCW_targetObject_VN );
        location previousTargetLocation = GetLocalLocation( activator, RCW_targetLocation_VN );
        if( GetObjectType( targetObject ) != OBJECT_TYPE_CREATURE )
            SendMessageToPC( activator, "The second target should be a creature. Operation canceled." );
        else if( GetObjectType(targetObject) != OBJECT_TYPE_CREATURE )
            SendMessageToPC( activator, "The first target should be a creature. Operation canceled." );
        if( wandState < RCW_WandState_lastStateThatRequiresTargetsBeOfDifferentFactions_CN && GetFactionEqual( previousTargetObject, targetObject ) )
            SendMessageToPC( activator, "The first and second target should be of different factions. Operation canceled." );
        else switch( wandState ) {

            case RCW_WandState_setFirstTargetCreatureBeMutualFriendWithSecondTargetCreature_CN:
                if( !GetIsPC( targetObject ) ) {
                    SetIsTemporaryFriend( previousTargetObject, targetObject );
                    AssignCommand( targetObject, ClearAllActions( TRUE ) );
                }
                if( !GetIsPC( previousTargetObject ) ) {
                    SetIsTemporaryFriend( targetObject, previousTargetObject );
                    AssignCommand( previousTargetObject, ClearAllActions( TRUE ) );
                }
                //RCW_showReputationOfTargetAgainstAllCreaturesInArea( targetObject, GetArea( activator ) );
                break;


            case RCW_WandState_setFirstTargetCreatureBeMutualEnemyWithSecondTargetCreature_CN:
                if( !GetIsPC( targetObject ) ) {
                    SetIsTemporaryEnemy( previousTargetObject, targetObject );
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectBlindness(), targetObject, 10.0 );
                }
                if( !GetIsPC( previousTargetObject ) ) {
                    SetIsTemporaryEnemy( targetObject, previousTargetObject );
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectBlindness(), previousTargetObject, 10.0 );
                }
                //RCW_showReputationOfTargetAgainstAllCreaturesInArea( targetObject, GetArea( activator ) );
                break;


            case RCW_WandState_setFirstTargetFactionBeMutualFriendWithSecondTargetFaction_CN: {
                object affectedArea = GetArea( previousTargetObject );
                object objectIterator = GetFirstObjectInArea( affectedArea );
                while( objectIterator != OBJECT_INVALID ) {
                    if( GetObjectType( objectIterator ) == OBJECT_TYPE_CREATURE && GetFactionEqual( objectIterator, targetObject ) ) {
                        AssignCommand( objectIterator, RCW_setMembersOfFactionInAreaBeFriendsWithCreature( affectedArea, previousTargetObject, objectIterator ) );
                    }
                    objectIterator = GetNextObjectInArea( affectedArea );
                }
                break; }


            case RCW_WandState_setFirstTargetFactionBeMutualEnemyWithSecondTargetFaction_CN: {
                object affectedArea = GetArea( previousTargetObject );
                object objectIterator = GetFirstObjectInArea( affectedArea );
                while( objectIterator != OBJECT_INVALID ) {
                    if( GetObjectType( objectIterator ) == OBJECT_TYPE_CREATURE && GetFactionEqual( objectIterator, targetObject ) ) {
                        AssignCommand( objectIterator, RCW_setMembersOfFactionInAreaBeEnemiesWithCreature( affectedArea, previousTargetObject, objectIterator ) );
                    }
                    objectIterator = GetNextObjectInArea( affectedArea );
                }
                break; }


            case RCW_WandState_setFirstTargetFactionBeMutualFriendWithSecondTargetCreature_CN:
                RCW_setMembersOfFactionInAreaBeFriendsWithCreature( GetArea( previousTargetObject ), previousTargetObject, targetObject );
                //RCW_showReputationOfTargetAgainstAllCreaturesInArea( targetObject, GetArea( activator ) );
                break;


            case RCW_WandState_setFirstTargetFactionBeMutualEnemyWithSecondTargetCreature_CN:
                RCW_setMembersOfFactionInAreaBeEnemiesWithCreature( GetArea(previousTargetObject), previousTargetObject, targetObject );
                //RCW_showReputationOfTargetAgainstAllCreaturesInArea( targetObject, GetArea( activator ) );
                break;


            case RCW_WandState_add50ToFirstTargetFactionReputationTowardSecondTargetCreature_CN:
                AdjustReputation( targetObject, previousTargetObject, GetReputation( previousTargetObject, targetObject ) - GetReputation( targetObject, previousTargetObject ) + 50 ); // AdjustReputation() no hace lo que dice la descripcion. En lugar de sumar nAdjustment a la reputacion de oSourceFaction hacia oTarget, hace que la reputacion de oSourceFaction hacia target sea igual a la reputacion que target tiene hacia oSourceFaction mas nAdjustment.
                RCW_cancelAllActionOfFactionInArea( GetArea( targetObject ), previousTargetObject );
                //RCW_showReputationOfTargetAgainstAllCreaturesInArea( targetObject, GetArea( activator ) );
                break;


            case RCW_WandState_substract50ToFirstTargetFactionReputationTowardSecondTargetCreature_CN:
                AdjustReputation( targetObject, previousTargetObject, GetReputation( previousTargetObject, targetObject ) - GetReputation( targetObject, previousTargetObject ) - 50 ); // AdjustReputation() no hace lo que dice la descripcion. En lugar de sumar nAdjustment a la reputacion de oSourceFaction hacia oTarget, hace que la reputacion de oSourceFaction hacia target sea igual a la reputacion que target tiene hacia oSourceFaction mas nAdjustment.
                //RCW_showReputationOfTargetAgainstAllCreaturesInArea( targetObject, GetArea( activator ) );
                break;


            case RCW_WandState_clearFirstTargetCreaturePersonalFeelingsTowardSecondTargetCreature_CN:
                ClearPersonalReputation( targetObject, previousTargetObject );
                //RCW_showReputationOfTargetAgainstAllCreaturesInArea( targetObject, GetArea( activator ) );
                break;

            case RCW_WandState_clearFirstTargetFactionPersonalFeelingsTowardSecondTargetCreature_CN:
                RCW_clearPersonalFeelingsOfFactionInAreaTowardCreature( GetArea(previousTargetObject), previousTargetObject, targetObject );
                //RCW_showReputationOfTargetAgainstAllCreaturesInArea( targetObject, GetArea( activator ) );
                break;

            case RCW_WandState_clearFirstTargetFactionPersonalFeelingsTowardSecondTargetFaction_CN: {
                object affectedArea = GetArea( previousTargetObject );
                object objectIterator = GetFirstObjectInArea( affectedArea );
                while( objectIterator != OBJECT_INVALID ) {
                    if( GetObjectType( objectIterator ) == OBJECT_TYPE_CREATURE && GetFactionEqual( objectIterator, targetObject ) ) {
                        AssignCommand( objectIterator, RCW_clearPersonalFeelingsOfFactionInAreaTowardCreature( affectedArea, previousTargetObject, objectIterator ) );
                    }
                    objectIterator = GetNextObjectInArea( affectedArea );
                }
                break; }

            case RCW_WandState_makeFirstTargetBeMasterOfSecondTarget_CN:
                if( GetIsPC( targetObject ) )
                    SendMessageToPC( activator, "The second target can't be a PC. Operation canceled." );
                object master = GetMaster( targetObject );
                if( GetIsObjectValid( master ) )
                    SendMessageToPC( activator, "The second target already has a master: " + GetName( master ) +". Operation canceled." );
                else {
                    SetLocalInt( targetObject, "merc", TRUE );
                    AddHenchman( previousTargetObject, targetObject );
                }
                break;

        }
        DeleteLocalInt( activator, RCW_wandState_VN );
        DeleteLocalObject( activator, RCW_targetObject_VN );
        DeleteLocalLocation( activator, RCW_targetLocation_VN );
    }

}



