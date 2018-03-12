//::///////////////////////////////////////////////
//:: User Defined OnHitCastSpell code
//:: x2_s3_onhitcast
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This file can hold your module specific
    OnHitCastSpell definitions

    How to use:
    - Add the Item Property OnHitCastSpell: UniquePower (OnHit)
    - Add code to this spellscript (see below)

   WARNING!
   This item property can be a major performance hog when used
   extensively in a multi player module. Especially in higher
   levels, with each player having multiple attacks, having numerous
   of OnHitCastSpell items in your module this can be a problem.

   It is always a good idea to keep any code in this script as
   optimized as possible.


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-22
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "prc_class_const"

void SetRancorVar(object oPC);

void main()
{

   object oItem;        // The item casting triggering this spellscript
   object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
   object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor
   int nVassal;         //Vassal Level
   int nBArcher;        // Blood Archer level
   int nFoeHunter;      // Foe Hunter Level
   int bItemIsWeapon;
   
      
   
   // fill the variables
   oSpellOrigin = OBJECT_SELF;
   oSpellTarget = GetSpellTargetObject();
   oItem        =  GetSpellCastItem();
   nVassal =  GetLevelByClass(CLASS_TYPE_VASSAL, OBJECT_SELF);
   nBArcher = GetLevelByClass(CLASS_TYPE_BLARCHER, OBJECT_SELF);
   nFoeHunter = GetLevelByClass(CLASS_TYPE_FOE_HUNTER, OBJECT_SELF);

   if (GetIsObjectValid(oItem))
   {
     // * Generic Item Script Execution Code
     // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
     // * it will execute a script that has the same name as the item's tag
     // * inside this script you can manage scripts for all events by checking against
     // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
     if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
     {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ONHITCAST);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }
     }

//// Stormlord Shocking & Thundering Spear

     if (GetHasFeat( FEAT_THUNDER_WEAPON,OBJECT_SELF))
           ExecuteScript("ft_shockweap",OBJECT_SELF);

     if (GetHasSpellEffect(TEMPUS_ENCHANT_WEAPON,oItem))
     {
       if ( (GetLocalInt(OBJECT_SELF,"WeapEchant1")==TEMPUS_ABILITY_VICIOUS && MyPRCGetRacialType(oSpellTarget)==GetLocalInt(OBJECT_SELF,"WeapEchantRace1")) ||
            (GetLocalInt(OBJECT_SELF,"WeapEchant2")==TEMPUS_ABILITY_VICIOUS && MyPRCGetRacialType(oSpellTarget)==GetLocalInt(OBJECT_SELF,"WeapEchantRace2")) ||
            (GetLocalInt(OBJECT_SELF,"WeapEchant3")==TEMPUS_ABILITY_VICIOUS && MyPRCGetRacialType(oSpellTarget)==GetLocalInt(OBJECT_SELF,"WeapEchantRace3")) )
           ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(d6()),OBJECT_SELF);
     }

     if (GetIsPC(oSpellOrigin))
             SetLocalInt(oSpellOrigin,"DmgDealt",GetTotalDamageDealt());

   }
   
   /// Vassal of Bahamut Dragonwrack
     if (nVassal > 3)
        {
           if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
            {
                ExecuteScript("prc_vb_dw_armor", oSpellOrigin);
            }
           else
            {
                ExecuteScript("prc_vb_dw_weap", oSpellOrigin);
            }
         }
   /// Blood Archer Acidic Blood
      if (nBArcher > 2)
        {
           if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
            {
                ExecuteScript("prc_bldarch_ab", oSpellOrigin);
            }
         }
   
   // Blood Archer Poison Blood
   if (nBArcher > 1 && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
   {
        // poison number based on archer level
        // gives proper DC for poison
        int iPoison = 104 + nBArcher;
        effect ePoison = EffectPoison(iPoison);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oSpellTarget);
   }
   
   // Frenzied Berserker Auto Frenzy
   if(GetHasFeat(FEAT_FRENZY, OBJECT_SELF) && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
   {      
	if(!GetHasFeatEffect(FEAT_FRENZY))
	{	    
             DelayCommand(0.01, ExecuteScript("prc_fb_auto_fre",OBJECT_SELF) );
        }
        
        if(GetHasFeatEffect(FEAT_FRENZY) && GetHasFeat(FEAT_DEATHLESS_FRENZY, OBJECT_SELF) && GetCurrentHitPoints(OBJECT_SELF) == 1)
        {
             DelayCommand(0.01, ExecuteScript("prc_fb_deathless",OBJECT_SELF) );
        }
   }
   
   // Foe Hunter Damage Resistance
   if(nFoeHunter > 1 && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
   {              
        DelayCommand(0.01, ExecuteScript("prc_fh_dr",OBJECT_SELF) );
   }
   
   // Foe Hunter Rancor Attack
   if(nFoeHunter > 0 && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
   {
        if(GetLocalInt(oSpellOrigin, "PRC_CanUseRancor") != 2 && GetLocalInt(oSpellOrigin, "HatedFoe") == MyPRCGetRacialType(oSpellTarget) )
        {
             int iFHLevel = GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oSpellOrigin);
             int iRancorDice = FloatToInt( (( iFHLevel + 1.0 ) /2) );
                          
             int iDamage = d6(iRancorDice);
             int iDamType = GetWeaponDamageType(oItem);
             int iDamPower = GetDamagePowerConstant(oItem, oSpellTarget, oSpellOrigin);
             
             effect eDam = EffectDamage(iDamage, iDamType, iDamPower);

             string sMess = "*Rancor Attack*";
             FloatingTextStringOnCreature(sMess, oSpellOrigin, FALSE);
             ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oSpellTarget);
             
             // Deactivates Ability
             SetLocalInt(oSpellOrigin, "PRC_CanUseRancor", 2);
             
             // Prevents the heartbeat script from running multiple times
             if(GetLocalInt(oSpellOrigin, "PRC_RancorVarRunning") != 1)
             {
                  DelayCommand(6.0, SetRancorVar(oSpellOrigin) );
                  SetLocalInt(oSpellOrigin, "PRC_RancorVarRunning", 1);
             }
        }
   }

	if(GetLocalInt(OBJECT_SELF,"doarcstrike") && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
	{
		int nDice = GetLocalInt(OBJECT_SELF,"curentspell");
		int nDamage = d4(nDice);
		effect eDam = EffectDamage(nDamage);
		ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oSpellTarget);
	}

   	//spellsword
	if(GetLocalInt(oItem,"spell")==1 && GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
	{

	        object oPC = oSpellOrigin;
	        
	        SetLocalInt(oPC,"spellswd_aoe",1);
	        SetLocalInt(oPC,"spell_metamagic",GetLocalInt(oItem,"metamagic_feat_1"));
	        string sSpellString1 = GetLocalString(oItem,"spellscript1");
	        ExecuteScript(sSpellString1,oPC);
	
	        SetLocalInt(oPC,"spell_metamagic",GetLocalInt(oItem,"metamagic_feat_2"));
	        string sSpellString2 = GetLocalString(oItem,"spellscript2");
	        ExecuteScript(sSpellString2,oPC);
	
	        SetLocalInt(oPC,"spell_metamagic",GetLocalInt(oItem,"metamagic_feat_3"));
	        string sSpellString3 = GetLocalString(oItem,"spellscript3");
	        ExecuteScript(sSpellString3,oPC);
	
	        SetLocalInt(oPC,"spell_metamagic",GetLocalInt(oItem,"metamagic_feat_4"));
	        string sSpellString4 = GetLocalString(oItem,"spellscript4");
	        ExecuteScript(sSpellString4,oPC);
	        DeleteLocalString(oItem,"spellscript1");
	        DeleteLocalString(oItem,"spellscript2");
	        DeleteLocalString(oItem,"spellscript3");
	        DeleteLocalString(oItem,"spellscript4");
	        DeleteLocalInt(oItem,"spell");
	        DeleteLocalInt(oPC,"spellswd_aoe");
        	DeleteLocalInt(oPC,"spell_metamagic");
	        
	}


}

void SetRancorVar(object oPC)
{
     // Turn Rancor on
     SetLocalInt(oPC, "PRC_CanUseRancor", 1);
     //FloatingTextStringOnCreature("Rancor Attack Possible", oPC, FALSE);
     
     int iMain = GetMainHandAttacks(oPC);
     float fDelay = 6.0 / IntToFloat(iMain);
     
     // Turn Rancor off after one attack is made
     DelayCommand(fDelay, SetLocalInt(oPC, "PRC_CanUseRancor", 2));
     //DelayCommand((fDelay + 0.01), FloatingTextStringOnCreature("Rancor Attack Not Possible", oPC, FALSE));
     
     // Call again if the character is still in combat.
     // this allows the ability to keep running even if the
     // player does not score a rancor hit during the allotted time
     if( GetIsFighting(oPC) )
     {
          DelayCommand(6.0, SetRancorVar(oPC) );
     }
     else
     {
          DelayCommand(2.0, SetLocalInt(oPC, "PRC_CanUseRancor", 1));
          DelayCommand(2.1, SetLocalInt(oPC, "PRC_RancorVarRunning", 2));
          //DelayCommand(2.2, FloatingTextStringOnCreature("Rancor Enabled After Combat", oPC, FALSE)); 
     }
}
