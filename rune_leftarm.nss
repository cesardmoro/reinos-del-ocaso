void main()
{
    object oPC = OBJECT_SELF;
    object oScribe = GetFirstItemInInventory(oPC);

    while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {
         if(GetLocalString(oScribe, "la_bulls") == "1")
            {
            DeleteLocalString(oScribe,"la_bulls");
            ExecuteScript("rune_bullstr", oPC);
            }
         if(GetLocalString(oScribe, "la_ccw") == "1")
            {
            DeleteLocalString(oScribe,"la_ccw");
            ExecuteScript("rune_ccw", oPC);
            }
         if(GetLocalString(oScribe, "la_cmw") == "1")
            {
            DeleteLocalString(oScribe,"la_cmw");
            ExecuteScript("rune_cmw", oPC);
            }
         if(GetLocalString(oScribe, "la_csw") == "1")
            {
            DeleteLocalString(oScribe,"la_csw");
            ExecuteScript("rune_csw", oPC);
            }
         if(GetLocalString(oScribe, "la_divfavor") == "1")
            {
            DeleteLocalString(oScribe,"la_divfavor");
            ExecuteScript("rune_divfav", oPC);
            }
         if(GetLocalString(oScribe, "la_divpower") == "1")
            {
            DeleteLocalString(oScribe,"la_divpower");
            ExecuteScript("rune_divpower", oPC);
            }
         if(GetLocalString(oScribe, "la_rest") == "1")
            {
            DeleteLocalString(oScribe,"la_rest");
            ExecuteScript("rune_restore", oPC);
            }
         if(GetLocalString(oScribe, "la_rmight") == "1")
            {
            DeleteLocalString(oScribe,"la_rmight");
            ExecuteScript("rune_rightmt", oPC);
            }
         if(GetLocalString(oScribe, "la_seein") == "1")
            {
            DeleteLocalString(oScribe,"la_seein");
            ExecuteScript("rune_seeinvis", oPC);
            }
         if(GetLocalString(oScribe, "la_spellr") == "1")
            {
            DeleteLocalString(oScribe,"la_spellr");
            ExecuteScript("rune_splresis", oPC);
            }
         if(GetLocalString(oScribe, "la_stone") == "1")
            {
            DeleteLocalString(oScribe,"la_stone");
            ExecuteScript("rune_stoneskn", oPC);
            }
         if(GetLocalString(oScribe, "la_truestrike") == "1")
            {
            DeleteLocalString(oScribe,"la_truestrike");
            ExecuteScript("rune_truestrike", oPC);
            }
         if(GetLocalString(oScribe, "la_dward") == "1")
            {
            DeleteLocalString(oScribe,"la_dward");
            ExecuteScript("rune_deaward", oPC);
            }
         if(GetLocalString(oScribe, "la_endur") == "1")
            {
            DeleteLocalString(oScribe,"la_endur");
            ExecuteScript("rune_endurce", oPC);
            }
         if(GetLocalString(oScribe, "la_gmw") == "1")
            {
            DeleteLocalString(oScribe,"la_gmw");
            ExecuteScript("rune_grmagweap", oPC);
            }
         if(GetLocalString(oScribe, "la_haste") == "1")
            {
            DeleteLocalString(oScribe,"la_haste");
            ExecuteScript("rune_haste", oPC);
            }
         if(GetLocalString(oScribe, "la_heal") == "1")
            {
            DeleteLocalString(oScribe,"la_heal");
            ExecuteScript("rune_heal", oPC);
            }
         if(GetLocalString(oScribe, "la_impinv") == "1")
            {
            DeleteLocalString(oScribe,"la_impinv");
            ExecuteScript("rune_imprinvis", oPC);
            }
         if(GetLocalString(oScribe, "la_invis") == "1")
            {
            DeleteLocalString(oScribe,"la_invis");
            ExecuteScript("rune_invisib", oPC);
            }
         if(GetLocalString(oScribe, "la_keen") == "1")
            {
            DeleteLocalString(oScribe,"la_keen");
            ExecuteScript("rune_keenedge", oPC);
            }
         if(GetLocalString(oScribe, "la_pois") == "1")
            {
            DeleteLocalString(oScribe,"la_pois");
            ExecuteScript("rune_neutpois", oPC);
            }
         }
        oScribe = GetNextItemInInventory(oPC);
      }
}
