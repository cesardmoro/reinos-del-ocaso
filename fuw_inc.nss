/************************ Freeze/Unfreeze Wand *********************************
Package: Freeze/Unfreeze wand - include
Author: Inquisidor
*******************************************************************************/
#include "DM_inc"
#include "RS_itf"

/////////////////////////// constants //////////////////////////////////////////

const int FUW_NPC_SET = 1;
const int FUW_PC_SET = 2;
const int FUW_ALL_SET = 3;

const string FUW_freeze_RN = "fuw_freeze";
const string FUW_freeze_TAG = "FUW_freeze";
const string FUW_unfreeze_RN = "fuw_unfreeze";
const string FUW_unfreeze_TAG = "FUW_unfreeze";
const string FUW_freezeEffectHolder_TAG = "FUW_freezeEffectHolder";

//////////////////////////// module variable names /////////////////////////////

const string FUW_freezeEffectHolder_VN = "FUWfeh"; // [object]


//////////////////////////// operations ////////////////////////////////////////


int FUW_hasEffect( object creature, effect searchedEffect );
int FUW_hasEffect( object creature, effect searchedEffect ) {
    effect effectIterator = GetFirstEffect( creature );
    while( GetIsEffectValid(effectIterator) ) {
       if( effectIterator == searchedEffect )
             return TRUE;
       effectIterator = GetNextEffect(creature);
    }
    return FALSE;
}


struct FUW_FreezeEffect {
    effect first;
    effect second;
};

struct FUW_FreezeEffect FUW_getFreezeEffect();
struct FUW_FreezeEffect FUW_getFreezeEffect() {
    struct FUW_FreezeEffect freezeEffect;
    object freezeEffectHolder = GetLocalObject( GetModule(), FUW_freezeEffectHolder_VN );
    if( GetIsObjectValid( freezeEffectHolder ) ) {
        freezeEffect.first = GetFirstEffect( freezeEffectHolder );
        freezeEffect.second = GetNextEffect( freezeEffectHolder );
    }
    else {
        freezeEffectHolder = GetObjectByTag( FUW_freezeEffectHolder_TAG );
        SetLocalObject( GetModule(), FUW_freezeEffectHolder_VN, freezeEffectHolder );
        freezeEffect.first  = EffectCutsceneParalyze();
        freezeEffect.second = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, freezeEffect.first,  freezeEffectHolder );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, freezeEffect.second, freezeEffectHolder );
    }
    return freezeEffect;
}


void FUW_unfreezeCreature( object creature );
void FUW_unfreezeCreature( object creature ) {
    struct FUW_FreezeEffect freezeEffect = FUW_getFreezeEffect();
    RemoveEffect( creature, freezeEffect.first );
    RemoveEffect( creature, freezeEffect.second );
}

// Congela a todos los NPC en 'area'.
int FUW_freezeAllNpcsInArea( object area );
int FUW_freezeAllNpcsInArea( object area ) {
    struct FUW_FreezeEffect freezeEffect = FUW_getFreezeEffect();
    int counter = 0;
    object objectIterator = GetFirstObjectInArea( area );
    while( objectIterator != OBJECT_INVALID ) {
        if(
            GetObjectType( objectIterator ) == OBJECT_TYPE_CREATURE
            && !GetIsPC( objectIterator )
            && !FUW_hasEffect( objectIterator, freezeEffect.first )
        ) {
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, freezeEffect.first, objectIterator );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, freezeEffect.second, objectIterator );
            // hacer que las criaturas que fueron congeladas alguna vez no den premio
            SetLocalInt( objectIterator, RS_nivelPremio_LN, 1 );
            counter += 1;
        }
        objectIterator = GetNextObjectInArea( area );
    }
    return counter;
}


// Descongela a todos los NPCs en 'area'.
int FUW_unfreezeAllNpcsInArea( object area );
int FUW_unfreezeAllNpcsInArea( object area ) {
    struct FUW_FreezeEffect freezeEffect = FUW_getFreezeEffect();
    int counter = 0;
    object objectIterator = GetFirstObjectInArea( area );
    while( objectIterator != OBJECT_INVALID ) {
        if( GetObjectType( objectIterator ) == OBJECT_TYPE_CREATURE && !GetIsPC( objectIterator ) ) {
            RemoveEffect( objectIterator, freezeEffect.first );
            RemoveEffect( objectIterator, freezeEffect.second );
            counter += 1;
        }
        objectIterator = GetNextObjectInArea( area );
    }
    return counter;
}

// Congela a todos los PCs en el área.
// Da TRUE si todos lo PCs en el área ya estaban congelados.
int FUW_freezeAllPcsInArea( object area, object exception=OBJECT_INVALID );
int FUW_freezeAllPcsInArea( object area, object exception=OBJECT_INVALID ) {
    int counter = 0;
    struct FUW_FreezeEffect freezeEffect = FUW_getFreezeEffect();
    object objectIterator = GetFirstObjectInArea( area );
    while( objectIterator != OBJECT_INVALID ) {
        if(
            GetIsPC( objectIterator )
            && objectIterator != exception
            && !FUW_hasEffect( objectIterator, freezeEffect.first )
        ) {
            //SetCutsceneMode( objectIterator, TRUE, FALSE );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, freezeEffect.first, objectIterator );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, freezeEffect.second, objectIterator );
            counter += 1;
        }
        objectIterator = GetNextObjectInArea( area );
    }
    return counter;
}


// Descongela a todos los PCs en 'area'.
int FUW_unfreezeAllPcsInArea( object area );
int FUW_unfreezeAllPcsInArea( object area ) {
    int counter = 0;
    struct FUW_FreezeEffect freezeEffect = FUW_getFreezeEffect();
    object objectIterator = GetFirstObjectInArea( area );
    while( objectIterator != OBJECT_INVALID ) {
        if( GetIsPC( objectIterator ) ) {
            //SetCutsceneMode( objectIterator, FALSE );
            RemoveEffect( objectIterator, freezeEffect.first );
            RemoveEffect( objectIterator, freezeEffect.second );
            counter += 1;
        }
        objectIterator = GetNextObjectInArea( area );
    }
    return counter;
}


void FUW_onFreezeActivated( object wand, object activator );
void FUW_onFreezeActivated( object wand, object activator ) {
    if( GetIsAllowedDM(activator) ) {
        object area = GetArea( activator );
        int pcsFreezed = FUW_freezeAllPcsInArea( area, activator );
        int npcsFreezed = FUW_freezeAllNpcsInArea( area );
        SendMessageToPC( activator, "The "+IntToString(pcsFreezed)+" PCs and "+IntToString(npcsFreezed)+" NPCs in this area were freezed." );
    }
}

void FUW_onUnfreezeActivated( object wand, object activator );
void FUW_onUnfreezeActivated( object wand, object activator ) {
    if( GetIsAllowedDM(activator) ) {
        object area = GetArea( activator );
        int pcsUnfreezed = FUW_unfreezeAllPcsInArea( area );
        int npcsUnfreezed = FUW_unfreezeAllNpcsInArea( area );
        SendMessageToPC( activator, "The "+IntToString(pcsUnfreezed)+" PCs and "+IntToString(npcsUnfreezed)+" NPCs in this area were unfreezed." );
    }
}
