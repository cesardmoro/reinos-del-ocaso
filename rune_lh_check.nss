int StartingConditional()
{
object oPC = OBJECT_SELF;
object oScribe = GetFirstItemInInventory(oPC);

while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {
         if(GetLocalString(oScribe, "lh_bulls") == "1"
          ||GetLocalString(oScribe, "lh_ccw") == "1"
          ||GetLocalString(oScribe, "lh_cmw") == "1"
          ||GetLocalString(oScribe, "lh_csw") == "1"
          ||GetLocalString(oScribe, "lh_divfavor") == "1"
          ||GetLocalString(oScribe, "lh_divpower") == "1"
          ||GetLocalString(oScribe, "lh_rest") == "1"
          ||GetLocalString(oScribe, "lh_rmight") == "1"
          ||GetLocalString(oScribe, "lh_seein") == "1"
          ||GetLocalString(oScribe, "lh_spellr") == "1"
          ||GetLocalString(oScribe, "lh_stone") == "1"
          ||GetLocalString(oScribe, "lh_truestrike") == "1"
          ||GetLocalString(oScribe, "lh_dward") == "1"
          ||GetLocalString(oScribe, "lh_endur") == "1"
          ||GetLocalString(oScribe, "lh_gmw") == "1"
          ||GetLocalString(oScribe, "lh_haste") == "1"
          ||GetLocalString(oScribe, "lh_heal") == "1"
          ||GetLocalString(oScribe, "lh_impinv") == "1"
          ||GetLocalString(oScribe, "lh_invis") == "1"
          ||GetLocalString(oScribe, "lh_keen") == "1"
          ||GetLocalString(oScribe, "lh_pois") == "1")return FALSE;
        }
        oScribe = GetNextItemInInventory(oPC);
      }
      return TRUE;
}

