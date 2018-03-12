#include "prc_class_const"

int StartingConditional()
{

    object oPC = OBJECT_SELF;
    object oScribe = GetFirstItemInInventory(oPC);
    int SpellCount2 = 0;
int lh,la,lc,rh,ra,rc,f;
    while(GetIsObjectValid(oScribe))
      {
       if(GetResRef(oScribe) == "runescarreddagge")
       {

         if(GetLocalString(oScribe, "f_bulls") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "lh_bulls") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "lc_bulls") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "la_bulls") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "rh_bulls") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "rc_bulls") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "ra_bulls") == "1")
            {
            SpellCount2 += 1;
            }

         if(GetLocalString(oScribe, "f_csw") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "lh_csw") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "la_csw") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "lc_csw") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "rh_csw") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "ra_csw") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "rc_csw") == "1")
            {
            SpellCount2 += 1;
            }

         if(GetLocalString(oScribe, "f_endur") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "lh_endur") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "la_endur") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "lc_endur") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "rh_endur") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "ra_endur") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "rc_endur") == "1")
            {
            SpellCount2 += 1;
            }

         if(GetLocalString(oScribe, "f_invis") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "lh_invis") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "la_invis") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "lc_invis") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "rh_invis") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "ra_invis") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "rc_invis") == "1")
            {
            SpellCount2 += 1;
            }

         if(GetLocalString(oScribe, "f_keen") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "lh_keen") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "la_keen") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "lc_keen") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "rh_keen") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "ra_keen") == "1")
            {
            SpellCount2 += 1;
            }

            if(GetLocalString(oScribe, "rc_keen") == "1")
            {
            SpellCount2 += 1;
            }

if(GetLocalString(oScribe, "lh_bulls") == "1"
          ||GetLocalString(oScribe, "lh_ccw") == "1"
          ||GetLocalString(oScribe, "lh_cmw") == "1"
          ||GetLocalString(oScribe, "lh_csw") == "1"
          ||GetLocalString(oScribe, "lh_divfavor") == "1"
          ||GetLocalString(oScribe, "lh_divpower") == "1"
          ||GetLocalString(oScribe, "lh_rest") == "1"
          ||GetLocalString(oScribe, "lh_rmight") == "1"
          ||GetLocalString(oScribe, "lh_seein") == "1"
          ||GetLocalString(oScribe, "lh_spellr") == "1"
          ||GetLocalString(oScribe, "lh_stone") == "1"
          ||GetLocalString(oScribe, "lh_truestrike") == "1"
          ||GetLocalString(oScribe, "lh_dward") == "1"
          ||GetLocalString(oScribe, "lh_endur") == "1"
          ||GetLocalString(oScribe, "lh_gmw") == "1"
          ||GetLocalString(oScribe, "lh_haste") == "1"
          ||GetLocalString(oScribe, "lh_heal") == "1"
          ||GetLocalString(oScribe, "lh_impinv") == "1"
          ||GetLocalString(oScribe, "lh_invis") == "1"
          ||GetLocalString(oScribe, "lh_keen") == "1"
          ||GetLocalString(oScribe, "lh_pois") == "1")lh = 1;

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
          ||GetLocalString(oScribe, "f_pois") == "1")f = 1;

         if(GetLocalString(oScribe, "la_bulls") == "1"
          ||GetLocalString(oScribe, "la_ccw") == "1"
          ||GetLocalString(oScribe, "la_cmw") == "1"
          ||GetLocalString(oScribe, "la_csw") == "1"
          ||GetLocalString(oScribe, "la_divfavor") == "1"
          ||GetLocalString(oScribe, "la_divpower") == "1"
          ||GetLocalString(oScribe, "la_rest") == "1"
          ||GetLocalString(oScribe, "la_rmight") == "1"
          ||GetLocalString(oScribe, "la_seein") == "1"
          ||GetLocalString(oScribe, "la_spellr") == "1"
          ||GetLocalString(oScribe, "la_stone") == "1"
          ||GetLocalString(oScribe, "la_truestrike") == "1"
          ||GetLocalString(oScribe, "la_dward") == "1"
          ||GetLocalString(oScribe, "la_endur") == "1"
          ||GetLocalString(oScribe, "la_gmw") == "1"
          ||GetLocalString(oScribe, "la_haste") == "1"
          ||GetLocalString(oScribe, "la_heal") == "1"
          ||GetLocalString(oScribe, "la_impinv") == "1"
          ||GetLocalString(oScribe, "la_invis") == "1"
          ||GetLocalString(oScribe, "la_keen") == "1"
          ||GetLocalString(oScribe, "la_pois") == "1")la = 1;

         if(GetLocalString(oScribe, "lc_bulls") == "1"
          ||GetLocalString(oScribe, "lc_ccw") == "1"
          ||GetLocalString(oScribe, "lc_cmw") == "1"
          ||GetLocalString(oScribe, "lc_csw") == "1"
          ||GetLocalString(oScribe, "lc_divfavor") == "1"
          ||GetLocalString(oScribe, "lc_divpower") == "1"
          ||GetLocalString(oScribe, "lc_rest") == "1"
          ||GetLocalString(oScribe, "lc_rmight") == "1"
          ||GetLocalString(oScribe, "lc_seein") == "1"
          ||GetLocalString(oScribe, "lc_spellr") == "1"
          ||GetLocalString(oScribe, "lc_stone") == "1"
          ||GetLocalString(oScribe, "lc_truestrike") == "1"
          ||GetLocalString(oScribe, "lc_dward") == "1"
          ||GetLocalString(oScribe, "lc_endur") == "1"
          ||GetLocalString(oScribe, "lc_gmw") == "1"
          ||GetLocalString(oScribe, "lc_haste") == "1"
          ||GetLocalString(oScribe, "lc_heal") == "1"
          ||GetLocalString(oScribe, "lc_impinv") == "1"
          ||GetLocalString(oScribe, "lc_invis") == "1"
          ||GetLocalString(oScribe, "lc_keen") == "1"
          ||GetLocalString(oScribe, "lc_pois") == "1")lc = 1;

         if(GetLocalString(oScribe, "ra_bulls") == "1"
          ||GetLocalString(oScribe, "ra_ccw") == "1"
          ||GetLocalString(oScribe, "ra_cmw") == "1"
          ||GetLocalString(oScribe, "ra_csw") == "1"
          ||GetLocalString(oScribe, "ra_divfavor") == "1"
          ||GetLocalString(oScribe, "ra_divpower") == "1"
          ||GetLocalString(oScribe, "ra_rest") == "1"
          ||GetLocalString(oScribe, "ra_rmight") == "1"
          ||GetLocalString(oScribe, "ra_seein") == "1"
          ||GetLocalString(oScribe, "ra_spellr") == "1"
          ||GetLocalString(oScribe, "ra_stone") == "1"
          ||GetLocalString(oScribe, "ra_truestrike") == "1"
          ||GetLocalString(oScribe, "ra_dward") == "1"
          ||GetLocalString(oScribe, "ra_endur") == "1"
          ||GetLocalString(oScribe, "ra_gmw") == "1"
          ||GetLocalString(oScribe, "ra_haste") == "1"
          ||GetLocalString(oScribe, "ra_heal") == "1"
          ||GetLocalString(oScribe, "ra_impinv") == "1"
          ||GetLocalString(oScribe, "ra_invis") == "1"
          ||GetLocalString(oScribe, "ra_keen") == "1"
          ||GetLocalString(oScribe, "ra_pois") == "1")ra = 1;

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
          ||GetLocalString(oScribe, "rc_pois") == "1")rc = 1;

         if(GetLocalString(oScribe, "rh_bulls") == "1"
          ||GetLocalString(oScribe, "rh_ccw") == "1"
          ||GetLocalString(oScribe, "rh_cmw") == "1"
          ||GetLocalString(oScribe, "rh_csw") == "1"
          ||GetLocalString(oScribe, "rh_divfavor") == "1"
          ||GetLocalString(oScribe, "rh_divpower") == "1"
          ||GetLocalString(oScribe, "rh_rest") == "1"
          ||GetLocalString(oScribe, "rh_rmight") == "1"
          ||GetLocalString(oScribe, "rh_seein") == "1"
          ||GetLocalString(oScribe, "rh_spellr") == "1"
          ||GetLocalString(oScribe, "rh_stone") == "1"
          ||GetLocalString(oScribe, "rh_truestrike") == "1"
          ||GetLocalString(oScribe, "rh_dward") == "1"
          ||GetLocalString(oScribe, "rh_endur") == "1"
          ||GetLocalString(oScribe, "rh_gmw") == "1"
          ||GetLocalString(oScribe, "rh_haste") == "1"
          ||GetLocalString(oScribe, "rh_heal") == "1"
          ||GetLocalString(oScribe, "rh_impinv") == "1"
          ||GetLocalString(oScribe, "rh_invis") == "1"
          ||GetLocalString(oScribe, "rh_keen") == "1"
          ||GetLocalString(oScribe, "rh_pois") == "1")rh = 1;

         if(rh == 1
            && ra == 1
            && rc == 1
            && lh == 1
            && la == 1
            && lc == 1
            && f  == 1)return FALSE;
         }
        oScribe = GetNextItemInInventory(oPC);
      }

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) >= 3)
        iPassed = 1;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 3 && SpellCount2 == 1)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 4 && SpellCount2 == 2)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 5 && SpellCount2 == 2)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 6 && SpellCount2 == 3)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 7 && SpellCount2 == 3)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) == 8 && SpellCount2 == 3)
        return FALSE;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, GetPCSpeaker()) >= 9 && SpellCount2 == 4)
        return FALSE;

    if(GetAbilityScore(GetPCSpeaker(),ABILITY_WISDOM) < 12)
        return FALSE;

    if(iPassed == 0)
        return FALSE;

    return TRUE;
}