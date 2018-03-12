

#include "prc_inc_clsfunc"
void main()
{
    object oSamurai = GetLocalObject(OBJECT_SELF,"CODI_SAMURAI");
    if(oSamurai != OBJECT_INVALID && GetIsPC(oSamurai))
    {
        int iValue = 0;
        object oItem = GetFirstItemInInventory();
        effect eVis = EffectVisualEffect(VFX_FNF_SMOKE_PUFF);
        while(oItem != OBJECT_INVALID)
        {
            if(!GetPlotFlag(oItem))
            {
                iValue = iValue + GetGoldPieceValue(oItem)/2;
                DestroyObject(oItem);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
            }
            oItem = GetNextItemInInventory();
        }
        if (iValue > 0)
        {
            object oToken = GetSamuraiToken(oSamurai);
            if(oToken == OBJECT_INVALID)
            {
                oToken = CreateItemOnObject("codi_sam_token",oSamurai);
            }
            int iCurrentValue = StringToInt(GetTag(oToken));
            object oNewToken = CopyObject(oToken, GetLocation(oSamurai), oSamurai, IntToString(iCurrentValue + iValue));
            DestroyObject(oToken);
            SendMessageToPC(oSamurai, "Your sacrifice is accepted. You now have " + IntToString(iCurrentValue + iValue) + " gold in sacrifices. Do not lose your token of sacrifice, or you will forfeit this value.");
        }
    }
}
