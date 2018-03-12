//::///////////////////////////////////////////////
//:: Time Stop
//:: NW_S0_TimeStop.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All persons in the Area are frozen in time
    except the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002         EffectCutsceneParalyze
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
//:: modified by dragoncin   Apr 4, 2008



#include "x2_inc_spellhook"

int GetHasEffectByType( int effectType, object oCreature );
int GetHasEffectByType( int effectType, object oCreature )
{
    effect efectoIterado = GetFirstEffect( oCreature );
    while (GetIsEffectValid( efectoIterado ))
    {
        if (GetEffectType( efectoIterado ) == effectType)
            return TRUE;
        efectoIterado = GetNextEffect( oCreature );
    }
    return FALSE;
}

// Aplica el efecto eTimeStop a todas las criaturas en el area de oCaster
// por la duracion durationLeft
void TimeStop( effect eTimeStop, float durationLeft, object oCaster );
void TimeStop( effect eTimeStop, float durationLeft, object oCaster )
{
    if (GetIsObjectValid( oCaster ))
    {
        object area = GetArea( oCaster );
        object objetoIterado;
        // chequeo que area sea un objeto valido en caso que el caster haya decidido teleportar
        // o cambiar de area
        if (GetIsObjectValid( area ))
        {
            objetoIterado = GetFirstObjectInArea( area );
            while (GetIsObjectValid( objetoIterado ))
            {
                if ( objetoIterado != oCaster && GetObjectType(objetoIterado) == OBJECT_TYPE_CREATURE )
                {
                    if (!GetHasEffectByType( EFFECT_TYPE_CUTSCENE_PARALYZE, objetoIterado ))
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTimeStop, objetoIterado, durationLeft);
                    }
                }
                objetoIterado = GetNextObjectInArea( area );
            }
        }
    }
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
    effect eTimeStop = EffectCutsceneParalyze();
    int nRoll = 1 + d4();

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TIME_STOP, FALSE));
    int CasterLvl = GetCasterLevel(oCaster);

    //Applythe VFX impact and effects
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);

    float durationInSeconds = RoundsToSeconds( nRoll );
    TimeStop( eTimeStop, durationInSeconds, oCaster );
    int i;
    for (i=1; i<FloatToInt(durationInSeconds); i++)
    {
        DelayCommand( IntToFloat(i), TimeStop(eTimeStop, (durationInSeconds-IntToFloat(i)), oCaster) );
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
