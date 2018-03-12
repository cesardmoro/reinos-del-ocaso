//::///////////////////////////////////////////////
//:: Name: Finalizar trato con montura
//:: FileName: eid_gsc_fin
//:: Copyright (c) 2005 ES] EIDOLOM
//:://////////////////////////////////////////////
/*
    En vez de desconvocar a la montura, ahora:
    -Si esta en el exterior se aleja hacia el punto de ruta mas cercano antes de
    desaparecer.
    -Si esta en un interior, la montura se queda alli.
    -La silla de montar no se destruye salvo desmarcando linea 36
*/
//::
//:: Ñ ñ Ú É í Ó Á ¿ ¡ ú é í ó á
//::
//:://////////////////////////////////////////////
//:: Modified By: Deeme
//:: Modified On: 02/07/2005
//:://////////////////////////////////////////////


void main()
{
    object oWP = GetNearestObject(OBJECT_TYPE_WAYPOINT, OBJECT_SELF);

    RemoveHenchman(GetPCSpeaker(), OBJECT_SELF);
    //DeleteLocalObject(OBJECT_SELF, "gsc_padrone");

    if(GetIsAreaInterior(GetArea(GetPCSpeaker())) == FALSE){
        AssignCommand(OBJECT_SELF, SetIsDestroyable(TRUE, FALSE, FALSE));
        AssignCommand(OBJECT_SELF, ActionForceMoveToObject(oWP, TRUE));
        DelayCommand(5.0, DestroyObject(OBJECT_SELF));
        return;
    }

    //DestroyObject(GetItemPossessedBy(GetPCSpeaker(), "gsc_sella"));
}
