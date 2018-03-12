//::///////////////////////////////////////////////
//:: Name x2_def_ondamage
//:: Autor: Zero e Inquisidor
//:://////////////////////////////////////////////
/*
Custom on damage script
*/

//#include "SPC_inc"

void main()
{
    // Make Plot Creatures Ignore Attacks
    if( GetPlotFlag(OBJECT_SELF) ) {
        return;
    }

    // Execute old NWN default AI code
    if( GetLocalInt( OBJECT_SELF, "merc" ) )
        ExecuteScript("NW_CH_AC3", OBJECT_SELF);
    else {
        ExecuteScript( "nw_c2_default6", OBJECT_SELF);

        // Linea movida a "nw_c2_default6"
        // SisPremioCombate_onDamage( GetLastDamager(), GetTotalDamageDealt() );
    }
}
