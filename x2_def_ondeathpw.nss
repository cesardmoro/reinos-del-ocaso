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

void main() {

      ExecuteScript("pw_on_death", OBJECT_SELF);

      if(GetLocalInt(OBJECT_SELF, "merc") == 1) {
        SetIsDestroyable( FALSE, TRUE, TRUE );
//        ExecuteScript("NW_CH_AC7", OBJECT_SELF);
    } else {
        //SetIsDestroyable(TRUE, TRUE, TRUE);
        RS_creatureOnDeath( GetLastKiller() );
        SisPremioCombate_onDeath( GetLastKiller() );
    }
}
