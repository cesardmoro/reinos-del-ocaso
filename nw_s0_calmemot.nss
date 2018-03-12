//::///////////////////////////////////////////////
//:: Calm Emotions
//:: NW_S0_CalmEmot.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: [Description of File]
//:://////////////////////////////////////////////
//:: Created By: [Your Name]
//:: Created On: [date]
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
 
 #include "spinc_common"
 
void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);



    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eImpact = EffectVisualEffect(192);//VFX_FNF_LOS_NORMAL_20
    location lLocal = GetSpellTargetLocation();

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal);
    while(GetIsObjectValid(oTarget))
    {
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(2),FALSE);
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}

