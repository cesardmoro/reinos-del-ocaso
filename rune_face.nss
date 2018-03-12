void main()
{
    object oPC = OBJECT_SELF;
    object oScribe = GetFirstItemInInventory(oPC);

    while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {
         if(GetLocalString(oScribe, "f_bulls") == "1")
            {
            DeleteLocalString(oScribe,"f_bulls");
            ExecuteScript("rune_bullstr", oPC);
            }
         if(GetLocalString(oScribe, "f_ccw") == "1")
            {
            DeleteLocalString(oScribe,"f_ccw");
            ExecuteScript("rune_ccw", oPC);
            }
         if(GetLocalString(oScribe, "f_cmw") == "1")
            {
            DeleteLocalString(oScribe,"f_cmw");
            ExecuteScript("rune_cmw", oPC);
            }
         if(GetLocalString(oScribe, "f_csw") == "1")
            {
            DeleteLocalString(oScribe,"f_csw");
            ExecuteScript("rune_csw", oPC);
            }
         if(GetLocalString(oScribe, "f_divfavor") == "1")
            {
            DeleteLocalString(oScribe,"f_divfavor");
            ExecuteScript("rune_divfav", oPC);
            }
         if(GetLocalString(oScribe, "f_divpower") == "1")
            {
            DeleteLocalString(oScribe,"f_divpower");
            ExecuteScript("rune_divpower", oPC);
            }
         if(GetLocalString(oScribe, "f_rest") == "1")
            {
            DeleteLocalString(oScribe,"f_rest");
            ExecuteScript("rune_restore", oPC);
            }
         if(GetLocalString(oScribe, "f_rmight") == "1")
            {
            DeleteLocalString(oScribe,"f_rmight");
            ExecuteScript("rune_rightmt", oPC);
            }
         if(GetLocalString(oScribe, "f_seein") == "1")
            {
            DeleteLocalString(oScribe,"f_seein");
            ExecuteScript("rune_seeinvis", oPC);
            }
         if(GetLocalString(oScribe, "f_spellr") == "1")
            {
            DeleteLocalString(oScribe,"f_spellr");
            ExecuteScript("rune_splresis", oPC);
            }
         if(GetLocalString(oScribe, "f_stone") == "1")
            {
            DeleteLocalString(oScribe,"f_stone");
            ExecuteScript("rune_stoneskn", oPC);
            }
         if(GetLocalString(oScribe, "f_truestrike") == "1")
            {
            DeleteLocalString(oScribe,"f_truestrike");
            ExecuteScript("rune_truestrike", oPC);
            }
         if(GetLocalString(oScribe, "f_dward") == "1")
            {
            DeleteLocalString(oScribe,"f_dward");
            ExecuteScript("rune_deaward", oPC);
            }
         if(GetLocalString(oScribe, "f_endur") == "1")
            {
            DeleteLocalString(oScribe,"f_endur");
            ExecuteScript("rune_endufe", oPC);
            }
         if(GetLocalString(oScribe, "f_gmw") == "1")
            {
            DeleteLocalString(oScribe,"f_gmw");
            ExecuteScript("rune_grmagweap", oPC);
            }
         if(GetLocalString(oScribe, "f_haste") == "1")
            {
            DeleteLocalString(oScribe,"f_haste");
            ExecuteScript("rune_haste", oPC);
            }
         if(GetLocalString(oScribe, "f_heal") == "1")
            {
            DeleteLocalString(oScribe,"f_heal");
            ExecuteScript("rune_heal", oPC);
            }
         if(GetLocalString(oScribe, "f_impinv") == "1")
            {
            DeleteLocalString(oScribe,"f_impinv");
            ExecuteScript("rune_imprinvis", oPC);
            }
         if(GetLocalString(oScribe, "f_invis") == "1")
            {
            DeleteLocalString(oScribe,"f_invis");
            ExecuteScript("rune_invisib", oPC);
            }
         if(GetLocalString(oScribe, "f_keen") == "1")
            {
            DeleteLocalString(oScribe,"f_keen");
            ExecuteScript("rune_keenedge", oPC);
            }
         if(GetLocalString(oScribe, "f_pois") == "1")
            {
            DeleteLocalString(oScribe,"f_pois");
            ExecuteScript("rune_neutpois", oPC);
            }
         }
        oScribe = GetNextItemInInventory(oPC);
      }
}
