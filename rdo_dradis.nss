////////////////////////////////////////////////
// Dragon Disciple - Customizaciones del mod
//
/////////////////////////////////////////////////

// Aplica los slots extra dados por la clase, elegidos por la conversacion "rdo_dradis_conv"
void ApplyBonusSpellSlots();
void ApplyBonusSpellSlots()
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR);
    int claseIterada;
    for (claseIterada=1; claseIterada<=3; claseIterada++)
    {
        int clase = GetClassByPosition(claseIterada);
        if (clase == CLASS_TYPE_SORCERER)
        {
            int conjuroIterado;
            for (conjuroIterado=1; conjuroIterado<=9; conjuroIterado++)
            {
                int nBonusSpellSlots = GetCampaignInt("classes", "DraDis_Clase"+IntToString(claseIterada)+"_SpellLvl"+IntToString(conjuroIterado), OBJECT_SELF);
                if (nBonusSpellSlots > 0)
                {
                    itemproperty ipBonusSpellSlot = ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, nBonusSpellSlots);
                    AddItemProperty(DURATION_TYPE_PERMANENT, ipBonusSpellSlot, oSkin);
                }
            }
        }
        else if (clase == CLASS_TYPE_BARD)
        {
            int conjuroIterado;
            for (conjuroIterado=1; conjuroIterado<=6; conjuroIterado++)
            {
                int nBonusSpellSlots = GetCampaignInt("classes", "DraDis_Clase"+IntToString(claseIterada)+"_SpellLvl"+IntToString(conjuroIterado), OBJECT_SELF);
                if (nBonusSpellSlots > 0)
                {
                    itemproperty ipBonusSpellSlot = ItemPropertyBonusLevelSpell(IP_CONST_CLASS_SORCERER, nBonusSpellSlots);
                    AddItemProperty(DURATION_TYPE_PERMANENT, ipBonusSpellSlot, oSkin);
                }
            }
        }
    }
}

void main()
{
    ApplyBonusSpellSlots();
}
