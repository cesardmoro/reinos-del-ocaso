//::///////////////////////////////////////////////
// Evento OnItemEquipped
// Script original por Zero
// Retocado por Dragoncin
//:://////////////////////////////////////////////

//#include "Tesoro_inc"
#include "inventario_inc"
#include "IPS_inc"
#include "InvRed_inc"
#include "Item_inc"
#include "Horses_inc"
#include "Competencias_inc"
#include "RdO_Clases_inc"
#include "ReglasDeLaCasa"
#include "Mod_inc"


int tieneEfectoPolymorph( object creature ) {
    effect effectIterator = GetFirstEffect( creature );
    while( GetIsEffectValid( effectIterator ) ) {
        if( GetEffectType( effectIterator ) == EFFECT_TYPE_POLYMORPH )
            return TRUE;
        effectIterator = GetNextEffect( creature );
    }
    return FALSE;
}

void main() {

    object oItem = GetPCItemLastEquipped();
    object oPC   = GetPCItemLastEquippedBy();

    if( GetIsPC(oPC) && (!GetIsDM(oPC)) ) {
        if( IPS_Item_getIsAdept(oItem) )
            IPS_Subject_onEquip( oPC, oItem );
        else if( !Mod_esItemHabilitadoEquipar( oItem ) && !tieneEfectoPolymorph(oPC) ) {
            //Extension del control de items ilegales
            if( GetTag(oItem) != Tesoro_ITEM_TAG  &&  GetGoldPieceValue(oItem) > 3000 ) {
                SendMessageToPC( oPC, "Este objecto se registra como ilegal: "+GetName(oItem)+", type="+IntToString(GetBaseItemType(oItem)) );
                WriteTimestampedLogEntry(GetName(oPC)+" ha intentado tomar un objeto que se registra como ilegal:"+GetName(oItem)+", type="+IntToString(GetBaseItemType(oItem)) );
                Item_tirar( oItem, oPC );
                return;
            }
            SendMessageToPC( oPC, "ADVERTENCIA: el item '"+GetName(oItem)+"' recién equipado debe ser convertido al nuevo sistema. Tag="+GetTag(oItem) );
            AssignCommand( oPC, ActionUnequipItem( oItem ) );
        }
    }

    ExecuteScript("prc_equip", oPC);

    Competencias_onEquip( oPC, oItem );
    RdO_Classes_onEquip( oPC, oItem );
    Horses_onEquip(oItem, oPC);

    Speed_applyModifiedSpeed( oPC );

    RdlC_ajustarFalloArcano( oPC );

    if (!GetIsDM(oPC) && GetIsPC(oPC)) {
        int tipoBase = GetBaseItemType(oItem);
        if (GetIsInCombat(oPC) == TRUE)
        {
            if ( !(  tipoBase==BASE_ITEM_ARROW ||
                     tipoBase==BASE_ITEM_BOLT ||
                     tipoBase==BASE_ITEM_BULLET ||
                     (GetHasFeat(FEAT_IMPROVED_INITIATIVE, oPC) && (Item_GetIsMeleeWeapon(oItem) || Item_GetIsRangedWeapon(oItem)))
                   )
                )
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oPC, 6.0);
        }

        if ((GetLocalInt(oPC, ESTADO_INVENTARIO_REDUCIDO) == INVENTARIO_REDUCIDO_ACTIVADO) && (GetLocalInt(GetArea(oPC), "puede") != 1))
            inventory_cambiarItem(oPC, oItem);

        InventarioReducido_onEquip(oPC, oItem);
    }
}
