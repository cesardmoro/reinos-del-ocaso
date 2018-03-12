/****************************** Dinamic Action schedule ************************
Author: Inquisidor
*******************************************************************************/
#include "RS_itf"

const string DA_targetTag_PN = "DAtt"; // [string=""] tag of the object to which the action 1 will be applied.
const string DA_actionCode_PN = "DAac"; // [int] code of the action that will be applied to the object whose tag is 'target1Tag'
const string DA_actionDelay_PN = "DAad"; // [float=0] delay of the action 1
const string DA_conditionVar_PN = "DAcv"; // [string] name of the area variable which holds a boolean value that determines if the action is performed or not.
const string DA_paramIntX_PN = "DApiX"; // [int] integer parameter X
const string DA_paramStringX_PN = "DApsX"; // [string] string parameter X
const string DA_paramFloatX_PN = "DApfX"; // [float] float parameter X
const string DA_paramIntY_PN = "DApiY"; // [int] integer parameter Y
const string DA_paramStringY_PN = "DApsY"; // [string] string parameter Y


object DA_findObjectByTag( object area, string tag );
object findObjectByTag( object area, string tag ) {
    object iteratedObject = GetFirstObjectInArea( area );
    while( iteratedObject != OBJECT_INVALID ) {
        if( GetTag( iteratedObject ) == tag )
            return iteratedObject;
        iteratedObject = GetNextObjectInArea( area );
    }
    return OBJECT_INVALID;
}


void DA_perform( object user, object target, int actionCode, int condition, int paramIntX, string paramStringX, float paramFloatX, int paramIntY, string paramStringY );
void DA_perform( object user, object target, int actionCode, int condition, int paramIntX, string paramStringX, float paramFloatX, int paramIntY, string paramStringY ) {
    object usedObject = OBJECT_SELF;
    object area = GetArea(usedObject);
    switch( actionCode ) {
        case 1:
            SetLocalInt( target, paramStringX, paramIntX );
            break;

        case 10:
            if( condition && !GetIsOpen(target) ) {
                ActionOpenDoor(target);
                PlaySound(paramStringX);
            }
            break;

        case 11:
            if( condition && GetIsOpen(target) ) {
                ActionCloseDoor(target);
                PlaySound(paramStringX);
            }
            break;

        case 20:
            if( condition )
                ActionCastSpellAtObject( paramIntX, user, METAMAGIC_NONE, TRUE, GetLocalInt( area, RS_crArea_PN ), PROJECTILE_PATH_TYPE_DEFAULT, TRUE );
            break;

        case 30:
            if( condition ) {
                object placeable = CreateObject( OBJECT_TYPE_PLACEABLE, paramStringX, GetLocation(target), paramIntX, paramStringY );
                SetLocalObject( usedObject, paramStringY, placeable );
            }
            break;
        case 31:
            if( condition ) {
                object item = CreateItemOnObject( paramStringX, target, paramIntX, paramStringY );
                SetLocalObject( usedObject, paramStringY, item );
            }
            break;
        case 38:
            if( condition ) {
                DestroyObject( target, paramFloatX );
            }
            break;
        case 39:
            if( condition ) {
                DestroyObject( GetLocalObject( target, paramStringX ), paramFloatX );
            }
            break;

    }
}


void DA_schedule( object user, string index );
void DA_schedule( object user, string index ) {
    object usedObject = OBJECT_SELF;
    object area = GetArea(usedObject);
    object target = findObjectByTag( area, GetLocalString( usedObject, DA_targetTag_PN + index ) );
    if( target != OBJECT_INVALID ) {
        int actionCode = GetLocalInt( usedObject, DA_actionCode_PN + index );
        string conditionVar = GetLocalString( usedObject, DA_conditionVar_PN );
        int condition = conditionVar == "" || GetLocalInt( area, conditionVar );
        int paramIntX = GetLocalInt( usedObject, DA_paramIntX_PN + index );
        string paramStringX = GetLocalString( usedObject, DA_paramStringX_PN + index );
        float paramFloatX = GetLocalFloat( usedObject, DA_paramFloatX_PN + index );
        int paramIntY = GetLocalInt( usedObject, DA_paramIntY_PN + index );
        string paramStringY = GetLocalString( usedObject, DA_paramStringY_PN + index );

        float actionDelay = GetLocalFloat( usedObject, DA_actionDelay_PN + index );
        if( actionDelay == 0.0 )
            DA_perform( user, target, actionCode, condition, paramIntX, paramStringX, paramFloatX, paramIntY, paramStringY );
        else
            DelayCommand( actionDelay, DA_perform( user, target, actionCode, condition, paramIntX, paramStringX, paramFloatX, paramIntY, paramStringY ) );
    }
}


void main() {
    object area = GetArea(OBJECT_SELF);
    object user = GetLastUsedBy();

    DA_schedule( user, "1" );
    DA_schedule( user, "2" );
    DA_schedule( user, "3" );
    DA_schedule( user, "4" );
    DA_schedule( user, "5" );
}
