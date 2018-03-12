void main()
{
    object oPC = OBJECT_SELF;
    object oScribe = GetFirstItemInInventory(oPC);

    while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {
         if(GetLocalString(oScribe, "ra_bulls") == "1")
            {
            DeleteLocalString(oScribe,"ra_bulls");
            ExecuteScript("rune_bullstr", oPC);
            }
         if(GetLocalString(oScribe, "ra_ccw") == "1")
            {
            DeleteLocalString(oScribe,"ra_ccw");
            ExecuteScript("rune_ccw", oPC);
            }
         if(GetLocalString(oScribe, "ra_cmw") == "1")
            {
            DeleteLocalString(oScribe,"ra_cmw");
            ExecuteScript("rune_cmw", oPC);
            }
         if(GetLocalString(oScribe, "ra_csw") == "1")
            {
            DeleteLocalString(oScribe,"ra_csw");
            ExecuteScript("rune_csw", oPC);
            }
         if(GetLocalString(oScribe, "ra_divfavor") == "1")
            {
            DeleteLocalString(oScribe,"ra_divfavor");
            ExecuteScript("rune_divfav", oPC);
            }
         if(GetLocalString(oScribe, "ra_divpower") == "1")
            {
            DeleteLocalString(oScribe,"ra_divpower");
            ExecuteScript("rune_divpower", oPC);
            }
         if(GetLocalString(oScribe, "ra_rest") == "1")
            {
            DeleteLocalString(oScribe,"ra_rest");
            ExecuteScript("rune_restore", oPC);
            }
         if(GetLocalString(oScribe, "ra_rmight") == "1")
            {
            DeleteLocalString(oScribe,"ra_rmight");
            ExecuteScript("rune_rightmt", oPC);
            }
         if(GetLocalString(oScribe, "ra_seein") == "1")
            {
            DeleteLocalString(oScribe,"ra_seein");
            ExecuteScript("rune_seeinvis", oPC);
            }
         if(GetLocalString(oScribe, "ra_spellr") == "1")
            {
            DeleteLocalString(oScribe,"ra_spellr");
            ExecuteScript("rune_splresis", oPC);
            }
         if(GetLocalString(oScribe, "ra_stone") == "1")
            {
            DeleteLocalString(oScribe,"ra_stone");
            ExecuteScript("rune_stoneskn", oPC);
            }
         if(GetLocalString(oScribe, "ra_truestrike") == "1")
            {
            DeleteLocalString(oScribe,"ra_truestrike");
            ExecuteScript("rune_truestrike", oPC);
            }
         if(GetLocalString(oScribe, "ra_dward") == "1")
            {
            DeleteLocalString(oScribe,"ra_dward");
            ExecuteScript("rune_deaward", oPC);
            }
         if(GetLocalString(oScribe, "ra_endur") == "1")
            {
            DeleteLocalString(oScribe,"ra_endur");
            ExecuteScript("rune_endurce", oPC);
            }
         if(GetLocalString(oScribe, "ra_gmw") == "1")
            {
            DeleteLocalString(oScribe,"ra_gmw");
            ExecuteScript("rune_grmagweap", oPC);
            }
         if(GetLocalString(oScribe, "ra_haste") == "1")
            {
            DeleteLocalString(oScribe,"ra_haste");
            ExecuteScript("rune_haste", oPC);
            }
         if(GetLocalString(oScribe, "ra_heal") == "1")
            {
            DeleteLocalString(oScribe,"ra_heal");
            ExecuteScript("rune_heal", oPC);
            }
         if(GetLocalString(oScribe, "ra_impinv") == "1")
            {
            DeleteLocalString(oScribe,"ra_impinv");
            ExecuteScript("rune_imprinvis", oPC);
            }
         if(GetLocalString(oScribe, "ra_invis") == "1")
            {
            DeleteLocalString(oScribe,"ra_invis");
            ExecuteScript("rune_invisib", oPC);
            }
         if(GetLocalString(oScribe, "ra_keen") == "1")
            {
            DeleteLocalString(oScribe,"ra_keen");
            ExecuteScript("rune_keenedge", oPC);
            }
         if(GetLocalString(oScribe, "ra_pois") == "1")
            {
            DeleteLocalString(oScribe,"ra_pois");
            ExecuteScript("rune_neutpois", oPC);
            }
         }
        oScribe = GetNextItemInInventory(oPC);
      }
}
