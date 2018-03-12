//mimic shifter class feat script

#include "pnp_shft_main"

void main()
{
	if (CanShift(OBJECT_SELF))
	{
		object oTarget = GetSpellTargetObject();
		if (GetValidShift(OBJECT_SELF,oTarget))
		{
			SetShift(OBJECT_SELF,oTarget);
			RecognizeCreature( OBJECT_SELF, GetResRef(oTarget), GetName(oTarget) ); //recognize now takes the name of oTarget as well as the resref
			if (!GetHasFeat(FEAT_PRESTIGE_SHIFTER_GWSHAPE_1, OBJECT_SELF))  //if your out of GWS
			{
				if (GetHasFeat(FEAT_WILD_SHAPE, OBJECT_SELF)) //and you have DWS left
				{
					if(GetLocalInt(OBJECT_SELF, "DWS") == 1) //and you wont to change then over to GWS
					{
						IncrementRemainingFeatUses(OBJECT_SELF,FEAT_PRESTIGE_SHIFTER_GWSHAPE_1); // +1 GWS
						DecrementRemainingFeatUses(OBJECT_SELF,FEAT_WILD_SHAPE); //-1 DWS
					}
				}
			}
		}
		else
			IncrementRemainingFeatUses(OBJECT_SELF,FEAT_PRESTIGE_SHIFTER_GWSHAPE_1); // only uses a feat if they shift
	}
	else
	{
		IncrementRemainingFeatUses(OBJECT_SELF,FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1); // only uses a feat if they shift
	}

}



