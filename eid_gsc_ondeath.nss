//::///////////////////////////////////////////////
//:: Name: Muerte de la montura
//:: FileName: eid_gsc_ondeath
//:: Copyright (c) 2005 ES] EIDOLOM
//:://////////////////////////////////////////////
/*
    Poner en el OnDeath de la montura.
*/
//::
//:: Ñ ñ Ú É í Ó Á ¿ ¡ ú é í ó á
//::
//:://////////////////////////////////////////////
//:: Modified By: Deeme
//:: Modified On: 27/06/2005
//:://////////////////////////////////////////////

void main()
{
    object oCavallo = OBJECT_SELF;

    DeleteLocalObject(oCavallo, "gsc_padrone");
    AssignCommand(oCavallo, SetIsDestroyable(TRUE, FALSE, FALSE));
}
