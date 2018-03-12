// Written by WodahsEht.
// Calculates the total sneak attack damage die given by all classes,
// and applies the resulting bonuses to the skin.  KNOWN ISSUE:
// Sneak attack feats of the same type can appear twice on the character sheet.
// For instance, Rogue +3d6 appears alongside Rogue +10d6.  They do not stack.
// The damage is 10d6.
// 
// Compatibility with old PRC's is maintained.


#include "prc_class_const"
#include "inc_item_props"
#include "prc_inc_sneak"

void ApplySneakToSkin(object oPC, int iRogueSneak, int iBlackguardSneak)
{
   object oSkin = GetPCSkin(oPC);

   int iRogueSneakFeat = 0;
   int iBlackguardSneakFeat = 0;
   int iPreviousSneakFeat = 0;

   //Rogue Sneaks, in increasing order, from iprp_feat.2da:
   //1-3: 32-34, 4: 301, 5: 39, 6-20: 302-316
   if (iRogueSneak > 20) return;  //Error, should never happen.

   if ((iRogueSneak >= 1) && (iRogueSneak < 4)) iRogueSneakFeat = iRogueSneak + 31;
   if (iRogueSneak == 4) iRogueSneakFeat = 301;
   if (iRogueSneak == 5) iRogueSneakFeat = 39;
   if (iRogueSneak >= 6) iRogueSneakFeat = iRogueSneak + 296;

   //Blackguard Sneaks
   //1-15: 276-290
   if (iBlackguardSneak > 15) return; //Error, should never happen.

   if (iBlackguardSneak) iBlackguardSneakFeat = iBlackguardSneak + 275;

   // This is basically to always readd the sneaks on every event PRCEvalFeats is called...
   iPreviousSneakFeat = GetLocalInt(oSkin,"RogueSneakDice");
   if (iPreviousSneakFeat) DelayCommand(0.1, RemoveSpecificProperty(oSkin,
                           ITEM_PROPERTY_BONUS_FEAT,iPreviousSneakFeat));

   iPreviousSneakFeat = GetLocalInt(oSkin,"BlackguardSneakDice");
   if (iPreviousSneakFeat) DelayCommand(0.1, RemoveSpecificProperty(oSkin,
                           ITEM_PROPERTY_BONUS_FEAT,iPreviousSneakFeat));

   SetLocalInt(oSkin,"RogueSneakDice",iRogueSneakFeat);
   SetLocalInt(oSkin,"BlackguardSneakDice",iBlackguardSneakFeat);

   if (iRogueSneak) DelayCommand(0.2, AddItemProperty(DURATION_TYPE_PERMANENT,
                           ItemPropertyBonusFeat(iRogueSneakFeat), oSkin));
   if (iBlackguardSneak) DelayCommand(0.2, AddItemProperty(DURATION_TYPE_PERMANENT,
                           ItemPropertyBonusFeat(iBlackguardSneakFeat), oSkin));
}


void main()
{
   object oPC = OBJECT_SELF;
   object oSkin = GetPCSkin(oPC);

   int iRogueSneakDice = GetRogueSneak(oPC);
   int iBlackguardSneakDice = GetBlackguardSneak(oPC);

   // Special case in case someone multiclasses Telflammar Shadowlord and Assassin -- These are the only
   // two classes that use Assassin Death Attack, and normally they would not stack.
   if((GetLevelByClass(CLASS_TYPE_SHADOWLORD, oPC) >= 6) && (GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC)))
      iRogueSneakDice++;

   int iFinalSneakDice = iRogueSneakDice + iBlackguardSneakDice;
   
   if(iRogueSneakDice > 20)        //Basically, if the total sneaks spill over the rogue limit,
   {                               //Add it to the Blackguard sneaks.  Only possible with a Rog39/PA1 ATM.
      iBlackguardSneakDice += iRogueSneakDice - 20;
      iRogueSneakDice = 20;
   }
   if(iBlackguardSneakDice > 15)   //Same as above, handles BG spillover.  Not really possible, but...
   {
      iRogueSneakDice += iBlackguardSneakDice - 15;
      iBlackguardSneakDice = 15;
   }
   if(iRogueSneakDice > 20)
   {
      //Keep in mind we are not considering the Assassin's Death Attack or Improved
      //Sneak Attack.  If we hit more than +35d6 there is something wrong with the
      //character or the above code.
      SendMessageToPC(oPC,"Fatal error: +35d6 Rogue/Blackguard Sneak Attack exceeded!");
      return;
   }

   // code to remove sneak attack feats if they had them before, but not now.
   // mainly used for classes whose sneak is based on using a certain weapon
   // such as the blood archer, peerless archer, and halfling warslinger.
   int iPreviousSneak = GetLocalInt(oSkin,"RogueSneakDice");
   if(!iFinalSneakDice && iPreviousSneak) DelayCommand(0.1, RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, iPreviousSneak));

   iPreviousSneak = GetLocalInt(oSkin,"BlackguardSneakDice");
   if(!iFinalSneakDice && iPreviousSneak) DelayCommand(0.1, RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, iPreviousSneak));
   
   if(iFinalSneakDice) ApplySneakToSkin(oPC,iRogueSneakDice,iBlackguardSneakDice);
}
