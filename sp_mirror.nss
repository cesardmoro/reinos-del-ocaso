//::///////////////////////////////////////////////
//:: Mirror Image
//:: sp_mirror.nss
//:://////////////////////////////////////////////
/*
Caster Level(s): Bard 2, Wizard 2, Sorcerer 2
Innate Level: 2
School: Illusion
Component(s): Verbal, Somatic
Range: Personal
Area of Effect / Target: Self
Duration: 1 min/level
Save: harmless
Spell Resistance: harmless

 Several illusory duplicates of you pop into being, making it
 difficult for enemies to know which target to attack. The
 figments stay near you and disappear when struck.

Mirror image creates 1d4 images plus one image per three
caster levels (maximum eight images total). These figments
separate from you and remain in a cluster, each within 5 feet
of at least one other figment or you. You can move into and
through a mirror image. When you and the mirror image separate,
observers can’t use vision or hearing to tell which one is you
and which the image. The figments may also move through each
other. The figments mimic your actions, pretending to cast spells
when you cast a spell, drink potions when you drink a potion,
levitate when you levitate, and so on.

Enemies attempting to attack you or cast spells at you must
select from among indistinguishable targets. Any successful
attack against an image destroys it. An image’s AC is 10 +
your size modifier + your Dex modifier. Figments seem to react
normally to area spells (such as looking like they’re burned or
dead after being hit by a fireball).

*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: August 20, 2004
//:://////////////////////////////////////////////

#include "spinc_common"


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
    int iLevel = PRCGetCasterLevel(OBJECT_SELF);
    int iAdd = iLevel/3;
    int iImages = d4(1) + iAdd;
    if(iImages >8)
        iImages = 8;
    int nDuration = iLevel;
    //Enter Metamagic conditions
    int nMetaMagic = PRCGetMetaMagicFeat();
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }

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
        //ApplyAbilityDamage(oImage, ABILITY_CONSTITUTION, iCon, DURATION_TYPE_PERMANENT, TRUE);
        DelayCommand(3.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oImage));

        ChangeToStandardFaction(oImage, STANDARD_FACTION_DEFENDER);
        SetIsTemporaryFriend(OBJECT_SELF, oImage, FALSE);

        //DestroyObject(oSkin, 0.2); //why kill the skin?
        DestroyObject(oImage, TurnsToSeconds(nDuration)); // they dissapear after a minute per level
    }

    CleanAllCopies();
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

// End of Spell Cast Hook

    DelayCommand(0.0, RemoveExtraImages());
    DelayCommand(0.1, main2());

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
