//::///////////////////////////////////////////////
//:: Name x2_def_ondeath
//:: Autor: Zero e Inquisidor
//:: Mayo 2006
//:://////////////////////////////////////////////
/*
Custom OnDeath script
*/


//#include "preguntascrea"
#include "SPC_Cre_onDeath"
#include "RS_inc"


void raise() {
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints()/6), OBJECT_SELF);
}

void main() {

    // ExecuteScript("pw_on_death", OBJECT_SELF);

    int iDamageRecieved = GetLocalInt(OBJECT_SELF, "TROLL_DAMAGE_RECIEVED");
    // Acid + fire
    int iAcid = GetDamageDealtByType(DAMAGE_TYPE_ACID);
    int iFire = GetDamageDealtByType(DAMAGE_TYPE_FIRE);

    // Add it to it
    iDamageRecieved = iDamageRecieved + iAcid + iFire;
    // Set it
    SetLocalInt(OBJECT_SELF, "TROLL_DAMAGE_RECIEVED", iDamageRecieved);
    //int iDamageRecieved = GetLocalInt(OBJECT_SELF, "TROLL_DAMAGE_RECIEVED");
    int iMax = GetMaxHitPoints();
    // Die - we will regen in 2 rounds
    if(iDamageRecieved < iMax) {
        // 2 rounds until regen + 1/6th of HP
        DelayCommand( 12.0, raise() );
        return;
        // Exit the UDE as we shouldn't give XP
        //SetToExitFromUDE(EVENT_DEATH_PRE_EVENT);
    }


    if(GetLocalInt(OBJECT_SELF, "merc") == 1) {
        SetIsDestroyable( FALSE, TRUE, TRUE );
//        ExecuteScript("NW_CH_AC7", OBJECT_SELF);
    } else {
        RS_creatureOnDeath( GetLastKiller() );
        SisPremioCombate_onDeath( GetLastKiller() );
    }


}
