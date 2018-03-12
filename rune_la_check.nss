int StartingConditional()
{
object oPC = OBJECT_SELF;
object oScribe = GetFirstItemInInventory(oPC);

while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {
         if(GetLocalString(oScribe, "la_bulls") == "1"
          ||GetLocalString(oScribe, "la_ccw") == "1"
          ||GetLocalString(oScribe, "la_cmw") == "1"
          ||GetLocalString(oScribe, "la_csw") == "1"
          ||GetLocalString(oScribe, "la_divfavor") == "1"
          ||GetLocalString(oScribe, "la_divpower") == "1"
          ||GetLocalString(oScribe, "la_rest") == "1"
          ||GetLocalString(oScribe, "la_rmight") == "1"
          ||GetLocalString(oScribe, "la_seein") == "1"
          ||GetLocalString(oScribe, "la_spellr") == "1"
          ||GetLocalString(oScribe, "la_stone") == "1"
          ||GetLocalString(oScribe, "la_truestrike") == "1"
          ||GetLocalString(oScribe, "la_dward") == "1"
          ||GetLocalString(oScribe, "la_endur") == "1"
          ||GetLocalString(oScribe, "la_gmw") == "1"
          ||GetLocalString(oScribe, "la_haste") == "1"
          ||GetLocalString(oScribe, "la_heal") == "1"
          ||GetLocalString(oScribe, "la_impinv") == "1"
          ||GetLocalString(oScribe, "la_invis") == "1"
          ||GetLocalString(oScribe, "la_keen") == "1"
          ||GetLocalString(oScribe, "la_pois") == "1")return FALSE;
        }
        oScribe = GetNextItemInInventory(oPC);
      }
      return TRUE;
}

