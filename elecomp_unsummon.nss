/******************************************************************************
26/02/07 - Script By Dragoncin

Desconvoca el Companiero Elemental de un Bonded Summoner
Se ejecuta en la conversacion del mismo (elecomp_conv):
******************************************************************************/

void main()
{
   DestroyObject(OBJECT_SELF, 0.5f);
   effect eFamiliar = EffectVisualEffect(VFX_IMP_UNSUMMON);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFamiliar, GetLocation(OBJECT_SELF));
}
