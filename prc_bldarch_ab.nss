// Acidic Blood for the Bloodarcher by Zedium
#include "prc_alterations"
#include "prc_feat_const"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"


void main()
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eDam;

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget) && GetLevelByClass(CLASS_TYPE_BLARCHER, oTarget) < 1 )
    {           
         if(!GetIsFriend(oTarget) )
         {
              eDam = EffectDamage(d6(1), DAMAGE_TYPE_ACID);
              ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
              ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);             
         }
         oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation(OBJECT_SELF));
    }
}