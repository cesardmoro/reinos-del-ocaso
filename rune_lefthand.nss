void main()
{
    object oPC = OBJECT_SELF;
    object oScribe = GetFirstItemInInventory(oPC);

    while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {
         if(GetLocalString(oScribe, "lh_bulls") == "1")
            {
            DeleteLocalString(oScribe,"lh_bulls");
            ExecuteScript("rune_bullstr", oPC);
            }
         if(GetLocalString(oScribe, "lh_ccw") == "1")
            {
            DeleteLocalString(oScribe,"lh_ccw");
            ExecuteScript("rune_ccw", oPC);
            }
         if(GetLocalString(oScribe, "lh_cmw") == "1")
            {
            DeleteLocalString(oScribe,"lh_cmw");
            ExecuteScript("rune_cmw", oPC);
            }
         if(GetLocalString(oScribe, "lh_csw") == "1")
            {
            DeleteLocalString(oScribe,"lh_csw");
            ExecuteScript("rune_csw", oPC);
            }
         if(GetLocalString(oScribe, "lh_divfavor") == "1")
            {
            DeleteLocalString(oScribe,"lh_divfavor");
            ExecuteScript("rune_divfav", oPC);
            }
         if(GetLocalString(oScribe, "lh_divpower") == "1")
            {
            DeleteLocalString(oScribe,"lh_divpower");
            ExecuteScript("rune_divpower", oPC);
            }
         if(GetLocalString(oScribe, "lh_rest") == "1")
            {
            DeleteLocalString(oScribe,"lh_rest");
            ExecuteScript("rune_restore", oPC);
            }
         if(GetLocalString(oScribe, "lh_rmight") == "1")
            {
            DeleteLocalString(oScribe,"lh_rmight");
            ExecuteScript("rune_rightmt", oPC);
            }
         if(GetLocalString(oScribe, "lh_seein") == "1")
            {
            DeleteLocalString(oScribe,"lh_seein");
            ExecuteScript("rune_seeinvis", oPC);
            }
         if(GetLocalString(oScribe, "lh_spellr") == "1")
            {
            DeleteLocalString(oScribe,"lh_spellr");
            ExecuteScript("rune_splresis", oPC);
            }
         if(GetLocalString(oScribe, "lh_stone") == "1")
            {
            DeleteLocalString(oScribe,"lh_stone");
            ExecuteScript("rune_stoneskn", oPC);
            }
         if(GetLocalString(oScribe, "lh_truestrike") == "1")
            {
            DeleteLocalString(oScribe,"lh_truestrike");
            ExecuteScript("rune_truestrike", oPC);
            }
         if(GetLocalString(oScribe, "lh_dward") == "1")
            {
            DeleteLocalString(oScribe,"lh_dward");
            ExecuteScript("rune_deaward", oPC);
            }
         if(GetLocalString(oScribe, "lh_endur") == "1")
            {
            DeleteLocalString(oScribe,"lh_endur");
            ExecuteScript("rune_endurce", oPC);
            }
         if(GetLocalString(oScribe, "lh_gmw") == "1")
            {
            DeleteLocalString(oScribe,"lh_gmw");
            ExecuteScript("rune_grmagweap", oPC);
            }
         if(GetLocalString(oScribe, "lh_haste") == "1")
            {
            DeleteLocalString(oScribe,"lh_haste");
            ExecuteScript("rune_haste", oPC);
            }
         if(GetLocalString(oScribe, "lh_heal") == "1")
            {
            DeleteLocalString(oScribe,"lh_heal");
            ExecuteScript("rune_heal", oPC);
            }
         if(GetLocalString(oScribe, "lh_impinv") == "1")
            {
            DeleteLocalString(oScribe,"lh_impinv");
            ExecuteScript("rune_imprinvis", oPC);
            }
         if(GetLocalString(oScribe, "lh_invis") == "1")
            {
            DeleteLocalString(oScribe,"lh_invis");
            ExecuteScript("rune_invisib", oPC);
            }
         if(GetLocalString(oScribe, "lh_keen") == "1")
            {
            DeleteLocalString(oScribe,"lh_keen");
            ExecuteScript("rune_keenedge", oPC);
            }
         if(GetLocalString(oScribe, "lh_pois") == "1")
            {
            DeleteLocalString(oScribe,"lh_pois");
            ExecuteScript("rune_neutpois", oPC);
            }
         }
        oScribe = GetNextItemInInventory(oPC);
      }
}
