int StartingConditional()
{
object oPC = OBJECT_SELF;
object oScribe = GetFirstItemInInventory(oPC);

while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {
         if(GetLocalString(oScribe, "f_bulls") == "1"
          ||GetLocalString(oScribe, "f_ccw") == "1"
          ||GetLocalString(oScribe, "f_cmw") == "1"
          ||GetLocalString(oScribe, "f_csw") == "1"
          ||GetLocalString(oScribe, "f_divfavor") == "1"
          ||GetLocalString(oScribe, "f_divpower") == "1"
          ||GetLocalString(oScribe, "f_rest") == "1"
          ||GetLocalString(oScribe, "f_rmight") == "1"
          ||GetLocalString(oScribe, "f_seein") == "1"
          ||GetLocalString(oScribe, "f_spellr") == "1"
          ||GetLocalString(oScribe, "f_stone") == "1"
          ||GetLocalString(oScribe, "f_truestrike") == "1"
          ||GetLocalString(oScribe, "f_dward") == "1"
          ||GetLocalString(oScribe, "f_endur") == "1"
          ||GetLocalString(oScribe, "f_gmw") == "1"
          ||GetLocalString(oScribe, "f_haste") == "1"
          ||GetLocalString(oScribe, "f_heal") == "1"
          ||GetLocalString(oScribe, "f_impinv") == "1"
          ||GetLocalString(oScribe, "f_invis") == "1"
          ||GetLocalString(oScribe, "f_keen") == "1"
          ||GetLocalString(oScribe, "f_pois") == "1")return FALSE;
        }
        oScribe = GetNextItemInInventory(oPC);
      }
      return TRUE;
}

