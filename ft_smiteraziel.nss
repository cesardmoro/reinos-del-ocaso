#include "prc_alterations"
#include "prc_inc_smite"


void main()
{   
    //handle what feat to decrement
    int LvlRaziel=GetLevelByClass(CLASS_TYPE_FISTRAZIEL);
    int iFeat=(LvlRaziel+1)/2+FEAT_SMITE_GOOD_ALIGN-1;

    if (GetHasFeat(FEAT_SMITE_EVIL))
    {
        DecrementRemainingFeatUses(OBJECT_SELF,FEAT_SMITE_EVIL);
        IncrementRemainingFeatUses(OBJECT_SELF,iFeat);
    }    
    
    DoSmite(OBJECT_SELF, PRCGetSpellTargetObject(), SMITE_TYPE_EVIL);
}