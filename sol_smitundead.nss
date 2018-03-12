#include "prc_alterations"
#include "prc_inc_smite"

void main()
{
    //decrements and stuff is automatic
    
    DoSmite(OBJECT_SELF, GetSpellTargetObject(), SMITE_TYPE_UNDEAD);
}

