//::///////////////////////////////////////////////
//:: Lasher - Third Hand
//:://////////////////////////////////////////////
/*
    Script to add lasher bonuses

    code "borrowed" from far hand, ranged disarm
    disarm gets weapon sizes using Get2DACache
*/
//:://////////////////////////////////////////////
//:: Created By: Flaming_Sword
//:: Created On: Sept 25, 2005
//:: Modified: Sept 27, 2005
//:://////////////////////////////////////////////

//compiler would completely crap itself unless this include was here
#include "inc_2dacache"
#include "spinc_common"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oCopy;
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int nWeight;
    int nBase;
    int nDC;
    int nSpellId = GetSpellId();
    int nClassLevel = GetLevelByClass(CLASS_TYPE_LASHER, oPC);
    int nType = GetObjectType(oTarget);
    float fRange = 4.5;
    float fDistance = GetDistanceToObject(oTarget);
    string sMessage = "";

    if(GetBaseItemType(oWeapon) == BASE_ITEM_WHIP)
    {
        if(fDistance < fRange)
        {
            int nAttack = GetAttackBonus(oTarget, OBJECT_SELF, oWeapon);

            if(nType == OBJECT_TYPE_PLACEABLE) //code for use on placeables here
            {
                nDC = 15; //use event hooks?
            }
            else if(nType == OBJECT_TYPE_DOOR) //code for use on doors here
            {
                nDC = 15;
            }
            else if(nType == OBJECT_TYPE_ITEM)
            {
                nWeight = GetWeight(oTarget);
                nBase = GetBaseItemType(oTarget);
                nDC = 20;

                if(nWeight <= 200)
                {
                    if(nAttack + d20() >= nDC)
                    {
                        oCopy = CopyItem(oTarget, oPC);
                        if(GetIsObjectValid(oCopy)) //wouldn't want to destroy objects that can't be copied
                        {
                            sMessage = "Third Hand picked up " + GetName(oTarget);
                            DestroyObject(oTarget);
                        }
                        else
                        {
                            if(nBase == BASE_ITEM_LARGEBOX)
                                sMessage = "You cannot pick up a container that is not empty";
                        }
                    }
                    else
                        sMessage = "Third Hand failed";
                }
                else
                    sMessage = "This item is too heavy";
            }
            else if(nType == OBJECT_TYPE_CREATURE)
            {
                if(nClassLevel > 5)
                {//string string Get2DACache(string s2DA, string sColumn, int nRow, string s = "", int nDebug = FALSE)
                    if (GetIsCreatureDisarmable(oTarget) && !GetPlotFlag(oTarget))
                    {
                        object oEnemyWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);

                        //weapon size
                        int nSize = StringToInt(Get2DACache("baseitems", "WeaponSize", GetBaseItemType(oEnemyWeapon)));
                        SPRaiseSpellCastAt(oTarget, TRUE, nSpellId);

                        //whip treated as medium from feat but -4 penalty on improved disarm
                        int nModifier = (2 - nSize) * 4;
                        int iHit = GetAttackRoll(oTarget, OBJECT_SELF, oWeapon, 0, nAttack, nModifier);

                        if(iHit)
                        {
                            if(GetSkill(oTarget, SKILL_DISCIPLINE) + d20() < nAttack)
                            {
                                nWeight = GetWeight(oEnemyWeapon);
                                nDC = 20;

                                FloatingTextStringOnCreature("*Disarm: Hit*", OBJECT_SELF, FALSE);

                                if(nWeight <= 200)
                                {
                                    if(nAttack + d20() >= nDC)
                                    {
                                        oCopy = CopyItem(oTarget, oPC);
                                        if(GetIsObjectValid(oCopy)) //wouldn't want to destroy objects that can't be copied
                                            sMessage = "Third Hand picked up " + GetName(oTarget);
                                        else
                                            sMessage = "DEBUG: CopyItem Failed (" + GetName(oTarget) + ")";
                                        DestroyObject(oTarget);
                                    }
                                    else
                                    {
                                        CopyObject(oEnemyWeapon, GetLocation(oTarget));
                                        DestroyObject(oEnemyWeapon);
                                    }
                                }
                                else
                                    sMessage = "This item is too heavy";
                            }
                            else
                                FloatingTextStringOnCreature("*Disarm: Failed*", OBJECT_SELF, FALSE);

                        }
                        else
                            FloatingTextStringOnCreature("*Disarm: Miss*", OBJECT_SELF, FALSE);
                   }
                    else
                        sMessage = "That target is not disarmable";
                }
                else
                    sMessage = "You cannot use Third Hand to disarm opponents until level 6";
            }
        }
        else
            sMessage = "The target is too far away";
    }
    else
        sMessage = "You must use a whip";
    SendMessageToPC(oPC, sMessage);
}
