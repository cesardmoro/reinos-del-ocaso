//::///////////////////////////////////////////////
//:: Name: Muerte de la montura
//:: FileName: eid_gsc_ondeath
//:: Copyright (c) 2005 ES] EIDOLOM
//:://////////////////////////////////////////////
/*
    Poner en el OnDeath de la montura.
*/
//::
//:: � � � � � � � � � � � � � �
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
