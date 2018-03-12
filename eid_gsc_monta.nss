//::///////////////////////////////////////////////
//:: Name: PJ monta en cabalgadura.
//:: FileName: eid_gsc_monta
//:: Copyright (c) 2005 ES] EIDOLOM
//:://////////////////////////////////////////////
/*
    Se ejecuta la orden de cabalgar.
*/
//::
//:: Ñ ñ Ú É í Ó Á ¿ ¡ ú é í ó á
//::
//:://////////////////////////////////////////////
//:: Modified By: Deeme
//:: Modified On: 02/07/2005
//:://////////////////////////////////////////////


#include "eid_gsc_include"

void main()
{
    //SetLocalObject(OBJECT_SELF, "gsc_padrone", GetPCSpeaker());

    //El PJ adquiere el fenotipo de jinete adecuado a su raza.
    GSC_SellaPG(GetPCSpeaker(), OBJECT_SELF);
}

