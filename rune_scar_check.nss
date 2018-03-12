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
            SendMessageToPC(oPC,"Rune Scribed: Face, Bull Strength.");
            }
         if(GetLocalString(oScribe, "f_ccw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Cure Critical Wounds.");
            }
         if(GetLocalString(oScribe, "f_cmw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Cure Moderate Wounds.");
            }
         if(GetLocalString(oScribe, "f_csw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Cure Serious Wounds.");
            }
         if(GetLocalString(oScribe, "f_divfavor") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Divine Favour.");
            }
         if(GetLocalString(oScribe, "f_divpower") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Divine Power.");
            }
         if(GetLocalString(oScribe, "f_rest") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Restoration.");
            }
         if(GetLocalString(oScribe, "f_rmight") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Righteous Might.");
            }
         if(GetLocalString(oScribe, "f_seein") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, See Invisibility.");
            }
         if(GetLocalString(oScribe, "f_spellr") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Spell Resistance.");
            }
         if(GetLocalString(oScribe, "f_stone") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Stoneskin.");
            }
         if(GetLocalString(oScribe, "f_truestrike") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, True Strike.");
            }
         if(GetLocalString(oScribe, "f_dward") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Deathward.");
            }
         if(GetLocalString(oScribe, "f_endur") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Endurance.");
            }
         if(GetLocalString(oScribe, "f_gmw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Greater Magic Weapon.");
            }
         if(GetLocalString(oScribe, "f_haste") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Haste.");
            }
         if(GetLocalString(oScribe, "f_heal") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Heal.");
            }
         if(GetLocalString(oScribe, "f_impinv") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Improved Invisibility.");
            }
         if(GetLocalString(oScribe, "f_invis") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Invisibility.");
            }
         if(GetLocalString(oScribe, "f_keen") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Keen Edge.");
            }
         if(GetLocalString(oScribe, "f_pois") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Face, Neutralize Poison.");
            }
         if(GetLocalString(oScribe, "la_bulls") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Bull Strength.");
            }
         if(GetLocalString(oScribe, "la_ccw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Cure Critical Wounds.");
            }
         if(GetLocalString(oScribe, "la_cmw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Cure Moderate Wounds.");
            }
         if(GetLocalString(oScribe, "la_csw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Cure Serious Wounds.");
            }
         if(GetLocalString(oScribe, "la_divfavor") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Divine Favour.");
            }
         if(GetLocalString(oScribe, "la_divpower") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Divine Power.");
            }
         if(GetLocalString(oScribe, "la_rest") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Restoration.");
            }
         if(GetLocalString(oScribe, "la_rmight") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Righteous Might.");
            }
         if(GetLocalString(oScribe, "la_seein") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, See Invisibility.");
            }
         if(GetLocalString(oScribe, "la_spellr") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Spell Resistance.");
            }
         if(GetLocalString(oScribe, "la_stone") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Stoneskin.");
            }
         if(GetLocalString(oScribe, "la_truestrike") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, True Strike.");
            }
         if(GetLocalString(oScribe, "la_dward") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Deathward.");
            }
         if(GetLocalString(oScribe, "la_endur") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Endurance.");
            }
         if(GetLocalString(oScribe, "la_gmw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Greater Magic Weapon.");
            }
         if(GetLocalString(oScribe, "la_haste") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Haste.");
            }
         if(GetLocalString(oScribe, "la_heal") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Heal.");
            }
         if(GetLocalString(oScribe, "la_impinv") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Improved Invisibility.");
            }
         if(GetLocalString(oScribe, "la_invis") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Invisibility.");
            }
         if(GetLocalString(oScribe, "la_keen") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Keen Edge.");
            }
         if(GetLocalString(oScribe, "la_pois") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Arm, Neutralize Poison.");
            }
         if(GetLocalString(oScribe, "lc_bulls") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Bull Strength.");
            }
         if(GetLocalString(oScribe, "lc_ccw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Cure Critical Wounds.");
            }
         if(GetLocalString(oScribe, "lc_cmw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Cure Moderate Wounds.");
            }
         if(GetLocalString(oScribe, "lc_csw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Cure Serious Wounds.");
            }
         if(GetLocalString(oScribe, "lc_divfavor") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Divine Favour.");
            }
         if(GetLocalString(oScribe, "lc_divpower") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Divine Power.");
            }
         if(GetLocalString(oScribe, "lc_rest") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Restoration.");
            }
         if(GetLocalString(oScribe, "lc_rmight") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Righteous Might.");
            }
         if(GetLocalString(oScribe, "lc_seein") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, See Invisibility.");
            }
         if(GetLocalString(oScribe, "lc_spellr") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Spell Resistance.");
            }
         if(GetLocalString(oScribe, "lc_stone") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Bull Strength.");
            }
         if(GetLocalString(oScribe, "lc_truestrike") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, True Strike.");
            }
         if(GetLocalString(oScribe, "lc_dward") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Deathward.");
            }
         if(GetLocalString(oScribe, "lc_endur") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Endurance.");
            }
         if(GetLocalString(oScribe, "lc_gmw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Greater Magic Weapon.");
            }
         if(GetLocalString(oScribe, "lc_haste") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Haste.");
            }
         if(GetLocalString(oScribe, "lc_heal") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Heal.");
            }
         if(GetLocalString(oScribe, "lc_impinv") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Improved Invisibility.");
            }
         if(GetLocalString(oScribe, "lc_invis") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Invisibility.");
            }
         if(GetLocalString(oScribe, "lc_keen") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Keen Edge.");
            }
         if(GetLocalString(oScribe, "lc_pois") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Chest, Neutralize Poison.");
            }
          if(GetLocalString(oScribe, "lh_bulls") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Bull Strength.");
            }
         if(GetLocalString(oScribe, "lh_ccw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Cure Critical Wounds.");
            }
         if(GetLocalString(oScribe, "lh_cmw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Cure Moderate Wounds.");
            }
         if(GetLocalString(oScribe, "lh_csw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Cure Serious Wounds.");
            }
         if(GetLocalString(oScribe, "lh_divfavor") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Divine Favour.");
            }
         if(GetLocalString(oScribe, "lh_divpower") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Divine Power.");
            }
         if(GetLocalString(oScribe, "lh_rest") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Restoration.");
            }
         if(GetLocalString(oScribe, "lh_rmight") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Righteous Might.");
            }
         if(GetLocalString(oScribe, "lh_seein") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, See Invisibility.");
            }
         if(GetLocalString(oScribe, "lh_spellr") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Spell Resistance.");
            }
         if(GetLocalString(oScribe, "lh_stone") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Stoneskin.");
            }
         if(GetLocalString(oScribe, "lh_truestrike") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, True Strike.");
            }
         if(GetLocalString(oScribe, "lh_dward") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Deathward.");
            }
         if(GetLocalString(oScribe, "lh_endur") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Endurance.");
            }
         if(GetLocalString(oScribe, "lh_gmw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Greater Magic Weapon.");
            }
         if(GetLocalString(oScribe, "lh_haste") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Haste.");
            }
         if(GetLocalString(oScribe, "lh_heal") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Heal.");
            }
         if(GetLocalString(oScribe, "lh_impinv") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Improved Invisibility.");
            }
         if(GetLocalString(oScribe, "lh_invis") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Invisibility.");
            }
         if(GetLocalString(oScribe, "lh_keen") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Keen Edge.");
            }
         if(GetLocalString(oScribe, "lh_pois") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Left Hand, Neutralize Poison.");
            }
         if(GetLocalString(oScribe, "ra_bulls") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Bull Strength.");
            }
         if(GetLocalString(oScribe, "ra_ccw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Cure Critical Wounds.");
            }
         if(GetLocalString(oScribe, "ra_cmw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Cure Moderate Wounds.");
            }
         if(GetLocalString(oScribe, "ra_csw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Cure Serious Wounds.");
            }
         if(GetLocalString(oScribe, "ra_divfavor") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Divine Favour.");
            }
         if(GetLocalString(oScribe, "ra_divpower") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Divine Power.");
            }
         if(GetLocalString(oScribe, "ra_rest") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Restoration.");
            }
         if(GetLocalString(oScribe, "ra_rmight") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Righteous Might.");
            }
         if(GetLocalString(oScribe, "ra_seein") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, See Invisibility.");
            }
         if(GetLocalString(oScribe, "ra_spellr") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Spell Resistance.");
            }
         if(GetLocalString(oScribe, "ra_stone") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Stoneskin.");
            }
         if(GetLocalString(oScribe, "ra_truestrike") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, True Strike.");
            }
         if(GetLocalString(oScribe, "ra_dward") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Deathward.");
            }
         if(GetLocalString(oScribe, "ra_endur") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Endurance.");
            }
         if(GetLocalString(oScribe, "ra_gmw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Greater Magic Weapon.");
            }
         if(GetLocalString(oScribe, "ra_haste") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Haste.");
            }
         if(GetLocalString(oScribe, "ra_heal") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Heal.");
            }
         if(GetLocalString(oScribe, "ra_impinv") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Improved Invisibility.");
            }
         if(GetLocalString(oScribe, "ra_invis") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Invisibility.");
            }
         if(GetLocalString(oScribe, "ra_keen") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Keen Edge.");
            }
         if(GetLocalString(oScribe, "ra_pois") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Arm, Neutralize Poison.");
            }
         if(GetLocalString(oScribe, "rc_bulls") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Bull Strength.");
            }
         if(GetLocalString(oScribe, "rc_ccw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Cure Critical Wounds.");
            }
         if(GetLocalString(oScribe, "rc_cmw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Cure Moderate Wounds.");
            }
         if(GetLocalString(oScribe, "rc_csw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Cure Serious Wounds.");
            }
         if(GetLocalString(oScribe, "rc_divfavor") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Divine Favour.");
            }
         if(GetLocalString(oScribe, "rc_divpower") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Divine Power.");
            }
         if(GetLocalString(oScribe, "rc_rest") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Restoration.");
            }
         if(GetLocalString(oScribe, "rc_rmight") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Righteous Might.");
            }
         if(GetLocalString(oScribe, "rc_seein") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, See Invisibility.");
            }
         if(GetLocalString(oScribe, "rc_spellr") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Spell Resistance.");
            }
         if(GetLocalString(oScribe, "rc_stone") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Stoneskin.");
            }
         if(GetLocalString(oScribe, "rc_truestrike") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, True Strike.");
            }
         if(GetLocalString(oScribe, "rc_dward") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Deathward.");
            }
         if(GetLocalString(oScribe, "rc_endur") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Endurance.");
            }
         if(GetLocalString(oScribe, "rc_gmw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Greater Magic Weapon.");
            }
         if(GetLocalString(oScribe, "rc_haste") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Haste.");
            }
         if(GetLocalString(oScribe, "rc_heal") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Heal.");
            }
         if(GetLocalString(oScribe, "rc_impinv") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Improved Invisibility.");
            }
         if(GetLocalString(oScribe, "rc_invis") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Invisibility.");
            }
         if(GetLocalString(oScribe, "rc_keen") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Keen Edge.");
            }
         if(GetLocalString(oScribe, "rc_pois") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Chest, Neutralize Poison.");
            }
         if(GetLocalString(oScribe, "rh_bulls") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Bull Strength.");
            }
         if(GetLocalString(oScribe, "rh_ccw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Cure Critical Wounds.");
            }
         if(GetLocalString(oScribe, "rh_cmw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Cure Moderate Wounds.");
            }
         if(GetLocalString(oScribe, "rh_csw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Cure Serious Wounds.");
            }
         if(GetLocalString(oScribe, "rh_divfavor") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Divine Favour.");
            }
         if(GetLocalString(oScribe, "rh_divpower") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Divine Power.");
            }
         if(GetLocalString(oScribe, "rh_rest") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Restoration.");
            }
         if(GetLocalString(oScribe, "rh_rmight") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Righteous Might.");
            }
         if(GetLocalString(oScribe, "rh_seein") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, See Invisibility.");
            }
         if(GetLocalString(oScribe, "rh_spellr") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Spell Resistance.");
            }
         if(GetLocalString(oScribe, "rh_stone") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Stoneskin.");
            }
         if(GetLocalString(oScribe, "rh_truestrike") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, True Strike.");
            }
         if(GetLocalString(oScribe, "rh_dward") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Deathward.");
            }
         if(GetLocalString(oScribe, "rh_endur") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Endurance.");
            }
         if(GetLocalString(oScribe, "rh_gmw") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Greater Magic Weapon.");
            }
         if(GetLocalString(oScribe, "rh_haste") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Haste.");
            }
         if(GetLocalString(oScribe, "rh_heal") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Heal.");
            }
         if(GetLocalString(oScribe, "rh_impinv") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Improved Invisibility.");
            }
         if(GetLocalString(oScribe, "rh_invis") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Invisibility.");
            }
         if(GetLocalString(oScribe, "rh_keen") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Keen Edge.");
            }
         if(GetLocalString(oScribe, "rh_pois") == "1")
            {
            SendMessageToPC(oPC,"Rune Scribed: Right Hand, Neutralize Poison.");
            }
         }
        oScribe = GetNextItemInInventory(oPC);
      }
}
