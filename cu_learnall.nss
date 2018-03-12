#include "cu_spells"
void main()
{
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
                            DestroyObject(oScroll);
                            SetLocalInt(OBJECT_SELF, "Known_" + IntToString(nId), TRUE);
                        }
                    }
                }
            }
        }
        oScroll = GetNextItemInInventory();
    }
}
