//::///////////////////////////////////////////////
//:: Include file for Detect Alignment spells
//:: prc_inc_s_det
//:://////////////////////////////////////////////
/** @file

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "spinc_common"
//#include "inc_draw"    Provided by inc_utility
//#include "inc_utility" Provided by prc_alterations

//this is the main detection function
void DetectAlignmentRound(int nRound, location lLoc, int nGoodEvil, int nLawChaos, string sAura, int nBeamVFX);

const int AURA_STRENGTH_DIM          = 1;
const int AURA_STRENGTH_FAINT        = 2;
const int AURA_STRENGTH_MODERATE     = 3;
const int AURA_STRENGTH_STRONG       = 4;
const int AURA_STRENGTH_OVERWHELMING = 5;



string GetNounForStrength(int nStrength)
{
    string sNoun;
    switch(nStrength)
    {
        case AURA_STRENGTH_DIM:
                sNoun = GetStringByStrRef(16832039); //"dimly"
            break;
        case AURA_STRENGTH_FAINT:
                sNoun = GetStringByStrRef(16832040); //"faintly"
            break;
        case AURA_STRENGTH_MODERATE:
                sNoun = GetStringByStrRef(16832041); //"moderately"
            break;
        case AURA_STRENGTH_STRONG:
                sNoun = GetStringByStrRef(16832042); //"strongly"
            break;
        case AURA_STRENGTH_OVERWHELMING:
                sNoun = GetStringByStrRef(16832043); //"overwhelmingly"
            break;
    }
    return sNoun;
}

void ApplyEffectDetectAuraOnObject(int nStrength, object oTarget, int nVFX)
{
    return;
    location lLoc = GetLocation(oTarget);
    float fRadius = (IntToFloat(GetCreatureSize(oTarget))*0.5)+0.5; //this is graphics related, not rules
    location lCenter;
    vector vCenter = GetPositionFromLocation(lLoc);
    switch(nStrength)
    {
        //yes fallthroughs here
        case AURA_STRENGTH_OVERWHELMING:
            vCenter.z += (fRadius/2.0);
            lCenter = Location(GetAreaFromLocation(lLoc), vCenter, 0.0);
            BeamPentacle(DURATION_TYPE_TEMPORARY, nVFX, lCenter, fRadius, 6.0);
        case AURA_STRENGTH_STRONG:
            vCenter.z += (fRadius/2.0);
            lCenter = Location(GetAreaFromLocation(lLoc), vCenter, 0.0);
            BeamPentacle(DURATION_TYPE_TEMPORARY, nVFX, lCenter, fRadius, 6.0);
        case AURA_STRENGTH_MODERATE:
            vCenter.z += (fRadius/2.0);
            lCenter = Location(GetAreaFromLocation(lLoc), vCenter, 0.0);
            BeamPentacle(DURATION_TYPE_TEMPORARY, nVFX, lCenter, fRadius, 6.0);
        case AURA_STRENGTH_FAINT:
            vCenter.z += (fRadius/2.0);
            lCenter = Location(GetAreaFromLocation(lLoc), vCenter, 0.0);
            BeamPentacle(DURATION_TYPE_TEMPORARY, nVFX, lCenter, fRadius, 6.0);
        case AURA_STRENGTH_DIM:
            vCenter.z += (fRadius/2.0);
            lCenter = Location(GetAreaFromLocation(lLoc), vCenter, 0.0);
            BeamPentacle(DURATION_TYPE_TEMPORARY, nVFX, lCenter, fRadius, 6.0);
    }
}

void DetectAlignmentRound(int nRound, location lLoc, int nGoodEvil, int nLawChaos, string sAura, int nBeamVFX)
{
    //if concentration is broken, abort
    if(GetBreakConcentrationCheck(OBJECT_SELF) && nRound != 0)
    {//                              "Concentration broken."
        FloatingTextStringOnCreature(GetStringByStrRef(16832000), OBJECT_SELF, FALSE);
        return;
    }

    //if you move/turn, restart the process
    if(lLoc != GetLocation(OBJECT_SELF))
        nRound = 1;
    if(nRound == 0)
        nRound = 1;
    //sanity check
   if(nRound > 3)
        nRound = 3;


    object oTest = GetFirstObjectInShape(SHAPE_SPELLCONE, 20.0, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    int nStrongestAura;
    int nAuraCount;
    while(GetIsObjectValid(oTest))
    {
        if((GetAlignmentGoodEvil(oTest)==nGoodEvil || nGoodEvil == -1)
            && (GetAlignmentGoodEvil(oTest)==nLawChaos || nLawChaos == -1)
            && oTest != OBJECT_SELF
            && !GetHasSpellEffect(SPELL_UNDETECTABLE_ALINGMENT, oTest))
        {
            if(nRound == 1)
            {
                //presence/absence
                ApplyEffectDetectAuraOnObject(AURA_STRENGTH_MODERATE, OBJECT_SELF, nBeamVFX);
                FloatingTextStringOnCreature(GetRGB(15,5,5) + GetStringByStrRef(16832001)// "You detect the presense of"
                                             + " " + (nLawChaos != -1 ? // "good" and "evil" work as both substantives and adjectives, but not so for "lawful" and "chaotic"
                                                      (nLawChaos == ALIGNMENT_LAWFUL ?
                                                       GetStringByStrRef(4957)   // "law"
                                                       : GetStringByStrRef(4958) // "chaos"
                                                       )
                                                      : sAura
                                                      )
                                              + ".",
                                             OBJECT_SELF, FALSE);
                break;//end while loop
            }

            int nStrength;
            int nRawStrength;
            int nRace = GetRacialType(oTest);
            if(nRace == RACIAL_TYPE_OUTSIDER)
                nRawStrength = GetHitDice(oTest);
            else if((nRace == RACIAL_TYPE_UNDEAD && nGoodEvil==ALIGNMENT_EVIL)//undead only for evils
                || nRace == RACIAL_TYPE_ELEMENTAL)
                nRawStrength = GetHitDice(oTest)/2;
            else
                nRawStrength = GetHitDice(oTest)/5;
            if(GetLevelByClass(CLASS_TYPE_CLERIC, oTest) > nRawStrength)
                nRawStrength = GetCasterLvl(CLASS_TYPE_CLERIC, oTest);
                //GetLevelByClass(CLASS_TYPE_CLERIC, oTest);   //use caster level when integrated

            if(nRawStrength == 0)
                nStrength = AURA_STRENGTH_DIM;
            else if(nRawStrength == 1)
                nStrength = AURA_STRENGTH_FAINT;
            else if(nRawStrength >= 2 && nRawStrength <= 4)
                nStrength = AURA_STRENGTH_MODERATE;
            else if(nRawStrength >= 5 && nRawStrength <= 10)
                nStrength = AURA_STRENGTH_STRONG;
            else if(nRawStrength >= 11)
                nStrength = AURA_STRENGTH_OVERWHELMING;

            if(nRound == 2)
            {
                //number & strongest
                nAuraCount++;
                if(nStrength > nStrongestAura)
                    nStrongestAura = nStrength;
                //if overwhelming then can stun
                int nOpposingGoodEvil;
                if(nGoodEvil == ALIGNMENT_EVIL)
                    nOpposingGoodEvil = ALIGNMENT_GOOD;
                else if(nGoodEvil == ALIGNMENT_GOOD)
                    nOpposingGoodEvil = ALIGNMENT_EVIL;
                else
                    nOpposingGoodEvil = -1;
                int nOpposingLawChaos;
                if(nLawChaos == ALIGNMENT_CHAOTIC)
                    nOpposingLawChaos = ALIGNMENT_LAWFUL;
                else if(nLawChaos == ALIGNMENT_LAWFUL)
                    nOpposingLawChaos = ALIGNMENT_CHAOTIC;
                else
                    nOpposingLawChaos = -1;

                if(nStrength == AURA_STRENGTH_OVERWHELMING
                    && (GetAlignmentGoodEvil(OBJECT_SELF)==nOpposingGoodEvil || nOpposingGoodEvil == -1)
                    && (GetAlignmentLawChaos(OBJECT_SELF)==nOpposingLawChaos || nOpposingLawChaos == -1)
                    && nRawStrength > GetHitDice(OBJECT_SELF)*2)
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), OBJECT_SELF, 6.0);
                }
            }
            else if(nRound == 3)
            {
                //strength & location
                ApplyEffectDetectAuraOnObject(nStrength, oTest, nBeamVFX);//                                       "feels"
                FloatingTextStringOnCreature(GetRGB(15,16-(nStrength*3),16-(nStrength*3)) + GetName(oTest) + " " + GetStringByStrRef(16832044) + " "+GetNounForStrength(nStrength)+" "+sAura+".", OBJECT_SELF, FALSE);
            }
        }
        oTest = GetNextObjectInShape(SHAPE_SPELLCONE, 20.0, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    }
    if(nRound==2)
    {
        //reporting
        ApplyEffectDetectAuraOnObject(nStrongestAura, OBJECT_SELF, nBeamVFX);//               "You detected"                                                                                                               "auras"
        FloatingTextStringOnCreature(GetRGB(15,16-(nStrongestAura*3),16-(nStrongestAura*3)) + GetStringByStrRef(16832045) + " " + IntToString(nAuraCount) + " " + GetNounForStrength(nStrongestAura) + " " + sAura + " " + GetStringByStrRef(16832046) + ".", OBJECT_SELF, FALSE);
    }

    //ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 6.0);
    nRound++;
    if(nRound >3)
        nRound = 3;
    ActionDoCommand(DetectAlignmentRound(nRound, lLoc, nGoodEvil, nLawChaos, sAura, nBeamVFX));
}