/*****************************************************************************
ACCION DE CARGA

Si hay una linea recta al objetivo, el personaje corre y ataca, causando mas daño
*****************************************************************************/

#include "prc_inc_combat"
#include "RdO_const_feat"
#include "Item_inc"

void main()
{
    object oTarget = GetSpellTargetObject();
    if (GetIsObjectValid(oTarget) && oTarget!=OBJECT_SELF)
    {
        float distanciaAlObjetivo = GetDistanceToObject(oTarget);
        if (distanciaAlObjetivo >= 10.0)
        {
            if (LineOfSightObject(OBJECT_SELF, oTarget))
            {
                object objetoIterado = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, distanciaAlObjetivo, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE);
                int numeroObjetos = 0;
                while (GetIsObjectValid(objetoIterado))
                {
                    numeroObjetos++;
                    if (numeroObjetos > 0) break;
                    objetoIterado = GetNextObjectInShape(SHAPE_SPELLCYLINDER, distanciaAlObjetivo, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE);
                }
                // Si no hay nada en el camino
                if (numeroObjetos == 0)
                {
                    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
                    if (IPGetIsMeleeWeapon(oWeapon))
                    {
                        int damageBonus = 2;
                        // Doble daño si se trata de una lanza o si tiene la dote Spirited Charge
                        if (GetBaseItemType(oWeapon)==BASE_ITEM_SHORTSPEAR || GetHasFeat(FEAT_SPIRITED_CHARGE))
                            damageBonus = GetWeaponDamagePerRound(oTarget, OBJECT_SELF, oWeapon);
                        PerformAttack(oTarget, OBJECT_SELF, EffectVisualEffect(VFX_NONE), 0.0, 2, damageBonus, Item_GetWeaponDamageType(oWeapon), "Carga exitosa!", "Carga faliida!");
                    }
                    else
                        FloatingTextStringOnCreature("Debes cargar con un arma cuerpo a cuerpo", OBJECT_SELF, FALSE);
                }
                else
                    FloatingTextStringOnCreature("No pudes tener en el camino para poder Cargar", OBJECT_SELF, FALSE);
            }
            else
                FloatingTextStringOnCreature("Debes tener linea de vision hasta el objetivo", OBJECT_SELF, FALSE);
        }
        else
            FloatingTextStringOnCreature("Debes estar mas lejos del objetivo para Cargar", OBJECT_SELF, FALSE);
    }
    else
        FloatingTextStringOnCreature("Esta accion debe realizarse sobre una criatura", OBJECT_SELF, FALSE);
}
