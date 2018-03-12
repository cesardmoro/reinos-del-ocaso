// Written by: Ne0nx3r0
// for the Dot Hack Project mod,
// http://www.dothackproject.net/
// Ne0nx3r0@hotmail.com

void main()
{
string sqname = GetLocalString(OBJECT_SELF,"current_name");
object oChest = GetNearestObjectByTag("ChestofNames",OBJECT_SELF);
object oItem  = GetFirstItemInInventory(oChest);

ActionCastFakeSpellAtObject(SPELL_VIRTUE, oChest, PROJECTILE_PATH_TYPE_DEFAULT);
SetName(oItem,sqname);
SetLocked(oChest,FALSE);

DelayCommand(0.5, AssignCommand(oChest, ActionSpeakString("Exito")));

ActionSpeakString(".. Esta hecho");

}
