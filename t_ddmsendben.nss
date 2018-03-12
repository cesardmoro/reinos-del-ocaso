//::///////////////////////////////////////////////
//:: FileName sailtobenzor   t_ddmsendben
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 7/7/2002 1:44:08 PM
//:://////////////////////////////////////////////
void main()
{

    // Remove items from the player's inventory
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "PasajeDDM");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
    //Enviar PJ a brosna
    AssignCommand(GetPCSpeaker(),
        JumpToLocation(GetLocation(GetObjectByTag ("WP_DDMLOADBEN"))));

}
