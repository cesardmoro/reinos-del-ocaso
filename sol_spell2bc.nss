#include "spinc_common"
#include "prc_spell_const"

void main()
{

ActionDoCommand(SetAllAoEInts(SPELL_SOL_CONCECRATE,OBJECT_SELF, GetSpellSaveDC(),0,GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT,GetAreaOfEffectCreator())));
 
    effect eVis = EffectVisualEffect(VFX_FNF_STRIKE_HOLY );

    object oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    //Declare the spell shape, size and the location.
    while(GetIsObjectValid(oTarget))
    {
        if (MyPRCGetRacialType(oTarget)==RACIAL_TYPE_UNDEAD)
        {
              if(!GetHasSpellEffect(SPELL_SOL_CONCECRATE, oTarget))
              {

                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    DestroyObject(oTarget);
              }


        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    }

}
