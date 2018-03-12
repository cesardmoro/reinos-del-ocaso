//#include "prc_alterations"
#include "nw_i0_spells"

void main()
{

    //Declare major variables
    //ject oTarget = PRCGetSpellTargetObject();
    effect eLink = CreateDoomEffectsLink();
    effect eStun = EffectStunned();
    location targetLocation = PRCGetSpellTargetLocation();

    int glareDC = 10 + GetLevelByClass(CLASS_TYPE_ACOLYTE) + GetAbilityModifier(ABILITY_CHARISMA);

    object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 30.0, targetLocation, TRUE);
    while (GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOOM));
            //Spell Resistance and Saving throw

            //* GZ Engine fix for mind affecting spell

            int nResult =       WillSave(oTarget, glareDC, SAVING_THROW_TYPE_MIND_SPELLS);
            if (nResult == 2)
            {
                if (GetIsPC(OBJECT_SELF)) // only display immune feedback for PCs
                {
                    FloatingTextStrRefOnCreature(84525, oTarget,FALSE); // * Target Immune
                }
                return;
            }

            nResult = (nResult && MyPRCResistSpell(OBJECT_SELF, oTarget,10+SPGetPenetr()));
            if (!nResult)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget, TurnsToSeconds(1));
                int targetHitPoints = GetMaxHitPoints( oTarget);
                if ( targetHitPoints < 51)
                {
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun , oTarget, RoundsToSeconds(10));
                }
                else if ( targetHitPoints < 101)
                {
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun , oTarget, RoundsToSeconds(3));
                }
                else if ( targetHitPoints < 151)
                {
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun , oTarget, RoundsToSeconds(2));
                }
                else
                {
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun , oTarget, RoundsToSeconds(1));
                }
            }
        }
    oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 30.0, targetLocation, TRUE);
    }


// Getting rid of the local integer storing the spellschool name
}
