#include "spinc_common"
#include "prc_class_const"


void main ()
{
	//declare variables
	object oPC = OBJECT_SELF;
	effect eBaelnEyes = EffectVisualEffect(VFX_DUR_BAELN_EYES);   
	
	//Apply eyes
	if(GetLevelByClass(CLASS_TYPE_BAELNORN, oPC)> 0)
	{
		if(!GetHasSpellEffect(SPELL_BAELN_EYES, oPC))
		{	
			SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eBaelnEyes, oPC);
		}
	}
}
	

	
	
	