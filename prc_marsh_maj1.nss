#include "x0_i0_spells"

void main()
{
     string sMes = "";
     object oPC = OBJECT_SELF;
                  
     if(!GetHasSpellEffect(GetSpellId()))
     { 
        //Declare major variables including Area of Effect Object
        object oTarget = GetSpellTargetObject();
        
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAreaOfEffect(156), oTarget);
        sMes = "*Major Aura Activated*";
     }
     else     
     {
        // Removes effects
        RemoveSpellEffects(GetSpellId(), oPC, oPC);
        sMes = "*Major Aura Deactivated*";
        DeleteLocalInt(oPC,"MarshalMajor");
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}