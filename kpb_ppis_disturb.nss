/////////////////////////////////
//: Kittrell's Persistent Banking
//: kbp_ppis_disturb.css
//: Modified By: Brian J. Kittrell
//: Modified On: 19-2-2004
//:
//: Originally By: OldManWhistler
//: PPIS System
/////////////////////////////////
#include "CIB_frente"

int PPISUserDefinedInventoryLimit(object oPC, int iCount, object oItem)
{
    // Maximum allowable items stored in the vault by any one player.
    if(iCount > 30)
    {
        SendMessageToPC(oPC, "You may not store more than 30 items.");
        return FALSE;
    }
    return TRUE;
}

const string PPIS_COUNT = "PPISCount";

void main()
{

    object oPC = GetLastDisturbed();
    if (!GetIsPC(oPC)) return;
    int iType = GetInventoryDisturbType();
    object oItem = GetInventoryDisturbItem();
    SetLocalInt(oPC, "cambio", 1);
    int iCount = GetLocalInt(OBJECT_SELF, PPIS_COUNT);
    if (iType == INVENTORY_DISTURB_TYPE_ADDED)
    {
        if (GetItemStackSize(oItem) > 1)
        {
            DelayCommand(0.3, AssignCommand(OBJECT_SELF, ActionGiveItem(oItem, oPC)));
            SendMessageToPC(oPC, "No se puede guardar Oro aqui");
        }
        if (GetHasInventory(oItem))
        {
            DelayCommand(0.3, AssignCommand(OBJECT_SELF, ActionGiveItem(oItem, oPC)));
            SendMessageToPC(oPC, "No puedes poner bolsas aqui");
            return;
        }
        if(!PPISUserDefinedInventoryLimit(oPC, iCount, oItem))
        {
            DelayCommand(0.3, AssignCommand(OBJECT_SELF, ActionGiveItem(oItem, oPC)));
            return;
        }
        iCount++;
        SetLocalInt(OBJECT_SELF, PPIS_COUNT, iCount);

        // Agregado por Inquisidor - BEGIN
        // Hace que 'oPC' sea el propietario de 'oItem' si no lo era. Esto evita burlar el CIB guardando en el cofre un ítem del que aún no se es propietario.
        // Notar que cuando este scrip es ejecutado, el onUnaquire del PJ que guarda el item ya fue ejectutado.
        CIB_asignarPropietario( oItem, oPC );
        // Agregado por Inquisidor - END
    }
    else if (iType == INVENTORY_DISTURB_TYPE_REMOVED)
    {
        iCount--;
        SetLocalInt(OBJECT_SELF, PPIS_COUNT, iCount);
    }
    SendMessageToPC(oPC, "Tienes "+IntToString(iCount)+" Items guardados");
}
