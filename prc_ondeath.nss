//
// Stub function for possible later use.
//
#include "matasumon"
void main()
{

   object oPlayer = GetLastPlayerDied();
   object Asso = GetLocalObject(oPlayer, "BONDED");
   if (GetIsObjectValid(Asso))
   {
     effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
     ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetLocation(Asso));
     DestroyObject(Asso);
   }
   object oSummon = GetFirstFactionMember(oPlayer, FALSE);
   while(GetIsObjectValid(oSummon))
   {
   matasumon(oSummon);
   }
}
