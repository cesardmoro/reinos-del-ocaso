int StartingConditional()
{
object oPC = OBJECT_SELF;
object oScribe = GetFirstItemInInventory(oPC);

while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {
         if(GetLocalString(oScribe, "lc_bulls") == "1"
          ||GetLocalString(oScribe, "lc_ccw") == "1"
          ||GetLocalString(oScribe, "lc_cmw") == "1"
          ||GetLocalString(oScribe, "lc_csw") == "1"
          ||GetLocalString(oScribe, "lc_divfavor") == "1"
          ||GetLocalString(oScribe, "lc_divpower") == "1"
          ||GetLocalString(oScribe, "lc_rest") == "1"
          ||GetLocalString(oScribe, "lc_rmight") == "1"
          ||GetLocalString(oScribe, "lc_seein") == "1"
          ||GetLocalString(oScribe, "lc_spellr") == "1"
          ||GetLocalString(oScribe, "lc_stone") == "1"
          ||GetLocalString(oScribe, "lc_truestrike") == "1"
          ||GetLocalString(oScribe, "lc_dward") == "1"
          ||GetLocalString(oScribe, "lc_endur") == "1"
          ||GetLocalString(oScribe, "lc_gmw") == "1"
          ||GetLocalString(oScribe, "lc_haste") == "1"
          ||GetLocalString(oScribe, "lc_heal") == "1"
          ||GetLocalString(oScribe, "lc_impinv") == "1"
          ||GetLocalString(oScribe, "lc_invis") == "1"
          ||GetLocalString(oScribe, "lc_keen") == "1"
          ||GetLocalString(oScribe, "lc_pois") == "1")return FALSE;
        }
        oScribe = GetNextItemInInventory(oPC);
      }
      return TRUE;
}

