void main()
{
    object oPC = OBJECT_SELF;
    object oScribe = GetFirstItemInInventory(oPC);

    while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {
         if(GetLocalString(oScribe, "lc_bulls") == "1")
            {
            DeleteLocalString(oScribe,"lc_bulls");
            ExecuteScript("rune_bullstr", oPC);
            }
         if(GetLocalString(oScribe, "lc_ccw") == "1")
            {
            DeleteLocalString(oScribe,"lc_ccw");
            ExecuteScript("rune_ccw", oPC);
            }
         if(GetLocalString(oScribe, "lc_cmw") == "1")
            {
            DeleteLocalString(oScribe,"lc_cmw");
            ExecuteScript("rune_cmw", oPC);
            }
         if(GetLocalString(oScribe, "lc_csw") == "1")
            {
            DeleteLocalString(oScribe,"lc_csw");
            ExecuteScript("rune_csw", oPC);
            }
         if(GetLocalString(oScribe, "lc_divfavor") == "1")
            {
            DeleteLocalString(oScribe,"lc_divfavor");
            ExecuteScript("rune_divfav", oPC);
            }
         if(GetLocalString(oScribe, "lc_divpower") == "1")
            {
            DeleteLocalString(oScribe,"lc_divpower");
            ExecuteScript("rune_divpower", oPC);
            }
         if(GetLocalString(oScribe, "lc_rest") == "1")
            {
            DeleteLocalString(oScribe,"lc_rest");
            ExecuteScript("rune_restore", oPC);
            }
         if(GetLocalString(oScribe, "lc_rmight") == "1")
            {
            DeleteLocalString(oScribe,"lc_rmight");
            ExecuteScript("rune_rightmt", oPC);
            }
         if(GetLocalString(oScribe, "lc_seein") == "1")
            {
            DeleteLocalString(oScribe,"lc_seein");
            ExecuteScript("rune_seeinvis", oPC);
            }
         if(GetLocalString(oScribe, "lc_spellr") == "1")
            {
            DeleteLocalString(oScribe,"lc_spellr");
            ExecuteScript("rune_splresis", oPC);
            }
         if(GetLocalString(oScribe, "lc_stone") == "1")
            {
            DeleteLocalString(oScribe,"lc_stone");
            ExecuteScript("rune_stoneskn", oPC);
            }
         if(GetLocalString(oScribe, "lc_truestrike") == "1")
            {
            DeleteLocalString(oScribe,"lc_truestrike");
            ExecuteScript("rune_truestrike", oPC);
            }
         if(GetLocalString(oScribe, "lc_dward") == "1")
            {
            DeleteLocalString(oScribe,"lc_dward");
            ExecuteScript("rune_deaward", oPC);
            }
         if(GetLocalString(oScribe, "lc_endur") == "1")
            {
            DeleteLocalString(oScribe,"lc_endur");
            ExecuteScript("rune_endurce", oPC);
            }
         if(GetLocalString(oScribe, "lc_gmw") == "1")
            {
            DeleteLocalString(oScribe,"lc_gmw");
            ExecuteScript("rune_grmagweap", oPC);
            }
         if(GetLocalString(oScribe, "lc_haste") == "1")
            {
            DeleteLocalString(oScribe,"lc_haste");
            ExecuteScript("rune_haste", oPC);
            }
         if(GetLocalString(oScribe, "lc_heal") == "1")
            {
            DeleteLocalString(oScribe,"lc_heal");
            ExecuteScript("rune_heal", oPC);
            }
         if(GetLocalString(oScribe, "lc_impinv") == "1")
            {
            DeleteLocalString(oScribe,"lc_impinv");
            ExecuteScript("rune_imprinvis", oPC);
            }
         if(GetLocalString(oScribe, "lc_invis") == "1")
            {
            DeleteLocalString(oScribe,"lc_invis");
            ExecuteScript("rune_invisib", oPC);
            }
         if(GetLocalString(oScribe, "lc_keen") == "1")
            {
            DeleteLocalString(oScribe,"lc_keen");
            ExecuteScript("rune_keenedge", oPC);
            }
         if(GetLocalString(oScribe, "lc_pois") == "1")
            {
            DeleteLocalString(oScribe,"lc_pois");
            ExecuteScript("rune_neutpois", oPC);
            }
         }
        oScribe = GetNextItemInInventory(oPC);
      }
}
