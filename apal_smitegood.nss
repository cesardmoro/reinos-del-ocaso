#include "prc_alterations"
#include "prc_inc_smite"

const int FEAT_AP_SMITEGOOD1 = 3459;

void main()
{   
    //handle what feat to decrement
    int iFeat;
    int nClass = GetLevelByClass(CLASS_TYPE_ANTI_PALADIN);
    if (nClass>19) iFeat = FEAT_AP_SMITEGOOD1+3;
    else if (nClass>9) iFeat = FEAT_AP_SMITEGOOD1+2;
    else if (nClass>4) iFeat = FEAT_AP_SMITEGOOD1+1;
    else if (nClass>0) iFeat = FEAT_AP_SMITEGOOD1;

    if (GetHasFeat(FEAT_SMITE_GOOD))
    {
        DecrementRemainingFeatUses(OBJECT_SELF,FEAT_SMITE_GOOD);
        IncrementRemainingFeatUses(OBJECT_SELF,iFeat);
    }
    
    DoSmite(OBJECT_SELF, GetSpellTargetObject(), SMITE_TYPE_GOOD);
}    
