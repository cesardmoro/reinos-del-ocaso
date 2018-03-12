#include "prc_class_const"

void main()
{
    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    location lCaster = GetLocation(oCaster);
    int iLevel       =  GetLevelByClass(CLASS_TYPE_BFZ,OBJECT_SELF);
    int iMaxDis      =  iLevel*6;
    int iDistance    =  FloatToInt(GetDistanceBetweenLocations(lCaster,lTarget));
    int iLeftUse = 1;

    object oTarget=GetSpellTargetObject();
    location lDest;
    if (GetIsObjectValid(oTarget)) lDest=GetLocation(oTarget);
    else lDest=GetSpellTargetLocation();
    effect eVis=EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    vector vOrigin=GetPositionFromLocation(GetLocation(oCaster));
    vector vDest=GetPositionFromLocation(lDest);

    vOrigin=Vector(vOrigin.x+2.0, vOrigin.y-0.2, vOrigin.z);
    vDest=Vector(vDest.x+2.0, vDest.y-0.2, vDest.z);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, Location(GetArea(oCaster), vOrigin, 0.0), 0.8);
    DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, Location(GetArea(oCaster), vDest, 0.0), 0.7));
    DelayCommand(0.8, AssignCommand(oCaster, JumpToLocation(lDest)));

}

