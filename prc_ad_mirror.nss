#include "prc_inc_clsfunc"


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
     for(i=0;i<14;i++)//equipment
     {
        oItem = GetItemInSlot(i, oImage);
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
     }
     TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

void CleanAllCopies()
{
    string sImage1 = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"mirror";
    string sImage2 = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"flurry";

    object oCreature = GetFirstObjectInArea(GetArea(OBJECT_SELF));
    while (GetIsObjectValid(oCreature))
        {
         if(GetTag(oCreature) == sImage1 || GetTag(oCreature) == sImage2)
         {
            CleanCopy(oCreature);
         }
         oCreature = GetNextObjectInArea(GetArea(OBJECT_SELF));;
        }
}

void RemoveExtraImages()
{
    string sImage1 = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"mirror";
    string sImage2 = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"flurry";

    object oCreature = GetFirstObjectInArea(GetArea(OBJECT_SELF));
    while (GetIsObjectValid(oCreature))
        {
         if(GetTag(oCreature) == sImage1 || GetTag(oCreature) == sImage2)
         {
         DestroyObject(oCreature, 0.0);
         }
         oCreature = GetNextObjectInArea(GetArea(OBJECT_SELF));;
        }
}

void main2()
{
int iLevel = GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, OBJECT_SELF);
int iAdd = iLevel/3;
int iImages = d4(1) + iAdd;
int iCon = GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION) - 1;
if (iCon > 10) iCon = 10;

string sImage = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"mirror";

effect eImage = EffectCutsceneParalyze();
       eImage = SupernaturalEffect(eImage);
effect eGhost = EffectCutsceneGhost();
       eGhost = SupernaturalEffect(eGhost);
effect eNoSpell = EffectSpellFailure(100);
       eNoSpell = SupernaturalEffect(eNoSpell);
effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, iCon);
       eCon = SupernaturalEffect(eCon);
       
    int iPlus;
    for (iPlus = 0; iPlus < iImages; iPlus++)
    {
     object oImage = CopyObject(OBJECT_SELF, GetLocation(OBJECT_SELF), OBJECT_INVALID, sImage);

     object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oImage);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImage, oImage);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNoSpell, oImage);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCon, oImage);
     DelayCommand(3.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oImage));

     ChangeToStandardFaction(oImage, STANDARD_FACTION_DEFENDER);
     SetIsTemporaryFriend(OBJECT_SELF, oImage, FALSE);

     DestroyObject(oSkin, 0.2);
     DestroyObject(oImage, (iLevel * 60.0)); // they dissapear after a minute per level
    }
    
    CleanAllCopies();
}

void main()
{
   DelayCommand(0.0, RemoveExtraImages());
   DelayCommand(0.5, main2());
}
