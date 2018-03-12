//::///////////////////////////////////////////////
//:: Name x2_def_ondeath
//:: Autor: Zero e Inquisidor
//:: Mayo 2006
//:://////////////////////////////////////////////
/*
Custom OnDeath script

14/04/07 Metida de mano de Dragoncin
*/

//#include "preguntascrea"
//#include "SPC_inc"
//#include "RS_inc"
#include "nigromancia_inc"
#include "Horses_inc"
#include "Mercenario_inc"

void main() {


    // ExecuteScript("pw_on_death", OBJECT_SELF);
    AnimateDead_onDeath();

    if(GetLocalInt(OBJECT_SELF, "merc")) {

        Mercenario_onDeath();

//        ExecuteScript("NW_CH_AC7", OBJECT_SELF);
    } else if (GetIsRidableHorse(OBJECT_SELF)) {

        Horses_onHorseDeath();

    } else {
        ExecuteScript( "nw_c2_default7", OBJECT_SELF );

        //Lineas movidas a "nw_c2_default7"
        //RS_creatureOnDeath( GetLastKiller() );
        //SisPremioCombate_onDeath( GetLastKiller() );

    }

}
