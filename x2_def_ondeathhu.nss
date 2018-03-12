//::///////////////////////////////////////////////
//:: Name x2_def_ondeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default OnDeath script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////
#include "SPC_Cre_onDeath"
#include "RS_inc"
#include "RS_sgeInterface"

void main() {

      object oDamager = GetLastKiller();
      int iHD = GetHitDice(GetFactionStrongestMember(oDamager, FALSE));
      int iHD2;

      if(GetLocalInt(OBJECT_SELF, "merc") == 1) {
        SetIsDestroyable( FALSE, TRUE, TRUE );
//        ExecuteScript("NW_CH_AC7", OBJECT_SELF);
    } else {
        //SetIsDestroyable(TRUE, TRUE, TRUE);
        RS_creatureOnDeath( GetLastKiller() );
        SisPremioCombate_onDeath( GetLastKiller() );
    }
    object ohuargo = CreateObject(OBJECT_TYPE_CREATURE, "huargo001", GetLocation(OBJECT_SELF));
    RS_copiarMarcasCriatura( OBJECT_SELF, ohuargo );
}
