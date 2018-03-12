//::///////////////////////////////////////////////
//:: FileName t_ddmhastick
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 20/12/2005 03:21:38 p.m.
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Comprobar si el PJ que habla tiene los objetos en su inventario
    if(!HasItem(GetPCSpeaker(), "PasajeDDM"))
        return FALSE;

    return TRUE;
}
