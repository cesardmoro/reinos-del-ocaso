//::///////////////////////////////////////////////
//:: Name: Montura aliada desde conversacion
//:: FileName: eid_gsc_atracc
//:: Copyright (c) 2005 ES] EIDOLOM
//:://////////////////////////////////////////////
/*
    Comprueba si el PJ que habla tiene la silla de montar en su inventario.
*/
//::
//:: Ñ ñ Ú É í Ó Á ¿ ¡ ú é í ó á
//::
//:://////////////////////////////////////////////
//:: Created By: Deeme
//:: Created On: 24/06/2005
//:: Modified On: 02/07/2005
//:://////////////////////////////////////////////

#include "nw_i0_tool"

int StartingConditional()
{
    if(HasItem(GetPCSpeaker(), "gsc_sella")){
        return TRUE;
    }

    return FALSE;
}

