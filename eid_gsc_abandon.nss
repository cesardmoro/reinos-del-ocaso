//::///////////////////////////////////////////////
//:: Name: Abandonando a la montura
//:: FileName: eid_gsc_abandon
//:: Copyright (c) 2005 ES] EIDOLOM
//:://////////////////////////////////////////////
/*
    Salta la frase a la que esta asignada este script.
*/
//::
//:: � � � � � � � � � � � � � �
//::
//:://////////////////////////////////////////////
//:: Created By: Deeme
//:: Created On: 02/07/2005
//:://////////////////////////////////////////////

int StartingConditional()
{
    if(GetMaster(OBJECT_SELF) == GetPCSpeaker()){
        return TRUE;
    }

    return FALSE;
}

/*
int StartingConditional()
{
    if(GetIsObjectValid(GetLocalObject(OBJECT_SELF, "gsc_padrone")) == TRUE){
        return TRUE;
    }

    return FALSE;
}
*/

