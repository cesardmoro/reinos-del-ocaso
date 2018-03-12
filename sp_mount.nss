/******************************************************************
  Mount

  Conjuration (Summoning)
  Level: Sor/Wiz 1
  Components: V, S, M
  Casting Time: 1 round
  Range: Close (25 ft. + 5 ft./2 levels)
  Effect: One mount
  Duration: 2 hours/level (D)
  Saving Throw: None
  Spell Resistance: No

  You summon a light horse or a pony (your choice) to serve you as a mount. The
  steed serves willingly and well. The mount comes with a bit and bridle and a
  riding saddle.

  Material Component: A bit of horse hair.
******************************************************************/

#include "spinc_common"
#include "Horses_inc"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    SPSetSchool(SPELL_SCHOOL_CONJURATION);

    object oCaster = OBJECT_SELF;
    float duration = HoursToSeconds( PRCGetCasterLevel() * 2 );
    location targetLocation = GetSpellTargetLocation();
    effect eVis = EffectVisualEffect( VFX_FNF_SUMMON_MONSTER_1 );

    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, targetLocation );
    object oMount = CreateObject( OBJECT_TYPE_CREATURE, "rdohorse_2", targetLocation, FALSE, Horses_GetHorseTag(0, oCaster) );
    Horses_StartFollowing( oMount, oCaster );
    SetLocalObject(oMount, Horses_OWNER, oCaster);
    SetLocalObject(oCaster, Horses_TAG_PREFIX+IntToString(0), oMount);

    DestroyObject( oMount, duration );
    DelayCommand( duration, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oMount)) );
    DelayCommand( duration, Horses_voidDisMount(oCaster, FALSE) );

    SPSetSchool();
}
