///////////////////////
// Ajustes de Velocidad para criaturas y PJs
// 01/06/07 - Script By Dragoncin
//
// Scripts que dependen de este:
// - mod_onenter
// - mod_onequip
// - mod_onunequip
// - mod_on_item_act
// - horses_dlg_mount
/////////////////////

#include "Horses_props_inc"
#include "inc_item_props"
#include "rdo_spinc"


const string Speed_EFFECT_CREATOR = "Speed_EFFECT_CREATOR";

// Devuelve el incremento o decremento porcentual de la la velocidad de la criatura
// en base a su armadura, su raza y su montura
// Atencion: devuelve el porcentaje en negativo si es una reduccion de velocidad
// y positivo si es un aumento de velocidad
int Speed_GetModifiedSpeedPercentChange( object oPC );
int Speed_GetModifiedSpeedPercentChange( object oPC )
{
    float baseSpeed = 30.0;
    float actualSpeed = baseSpeed;

    if (GetIsMounted(oPC)) {

        actualSpeed = Horses_GetMountSpeed(oPC);
        actualSpeed -= GetLevelByClass(CLASS_TYPE_MONK, oPC) * 10.0;

    } /*else {

        int racialType = GetRacialType(oPC);
        if (    racialType == RACIAL_TYPE_DWARF ||
                racialType == RACIAL_TYPE_GNOME ||
                racialType == RACIAL_TYPE_HALFLING
            )
            actualSpeed -= 5.0;

        if (GetBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) > 4 && racialType != RACIAL_TYPE_DWARF)
            actualSpeed -= 5.0;

    } */
    //SendMessageToPC(oPC, "ActualSpeed: "+FloatToString(actualSpeed));

    int speedPercentChange = FloatToInt( 100 * actualSpeed / baseSpeed )-100;

    if (speedPercentChange >= 100) speedPercentChange = 99;
    else if (speedPercentChange <= -100) speedPercentChange = -99;
    //SendMessageToPC(oPC, "speedPercentChange: "+IntToString(speedPercentChange));

    return speedPercentChange;
}


// Ajusta la velocidad de la criatura
// en base a su armadura, su raza y su montura
void Speed_applyModifiedSpeed( object oPC = OBJECT_SELF );
void Speed_applyModifiedSpeed( object oPC = OBJECT_SELF )
{
    object speedEffectCreator = RDO_GetCreatorByTag(Speed_EFFECT_CREATOR);

    RDO_RemoveEffectsByCreator(oPC, speedEffectCreator);

    int speedPercentChange = Speed_GetModifiedSpeedPercentChange(oPC);
    if (speedPercentChange > 0)
        AssignCommand(speedEffectCreator, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedIncrease(speedPercentChange)), oPC));
    else if(speedPercentChange < 0)                                                                                                   //muy importante el - de aca abajo
        AssignCommand(speedEffectCreator, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedDecrease(-speedPercentChange)), oPC));

}
