/*

    Henchman Inventory And Battle AI

    This file contains code used by henchman when buffing up
    the party. Modified by Pausanias from the original Talent*
    functions.

*/

#include "hench_i0_generic"

// SUMMON ALLIES

// void main() {   }


int HenchTalentSummonAllies(int nForce = FALSE)
{
    talent tUse;

    if(!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED))
        && (nForce || !GetLocalInt(OBJECT_SELF, sHenchDontSummon)))
    {
        tUse = GetCreatureTalentBest(TALENT_CATEGORY_BENEFICIAL_OBTAIN_ALLIES, 20);
        if(GetIsTalentValid(tUse))
        {
            ClearAllActions();

            object oRealMaster = GetRealMaster();
            //This is for henchmen wizards, so they do no run off and get killed
            //summoning in allies.
            if(GetIsObjectValid(oRealMaster))
            {
                CU_ActionUseTalentAtLocation(tUse, GetLocation(oRealMaster));
            }
            else
            {
                CU_ActionUseTalentAtLocation(tUse, GetLocation(OBJECT_SELF));
            }
            return TRUE;
        }
    }
    return FALSE;
}


int GetWasCast(int nIndex, object oTarget)
{
    int nCast = GetLocalInt(oTarget,"nCast");

    int i;
    for (i = 1; i <= nCast; ++i)
        if (GetIntArray(oTarget,"IndexCast",i) == nIndex) return TRUE;

    return FALSE;
}


//PROTECT PARTY
int HenchTalentUseProtectionOthers(object oDefault = OBJECT_INVALID, int iClearActions = TRUE)
{
    talent tUse, tMass;
    int nType, nFriends, nIndex;
    int nCnt = 1;
    int bValid = FALSE;
    object oTarget;
    object oMaster = GetMaster();

    tUse = CU_GetCreatureTalentBest(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE, 20);
    tMass = CU_GetCreatureTalentBest(TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT, 20);

    // Pausanias: added option for the spell to have a specified target.
    if (oDefault == OBJECT_INVALID) {
       oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);

       //Override the nearest target if the master wants aggressive buff spells
       if(GetAssociateState(NW_ASC_AGGRESSIVE_BUFF) && GetAssociateState(NW_ASC_HAVE_MASTER))
       {
           oTarget = GetMaster();
       }
       // Do not enhance target it if it's running away

       if (oTarget != oMaster)
          if (GetLocalInt(oTarget,"RunningAway")) {
              return FALSE;
          }

    } else {
       oTarget = oDefault;

       // Try to get a protection that the target doesn't already have
       int iDone = FALSE;
       int nTry = 1;
       while (!iDone && GetIsTalentValid(tUse) && nTry <= 5) {
            nType = GetTypeFromTalent(tUse);
            nIndex = GetIdFromTalent(tUse);
            iDone = TRUE;

            if (nType == TALENT_TYPE_SPELL)
                if (GetHasSpellEffect(nIndex,oTarget) ||
                    GetWasCast(nIndex,oTarget)) iDone = FALSE;

            if (nType == TALENT_TYPE_FEAT)
                if (GetHasFeatEffect(nIndex,oTarget)||
                    GetWasCast(nIndex,oTarget)) iDone = FALSE;

            if (!iDone)
               tUse = CU_GetCreatureTalentRandom(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE);
            ++nTry;
       }
       if (!iDone) {
            SetLocalInt(OBJECT_SELF,"MaxedOut",TRUE);
            return FALSE;
       } else {
            if (!iClearActions) {
                int nCast = GetLocalInt(oTarget,"nCast");
                ++nCast;
                SetLocalInt(oTarget,"nCast",nCast);
                SetIntArray(oTarget,"IndexCast",nCast,nIndex);
            }
            SetLocalInt(OBJECT_SELF,"MaxedOut",FALSE);
       }
    }

    while(GetIsObjectValid(oTarget))
    {
       int iValidTarget = TRUE;

       // Do not enhance target it if it's running away or too far.
       if (oTarget != oMaster) {
          if (GetLocalInt(oTarget,"RunningAway")) {
              iValidTarget = FALSE;
          }
          if (GetDistanceBetween(oTarget,oMaster) > 6.0) {
              iValidTarget = FALSE;
          }
        }
        if(GetIsTalentValid(tUse) && iValidTarget)
        {
            nType = GetTypeFromTalent(tUse);
            nIndex = GetIdFromTalent(tUse);
            if(nType == TALENT_TYPE_SPELL)
            {
                if(!GetHasSpellEffect(nIndex, oTarget))
                {
                    if (iClearActions) ClearAllActions();
                    CU_ActionUseTalentOnObject(tUse, oTarget);
                    return TRUE;
                }
            }
            else if(nType == TALENT_TYPE_FEAT)
            {
                if(!GetHasFeatEffect(nIndex, oTarget))
                {
                    if (iClearActions) {
                        ClearAllActions();
                        CU_ActionUseTalentOnObject(tUse, OBJECT_SELF);
                    } else
                        ActionDoCommand(CU_ActionUseTalentOnObject(tUse, OBJECT_SELF));
                    return TRUE;
                }
            }
            else
            {
                if (iClearActions) ClearAllActions();
                CU_ActionUseTalentOnObject(tUse, oTarget);
                return TRUE;
            }
        }
        nCnt++;
        if (oDefault == OBJECT_INVALID)
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, OBJECT_SELF, nCnt, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
        else
            oTarget = OBJECT_INVALID;
    }
    return FALSE;
}

// ENHANCE OTHERS
int HenchTalentEnhanceOthers(object oDefault = OBJECT_INVALID,
                        int iAvoidInvisibility = FALSE,
                        int iClearActions = TRUE)
{
    talent tInvis;

    talent tUse, tMass;
    int nType, nFriends, nIndex;
    int nCnt = 1;
    int bValid = FALSE;
    object oTarget;
    object oMaster = GetMaster();

    tUse = CU_GetCreatureTalentBest(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE, 20);
    tMass = CU_GetCreatureTalentBest(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT, 20);
    // Pausanias: added option to specify a target
    if (oDefault == OBJECT_INVALID) {
       oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);

       //Override the nearest target if the master wants aggressive buff spells
       if(GetAssociateState(NW_ASC_AGGRESSIVE_BUFF) && GetAssociateState(NW_ASC_HAVE_MASTER))
       {
          oTarget = oMaster;
       }


    } else {
       oTarget = oDefault;

       // Pausanias:
       // Try to get a buff that the target doesn't already have
       // Also try to avoid invisibility spells if so indicated.
       // This inelegant approach is necessitate by CU_GetHasSpell and
       // CU_GetCreatureHasTalent not working properly for bards/sorcerers
       int iDone = FALSE;
       int nTry = 1;
       int nMaxTries = 20;
       int iFoundInvis = FALSE;

       while (!iDone && GetIsTalentValid(tUse) && nTry <= nMaxTries) {
            nType = GetTypeFromTalent(tUse);
            nIndex = GetIdFromTalent(tUse);
            iDone = TRUE;

            if (iAvoidInvisibility) {
                if (nIndex == SPELL_INVISIBILITY || nIndex == SPELL_IMPROVED_INVISIBILITY) {
                    if (nTry < nMaxTries) {
                        iDone = FALSE;
                        iFoundInvis = TRUE;
                        tInvis = tUse;
                    }
                }
                if (nTry == nMaxTries && iFoundInvis) {
                    tUse = tInvis;
                    nType = GetTypeFromTalent(tUse);
                    nIndex = GetIdFromTalent(tUse);
                }
            }

            if (nType == TALENT_TYPE_SPELL) {
                if (GetHasSpellEffect(nIndex,oTarget) ||
                    GetWasCast(nIndex,oTarget)) iDone = FALSE;

                if (nIndex == SPELL_HASTE)
                    if (GetHasEffect(EFFECT_TYPE_HASTE, oTarget) || GetCreatureHasItemProperty(ITEM_PROPERTY_HASTE, oTarget))
                        iDone = FALSE;
            }

            if (nType == TALENT_TYPE_FEAT)
                if (GetHasFeatEffect(nIndex,oTarget) ||
                    GetWasCast(nIndex,oTarget)) iDone = FALSE;

            if (!iDone)
               tUse = CU_GetCreatureTalentRandom(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE);
            ++nTry;
       }

       if (!iDone) {
            SetLocalInt(OBJECT_SELF,"MaxedOut",TRUE);
            return FALSE;
       } else {
            SetLocalInt(OBJECT_SELF,"MaxedOut",FALSE);
            if (!iClearActions) {
                int nCast = GetLocalInt(oTarget,"nCast");
                ++nCast;
                SetLocalInt(oTarget,"nCast",nCast);
                SetIntArray(oTarget,"IndexCast",nCast,nIndex);
            }
       }
    }


    while(GetIsObjectValid(oTarget))
    {

       int iValidTarget = TRUE;

       // Do not enhance target it if it's running away or too far.
       if (oTarget != oMaster) {
          if (GetLocalInt(oTarget,"RunningAway")) {
              iValidTarget = FALSE;
          }
          if (GetDistanceBetween(oTarget,oMaster) > 6.0) {
              iValidTarget = FALSE;
          }
        }
        if(GetIsTalentValid(tUse) && iValidTarget)
        {
            nType = GetTypeFromTalent(tUse);
            nIndex = GetIdFromTalent(tUse);
            if(nType == TALENT_TYPE_SPELL)
            {
                if(!GetHasSpellEffect(nIndex, oTarget))
                {
                    if (iClearActions) ClearAllActions();
                    CU_ActionUseTalentOnObject(tUse, oTarget);
                    return TRUE;
                }
            }
            else if(nType == TALENT_TYPE_FEAT)
            {
                if(!GetHasFeatEffect(nIndex, oTarget))
                {
                    // Bug fix by Pausanias: changed OBJECT_SELF to oTarget
                    if (iClearActions) {
                        ClearAllActions();
                        CU_ActionUseTalentOnObject(tUse, oTarget);
                    } else
                        ActionDoCommand(CU_ActionUseTalentOnObject(tUse, oTarget));
                    return TRUE;
                }
            }
            else
            {
                if (iClearActions) ClearAllActions();
                CU_ActionUseTalentOnObject(tUse, oTarget);
                return TRUE;
            }
        }
        nCnt++;
        if (oDefault == OBJECT_INVALID)
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, OBJECT_SELF, nCnt, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
        else
            oTarget = OBJECT_INVALID;
    }
    return FALSE;
}
