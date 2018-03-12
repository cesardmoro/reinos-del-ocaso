#include "spinc_common"
#include "x2_inc_spellhook"
#include "prc_alterations"


void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", IP_CONST_SPELLSCHOOL_EVOCATION);
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
ActionDoCommand(SetAllAoEInts(SPELL_CONCECRATE,OBJECT_SELF, GetSpellSaveDC() ));


    //Declare major variables
    object oTarget = GetEnteringObject();

    effect eVis =  EffectVisualEffect(VFX_DUR_SANCTUARY);

    if (MyPRCGetRacialType(oTarget)==RACIAL_TYPE_UNDEAD)
    {


        effect eAtk = EffectAttackDecrease(1);
        effect eDmg = EffectDamageDecrease(1,DAMAGE_TYPE_SLASHING);
        effect eSav = EffectSavingThrowDecrease(SAVING_THROW_ALL,1);
        effect eNegDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

        effect eNegLink = EffectLinkEffects(eAtk, eDmg);
               eNegLink = EffectLinkEffects(eNegLink, eSav);
               eNegLink = EffectLinkEffects(eNegLink, eNegDur);

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNegLink, oTarget);

    }


 DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
