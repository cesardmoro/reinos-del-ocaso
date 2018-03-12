void main()
{
    object oPC = OBJECT_SELF;
    object oScribe = GetFirstItemInInventory(oPC);

    while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {
         if(GetLocalString(oScribe, "rc_bulls") == "1")
            {
            DeleteLocalString(oScribe,"rc_bulls");
            ExecuteScript("rune_bullstr", oPC);
            }
         if(GetLocalString(oScribe, "rc_ccw") == "1")
            {
            DeleteLocalString(oScribe,"rc_ccw");
            ExecuteScript("rune_ccw", oPC);
            }
         if(GetLocalString(oScribe, "rc_cmw") == "1")
            {
            DeleteLocalString(oScribe,"rc_cmw");
            ExecuteScript("rune_cmw", oPC);
            }
         if(GetLocalString(oScribe, "rc_csw") == "1")
            {
            DeleteLocalString(oScribe,"rc_csw");
            ExecuteScript("rune_csw", oPC);
            }
         if(GetLocalString(oScribe, "rc_divfavor") == "1")
            {
            DeleteLocalString(oScribe,"rc_divfavor");
            ExecuteScript("rune_divfav", oPC);
            }
         if(GetLocalString(oScribe, "rc_divpower") == "1")
            {
            DeleteLocalString(oScribe,"rc_divpower");
            ExecuteScript("rune_divpower", oPC);
            }
         if(GetLocalString(oScribe, "rc_rest") == "1")
            {
            DeleteLocalString(oScribe,"rc_rest");
            ExecuteScript("rune_restore", oPC);
            }
         if(GetLocalString(oScribe, "rc_rmight") == "1")
            {
            DeleteLocalString(oScribe,"rc_rmight");
            ExecuteScript("rune_rightmt", oPC);
            }
         if(GetLocalString(oScribe, "rc_seein") == "1")
            {
            DeleteLocalString(oScribe,"rc_seein");
            ExecuteScript("rune_seeinvis", oPC);
            }
         if(GetLocalString(oScribe, "rc_spellr") == "1")
            {
            DeleteLocalString(oScribe,"rc_spellr");
            ExecuteScript("rune_splresis", oPC);
            }
         if(GetLocalString(oScribe, "rc_stone") == "1")
            {
            DeleteLocalString(oScribe,"rc_stone");
            ExecuteScript("rune_stoneskn", oPC);
            }
         if(GetLocalString(oScribe, "rc_truestrike") == "1")
            {
            DeleteLocalString(oScribe,"rc_truestrike");
            ExecuteScript("rune_truestrike", oPC);
            }
         if(GetLocalString(oScribe, "rc_dward") == "1")
            {
            DeleteLocalString(oScribe,"rc_dward");
            ExecuteScript("rune_deaward", oPC);
            }
         if(GetLocalString(oScribe, "rc_endur") == "1")
            {
            DeleteLocalString(oScribe,"rc_endur");
            ExecuteScript("rune_endurce", oPC);
            }
         if(GetLocalString(oScribe, "rc_gmw") == "1")
            {
            DeleteLocalString(oScribe,"rc_gmw");
            ExecuteScript("rune_grmagweap", oPC);
            }
         if(GetLocalString(oScribe, "rc_haste") == "1")
            {
            DeleteLocalString(oScribe,"rc_haste");
            ExecuteScript("rune_haste", oPC);
            }
         if(GetLocalString(oScribe, "rc_heal") == "1")
            {
            DeleteLocalString(oScribe,"rc_heal");
            ExecuteScript("rune_heal", oPC);
            }
         if(GetLocalString(oScribe, "rc_impinv") == "1")
            {
            DeleteLocalString(oScribe,"rc_impinv");
            ExecuteScript("rune_imprinvis", oPC);
            }
         if(GetLocalString(oScribe, "rc_invis") == "1")
            {
            DeleteLocalString(oScribe,"rc_invis");
            ExecuteScript("rune_invisib", oPC);
            }
         if(GetLocalString(oScribe, "rc_keen") == "1")
            {
            DeleteLocalString(oScribe,"rc_keen");
            ExecuteScript("rune_keenedge", oPC);
            }
         if(GetLocalString(oScribe, "rc_pois") == "1")
            {
            DeleteLocalString(oScribe,"rc_pois");
            ExecuteScript("rune_neutpois", oPC);
            }
         }
        oScribe = GetNextItemInInventory(oPC);
      }
}
