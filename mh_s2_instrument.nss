#include "prc_alterations"
#include "x2_inc_craft"
#include "prc_inc_clsfunc"

void main()
{
    //object oCaster = GetLastSpellCaster();
    object oCaster = OBJECT_SELF;

    if(GetLocalInt(oCaster,"use_CIMM"))
    {
        UnactiveModeCIMM(oCaster);
    }
    else
    {
        ActiveModeCIMM(oCaster);
    }
}
