#include "prc_alterations"

void main()
{
     string sMes = "";
     object oPC = OBJECT_SELF;    
     
     if(!GetHasSpellEffect(GetSpellId()))
     { 
        //Declare major variables including Area of Effect Object
        object oTarget = PRCGetSpellTargetObject();
        
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAreaOfEffect(155), oTarget);
        sMes = "*Minor Aura Activated*";
     }
     else     
     {
        // Removes effects
        RemoveSpellEffects(GetSpellId(), oPC, oPC);
        sMes = "*Minor Aura Deactivated*";
        DeleteLocalInt(oPC,"MarshalMinor");
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}