//::///////////////////////////////////////////////
//:: FileName s_openarmor abre la tienda armaduras
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 12/09/02 04:37:16
//:://////////////////////////////////////////////
void main()
{

// Either open the store with that tag or let the user know that no store exists.
    object oStore = GetNearestObjectByTag("ironwood");
    if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
    OpenStore(oStore, GetPCSpeaker());
    else
    ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}

