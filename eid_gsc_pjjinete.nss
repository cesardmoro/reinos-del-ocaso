//::///////////////////////////////////////////////
//:: Name: El PJ ya es jinete
//:: FileName: eid_gsc_pjjinete
//:: Copyright (c) 2005 ES] EIDOLOM
//:://////////////////////////////////////////////
/*
    Si el PJ ya es jinete o tiene asignada alguna montura o ayudante, este
    script lo detecta para impedir que se le asigne otra montura.
    Colocar en "El texto aparece cuando" de la linea de conversacion adecuada.
*/
//::
//:: Ñ ñ Ú É í Ó Á ¿ ¡ ú é í ó á
//::
//:://////////////////////////////////////////////
//:: Created By: Deeme
//:: Created On: 02/07/2005
//:://////////////////////////////////////////////

// Salta el mensaje "Ya estas al cargo de otros ayudantes.".

#include "eid_gsc_include"

int StartingConditional()
{
    // Si PJ esta montado sobre una montura entonces TRUE
    if(GSC_IsPGRidingHorse(GetPCSpeaker()) == TRUE){
        return TRUE;
    }

    // Si la montura a la que se habla no pertenece al PJ...
    if(GetMaster(OBJECT_SELF) != GetPCSpeaker()){
        // ...pero el PJ tiene algun ayudante entonces TRUE
        if(GetHenchman(GetPCSpeaker(), 1) != OBJECT_INVALID){
            return TRUE;
        }
    }

    return FALSE;
}

