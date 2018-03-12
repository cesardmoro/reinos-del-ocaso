void main()
{
    object oPC = OBJECT_SELF;
    object oScribe = GetFirstItemInInventory(oPC);

    while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {
         if(GetLocalString(oScribe, "rh_bulls") == "1")
            {
            DeleteLocalString(oScribe,"rh_bulls");
            ExecuteScript("rune_bullstr", oPC);
            }
         if(GetLocalString(oScribe, "rh_ccw") == "1")
            {
            DeleteLocalString(oScribe,"rh_ccw");
            ExecuteScript("rune_ccw", oPC);
            }
         if(GetLocalString(oScribe, "rh_cmw") == "1")
            {
            DeleteLocalString(oScribe,"rh_cmw");
            ExecuteScript("rune_cmw", oPC);
            }
         if(GetLocalString(oScribe, "rh_csw") == "1")
            {
            DeleteLocalString(oScribe,"rh_csw");
            ExecuteScript("rune_csw", oPC);
            }
         if(GetLocalString(oScribe, "rh_divfavor") == "1")
            {
            DeleteLocalString(oScribe,"rh_divfavor");
            ExecuteScript("rune_divfav", oPC);
            }
         if(GetLocalString(oScribe, "rh_divpower") == "1")
            {
            DeleteLocalString(oScribe,"rh_divpower");
            ExecuteScript("rune_divpower", oPC);
            }
         if(GetLocalString(oScribe, "rh_rest") == "1")
            {
            DeleteLocalString(oScribe,"rh_rest");
            ExecuteScript("rune_restore", oPC);
            }
         if(GetLocalString(oScribe, "rh_rmight") == "1")
            {
            DeleteLocalString(oScribe,"rh_rmight");
            ExecuteScript("rune_rightmt", oPC);
            }
         if(GetLocalString(oScribe, "rh_seein") == "1")
            {
            DeleteLocalString(oScribe,"rh_seein");
            ExecuteScript("rune_seeinvis", oPC);
            }
         if(GetLocalString(oScribe, "rh_spellr") == "1")
            {
            DeleteLocalString(oScribe,"rh_spellr");
            ExecuteScript("rune_splresis", oPC);
            }
         if(GetLocalString(oScribe, "rh_stone") == "1")
            {
            DeleteLocalString(oScribe,"rh_stone");
            ExecuteScript("rune_stoneskn", oPC);
            }
         if(GetLocalString(oScribe, "rh_truestrike") == "1")
            {
            DeleteLocalString(oScribe,"rh_truestrike");
            ExecuteScript("rune_truestrike", oPC);
            }
         if(GetLocalString(oScribe, "rh_dward") == "1")
            {
            DeleteLocalString(oScribe,"rh_dward");
            ExecuteScript("rune_deaward", oPC);
            }
         if(GetLocalString(oScribe, "rh_endur") == "1")
            {
            DeleteLocalString(oScribe,"rh_endur");
            ExecuteScript("rune_endurce", oPC);
            }
         if(GetLocalString(oScribe, "rh_gmw") == "1")
            {
            DeleteLocalString(oScribe,"rh_gmw");
            ExecuteScript("rune_grmagweap", oPC);
            }
         if(GetLocalString(oScribe, "rh_haste") == "1")
            {
            DeleteLocalString(oScribe,"rh_haste");
            ExecuteScript("rune_haste", oPC);
            }
         if(GetLocalString(oScribe, "rh_heal") == "1")
            {
            DeleteLocalString(oScribe,"rh_heal");
            ExecuteScript("rune_heal", oPC);
            }
         if(GetLocalString(oScribe, "rh_impinv") == "1")
            {
            DeleteLocalString(oScribe,"rh_impinv");
            ExecuteScript("rune_imprinvis", oPC);
            }
         if(GetLocalString(oScribe, "rh_invis") == "1")
            {
            DeleteLocalString(oScribe,"rh_invis");
            ExecuteScript("rune_invisib", oPC);
            }
         if(GetLocalString(oScribe, "rh_keen") == "1")
            {
            DeleteLocalString(oScribe,"rh_keen");
            ExecuteScript("rune_keenedge", oPC);
            }
         if(GetLocalString(oScribe, "rh_pois") == "1")
            {
            DeleteLocalString(oScribe,"rh_pois");
            ExecuteScript("rune_neutpois", oPC);
            }
         }
        oScribe = GetNextItemInInventory(oPC);
      }
}
