//::///////////////////////////////////////////////
//:: Glyph of Warding Heartbet
//:: x2_o0_glyphhb
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default Glyph of warding damage script

    This spellscript is fired when someone triggers
    a player cast Glyph of Warding


    Check x2_o0_hhb.nss and the Glyph of Warding
    placeable object for details

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-02
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "x0_i0_spells"

void DoDamage(int nDamage, object oTarget)
{
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eDam = EffectDamage(nDamage, ChangedElementalDamage(GetAreaOfEffectCreator(), DAMAGE_TYPE_SONIC));
    if(nDamage > 0)
    {
        //Apply VFX impact and damage effect
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(0.01,SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    }
}

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

ActionDoCommand(SetAllAoEInts(SPELL_GLYPH_OF_WARDING,OBJECT_SELF, GetSpellSaveDC()));


  //Declare major variables
    object oTarget = GetLocalObject(OBJECT_SELF,"X2_GLYPH_LAST_ENTER");
    location lTarget = GetLocation(OBJECT_SELF);
    effect eDur = EffectVisualEffect(445);
    int nDamage;
    int nCasterLevel =   GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_CASTER_LEVEL");
    int nMetaMagic = GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_CASTER_METAMAGIC");
    object oCreator = GetLocalObject(OBJECT_SELF,"X2_PLC_GLYPH_CASTER") ;

    int nPenetr = SPGetPenetrAOE(oCreator,nCasterLevel);
    


    if ( GetLocalInt (OBJECT_SELF,"X2_PLC_GLYPH_PLAYERCREATED") == 0 )
    {
        oCreator = OBJECT_SELF;
    }

    if (!GetIsObjectValid(oCreator))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    int nDice = nCasterLevel /2;

    if (nDice > 5)
        nDice = 5;
    else if (nDice <1 )
        nDice = 1;

    effect eDam;
    effect eExplode = EffectVisualEffect(459);

    //Check the faction of the entering object to make sure the entering object is not in the casters faction

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Cycle through the targets in the explosion area
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
            if (spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,oCreator))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oCreator, GetSpellId()));
                //Make SR check
                if (!MyPRCResistSpell(oCreator, oTarget,nPenetr))
                {
                    int nDC = GetChangesToSaveDC(oTarget,oCreator);
                    nDamage = d8(nDice);
                    //Enter Metamagic conditions

                    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                    {
                        nDamage = 8 * 5;//Damage is at max
                    }
                    else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                    {
                        nDamage = nDamage + (nDamage/2);//Damage/Healing is +50%
                    }

                    //Change damage according to Reflex, Evasion and Improved Evasion
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC()  + nDC), SAVING_THROW_TYPE_SONIC, oCreator);


                    //----------------------------------------------------------
                    // Have the creator do the damage so he gets feedback strings
                    //----------------------------------------------------------
                    if (oCreator != OBJECT_SELF)
                    {
                        AssignCommand(oCreator, DoDamage(nDamage,oTarget));
                    }
                    else
                    {
                        DoDamage(nDamage,oTarget);
                    }

                }
            }
             //Get next target in the sequence
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
