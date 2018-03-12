#include "cu_spells"


int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF, "AllScrollsFound")) return FALSE;
    int nScrollNum = GetLocalInt(OBJECT_SELF, "ScrollNum") + 1;
    int nScrollSlot = GetLocalInt(OBJECT_SELF, "ScrollSlot") + 1;
    int nFound;
    SetLocalInt(OBJECT_SELF, "ScrollSlot", nScrollSlot);
    SetLocalInt(OBJECT_SELF, "ScrollNum", nScrollNum);
    object oScroll = GetFirstItemInInventory();
    while (GetIsObjectValid(oScroll))
    {
        if (GetBaseItemType(oScroll) == BASE_ITEM_SPELLSCROLL)
        {
            int nId = GetScrollSpellId(oScroll);
            if (nId >= 0)
            {
                string sLevel = CU_Get2DAString("spells", "Wiz_Sorc", nId);
                if (sLevel != "")
                {
                    int nLevel = StringToInt(sLevel);
                    int nMaxLevel = (GetLevelByClass(CLASS_TYPE_WIZARD) + 1) / 2;
                    if (nLevel < nMaxLevel)
                    {
                        int nKnown = GetLocalInt(OBJECT_SELF, "Known_" + IntToString(nId));
                        if (!nKnown)
                        {
                            nFound++;
                            if (nFound == nScrollNum)
                            {
                                SetCustomToken(399 + nScrollSlot, GetName(oScroll));
                                SetLocalObject(OBJECT_SELF, "ScrollSlotScroll_" + IntToString(nScrollSlot), oScroll);
                                SetLocalInt(OBJECT_SELF, "ScrollSlotId_" + IntToString(nScrollSlot), nId);
                                return TRUE;
                            }
                        }
                    }
                }
            }
        }
        oScroll = GetNextItemInInventory();
    }
    SetLocalInt(OBJECT_SELF, "AllScrollsFound",TRUE);
    return FALSE;
}
