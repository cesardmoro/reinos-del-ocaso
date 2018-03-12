/**
 * Master of Shrouds: Summon Undead (1-4)
 * 2004/02/15
 * Brian Greinke
 * edited to include epic wraith summons 2004/03/04; also removed unnecessary scripting.
 * Lockindal Linantal
 */

#include "prc_alterations"
#include "prc_inc_clsfunc"
#include "inc_utility"
#include "prc_inc_turning"

void SummonUndeadPseudoHB(object oSummon, int nSpellID);
void SummonUndeadPseudoHB(object oSummon, int nSpellID)
{
    if(!GetIsObjectValid(oSummon))
        return;
    if(!GetIsInCombat(OBJECT_SELF))
    {
        //casters level for turning
        int nLevel = GetTurningClassLevel();

        //casters charimsa modifier
        int nChaMod = GetAbilityModifier(ABILITY_CHARISMA);
        //Heartwarder adds two to cha checks
        if (GetHasFeat(FEAT_HEART_PASSION))
            nChaMod +=2;
        int nTurningMaxHD = GetTurningCheckResult(nLevel, nChaMod);
        int nTargetHD = GetHitDiceForTurning(oSummon);
        if(nTurningMaxHD < nTargetHD)
        {
            effect eTest= GetFirstEffect(oSummon);
            while(GetIsEffectValid(eTest))
            {
                if(GetEffectSpellId(eTest) == nSpellID)
                    RemoveEffect(oSummon, eTest);
                eTest = GetNextEffect(oSummon);
            }
            //make em hostile
            object oTest = GetFirstFactionMember(OBJECT_SELF);
            while(GetIsObjectValid(oTest))
            {
                SetIsTemporaryEnemy(oTest, oSummon);
                oTest = GetNextFactionMember(OBJECT_SELF);
            }
        }    
        else
        {
            AssignCommand(oSummon, ClearAllActions());
            AssignCommand(oSummon, ActionForceFollowObject(OBJECT_SELF, IntToFloat(Random(8)+3)));
        }    
    
    }
    DelayCommand(6.0, SummonUndeadPseudoHB(oSummon, nSpellID));
}

void main()
{
    string sSummon;
    effect eSummonB = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);//EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
    object oCreature;
    int nClass = GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, OBJECT_SELF);
    int nCount;
    int nSpellID = PRCGetSpellId();
    if(nSpellID == 3009)      nCount = 1;
    else if(nSpellID == 3010) nCount = 2;
    else if(nSpellID == 3011) nCount = 4;
    else if(nSpellID == 3012) nCount = 8;

    if (nClass >= 29)        sSummon = "prc_mos_39";
    else if (nClass >= 26)   sSummon = "prc_mos_36";
    else if (nClass >= 23)   sSummon = "prc_mos_33";
    else if (nClass >= 20)   sSummon = "prc_mos_30";
    else if (nClass >= 17)   sSummon = "prc_mos_27";
    else if (nClass >= 14)   sSummon = "prc_mos_24";
    else if (nClass >= 11)   sSummon = "prc_mos_21";
    else if (nClass >= 9)    sSummon = "prc_mos_spectre2";
    else if (nClass >= 7)    sSummon = "prc_mos_spectre1";
    else if (nClass >= 5)    sSummon = "prc_mos_wraith";
    else                    sSummon = "prc_mos_allip";

   //MultisummonPreSummon(OBJECT_SELF);
   effect eCommand = EffectCutsceneDominated();//SupernaturalEffect(effectdominated doesnt work on mind-immune
   int i;
   for(i=0;i<nCount;i++)
   {
       object oSummon = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());
       ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummonB, GetLocation(oSummon));
       ChangeToStandardFaction(oSummon, STANDARD_FACTION_HOSTILE);
       SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eCommand, oSummon);
       DelayCommand(6.0, SummonUndeadPseudoHB(oSummon, nSpellID));
       DestroyObject(oSummon, RoundsToSeconds(nClass));
   }
}
