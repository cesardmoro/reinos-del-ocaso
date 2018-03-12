int StartingConditional()
{
object oPC = OBJECT_SELF;
object oScribe = GetFirstItemInInventory(oPC);

while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {
         if(GetLocalString(oScribe, "rc_bulls") == "1"
          ||GetLocalString(oScribe, "rc_ccw") == "1"
          ||GetLocalString(oScribe, "rc_cmw") == "1"
          ||GetLocalString(oScribe, "rc_csw") == "1"
          ||GetLocalString(oScribe, "rc_divfavor") == "1"
          ||GetLocalString(oScribe, "rc_divpower") == "1"
          ||GetLocalString(oScribe, "rc_rest") == "1"
          ||GetLocalString(oScribe, "rc_rmight") == "1"
          ||GetLocalString(oScribe, "rc_seein") == "1"
          ||GetLocalString(oScribe, "rc_spellr") == "1"
          ||GetLocalString(oScribe, "rc_stone") == "1"
          ||GetLocalString(oScribe, "rc_truestrike") == "1"
          ||GetLocalString(oScribe, "rc_dward") == "1"
          ||GetLocalString(oScribe, "rc_endur") == "1"
          ||GetLocalString(oScribe, "rc_gmw") == "1"
          ||GetLocalString(oScribe, "rc_haste") == "1"
          ||GetLocalString(oScribe, "rc_heal") == "1"
          ||GetLocalString(oScribe, "rc_impinv") == "1"
          ||GetLocalString(oScribe, "rc_invis") == "1"
          ||GetLocalString(oScribe, "rc_keen") == "1"
          ||GetLocalString(oScribe, "rc_pois") == "1")return FALSE;
        }
        oScribe = GetNextItemInInventory(oPC);
      }
      return TRUE;
}

