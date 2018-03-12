/*****************************************************************************
Bard Song of Freedom

Gasta un uso de cancion y quita todas las compulsiones (dominacion, charm, etc)
de todas las criaturas en 30 pies
*****************************************************************************/
#include "nw_i0_generic"

void main()
{
    if (!GetHasEffect(EFFECT_TYPE_SILENCE))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_BARD_SONG), OBJECT_SELF);
        object objetoIterado = GetFirstObjectInShape(SHAPE_SPHERE, 15.0, GetLocation(OBJECT_SELF));
        while (GetIsObjectValid(objetoIterado))
        {
            if (!GetHasEffect(EFFECT_TYPE_DEAF, objetoIterado))
            {
                effect efectoIterado = GetFirstEffect(objetoIterado);
                while (GetIsEffectValid(efectoIterado))
                {
                    int tipoDeEfecto = GetEffectType(efectoIterado);
                    if ((tipoDeEfecto == EFFECT_TYPE_DOMINATED ||
                         tipoDeEfecto == EFFECT_TYPE_CHARMED) &&
                         GetLocalInt(objetoIterado, "merc")!=TRUE
                       )
                        RemoveEffect(objetoIterado, efectoIterado);
                    efectoIterado = GetNextEffect(objetoIterado);
                }
            }
            objetoIterado = GetNextObjectInShape(SHAPE_SPHERE, 15.0, GetLocation(OBJECT_SELF));
        }
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
    }
}
