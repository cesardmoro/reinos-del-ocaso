int StartingConditional()
{
object oPC = OBJECT_SELF;
object oScribe = GetFirstItemInInventory(oPC);

while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {
         if(GetLocalString(oScribe, "ra_bulls") == "1"
          ||GetLocalString(oScribe, "ra_ccw") == "1"
          ||GetLocalString(oScribe, "ra_cmw") == "1"
          ||GetLocalString(oScribe, "ra_csw") == "1"
          ||GetLocalString(oScribe, "ra_divfavor") == "1"
          ||GetLocalString(oScribe, "ra_divpower") == "1"
          ||GetLocalString(oScribe, "ra_rest") == "1"
          ||GetLocalString(oScribe, "ra_rmight") == "1"
          ||GetLocalString(oScribe, "ra_seein") == "1"
          ||GetLocalString(oScribe, "ra_spellr") == "1"
          ||GetLocalString(oScribe, "ra_stone") == "1"
          ||GetLocalString(oScribe, "ra_truestrike") == "1"
          ||GetLocalString(oScribe, "ra_dward") == "1"
          ||GetLocalString(oScribe, "ra_endur") == "1"
          ||GetLocalString(oScribe, "ra_gmw") == "1"
          ||GetLocalString(oScribe, "ra_haste") == "1"
          ||GetLocalString(oScribe, "ra_heal") == "1"
          ||GetLocalString(oScribe, "ra_impinv") == "1"
          ||GetLocalString(oScribe, "ra_invis") == "1"
          ||GetLocalString(oScribe, "ra_keen") == "1"
          ||GetLocalString(oScribe, "ra_pois") == "1")return FALSE;
        }
        oScribe = GetNextItemInInventory(oPC);
      }
      return TRUE;
}

