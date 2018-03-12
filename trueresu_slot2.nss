#include "sp_resu_inc"

const int DEAD_PLAYER_SLOT = 2;

void main()
{
    object oCaster = GetPCSpeaker();
    object pjRevivido = GetLocalObject(oCaster, TrueResurrection_deadPlayerSlot_VN_PREFIX+IntToString(DEAD_PLAYER_SLOT));
    location dondeRevivir = GetLocalLocation(oCaster, TrueResurrection_targetLocation_VN);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_CELESTIAL), dondeRevivir);
    SetLocalInt(pjRevivido, Muerte_condicionResurreccion_VN, Muerte_REVIVIDO_CON_TRUERESURRECTION);
    AssignCommand(pjRevivido, Location_forcedJump(dondeRevivir));
}
