/*
   ----------------
   prc_enforce_feat
   ----------------

   7/25/04 by Stratovarius

   This script is used to enforce the proper selection of bonus feats
   so that people cannot use epic bonus feats and class bonus feats to
   select feats they should not be allowed to. Only contains the Red Wizard,
   but more, such as the Mage Killer and Fist of Hextor, will be added later.
*/


#include "prc_class_const"
#include "prc_feat_const"
#include "prc_alterations"


// Enforces the proper selection of the Red Wizard feats
// that are used to determine restricted and specialist
// spell schools. You must have two restricted and one specialist.
void RedWizardFeats(object oPC = OBJECT_SELF);

// Enforces the proper selection of the Mage Killer
// Bonus Save feats.
void MageKiller(object oPC = OBJECT_SELF);

// Enforces the proper selection of the Fist of Hextor
// Brutal Strike feats.
void Hextor(object oPC = OBJECT_SELF);

// Enforces the proper selection of the Vile feats
// and prevents illegal stacking of them
void VileFeats(object oPC = OBJECT_SELF);

// Enforces the proper selection of the Ultimate Ranger feats
// and prevents illegal use of bonus feats.
void UltiRangerFeats(object oPC = OBJECT_SELF);

// Stops non-Orcs from taking the Blood of the Warlord
// Feat, can be expanded later.
void Warlord(object oPC = OBJECT_SELF);


// Enforces Genasai taking the proper elemental domain
void GenasaiFocus(object oPC = OBJECT_SELF);

// ---------------
// BEGIN FUNCTIONS
// ---------------
void RedWizardFeats(object oPC = OBJECT_SELF)
{

     int iRedWizard = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oPC);
     int iRWRes;
     int iRWSpec;


          iRWSpec     += (GetHasFeat(FEAT_RW_TF_ABJ, oPC))
                   +     (GetHasFeat(FEAT_RW_TF_CON, oPC))
                   +     (GetHasFeat(FEAT_RW_TF_DIV, oPC))
                   +     (GetHasFeat(FEAT_RW_TF_ENC, oPC))
                   +     (GetHasFeat(FEAT_RW_TF_EVO, oPC))
                   +     (GetHasFeat(FEAT_RW_TF_ILL, oPC))
                   +     (GetHasFeat(FEAT_RW_TF_NEC, oPC))
                   +     (GetHasFeat(FEAT_RW_TF_TRS, oPC));

          if (iRWSpec > 1)
          {
               int nHD = GetHitDice(oPC);
               int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
               int nOldXP = GetXP(oPC);
               int nNewXP = nMinXPForLevel - 1000;
               SetXP(oPC,nNewXP);
               FloatingTextStringOnCreature("You may only have one Tattoo Focus. Please reselect your feats.", oPC, FALSE);
               DelayCommand(1.0, SetXP(oPC,nOldXP));
          }


     if (iRedWizard > 0)
     {
          iRWRes      += (GetHasFeat(FEAT_RW_RES_ABJ, oPC))
                   +     (GetHasFeat(FEAT_RW_RES_CON, oPC))
                   +     (GetHasFeat(FEAT_RW_RES_DIV, oPC))
                   +     (GetHasFeat(FEAT_RW_RES_ENC, oPC))
                   +     (GetHasFeat(FEAT_RW_RES_EVO, oPC))
                   +     (GetHasFeat(FEAT_RW_RES_ILL, oPC))
                   +     (GetHasFeat(FEAT_RW_RES_NEC, oPC))
                   +     (GetHasFeat(FEAT_RW_RES_TRS, oPC));


          if (iRWRes != 2)
          {
               int nHD = GetHitDice(oPC);
               int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
               int nOldXP = GetXP(oPC);
               int nNewXP = nMinXPForLevel - 1000;
               SetXP(oPC,nNewXP);
               FloatingTextStringOnCreature("You must have 2 Restricted Schools. Please reselect your feats.", oPC, FALSE);
               DelayCommand(1.0, SetXP(oPC,nOldXP));
          }
     }
}


void MageKiller(object oPC = OBJECT_SELF)
{

     int iMK = (GetLevelByClass(CLASS_TYPE_MAGEKILLER, oPC) + 1) / 2;

     int iRef = 0;
     int iFort = 0;
     int iMKSave = 0;

     if (iMK > 0)
     {

     iRef +=        GetHasFeat(FEAT_MK_REF_15, oPC) +
               GetHasFeat(FEAT_MK_REF_14, oPC) +
               GetHasFeat(FEAT_MK_REF_13, oPC) +
               GetHasFeat(FEAT_MK_REF_12, oPC) +
               GetHasFeat(FEAT_MK_REF_11, oPC) +
               GetHasFeat(FEAT_MK_REF_10, oPC) +
               GetHasFeat(FEAT_MK_REF_9, oPC) +
               GetHasFeat(FEAT_MK_REF_8, oPC) +
               GetHasFeat(FEAT_MK_REF_7, oPC) +
               GetHasFeat(FEAT_MK_REF_6, oPC) +
               GetHasFeat(FEAT_MK_REF_5, oPC) +
               GetHasFeat(FEAT_MK_REF_4, oPC) +
               GetHasFeat(FEAT_MK_REF_3, oPC) +
               GetHasFeat(FEAT_MK_REF_2, oPC) +
               GetHasFeat(FEAT_MK_REF_1, oPC);

     iFort +=  GetHasFeat(FEAT_MK_FORT_15, oPC) +
               GetHasFeat(FEAT_MK_FORT_14, oPC) +
               GetHasFeat(FEAT_MK_FORT_13, oPC) +
               GetHasFeat(FEAT_MK_FORT_12, oPC) +
               GetHasFeat(FEAT_MK_FORT_11, oPC) +
               GetHasFeat(FEAT_MK_FORT_10, oPC) +
               GetHasFeat(FEAT_MK_FORT_9, oPC) +
               GetHasFeat(FEAT_MK_FORT_8, oPC) +
               GetHasFeat(FEAT_MK_FORT_7, oPC) +
               GetHasFeat(FEAT_MK_FORT_6, oPC) +
               GetHasFeat(FEAT_MK_FORT_5, oPC) +
               GetHasFeat(FEAT_MK_FORT_4, oPC) +
               GetHasFeat(FEAT_MK_FORT_3, oPC) +
               GetHasFeat(FEAT_MK_FORT_2, oPC) +
               GetHasFeat(FEAT_MK_FORT_1, oPC);

     iMKSave = iRef + iFort;
/*
     FloatingTextStringOnCreature("Mage Killer Level: " + IntToString(iMK), oPC, FALSE);
     FloatingTextStringOnCreature("Reflex Save Level: " + IntToString(iRef), oPC, FALSE);
     FloatingTextStringOnCreature("Fortitude Save Level: " + IntToString(iFort), oPC, FALSE);
*/
     if (iMK != iMKSave)
     {
          int nHD = GetHitDice(oPC);
          int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
          int nOldXP = GetXP(oPC);
          int nNewXP = nMinXPForLevel - 1000;
          SetXP(oPC,nNewXP);
          FloatingTextStringOnCreature("You must select an Improved Save Feat. Please reselect your feats.", oPC, FALSE);
          DelayCommand(1.0, SetXP(oPC,nOldXP));
     }

     }
}

void Hextor(object oPC = OBJECT_SELF)
{

     int iHextor = GetLevelByClass(CLASS_TYPE_HEXTOR, oPC);

     int iAtk = 0;
     int iDam = 0;
     int iTotal = 0;
     int iCheck;

     if (iHextor > 0)
     {

     iAtk +=        GetHasFeat(FEAT_BSTRIKE_A12, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A11, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A10, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A9, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A8, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A7, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A6, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A5, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A4, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A3, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A2, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A1, oPC);

     iDam +=        GetHasFeat(FEAT_BSTRIKE_D12, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D11, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D10, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D9, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D8, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D7, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D6, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D5, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D4, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D3, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D2, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D1, oPC);

     iTotal = iAtk + iDam;

     if (iTotal == 12 && iHextor > 29) { iCheck = TRUE; }
     else if (iTotal == 11 && iHextor > 26 && iHextor < 30) { iCheck = TRUE; }
     else if (iTotal == 10 && iHextor > 23 && iHextor < 27) { iCheck = TRUE; }
     else if (iTotal == 9 && iHextor > 20 && iHextor < 24) { iCheck = TRUE; }
     else if (iTotal == 8 && iHextor > 19 && iHextor < 21) { iCheck = TRUE; }
     else if (iTotal == 7 && iHextor > 16 && iHextor < 20) { iCheck = TRUE; }
     else if (iTotal == 6 && iHextor > 13 && iHextor < 17) { iCheck = TRUE; }
     else if (iTotal == 5 && iHextor > 10 && iHextor < 14) { iCheck = TRUE; }
     else if (iTotal == 4 && iHextor > 9 && iHextor < 11) { iCheck = TRUE; }
     else if (iTotal == 3 && iHextor > 6 && iHextor < 10) { iCheck = TRUE; }
     else if (iTotal == 2 && iHextor > 3 && iHextor < 7) { iCheck = TRUE; }
     else if (iTotal == 1 && iHextor > 0) { iCheck = TRUE; }
     else { iCheck = FALSE; }

/*
     FloatingTextStringOnCreature("Fist of Hextor Level: " + IntToString(iHextor), oPC, FALSE);
     FloatingTextStringOnCreature("Brutal Strike Attack Level: " + IntToString(iAtk), oPC, FALSE);
     FloatingTextStringOnCreature("Brutal Strike Damage Level: " + IntToString(iDam), oPC, FALSE);
*/
     if (iCheck != TRUE)
     {
          int nHD = GetHitDice(oPC);
          int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
          int nOldXP = GetXP(oPC);
          int nNewXP = nMinXPForLevel - 1000;
          SetXP(oPC,nNewXP);
          FloatingTextStringOnCreature("You must select a Brutal Strike Feat. Please reselect your feats.", oPC, FALSE);
          DelayCommand(1.0, SetXP(oPC,nOldXP));
     }

     }
}


void GenasaiFocus(object oPC)
{
   if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && (GetRacialType(oPC) == RACIAL_TYPE_AIR_GEN))
   {
       if (!GetHasFeat(FEAT_AIR_DOMAIN_POWER, oPC))
       {
        int nHD = GetHitDice(oPC);
        int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
        int nOldXP = GetXP(oPC);
        int nNewXP = nMinXPForLevel - 1000;
        SetXP(oPC,nNewXP);
        FloatingTextStringOnCreature("You must have the Air Domain as an Air Genasai.", oPC, FALSE);
        DelayCommand(1.0, SetXP(oPC,nOldXP));
       }
   }
   if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && (GetRacialType(oPC) == RACIAL_TYPE_EARTH_GEN))
   {
       if (!GetHasFeat(FEAT_EARTH_DOMAIN_POWER, oPC))
       {
        int nHD = GetHitDice(oPC);
        int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
        int nOldXP = GetXP(oPC);
        int nNewXP = nMinXPForLevel - 1000;
        SetXP(oPC,nNewXP);
        FloatingTextStringOnCreature("You must have the Earth Domain as an Earth Genasai.", oPC, FALSE);
        DelayCommand(1.0, SetXP(oPC,nOldXP));
       }
   }
   if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && (GetRacialType(oPC) == RACIAL_TYPE_FIRE_GEN))
   {
       if (!GetHasFeat(FEAT_FIRE_DOMAIN_POWER, oPC))
       {
        int nHD = GetHitDice(oPC);
        int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
        int nOldXP = GetXP(oPC);
        int nNewXP = nMinXPForLevel - 1000;
        SetXP(oPC,nNewXP);
        FloatingTextStringOnCreature("You must have the Fire Domain as an Fire Genasai.", oPC, FALSE);
        DelayCommand(1.0, SetXP(oPC,nOldXP));
       }
   }
   if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && (GetRacialType(oPC) == RACIAL_TYPE_WATER_GEN))
   {
       if (!GetHasFeat(FEAT_WATER_DOMAIN_POWER, oPC))
       {
        int nHD = GetHitDice(oPC);
        int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
        int nOldXP = GetXP(oPC);
        int nNewXP = nMinXPForLevel - 1000;
        SetXP(oPC,nNewXP);
        FloatingTextStringOnCreature("You must have the Water Domain as an Water Genasai.", oPC, FALSE);
        DelayCommand(1.0, SetXP(oPC,nOldXP));
       }
   }
}


void VileFeats(object oPC = OBJECT_SELF)
{

     int iDeform = GetHasFeat(FEAT_VILE_DEFORM_OBESE, oPC) + GetHasFeat(FEAT_VILE_DEFORM_GAUNT, oPC);
     int iThrall = GetHasFeat(FEAT_THRALL_TO_DEMON, oPC) + GetHasFeat(FEAT_DISCIPLE_OF_DARKNESS, oPC);


          if (iDeform > 1)
          {
               int nHD = GetHitDice(oPC);
               int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
               int nOldXP = GetXP(oPC);
               int nNewXP = nMinXPForLevel - 1000;
               SetXP(oPC,nNewXP);
               FloatingTextStringOnCreature("You may only have one Deformity. Please reselect your feats.", oPC, FALSE);
               DelayCommand(1.0, SetXP(oPC,nOldXP));
          }


          if (iThrall > 1)
          {
               int nHD = GetHitDice(oPC);
               int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
               int nOldXP = GetXP(oPC);
               int nNewXP = nMinXPForLevel - 1000;
               SetXP(oPC,nNewXP);
               FloatingTextStringOnCreature("You may only worship Demons or Devils, not both. Please reselect your feats.", oPC, FALSE);
               DelayCommand(1.0, SetXP(oPC,nOldXP));
          }
}

void Warlord(object oPC = OBJECT_SELF)
{
          if (GetHasFeat(FEAT_BLOOD_OF_THE_WARLORD, oPC) && (MyPRCGetRacialType(oPC) != RACIAL_TYPE_HALFORC)
                  && (MyPRCGetRacialType(oPC) != RACIAL_TYPE_HUMANOID_ORC))
          {
               int nHD = GetHitDice(oPC);
               int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
               int nOldXP = GetXP(oPC);
               int nNewXP = nMinXPForLevel - 1000;
               SetXP(oPC,nNewXP);
               FloatingTextStringOnCreature("You must be an Orc or Half-Orc to take this feat. Please reselect your feats.", oPC, FALSE);
               DelayCommand(1.0, SetXP(oPC,nOldXP));
          }
}

void Ethran(object oPC = OBJECT_SELF)
{
          if (GetHasFeat(FEAT_ETHRAN, oPC) && (GetGender(oPC) != GENDER_FEMALE))
          {
               int nHD = GetHitDice(oPC);
               int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
               int nOldXP = GetXP(oPC);
               int nNewXP = nMinXPForLevel - 1000;
               SetXP(oPC,nNewXP);
               FloatingTextStringOnCreature("You must be Female to take this feat. Please reselect your feats.", oPC, FALSE);
               DelayCommand(1.0, SetXP(oPC,nOldXP));
          }
}

void UltiRangerFeats(object oPC = OBJECT_SELF)
{

     int iURanger = GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER, oPC);
     int iAbi = 0, iFE = 0, Ability = 0;

     if (iURanger > 0)
     {
          iFE     +=     (GetHasFeat(FEAT_UR_FE_DWARF, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_ELF, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_GNOME, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_HALFING, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_HALFELF, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_HALFORC, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_HUMAN, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_ABERRATION, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_ANIMAL, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_BEAST, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_CONSTRUCT, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_DRAGON, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_GOBLINOID, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_MONSTROUS, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_ORC, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_REPTILIAN, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_ELEMENTAL, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_FEY, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_GIANT, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_MAGICAL_BEAST, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_OUTSIDER, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_SHAPECHANGER, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_UNDEAD, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_VERMIN, oPC));

          iAbi    +=     (GetHasFeat(FEAT_UR_SNEAKATK_3D6, oPC))
                   +     (GetHasFeat(FEAT_UR_ARMOREDGRACE, oPC))
                   +     (GetHasFeat(FEAT_UR_DODGE_FE, oPC))
                   +     (GetHasFeat(FEAT_UR_RESIST_FE, oPC))
                   +     (GetHasFeat(FEAT_UR_HAWK_TOTEM, oPC))
                   +     (GetHasFeat(FEAT_UR_OWL_TOTEM, oPC))
                   +     (GetHasFeat(FEAT_UR_VIPER_TOTEM, oPC))
                   +     (GetHasFeat(FEAT_UR_FAST_MOVEMENT, oPC))
                   +     (GetHasFeat(FEAT_UNCANNYX_DODGE_1, oPC))
                   +     (GetHasFeat(FEAT_UR_HIPS, oPC));

                if (iURanger>=11){
                   if ((iURanger-8)/3 != iAbi) Ability = 1;
                }

          if ( iFE != (iURanger+3)/5 || Ability)
          {
               int nHD = GetHitDice(oPC);
               int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
               int nOldXP = GetXP(oPC);
               int nNewXP = nMinXPForLevel - 1000;
               SetXP(oPC,nNewXP);
               string sAbi ="1 ability ";
               string sFE =" 1 favorite enemy ";
               string msg=" You must select ";
               int bFeat;
                     if (iURanger>4 && iURanger<21 ) bFeat = ((iURanger+1)%4 == 0);
                     else if (iURanger>20 ) bFeat = ((iURanger+2)%5 == 0);
               if (iURanger>10 &&  (iURanger-8)%3 == 0) msg = msg+sAbi+" ";
               if (iURanger>1 && (iURanger+8)%5 == 0) msg+=sFE;
               if (iURanger == 1 || iURanger == 4 ||bFeat) msg+= " 1 bonus Feat";

               //FloatingTextStringOnCreature(" Please reselect your feats.", oPC, FALSE);
               FloatingTextStringOnCreature(msg, oPC, FALSE);
               DelayCommand(1.0, SetXP(oPC,nOldXP));
          }
          else
          {
              iURanger++;
              string msg =" In your next Ultimate Ranger level, you must select ";
              int bFeat;
                 if (iURanger>4 && iURanger<21 ) bFeat = ((iURanger+1)%4 == 0);
                 else if (iURanger>20 ) bFeat = ((iURanger+2)%5 == 0);
              if (iURanger == 1 || iURanger == 4 || bFeat) msg+= "1 bonus Feat ";
                    if (iURanger>10 &&  (iURanger-8)%3 == 0) msg +="1 Ability ";
                    if (iURanger>1 && (iURanger+8)%5 == 0) msg+="1 Favorite Enemy ";
                    if ( msg != " In your next Ultimate Ranger level, you must select ")
                      FloatingTextStringOnCreature(msg, oPC, FALSE);
          }
     }
}

void CheckClericShadowWeave(object oPC)
{
   if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && GetHasFeat(FEAT_SHADOWWEAVE, oPC))
   {
       int iCleDom = GetHasFeat(FEAT_EVIL_DOMAIN_POWER, oPC) +
                     GetHasFeat(FEAT_KNOWLEDGE_DOMAIN_POWER, oPC) +
                     GetHasFeat(FEAT_DARKNESS_DOMAIN, oPC);

       if (iCleDom < 2)
       {
           int nHD = GetHitDice(oPC);
        int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
        int nOldXP = GetXP(oPC);
        int nNewXP = nMinXPForLevel - 1000;
        SetXP(oPC,nNewXP);
        FloatingTextStringOnCreature("You must have two of the following domains: Evil, Knowledge, or Darkness to use the shadow weave.", oPC, FALSE);
        FloatingTextStringOnCreature("Please reselect your feats.", oPC, FALSE);
        DelayCommand(1.0, SetXP(oPC,nOldXP));
       }
   }
}

void LolthsMeat(object oPC)
{
     if (GetHasFeat(FEAT_LOLTHS_MEAT, oPC) &&
         (GetRacialType(oPC) != RACIAL_TYPE_DROW_FEMALE &&
          GetRacialType(oPC) != RACIAL_TYPE_DROW_MALE   &&
          GetRacialType(oPC) != RACIAL_TYPE_ELF         &&
          GetRacialType(oPC) != RACIAL_TYPE_HALFDROW        ) )
     {
          int nHD = GetHitDice(oPC);
          int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
          int nOldXP = GetXP(oPC);
          int nNewXP = nMinXPForLevel - 1000;
          SetXP(oPC,nNewXP);
          FloatingTextStringOnCreature("You must be a Drow or Half-Drow to take this feat. Please reselect your feats.", oPC, FALSE);
          DelayCommand(1.0, SetXP(oPC,nOldXP));
     }
}

void main()
{
        //Declare Major Variables
        object oPC = OBJECT_SELF;

     RedWizardFeats(oPC);
     VileFeats(oPC);
     Warlord(oPC);
     Hextor(oPC);
     Ethran(oPC);
     UltiRangerFeats(oPC);
     MageKiller(oPC);
     GenasaiFocus(oPC);
     CheckClericShadowWeave(oPC);
     LolthsMeat(oPC);
}
