#include "Muerte_inc"
#include "Location_tools"

const string TrueResurrection_deadPlayerSlot_VN_PREFIX = "deadPlayerSlot";
const string TrueResurrection_targetLocation_VN        = "trueResuTarget";

const string ResurrectCreature_lastWasSuccessful_VN = "rcLWS";


void removeNegativeEffects( object creature ) {
    //Search for negative effects
    effect eBad = GetFirstEffect(creature);
    while(GetIsEffectValid(eBad)) {
        int effectType = GetEffectType( eBad );
        if(
            effectType == EFFECT_TYPE_ABILITY_DECREASE ||
            effectType == EFFECT_TYPE_AC_DECREASE ||
            effectType == EFFECT_TYPE_ATTACK_DECREASE ||
            effectType == EFFECT_TYPE_DAMAGE_DECREASE ||
            effectType == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            effectType == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            effectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            effectType == EFFECT_TYPE_SKILL_DECREASE ||
            effectType == EFFECT_TYPE_BLINDNESS ||
            effectType == EFFECT_TYPE_DEAF ||
            effectType == EFFECT_TYPE_PARALYZE ||
            effectType == EFFECT_TYPE_NEGATIVELEVEL
        ) {
            RemoveEffect(creature, eBad);
        }
        eBad = GetNextEffect(creature);
    }
}


// Revive a la criatura muerta y devuelve si se pudo revivir o no
// healAllHPs indica si se debe curar al sujeto por completo
// restoreSpells indica si se debe recuperar los conjuros memorizados por el sujeto
int ResurrectCreature( object oTarget, int spellCost, int tipoResurreccion, object oCaster = OBJECT_SELF );
int ResurrectCreature( object oTarget, int spellCost, int tipoResurreccion, object oCaster = OBJECT_SELF )
{
    //Declare major variables
    int result = FALSE;
    //Fire cast spell at event for the specified target
    if(GetIsDead(oTarget))
    {
        if (GetTag(oTarget)=="cuerpoPj")
        {
            object cadaver = oTarget;

            object oPC = Muerte_getPjDadoCadaver( cadaver );

            if (GetIsObjectValid(oPC)) {
                location ubicacionCadaver = GetLocation(cadaver);
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), ubicacionCadaver );
                SetLocalInt(oPC, Muerte_condicionResurreccion_VN, tipoResurreccion); // recuerda que tipo de resurrección es realizada a 'oPC', para que cuando salga del fugue se le aplique el daño y consume de hechizos adecuado.
                AssignCommand( oPC, Location_forcedJump( ubicacionCadaver ) );
                // De destruir el cadaver, aplicar el daño, y consumir los hechizos, se ocupa el onEnter del área al que vaya (ver Muerte_onPjEnteresArea(..) )
                result = TRUE;
            }
        }
        else
        {
            int creatureRace = GetRacialType(oTarget);
            if (
                creatureRace != RACIAL_TYPE_CONSTRUCT && // Modificado por Inquisidor: cambie los || por &&
                creatureRace != RACIAL_TYPE_ELEMENTAL &&
                creatureRace != RACIAL_TYPE_FEY &&
                creatureRace != RACIAL_TYPE_HUMANOID_MONSTROUS &&
                creatureRace != RACIAL_TYPE_INVALID &&
                creatureRace != RACIAL_TYPE_OOZE &&
                creatureRace != RACIAL_TYPE_OUTSIDER &&
                creatureRace != RACIAL_TYPE_UNDEAD
            ) {
                removeNegativeEffects( oTarget );

                //AssignCommand(oTarget, SetIsDestroyable(TRUE, TRUE, TRUE) ); // ¿sirve esta linea? ¿acaso no se ejecuta después cuando ya es inútil?
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), GetLocation(oTarget));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oTarget);
                if (tipoResurreccion != Muerte_REVIVIDO_CON_RAISE_DEAD)
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oTarget)), oTarget);
                result = TRUE;
            }
        }
    }

    if( result ) {
        TakeGoldFromCreature(spellCost, oCaster, TRUE);
        SetLocalInt( oCaster, ResurrectCreature_lastWasSuccessful_VN, TRUE );
    }
    else
        DeleteLocalInt( oCaster, ResurrectCreature_lastWasSuccessful_VN );

    return result;
}
