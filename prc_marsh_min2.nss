#include "prc_alterations"

void main()
{
     string sMes = "";
     object oPC = OBJECT_SELF;
     
     if(!GetHasSpellEffect(GetSpellId()))
     { 
	//Declare major variables including Area of Effect Object
    	object oTarget = PRCGetSpellTargetObject();
	
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAreaOfEffect(156), oTarget);
     	sMes = "*Aura: Force of Will Activated*";
     }
     else     
     {
	// Removes effects
	RemoveSpellEffects(GetSpellId(), oPC, oPC);
	sMes = "*Aura: Force of Will Deactivated*";
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}
