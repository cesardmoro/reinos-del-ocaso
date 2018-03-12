int StartingConditional()
{
object oPC = OBJECT_SELF;
object oScribe = GetFirstItemInInventory(oPC);

while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {
         if(GetLocalString(oScribe, "rh_bulls") == "1"
          ||GetLocalString(oScribe, "rh_ccw") == "1"
          ||GetLocalString(oScribe, "rh_cmw") == "1"
          ||GetLocalString(oScribe, "rh_csw") == "1"
          ||GetLocalString(oScribe, "rh_divfavor") == "1"
          ||GetLocalString(oScribe, "rh_divpower") == "1"
          ||GetLocalString(oScribe, "rh_rest") == "1"
          ||GetLocalString(oScribe, "rh_rmight") == "1"
          ||GetLocalString(oScribe, "rh_seein") == "1"
          ||GetLocalString(oScribe, "rh_spellr") == "1"
          ||GetLocalString(oScribe, "rh_stone") == "1"
          ||GetLocalString(oScribe, "rh_truestrike") == "1"
          ||GetLocalString(oScribe, "rh_dward") == "1"
          ||GetLocalString(oScribe, "rh_endur") == "1"
          ||GetLocalString(oScribe, "rh_gmw") == "1"
          ||GetLocalString(oScribe, "rh_haste") == "1"
          ||GetLocalString(oScribe, "rh_heal") == "1"
          ||GetLocalString(oScribe, "rh_impinv") == "1"
          ||GetLocalString(oScribe, "rh_invis") == "1"
          ||GetLocalString(oScribe, "rh_keen") == "1"
          ||GetLocalString(oScribe, "rh_pois") == "1")return FALSE;
        }
        oScribe = GetNextItemInInventory(oPC);
      }
      return TRUE;
}

