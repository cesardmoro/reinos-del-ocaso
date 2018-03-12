#include "horses_persist"

void matasumon(object oSummon, object oMaster, int incluirUndead = FALSE );
void matasumon(object oSummon, object oMaster, int incluirUndead = FALSE ) {

    if( GetAssociateType(oSummon) == ASSOCIATE_TYPE_DOMINATED && GetMaster(oSummon) == oMaster ) {
        if (!GetIsPersistantHorse(oSummon)) {
            if (GetRacialType(oSummon) != RACIAL_TYPE_UNDEAD) {
                effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetLocation(oSummon));
                AssignCommand(oSummon, SetIsDestroyable(TRUE, FALSE, FALSE));
                DestroyObject(oSummon, 0.1);
            } else if (incluirUndead == TRUE) {
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_10), GetLocation(oSummon));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oSummon)+1), oSummon);
                DestroyObject(oSummon, 3.0);
            }
        }
    }
}

