//::///////////////////////////////////////////////
//:: Name x2_def_ondamage
//:: Autor: Zero e Inquisidor
//:://////////////////////////////////////////////
/*
Custom on damage script
*/

#include "SPC_inc"

void main()
{
    // Make Plot Creatures Ignore Attacks
    if( GetPlotFlag(OBJECT_SELF) ) {
        return;
    }
    int iDamageRecieved = GetLocalInt(OBJECT_SELF, "TROLL_DAMAGE_RECIEVED");
            // Acid + fire
            int iAcid = GetDamageDealtByType(DAMAGE_TYPE_ACID);
            int iFire = GetDamageDealtByType(DAMAGE_TYPE_FIRE);

            // Add it to it
            iDamageRecieved = iDamageRecieved + iAcid + iFire;
            // Set it
            SetLocalInt(OBJECT_SELF, "TROLL_DAMAGE_RECIEVED", iDamageRecieved);

    // Execute old NWN default AI code
    ExecuteScript( "nw_c2_default6", OBJECT_SELF);

    // Linea movida a "nw_c2_default6"
    //SisPremioCombate_onDamage( GetLastDamager(), GetTotalDamageDealt() );
}
