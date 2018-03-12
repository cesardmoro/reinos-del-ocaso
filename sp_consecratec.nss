#include "prc_alterations"
#include "spinc_common"
#include "prc_spell_const"

void main()
{

    effect eVis = EffectVisualEffect(VFX_FNF_STRIKE_HOLY );
   ActionDoCommand(SetAllAoEInts(SPELL_CONCECRATE,OBJECT_SELF, GetSpellSaveDC() ));

    object oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    //Declare the spell shape, size and the location.
    while(GetIsObjectValid(oTarget))
    {
        if (MyPRCGetRacialType(oTarget)==RACIAL_TYPE_UNDEAD)
        {
              if(!GetHasSpellEffect(SPELL_CONCECRATE, oTarget))
              {

                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    DestroyObject(oTarget);
              }


        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    }

}
