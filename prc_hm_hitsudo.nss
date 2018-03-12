/******************************************************
* Feat: Hitsu-Do
* Description: Hands and weapons have fire on them
* adding 1d6 fire damage for 2 rounds per mystic level
* once per day.
*
* by Jeremiah Teague
******************************************************/
//#include "prc_hnshnmystc"
#include "prc_class_const"
#include "prc_feat_const"

void main()
{
int nLevel = GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC, OBJECT_SELF);
effect ePCDamInc  = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
effect eVFX = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
itemproperty ipDam = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6);
itemproperty ipVFX = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);
object oWeapon =  GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);

//figure out the length of the effects and apply them:
float fDuration = RoundsToSeconds(nLevel * 2);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, OBJECT_SELF, fDuration);

if(GetIsObjectValid(oWeapon))
    {
    // a weapon is equiped add the 1d6 fire damage and vfx:
    AddItemProperty(DURATION_TYPE_TEMPORARY, ipDam, oWeapon, fDuration);
    AddItemProperty(DURATION_TYPE_TEMPORARY, ipVFX, oWeapon, fDuration);

    if(GetIsObjectValid(oWeapon2))
        {//Check for weapon in left hand
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipDam, oWeapon, fDuration);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipVFX, oWeapon, fDuration);
        }
    }
else
    {
    // no weapon equiped...
    // add 1d6 fire damage to unarmed attacks:
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePCDamInc, OBJECT_SELF, fDuration);
    }
}
