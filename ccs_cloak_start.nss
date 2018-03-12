/* Modificacion by Dragoncin

Originalmente no existia este Script. Lo que hace es evitar que la capa actual pueda ser el modelo 0 (cero)
y que el jugador pueda perder su capa.
*/

void main()
{
    int nModel = GetLocalInt(OBJECT_SELF, "current_cloak_model");
    if (nModel == 0) {
        nModel = 1;
        SetLocalInt(OBJECT_SELF, "current_cloak_model", nModel);
        // Unequip current cloak
        object oOldCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, OBJECT_SELF);
        AssignCommand(OBJECT_SELF, ActionUnequipItem(oOldCloak));
        // Equip next cloak
        object oNewCloak = GetItemPossessedBy(OBJECT_SELF, "cloak_model_" + IntToString(nModel));
    }
}
