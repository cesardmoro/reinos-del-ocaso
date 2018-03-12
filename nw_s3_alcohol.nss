//::///////////////////////////////////////////////
//:: NW_S3_Alcohol.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Makes beverages fun.
  May 2002: Removed fortitude saves. Just instant intelligence loss
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:   February 2002
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//:: Modified by Jeremiah Teague for Drunken
//:: Master Prestige Class
//:://////////////////////////////////////////////
#include "prc_inc_clsfunc"
#include "prc_class_const"
#include "prc_feat_const"

void main()
{
    object oTarget = GetSpellTargetObject();
    int nDrunkenMaster = GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oTarget);

    switch(nDrunkenMaster)
        {
        case 0:
          {
          MakeDrunk(oTarget, 3);
          break;
          }
        case 1:
          {
          ExecuteScript("prc_dm_drnkdemon", oTarget);
          DrunkenMasterSpeakString(oTarget);
          DrunkenMasterCreateEmptyBottle(oTarget, GetSpellId());
          break;
          }
        case 2:
          {
          ExecuteScript("prc_dm_drnkdemon", oTarget);
          DrunkenMasterSpeakString(oTarget);
          DrunkenMasterCreateEmptyBottle(oTarget, GetSpellId());
          break;
          }
        case 3:
          {
          ExecuteScript("prc_dm_drnkdemon", oTarget);
          DrunkenMasterSpeakString(oTarget);
          DrunkenMasterCreateEmptyBottle(oTarget, GetSpellId());
          break;
          }
        case 4:
          {
          ExecuteScript("prc_dm_drnkdemon", oTarget);
          DrunkenMasterSpeakString(oTarget);
          DrunkenMasterCreateEmptyBottle(oTarget, GetSpellId());
          break;
          }
        case 5:
          {
          ExecuteScript("prc_dm_drnknrage", oTarget);
          DrunkenMasterSpeakString(oTarget);
          DrunkenMasterCreateEmptyBottle(oTarget, GetSpellId());
          break;
          }
        case 6:
          {
          ExecuteScript("prc_dm_drnknrage", oTarget);
          DrunkenMasterSpeakString(oTarget);
          DrunkenMasterCreateEmptyBottle(oTarget, GetSpellId());
          break;
          }
        case 7:
          {
          ExecuteScript("prc_dm_drnknrage", oTarget);
          DrunkenMasterSpeakString(oTarget);
          DrunkenMasterCreateEmptyBottle(oTarget, GetSpellId());
          break;
          }
        case 8:
          {
          ExecuteScript("prc_dm_drnknrage", oTarget);
          DrunkenMasterSpeakString(oTarget);
          DrunkenMasterCreateEmptyBottle(oTarget, GetSpellId());
          break;
          }
        case 9:
          {
          ExecuteScript("prc_dm_drnknrage", oTarget);
          DrunkenMasterSpeakString(oTarget);
          DrunkenMasterCreateEmptyBottle(oTarget, GetSpellId());
          break;
          }
        case 10:
          {
          ExecuteScript("prc_dm_drnknrage", oTarget);
          DrunkenMasterSpeakString(oTarget);
          DrunkenMasterCreateEmptyBottle(oTarget, GetSpellId());
          break;
          }
        }
}
