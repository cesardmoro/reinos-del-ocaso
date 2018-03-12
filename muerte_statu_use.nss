////////////
// Script By Zero
//
// Empieza la conversacion con la estatua del Plano de la Fuga
/////////////

#include "muerte_inc"

void main()
{
    object oPC = GetLastUsedBy();
    AssignCommand(oPC, ActionStartConversation(oPC, "muerte_conv", TRUE, FALSE));
}
