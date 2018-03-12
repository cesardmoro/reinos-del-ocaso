#include "prc_alterations"
#include "prc_spell_const"
#include "x2_inc_spellhook"

void CleanCopy(object oImage)
{     
     SetLootable(oImage, FALSE);
     object oItem = GetFirstItemInInventory(oImage);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        oItem = GetNextItemInInventory(oImage);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
     {
        oItem = GetItemInSlot(i, oImage);
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
     }
     TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    int nDuration = GetLevelByTypeArcane();

    object oCopy = CopyObject(OBJECT_SELF, GetSpellTargetLocation(), OBJECT_INVALID, "Clone"+GetName(OBJECT_SELF));

    DelayCommand(0.1f, CleanCopy(oCopy));

    effect eDomi = SupernaturalEffect(EffectCutsceneDominated());
    DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDomi, oCopy));

    SetStandardFactionReputation(STANDARD_FACTION_DEFENDER,100,OBJECT_SELF);
    SetIsTemporaryFriend(oCopy,OBJECT_SELF);
    DestroyObject(oCopy,RoundsToSeconds(nDuration) );


//    AddHenchman(OBJECT_SELF,oCopy);

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the local integer storing the spellschool name

}
