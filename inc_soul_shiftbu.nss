// Soul Eater Shifting Include

#include "prc_alterations"
#include "nw_o0_itemmaker"
#include "nw_i0_spells"
#include "prc_inc_function"


// Adds a creature to the list of valid GWS shift possibilities
void RecognizeCreature( object oPC, string sTemplate, string sCreatureName );

// Checks to see if the specified creature is a valid GWS shift choice
int IsKnownCreature( object oPC, string sTemplate );

// Shift based on position in the known array
// oTemplate is either the epic or normal template
void ShiftFromKnownArray(int nIndex,int iEpic, object oPC);

// Creates a temporary creature for the shifter to shift into
// Validates the shifter is able to become that creature based on level
// Return values: TRUE or FALSE
int SetShiftFromTemplateValidate(object oPC, string sTemplate, int iEpic);

//is inventory full if yes then CanShift = false else CanShift = true
int CanShift(object oPC);

// Transforms the oPC into the oTarget using the epic rules
// Assumes oTarget is already a valid target
// Return values: TRUE or FALSE
int SetShiftEpic(object oPC, object oTarget);

// Transforms the oPC into the oTarget
// Assumes oTarget is already a valid target
// this is 3 stage
// these 3 scripts replace the origanel setshift script
// (setshift_03 is almost all of the origenal setshift script)
void SetShift(object oPC, object oTarget);
void SetShift_02(object oPC, object oTarget);

// Transforms the oPC back to thier true form if they are shifted
// Return values: TRUE or FALSE
void SetShiftTrueForm(object oPC);

//clears out all extra shifter creature items
void ClearShifterItems(object oPC);

//shift from quickslot info
void QuickShift(object oPC, int iQuickSlot);

//asign form to your quick slot
void SetQuickSlot(object oPC, int iIndex, int iQuickSlot, int iEpic);

// Determine if the oCreature has the ability to cast spells
// Return values: TRUE or FALSE
int GetCanFormCast(object oCreature);

// Determines if the oCreature is harmless enough to have
// special effects applied to the shifter
// Return values: TRUE or FALSE
int GetIsCreatureHarmless(object oCreature);

// Transforms the oPC back to thier true form if they are shifted
// Return values: TRUE or FALSE
void SetShiftTrueForm(object oPC);

// Extra item functions
// Copys all the item properties from the target to the destination
void CopyAllItemProperties(object oDestination,object oTarget);

// Gets all the ability modifires from the creature objects inv
// use IP_CONTS_ABILITY_*
int GetAllItemsAbilityModifier(object oTarget, int nAbility);

// Removes all the item properties from the item
void RemoveAllItemProperties(object oItem);

// Gets an IP_CONST_FEAT_* from FEAT_*
// returns -1 if the feat is not available
int GetIPFeatFromFeat(int nFeat);

// Determines if the target creature has a certain type of spell
// and sets the powers onto the object item
void SetItemSpellPowers(object oItem, object oTarget);

// Removes leftover aura effects
void RemoveAuraEffect( object oPC );

//delete form from spark
void DeleteFromKnownArray(int nIndex, object oPC);

// Determines the APPEARANCE_TYPE_* for the PC
// based on the players RACIAL type
int GetTrueForm(object oPC);





void RecognizeCreature( object oPC, string sTemplate, string sCreatureName )
{

    // Only add new ones
    if (IsKnownCreature(oPC,sTemplate))
        return;

    object oMimicForms = GetItemPossessedBy( oPC, "soul_prism" );
    if ( !GetIsObjectValid(oMimicForms) )
        oMimicForms = CreateItemOnObject( "soul_prism", oPC );

    SetPlotFlag(oMimicForms, TRUE);
    SetDroppableFlag(oMimicForms, FALSE);
    SetItemCursedFlag(oMimicForms, FALSE);

    int num_creatures = GetLocalInt( oMimicForms, "num_creatures" );

    SetLocalArrayString( oMimicForms, "shift_choice", num_creatures, sTemplate );
    SetLocalArrayString( oMimicForms, "shift_choice_name", num_creatures, sCreatureName );
    SetLocalInt( oMimicForms, "num_creatures", num_creatures+1 );


SendMessageToPC(oPC,"Num Creatures = "+IntToString(num_creatures+1));
}




int IsKnownCreature( object oPC, string sTemplate )
{
    object oMimicForms = GetItemPossessedBy( oPC, "soul_prism" );
    int num_creatures = GetLocalInt( oMimicForms, "num_creatures" );
    int i;
    string cmp;

    for ( i=0; i<num_creatures; i++ )
    {
        cmp = GetLocalArrayString( oMimicForms, "shift_choice", i );
        if ( TestStringAgainstPattern( cmp, sTemplate ) )
        {
            return TRUE;
        }
    }
    return FALSE;
}





// Shift based on position in the known array
void ShiftFromKnownArray(int nIndex,int iEpic, object oPC)
{
    object oMimicForms = GetItemPossessedBy( oPC, "soul_prism" );

    // Find the name
    string sResRef = GetLocalArrayString( oMimicForms, "shift_choice", nIndex );
    if (iEpic == FALSE)
    {
        // Force a normal shift
        SetShiftFromTemplateValidate(oPC,sResRef,FALSE);
    }
    else // epic shift
    {
        SetShiftFromTemplateValidate(oPC,sResRef,TRUE);
    }
}





// Creates a temporary creature for the shifter to shift into
// Validates the shifter is able to become that creature based on level
// Return values: TRUE or FALSE
// the epic version of this script was rolled into this 1 with the
// addition of the iEpic peramiter
int SetShiftFromTemplateValidate(object oPC, string sTemplate, int iEpic)
{
    if (!CanShift(oPC))
    {
        return FALSE;
    }
    int bRetValue = FALSE;
    int in_list = IsKnownCreature( oPC, sTemplate );


    int i=0;
    object oLimbo=GetObjectByTag("Limbo",i);
    location lLimbo;
    while (i < 100)
    {
        if (GetIsObjectValid(oLimbo))
        {
            if (GetName(oLimbo)=="Limbo")
            {
                i = 2000;
                vector vLimbo = Vector(0.0f, 0.0f, 0.0f);
                lLimbo = Location(oLimbo, vLimbo, 0.0f);
            }
        }
        i++;
        object oLimbo=GetObjectByTag("Limbo",i);
    }
    object oTarget;
    if (i>=2000)
    {
        oTarget = CreateObject(OBJECT_TYPE_CREATURE,sTemplate,lLimbo);
    }
    else
    {
        oTarget = CreateObject(OBJECT_TYPE_CREATURE,sTemplate,GetLocation(oPC));
    }
    // Create the obj from the template
//    object oTarget = CreateObject(OBJECT_TYPE_CREATURE,sTemplate,GetLocation(oPC));




        //get the appearance before changing it
        SetLocalInt(oTarget,"Appearance",GetAppearanceType(oTarget));
        //set appearance to invis so it dont show up when scripts run thro
        SetCreatureAppearanceType(oTarget,APPEARANCE_TYPE_INVISIBLE_HUMAN_MALE);
        //set oTarget for deletion
        SetLocalInt(oTarget,"pnp_shifter_deleteme",1);
        //Shift the PC to it
        bRetValue = TRUE;
        if (iEpic==TRUE)
            SetShiftEpic (oPC, oTarget);
        else
            SetShift(oPC,oTarget);

    return bRetValue;
}




int CanShift(object oPC)
{


    int iOutcome = FALSE;

    if (GetLocalInt(oPC, "shifting") == TRUE)
    {
        return iOutcome;
    }

    object oItem = CreateItemOnObject("pnp_shft_tstpkup", oPC);
    if (GetItemPossessor(oItem) == oPC)
    {
        iOutcome = TRUE;
    }
    else
    {
        SendMessageToPC(oPC, "Your inventory is too full to allow you to unshift.");
        SendMessageToPC(oPC, "Please make room enough for an armor-sized item and then try again.");
    }

    DestroyObject(oItem);

    //there are issues with shifting will polymorphed
    effect eEff = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEff))
    {
        int eType = GetEffectType(eEff);
        if (eType == EFFECT_TYPE_POLYMORPH)
        {
            SendMessageToPC(oPC, "Shifting when polymorphed has been disabled.");
            SendMessageToPC(oPC, "Please cancel your polymorph first.");
            return FALSE;
        }
        eEff = GetNextEffect(oPC);
    }
    return iOutcome;
}




// Transforms the oPC into the oTarget using the epic rules
// Assumes oTarget is already a valid target
int SetShiftEpic(object oPC, object oTarget)
{

    SetLocalInt(oPC,"EpicShift",1); //this makes the setshift_3 script do the epic shifter stuff that used to be here

    SetShift(oPC, oTarget);

    return TRUE;
}




// Transforms the oPC into the oTarget
// Assumes oTarget is already a valid target
// starts here and goes to SetShift_02 then SetShift_03

// stage 1:
//   if the shifter if already shifted call unshift to run after this stage ends
//   call next stage to start after this stage ends
void SetShift(object oPC, object oTarget)
{
    SetLocalInt(oPC, "shifting", TRUE);

    DelayCommand(0.1,SetShift_02(oPC, oTarget));
    SetShiftTrueForm(oPC);

}
// stage 1 end:
//   the shifter is unshifted if need be
//   and the next stage is called

// stage 2:
//   this is most of what the old SetShift script did
//   the changes are:
//     no check for if shifted is needed and has been removed
//     the epic ability item is done here (if epicshifter var is 1)
//     oTarget is destryed in this script if its from the convo
void SetShift_02(object oPC, object oTarget)
{

    //get all the creature items from the target
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oTarget);
    object oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oTarget);
    object oWeapCL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oTarget);
    object oWeapCB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oTarget);

    //get all the creature items from the pc
    object oHidePC = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
    object oWeapCRPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
    object oWeapCLPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
    object oWeapCBPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);


    //creature item handling
    if (!GetIsObjectValid(oHidePC)) //if you dont got a hide
    {
        oHidePC = CopyObject(oHide,GetLocation(oPC),oPC);  //copy the targets hide
        if (!GetIsObjectValid(oHidePC))  //if the target dont have a hide
        {
            oHidePC = CreateItemOnObject("shifterhide",oPC);  //use a blank shifter hide
        }
        // Need to ID the stuff before we can put it on the PC
        SetIdentified(oHidePC,TRUE);
        DelayCommand(0.2,AssignCommand(oPC,ActionEquipItem(oHidePC,INVENTORY_SLOT_CARMOUR)));
    }
    else // if you do have a hide
    {
        ScrubPCSkin(oPC,oHidePC); //clean off all old props
        CopyAllItemProperties(oHidePC,oHide); //copy all target props to our hide
        DelayCommand(0.2,AssignCommand(oPC,ActionEquipItem(oHidePC,INVENTORY_SLOT_CARMOUR)));  //reequip the hide to get item props to update properly
    }

    //copy targets right creature weapon
    if (GetIsObjectValid(oWeapCRPC)) //if we still have a creature weapon
    {
        //remove and destroy the weapon we have
        AssignCommand(oPC,ActionUnequipItem(oWeapCRPC));

    }
    if (GetIsObjectValid(oWeapCR)) //if the target has a weapon
    {
        oWeapCRPC = CreateItemOnObject("pnp_shft_cweap", oPC); //create a shifter blank creature weapon
        CopyAllItemProperties(oWeapCRPC,oWeapCR); //copy all target props over
        SetIdentified(oWeapCRPC,TRUE); //id so we dont get any funny stuff when equiping
        DelayCommand(0.2,AssignCommand(oPC,ActionEquipItem(oWeapCRPC,INVENTORY_SLOT_CWEAPON_R))); //reequip the item to get item props to update properly
    }

    //copy targets left creature weapon
    if (GetIsObjectValid(oWeapCLPC)) //if we still have a creature weapon
    {
        //remove and destroy the weapon we have
        AssignCommand(oPC,ActionUnequipItem(oWeapCLPC));
    }
    if (GetIsObjectValid(oWeapCL)) //if the target has a weapon
    {
        oWeapCLPC = CreateItemOnObject("pnp_shft_cweap", oPC); //create a shifter blank creature weapon
        CopyAllItemProperties(oWeapCLPC,oWeapCL); //copy all target props over
        SetIdentified(oWeapCLPC,TRUE); //id so we dont get any funny stuff when equiping
        DelayCommand(0.2,AssignCommand(oPC,ActionEquipItem(oWeapCLPC,INVENTORY_SLOT_CWEAPON_L))); //reequip the item to get item props to update properly
    }
    //copy targets special creature weapons
    if (GetIsObjectValid(oWeapCBPC)) //if we still have a creature weapon
    {
        //remove and destroy the weapon we have
        AssignCommand(oPC,ActionUnequipItem(oWeapCBPC));
    }
    if (GetIsObjectValid(oWeapCB)) //if the target has a weapon
    {
        oWeapCBPC = CreateItemOnObject("pnp_shft_cweap", oPC); //create a shifter blank creature weapon
        CopyAllItemProperties(oWeapCBPC,oWeapCB); //copy all target props over
        SetIdentified(oWeapCBPC,TRUE); //id so we dont get any funny stuff when equiping
        DelayCommand(0.2,AssignCommand(oPC,ActionEquipItem(oWeapCBPC,INVENTORY_SLOT_CWEAPON_B))); //reequip the item to get item props to update properly
    }

    // Get the Targets str, dex, and con
    int nTStr = GetAbilityScore(oTarget,ABILITY_STRENGTH);
    int nTDex = GetAbilityScore(oTarget,ABILITY_DEXTERITY);
    int nTCon = GetAbilityScore(oTarget,ABILITY_CONSTITUTION);

    // Get the PCs str, dex, and con from the clone
    int nPCStr = GetLocalInt(oHidePC, "PRC_trueSTR");
    int nPCDex = GetLocalInt(oHidePC, "PRC_trueDEX");
    int nPCCon = GetLocalInt(oHidePC, "PRC_trueCON");

    // Get the deltas
    int nStrDelta = nTStr - nPCStr;
    int nDexDelta = nTDex - nPCDex;
    int nConDelta = nTCon - nPCCon;

    int iRemainingSTR;
    int iRemainingCON;
    int iRemainingDEX;

    // Cap max to +12 til they can fix it and -10 for the low value
    // get remaining bonus/penelty for later
    if (nStrDelta > 12)
    {
        iRemainingSTR = nStrDelta - 12;
        nStrDelta = 12;
    }
    if (nStrDelta < -10)
    {
        iRemainingSTR = nStrDelta + 10;
        nStrDelta = -10;
    }
    if (nDexDelta > 12)
    {
        iRemainingDEX = nDexDelta - 12;
        nDexDelta = 12;
    }
    if (nDexDelta < -10)
    {
        iRemainingDEX = nDexDelta + 10;
        nDexDelta = -10;
    }
    if (nConDelta > 12)
    {
        iRemainingCON = nConDelta - 12;
        nConDelta = 12;
    }
    if (nConDelta < -10)
    {
        iRemainingCON = nConDelta + 10;
        nConDelta = -10;
    }

    // Big problem with < 0 to abilities, if they have immunity to ability drain
    // the - to the ability wont do anything

    // Apply these boni to the creature hide
    if (nStrDelta > 0)
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,nStrDelta),oHidePC);
    else
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR,nStrDelta*-1),oHidePC);
    if (nDexDelta > 0)
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX,nDexDelta),oHidePC);
    else
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDecreaseAbility(IP_CONST_ABILITY_DEX,nDexDelta*-1),oHidePC);
    if (nConDelta > 0)
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON,nConDelta),oHidePC);
    else
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CON,nConDelta*-1),oHidePC);

    //add extra str bonuses to pc as attack bonues and damage bonus
    int iExtSTRBon;
    effect eAttackIncrease;
    effect eDamageIncrease;
    if (iRemainingSTR != 0)
    {
        int iDamageType = DAMAGE_TYPE_BLUDGEONING;
        iExtSTRBon = FloatToInt(iRemainingSTR/2.0);

        if (GetIsObjectValid(oWeapCR))
        {
            int iCR = GetBaseItemType(oWeapCR);
            if ((iCR == BASE_ITEM_CSLASHWEAPON) || (iCR == BASE_ITEM_CSLSHPRCWEAP))
                iDamageType = DAMAGE_TYPE_SLASHING;
            else if (iCR == BASE_ITEM_CPIERCWEAPON)
                iDamageType = DAMAGE_TYPE_PIERCING;
        }
        else if (GetIsObjectValid(oWeapCL))
        {
            int iCL = GetBaseItemType(oWeapCL);
            if ((iCL == BASE_ITEM_CSLASHWEAPON) || (iCL == BASE_ITEM_CSLSHPRCWEAP))
                iDamageType = DAMAGE_TYPE_SLASHING;
            else if (iCL == BASE_ITEM_CPIERCWEAPON)
                iDamageType = DAMAGE_TYPE_PIERCING;
        }
        else if (GetIsObjectValid(oWeapCB))
        {
            int iCB = GetBaseItemType(oWeapCB);
            if ((iCB == BASE_ITEM_CSLASHWEAPON) || (iCB == BASE_ITEM_CSLSHPRCWEAP))
                iDamageType = DAMAGE_TYPE_SLASHING;
            else if (iCB == BASE_ITEM_CPIERCWEAPON)
                iDamageType = DAMAGE_TYPE_PIERCING;
        }

        int iDamageB;
        switch (iExtSTRBon)
        {
        case 0:
            iDamageB = 0;
            break;
        case 1:
        case -1:
            iDamageB = DAMAGE_BONUS_1;
            break;
        case 2:
        case -2:
            iDamageB = DAMAGE_BONUS_2;
            break;
        case 3:
        case -3:
            iDamageB = DAMAGE_BONUS_3;
            break;
        case 4:
        case -4:
            iDamageB = DAMAGE_BONUS_4;
            break;
        case 5:
        case -5:
            iDamageB = DAMAGE_BONUS_5;
            break;
        case 6:
        case -6:
            iDamageB = DAMAGE_BONUS_6;
            break;
        case 7:
        case -7:
            iDamageB = DAMAGE_BONUS_7;
            break;
        case 8:
        case -8:
            iDamageB = DAMAGE_BONUS_8;
            break;
        case 9:
        case -9:
            iDamageB = DAMAGE_BONUS_9;
            break;
        case 10:
        case -10:
            iDamageB = DAMAGE_BONUS_10;
            break;
        case 11:
        case -11:
            iDamageB = DAMAGE_BONUS_11;
            break;
        case 12:
        case -12:
            iDamageB = DAMAGE_BONUS_12;
            break;
        case 13:
        case -13:
            iDamageB = DAMAGE_BONUS_13;
            break;
        case 14:
        case -14:
            iDamageB = DAMAGE_BONUS_14;
            break;
        case 15:
        case -15:
            iDamageB = DAMAGE_BONUS_15;
            break;
        case 16:
        case -16:
            iDamageB = DAMAGE_BONUS_16;
            break;
        case 17:
        case -17:
            iDamageB = DAMAGE_BONUS_17;
            break;
        case 18:
        case -18:
            iDamageB = DAMAGE_BONUS_18;
            break;
        case 19:
        case -19:
            iDamageB = DAMAGE_BONUS_19;
            break;
        default:
            iDamageB = DAMAGE_BONUS_20;
            break;
        }

        if (iRemainingSTR > 0)
        {
            eAttackIncrease = EffectAttackIncrease(iDamageB, ATTACK_BONUS_MISC);
            eDamageIncrease = EffectDamageIncrease(iDamageB, iDamageType);
        }
        else if (iRemainingSTR < 0)
        {
            eAttackIncrease = EffectAttackDecrease(iDamageB, ATTACK_BONUS_MISC);
            eDamageIncrease = EffectDamageDecrease(iDamageB, iDamageType);
        }

        ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eAttackIncrease),oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eDamageIncrease),oPC);
    }

    //add extra con bonus as temp HP
    if (iRemainingCON > 0)
    {
        int iExtCONBon = FloatToInt(iRemainingCON/2.0);
        effect eTemporaryHitpoints = EffectTemporaryHitpoints(iExtCONBon * GetCharacterLevel(oPC));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eTemporaryHitpoints),oPC);
    }

    // Apply the natural AC bonus to the hide
    // First get the AC from the target
    int nTAC = GetAC(oTarget);
    nTAC -= GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
    // All creatures have 10 base AC
    nTAC -= 10;
    int i;
    for (i=0; i < NUM_INVENTORY_SLOTS; i++)
    {
        nTAC -= GetItemACValue(GetItemInSlot(i,oTarget));
    }

    if (nTAC > 0)
    {
        effect eAC = EffectACIncrease(nTAC,AC_NATURAL_BONUS);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eAC),oPC);
    }

    //add extra dex bonus as dodge ac
    if (iRemainingDEX != 0)
    {
        int iExtDEXBon = FloatToInt(iRemainingDEX/2.0);
        effect eACIncrease;
        if (iRemainingDEX > 0)
        {
            object oPCArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
            if (GetIsObjectValid(oPCArmour))
            {
                int iACArmour = GetItemACValue(oPCArmour);
                int iMaxDexBon;
                int iCurentDexBon;
                iCurentDexBon = FloatToInt(((nPCDex + nStrDelta)-10.0)/2.0);
                switch (iACArmour)
                {
                case 8:
                case 7:
                case 6:
                    iMaxDexBon = 1;
                    break;
                case 5:
                    iMaxDexBon = 2;
                    break;
                case 4:
                case 3:
                    iMaxDexBon = 4;
                    break;
                case 2:
                    iMaxDexBon = 6;
                    break;
                case 1:
                    iMaxDexBon = 8;
                    break;
                default:
                    iMaxDexBon = 100;
                    break;
                }
                if (iCurentDexBon > iMaxDexBon)
                {
                    iExtDEXBon = 0;
                }
                else
                {
                    if ((iExtDEXBon+iCurentDexBon) > iMaxDexBon)
                    {
                        iExtDEXBon = iMaxDexBon - iCurentDexBon;
                    }
                }
            }
            eACIncrease = EffectACIncrease(iExtDEXBon);
        }
        else if (iRemainingDEX < 0)
        {
            eACIncrease = EffectACDecrease(iExtDEXBon * -1);
        }
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eACIncrease),oPC);
    }

    // Apply any feats the target has to the hide as a bonus feat
    for (i = 0; i< 500; i++)
    {
        if (GetHasFeat(i,oTarget))
        {
            int nIP =  GetIPFeatFromFeat(i);
            if(nIP != -1)
            {
                itemproperty iProp = ItemPropertyBonusFeat(nIP);
                //AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oHidePC);
                IPSafeAddItemProperty(oHidePC, iProp, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }

        }
    }

    // If they dont have the natural spell feat they can only cast spells in certain shapes
    if (!GetHasFeat(FEAT_PRESTIGE_SHIFTER_NATURALSPELL,oPC))
    {
        if (!GetCanFormCast(oTarget))
        {
            // remove the ability from the PC to cast
            effect eNoCast = EffectSpellFailure();
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eNoCast),oPC);
        }
    }

    // If the creature is "harmless" give it a perm invis for stealth
    if(GetIsCreatureHarmless(oTarget))
    {
        effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eInvis),oPC);
    }


    // Change the Appearance of the PC
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oPC);
    //get the appearance of oTarget
    int iAppearance = GetLocalInt(oTarget,"Appearance");
    if (iAppearance>0)
        SetCreatureAppearanceType(oPC,iAppearance);
    else
        SetCreatureAppearanceType(oPC,GetAppearanceType(oTarget));

    // For spells to make sure they now treat you like the new race
    SetLocalInt(oPC,"RACIAL_TYPE",MyPRCGetRacialType(oTarget)+1);

    // PnP rules say the shifter would heal as if they rested
    effect eHeal = EffectHeal(GetHitDice(oPC)*d4());
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eHeal,oPC);

    //epic shift
    if (GetLocalInt(oPC,"EpicShift"))
    {
        // Create some sort of usable item to represent monster spells
        object oEpicPowersItem = GetItemPossessedBy(oPC,"EpicShifterPowers");
        if (!GetIsObjectValid(oEpicPowersItem))
            oEpicPowersItem = CreateItemOnObject("epicshifterpower",oPC);
        SetItemSpellPowers(oEpicPowersItem,oTarget);
    }

    // Set a flag on the PC to tell us that they are shifted
    SetLocalInt(oHidePC,"nPCShifted",TRUE);
    //clear epic shift var
    SetLocalInt(oPC,"EpicShift",0);

    //remove oTarget if it is from the template
    int iDeleteMe = GetLocalInt(oTarget,"pnp_shifter_deleteme");
    if (iDeleteMe==1)
    {
        // Remove the temporary creature
        AssignCommand(oTarget,SetIsDestroyable(TRUE,FALSE,FALSE));
        SetPlotFlag(oTarget,FALSE);
        SetImmortal(oTarget,FALSE);
        DestroyObject(oTarget);
    }

    // Reset any PRC feats that might have been lost from the shift
    DelayCommand(1.0, EvalPRCFeats(oPC));

    DelayCommand(1.5, ClearShifterItems(oPC));

    DelayCommand(3.0, DeleteLocalInt(oPC, "shifting"));
    SendMessageToPC(oPC, "Finished shifting");
}




// Transforms the oPC back to thier true form if they are shifted
void SetShiftTrueForm(object oPC)
{
    // Remove all the creature equipment and destroy it
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
    object oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
    object oWeapCL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
    object oWeapCB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);

    // Do not move or destroy the objects, it will crash the game
    if (GetIsObjectValid(oHide))
    {
        // Remove all the abilities of the object
        ScrubPCSkin(oPC,oHide);
        DeletePRCLocalInts(oHide);

//        RemoveAllItemProperties(oHide);
    // Debug
        //CopyItem(oHide,oPC,TRUE);
    }

    itemproperty ipUnarmed = ItemPropertyMonsterDamage(2);

    if (GetIsObjectValid(oWeapCR))
    {
        //remove creature weapons
        AssignCommand(oPC,ActionUnequipItem(oWeapCR));

        // Remove all abilities of the object
//        RemoveAllItemProperties(oWeapCR);
//          AddItemProperty(DURATION_TYPE_PERMANENT, ipUnarmed, oWeapCR);
    }
    if (GetIsObjectValid(oWeapCL))
    {
        //remove creature weapons
        AssignCommand(oPC,ActionUnequipItem(oWeapCL));

        // Remove all the abilities of the object
//        RemoveAllItemProperties(oWeapCL);
    }
    if (GetIsObjectValid(oWeapCB))
    {
        //remove creature weapons
        AssignCommand(oPC,ActionUnequipItem(oWeapCB));

        // Remove all abilities of the object
//        RemoveAllItemProperties(oWeapCB);
    }
    // if the did an epic form remove the special powers
    object oEpicPowersItem = GetItemPossessedBy(oPC,"EpicShifterPowers");
    if (GetIsObjectValid(oEpicPowersItem))
    {
        RemoveAllItemProperties(oEpicPowersItem);
        RemoveAuraEffect( oPC );
    }


    // Spell failure was done through an effect
    // AC was done via an effect
    // invis was done via an effect
    // we will look for and remove them
    effect eEff = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEff))
    {
        int eDurType = GetEffectDurationType(eEff);
        int eSubType = GetEffectSubType(eEff);
        int eType = GetEffectType(eEff);
        int eID = GetEffectSpellId(eEff);
        object eCreator = GetEffectCreator(eEff);
        //all three effects are permanent and supernatural and are created by spell id -1 and by the PC.
        if ((eDurType == DURATION_TYPE_PERMANENT) && (eSubType == SUBTYPE_SUPERNATURAL) && (eID == -1) && (eCreator == oPC))
        {
            switch (eType)
            {
                case EFFECT_TYPE_SPELL_FAILURE:
                case EFFECT_TYPE_INVISIBILITY:
                case EFFECT_TYPE_AC_INCREASE:
                case EFFECT_TYPE_AC_DECREASE:
                case EFFECT_TYPE_ATTACK_INCREASE:
                case EFFECT_TYPE_ATTACK_DECREASE:
                case EFFECT_TYPE_DAMAGE_INCREASE:
                case EFFECT_TYPE_DAMAGE_DECREASE:
                case EFFECT_TYPE_TEMPORARY_HITPOINTS:
                    RemoveEffect(oPC,eEff);
                    break;
            }
        }
        if (eType == EFFECT_TYPE_POLYMORPH)
        {
            RemoveEffect(oPC,eEff);
        }
        eEff = GetNextEffect(oPC);
    }

    // Change the PC back to TRUE form
    SetCreatureAppearanceType(oPC,GetTrueForm(oPC));
    // Set race back to unused
    SetLocalInt(oPC,"RACIAL_TYPE",0);

    // Reset any PRC feats that might have been lost from the shift
//  EvalPRCFeats(oPC);
    SetLocalInt(oHide,"nPCShifted",FALSE);

    //object oCont = GetItemPossessedBy(oPC, "pnp_shft_sprkbox");
    //if (GetIsObjectValid(oCont))
    //{
    //  object oSpark = GetItemPossessedBy(oPC, "soul_prism");
    //  DelayCommand(0.3, AssignCommand(oPC, ActionTakeItem(oSpark, oCont)));
    //  DestroyObject(oCont, 0.7);
    //}

    DelayCommand(1.0, ClearShifterItems(oPC));
}




void ClearShifterItems(object oPC)
{
    object oCheck = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oCheck))
    {
        if (GetTag(oCheck) == "pnp_shft_cweap")
        {
            if ((oCheck != GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC)) &&
                 (oCheck != GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC)) &&
                (oCheck != GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC)))
                AssignCommand(oPC, DestroyObject(oCheck));
        }
        oCheck = GetNextItemInInventory(oPC);
    }


}




void QuickShift(object oPC, int iQuickSlot)
{
    object oMimicForms = GetItemPossessedBy( oPC, "soul_prism" );
    int iMaxIndex = GetLocalInt(oMimicForms, "num_creatures");
    int iIndex = GetLocalArrayInt(oMimicForms, "QuickSlotIndex", iQuickSlot);
    int iEpic = GetLocalArrayInt(oMimicForms, "QuickSlotEpic", iQuickSlot);
    if(!(iIndex>iMaxIndex))
        ShiftFromKnownArray(iIndex, iEpic, oPC);
}




void SetQuickSlot(object oPC, int iIndex, int iQuickSlot, int iEpic)
{
    object oMimicForms = GetItemPossessedBy( oPC, "soul_prism" );
    SetLocalArrayInt(oMimicForms,"QuickSlotIndex",iQuickSlot,iIndex);
    SetLocalArrayInt(oMimicForms,"QuickSlotEpic",iQuickSlot,iEpic);
}




// Determine if the oCreature has the ability to cast spells
// Return values: TRUE or FALSE
int GetCanFormCast(object oCreature)
{
    int nTRacialType = MyPRCGetRacialType(oCreature);

    // Need to have hands, and the ability to speak

    switch (nTRacialType)
    {
    case RACIAL_TYPE_ABERRATION:
    case RACIAL_TYPE_MAGICAL_BEAST:
    case RACIAL_TYPE_VERMIN:
    case RACIAL_TYPE_BEAST:
    case RACIAL_TYPE_ANIMAL:
    case RACIAL_TYPE_OOZE:
//    case RACIAL_TYPE_PLANT:
        // These forms can't cast spells
        return FALSE;
        break;
    case RACIAL_TYPE_SHAPECHANGER:
    case RACIAL_TYPE_ELEMENTAL:
    case RACIAL_TYPE_DRAGON:
    case RACIAL_TYPE_OUTSIDER:
    case RACIAL_TYPE_UNDEAD:
    case RACIAL_TYPE_CONSTRUCT:
    case RACIAL_TYPE_GIANT:
    case RACIAL_TYPE_HUMANOID_MONSTROUS:
    case RACIAL_TYPE_DWARF:
    case RACIAL_TYPE_ELF:
    case RACIAL_TYPE_GNOME:
    case RACIAL_TYPE_HALFELF:
    case RACIAL_TYPE_HALFLING:
    case RACIAL_TYPE_HALFORC:
    case RACIAL_TYPE_HUMAN:
    case RACIAL_TYPE_HUMANOID_ORC:
    case RACIAL_TYPE_HUMANOID_REPTILIAN:
    case RACIAL_TYPE_FEY:
        break;
    }

    return TRUE;
}




// Determines if the oCreature is harmless enough to have
// special effects applied to the shifter
// Return values: TRUE or FALSE
int GetIsCreatureHarmless(object oCreature)
{
    string sCreatureName = GetName(oCreature);

    // looking for small < 1 CR creatures that nobody looks at twice

    if ((sCreatureName == "Chicken") ||
        (sCreatureName == "Falcon") ||
        (sCreatureName == "Hawk") ||
        (sCreatureName == "Raven") ||
        (sCreatureName == "Bat") ||
        (sCreatureName == "Dire Rat") ||
        (sCreatureName == "Will-O'-Wisp") ||
        (sCreatureName == "Rat") ||
        (GetChallengeRating(oCreature) < 1.0 ))
        return TRUE;
    else
        return FALSE;
}



/*
// Transforms the oPC back to thier true form if they are shifted
void SetShiftTrueForm(object oPC)
{
    // Remove all the creature equipment and destroy it
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
    object oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
    object oWeapCL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
    object oWeapCB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);

    // Do not move or destroy the objects, it will crash the game
    if (GetIsObjectValid(oHide))
    {
        // Remove all the abilities of the object
        ScrubPCSkin(oPC,oHide);
        DeletePRCLocalInts(oHide);

//        RemoveAllItemProperties(oHide);
    // Debug
        //CopyItem(oHide,oPC,TRUE);
    }

    itemproperty ipUnarmed = ItemPropertyMonsterDamage(2);

    if (GetIsObjectValid(oWeapCR))
    {
        //remove creature weapons
        AssignCommand(oPC,ActionUnequipItem(oWeapCR));

        // Remove all abilities of the object
//        RemoveAllItemProperties(oWeapCR);
//          AddItemProperty(DURATION_TYPE_PERMANENT, ipUnarmed, oWeapCR);
    }
    if (GetIsObjectValid(oWeapCL))
    {
        //remove creature weapons
        AssignCommand(oPC,ActionUnequipItem(oWeapCL));

        // Remove all the abilities of the object
//        RemoveAllItemProperties(oWeapCL);
    }
    if (GetIsObjectValid(oWeapCB))
    {
        //remove creature weapons
        AssignCommand(oPC,ActionUnequipItem(oWeapCB));

        // Remove all abilities of the object
//        RemoveAllItemProperties(oWeapCB);
    }
    // if the did an epic form remove the special powers
    object oEpicPowersItem = GetItemPossessedBy(oPC,"EpicShifterPowers");
    if (GetIsObjectValid(oEpicPowersItem))
    {
        RemoveAllItemProperties(oEpicPowersItem);
        RemoveAuraEffect( oPC );
    }


    // Spell failure was done through an effect
    // AC was done via an effect
    // invis was done via an effect
    // we will look for and remove them
    effect eEff = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEff))
    {
        int eDurType = GetEffectDurationType(eEff);
        int eSubType = GetEffectSubType(eEff);
        int eType = GetEffectType(eEff);
        int eID = GetEffectSpellId(eEff);
        object eCreator = GetEffectCreator(eEff);
        //all three effects are permanent and supernatural and are created by spell id -1 and by the PC.
        if ((eDurType == DURATION_TYPE_PERMANENT) && (eSubType == SUBTYPE_SUPERNATURAL) && (eID == -1) && (eCreator == oPC))
        {
            switch (eType)
            {
                case EFFECT_TYPE_SPELL_FAILURE:
                case EFFECT_TYPE_INVISIBILITY:
                case EFFECT_TYPE_AC_INCREASE:
                case EFFECT_TYPE_AC_DECREASE:
                case EFFECT_TYPE_ATTACK_INCREASE:
                case EFFECT_TYPE_ATTACK_DECREASE:
                case EFFECT_TYPE_DAMAGE_INCREASE:
                case EFFECT_TYPE_DAMAGE_DECREASE:
                case EFFECT_TYPE_TEMPORARY_HITPOINTS:
                    RemoveEffect(oPC,eEff);
                    break;
            }
        }
        if (eType == EFFECT_TYPE_POLYMORPH)
        {
            RemoveEffect(oPC,eEff);
        }
        eEff = GetNextEffect(oPC);
    }

    // Change the PC back to TRUE form
    SetCreatureAppearanceType(oPC,GetTrueForm(oPC));
    // Set race back to unused
    SetLocalInt(oPC,"RACIAL_TYPE",0);

    // Reset any PRC feats that might have been lost from the shift
//  EvalPRCFeats(oPC);
    SetLocalInt(oHide,"nPCShifted",FALSE);

    //object oCont = GetItemPossessedBy(oPC, "pnp_shft_sprkbox");
    //if (GetIsObjectValid(oCont))
    //{
    //  object oSpark = GetItemPossessedBy(oPC, "soul_prism");
    //  DelayCommand(0.3, AssignCommand(oPC, ActionTakeItem(oSpark, oCont)));
    //  DestroyObject(oCont, 0.7);
    //}

    DelayCommand(1.0, ClearShifterItems(oPC));
}
*/



void CopyAllItemProperties(object oDestination,object oTarget)
{
    itemproperty iProp = GetFirstItemProperty(oTarget);

    while (GetIsItemPropertyValid(iProp))
    {
        AddItemProperty(GetItemPropertyDurationType(iProp), iProp, oDestination);
        iProp = GetNextItemProperty(oTarget);
    }
}





int GetAllItemsAbilityModifier(object oTarget, int nAbility)
{
    // Go through all the equipment and add it all up
    int nRetValue = 0;
    object oItem;
    itemproperty iProp;
    int i;

    for (i=0; i < NUM_INVENTORY_SLOTS; i++)
    {
        oItem = GetItemInSlot(i,oTarget);

        if (GetIsObjectValid(oItem))
        {
            iProp = GetFirstItemProperty(oItem);
            while (GetIsItemPropertyValid(iProp))
            {
                //SendMessageToPC(oTarget,"In while loop for " + GetName(oItem));
                if (ITEM_PROPERTY_ABILITY_BONUS == GetItemPropertyType(iProp))
                {
                    if (nAbility == GetItemPropertySubType(iProp))
                    {
                        nRetValue += GetItemPropertyCostTableValue(iProp);
                    }
                }
                iProp = GetNextItemProperty(oItem);
            }
        }

    }
    return nRetValue;
}

void RemoveAllItemProperties(object oItem)
{
    itemproperty iProp = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(iProp))
    {

//        SendMessageToPC(GetItemPossessor(oItem),"item prop type-" + IntToString(GetItemPropertyType(iProp)));

        RemoveItemProperty(oItem,iProp);
        iProp = GetNextItemProperty(oItem);

    }
    // for a skin and prcs to get their feats back
    DeletePRCLocalInts(oItem);
}

// Gets an IP_CONST_FEAT_* from FEAT_*
// -1 is an invalid IP_CONST_FEAT
int GetIPFeatFromFeat(int nFeat)
{
    switch (nFeat)
    {
    case FEAT_ALERTNESS:
        return IP_CONST_FEAT_ALERTNESS;
    case FEAT_AMBIDEXTERITY:
        return IP_CONST_FEAT_AMBIDEXTROUS;
    case FEAT_ARMOR_PROFICIENCY_HEAVY:
        return IP_CONST_FEAT_ARMOR_PROF_HEAVY;
    case FEAT_ARMOR_PROFICIENCY_LIGHT:
        return IP_CONST_FEAT_ARMOR_PROF_LIGHT;
    case FEAT_ARMOR_PROFICIENCY_MEDIUM:
        return IP_CONST_FEAT_ARMOR_PROF_MEDIUM;
    case FEAT_CLEAVE:
        return IP_CONST_FEAT_CLEAVE;
    case FEAT_COMBAT_CASTING:
        return IP_CONST_FEAT_COMBAT_CASTING;
    case FEAT_DODGE:
        return IP_CONST_FEAT_DODGE;
    case FEAT_EXTRA_TURNING:
        return IP_CONST_FEAT_EXTRA_TURNING;
    case FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE:
        return IP_CONST_FEAT_IMPCRITUNARM;
    case FEAT_IMPROVED_KNOCKDOWN:
    case FEAT_KNOCKDOWN:
        return IP_CONST_FEAT_KNOCKDOWN;
    case FEAT_POINT_BLANK_SHOT:
        return IP_CONST_FEAT_POINTBLANK;
    case FEAT_POWER_ATTACK:
    case FEAT_IMPROVED_POWER_ATTACK:
        return IP_CONST_FEAT_POWERATTACK;
    case FEAT_SPELL_FOCUS_ABJURATION:
    case FEAT_EPIC_SPELL_FOCUS_ABJURATION:
    case FEAT_GREATER_SPELL_FOCUS_ABJURATION:
        return IP_CONST_FEAT_SPELLFOCUSABJ;
    case FEAT_SPELL_FOCUS_CONJURATION:
    case FEAT_EPIC_SPELL_FOCUS_CONJURATION:
    case FEAT_GREATER_SPELL_FOCUS_CONJURATION:
        return IP_CONST_FEAT_SPELLFOCUSCON;
    case FEAT_SPELL_FOCUS_DIVINATION:
    case FEAT_EPIC_SPELL_FOCUS_DIVINATION:
    case FEAT_GREATER_SPELL_FOCUS_DIVINIATION:
        return IP_CONST_FEAT_SPELLFOCUSDIV;
    case FEAT_SPELL_FOCUS_ENCHANTMENT:
    case FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT:
    case FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT:
        return IP_CONST_FEAT_SPELLFOCUSENC;
    case FEAT_SPELL_FOCUS_EVOCATION:
    case FEAT_EPIC_SPELL_FOCUS_EVOCATION:
    case FEAT_GREATER_SPELL_FOCUS_EVOCATION:
        return IP_CONST_FEAT_SPELLFOCUSEVO;
    case FEAT_SPELL_FOCUS_ILLUSION:
    case FEAT_EPIC_SPELL_FOCUS_ILLUSION:
    case FEAT_GREATER_SPELL_FOCUS_ILLUSION:
        return IP_CONST_FEAT_SPELLFOCUSILL;
    case FEAT_SPELL_FOCUS_NECROMANCY:
    case FEAT_EPIC_SPELL_FOCUS_NECROMANCY:
    case FEAT_GREATER_SPELL_FOCUS_NECROMANCY:
        return IP_CONST_FEAT_SPELLFOCUSNEC;
    case FEAT_SPELL_PENETRATION:
    case FEAT_EPIC_SPELL_PENETRATION:
    case FEAT_GREATER_SPELL_PENETRATION:
        return IP_CONST_FEAT_SPELLPENETRATION;
    case FEAT_TWO_WEAPON_FIGHTING:
    case FEAT_IMPROVED_TWO_WEAPON_FIGHTING:
        return IP_CONST_FEAT_TWO_WEAPON_FIGHTING;
    case FEAT_WEAPON_FINESSE:
        return IP_CONST_FEAT_WEAPFINESSE;
    case FEAT_WEAPON_PROFICIENCY_EXOTIC:
        return IP_CONST_FEAT_WEAPON_PROF_EXOTIC;
    case FEAT_WEAPON_PROFICIENCY_MARTIAL:
        return IP_CONST_FEAT_WEAPON_PROF_MARTIAL;
    case FEAT_WEAPON_PROFICIENCY_SIMPLE:
        return IP_CONST_FEAT_WEAPON_PROF_SIMPLE;
    case FEAT_IMPROVED_UNARMED_STRIKE:
        return IP_CONST_FEAT_WEAPSPEUNARM;

    // Some undefined ones
    case FEAT_DISARM:
        return 28;
    case FEAT_HIDE_IN_PLAIN_SIGHT:
        return 31;
    case FEAT_MOBILITY:
        return 27;
    case FEAT_RAPID_SHOT:
        return 30;
    case FEAT_SHIELD_PROFICIENCY:
        return 35;
    case FEAT_SNEAK_ATTACK:
        return 32;
    case FEAT_USE_POISON:
        return 36;
    case FEAT_WHIRLWIND_ATTACK:
        return 29;
    case FEAT_WEAPON_PROFICIENCY_CREATURE:
        return 38;
        // whip disarm is 37
    }
    return (-1);
}



/*
void RemoveAllItemProperties(object oItem)
{
    itemproperty iProp = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(iProp))
    {

//        SendMessageToPC(GetItemPossessor(oItem),"item prop type-" + IntToString(GetItemPropertyType(iProp)));

        RemoveItemProperty(oItem,iProp);
        iProp = GetNextItemProperty(oItem);

    }
    // for a skin and prcs to get their feats back
    DeletePRCLocalInts(oItem);
}
*/


/*
// Gets an IP_CONST_FEAT_* from FEAT_*
// -1 is an invalid IP_CONST_FEAT
int GetIPFeatFromFeat(int nFeat)
{
    switch (nFeat)
    {
    case FEAT_ALERTNESS:
        return IP_CONST_FEAT_ALERTNESS;
    case FEAT_AMBIDEXTERITY:
        return IP_CONST_FEAT_AMBIDEXTROUS;
    case FEAT_ARMOR_PROFICIENCY_HEAVY:
        return IP_CONST_FEAT_ARMOR_PROF_HEAVY;
    case FEAT_ARMOR_PROFICIENCY_LIGHT:
        return IP_CONST_FEAT_ARMOR_PROF_LIGHT;
    case FEAT_ARMOR_PROFICIENCY_MEDIUM:
        return IP_CONST_FEAT_ARMOR_PROF_MEDIUM;
    case FEAT_CLEAVE:
        return IP_CONST_FEAT_CLEAVE;
    case FEAT_COMBAT_CASTING:
        return IP_CONST_FEAT_COMBAT_CASTING;
    case FEAT_DODGE:
        return IP_CONST_FEAT_DODGE;
    case FEAT_EXTRA_TURNING:
        return IP_CONST_FEAT_EXTRA_TURNING;
    case FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE:
        return IP_CONST_FEAT_IMPCRITUNARM;
    case FEAT_IMPROVED_KNOCKDOWN:
    case FEAT_KNOCKDOWN:
        return IP_CONST_FEAT_KNOCKDOWN;
    case FEAT_POINT_BLANK_SHOT:
        return IP_CONST_FEAT_POINTBLANK;
    case FEAT_POWER_ATTACK:
    case FEAT_IMPROVED_POWER_ATTACK:
        return IP_CONST_FEAT_POWERATTACK;
    case FEAT_SPELL_FOCUS_ABJURATION:
    case FEAT_EPIC_SPELL_FOCUS_ABJURATION:
    case FEAT_GREATER_SPELL_FOCUS_ABJURATION:
        return IP_CONST_FEAT_SPELLFOCUSABJ;
    case FEAT_SPELL_FOCUS_CONJURATION:
    case FEAT_EPIC_SPELL_FOCUS_CONJURATION:
    case FEAT_GREATER_SPELL_FOCUS_CONJURATION:
        return IP_CONST_FEAT_SPELLFOCUSCON;
    case FEAT_SPELL_FOCUS_DIVINATION:
    case FEAT_EPIC_SPELL_FOCUS_DIVINATION:
    case FEAT_GREATER_SPELL_FOCUS_DIVINIATION:
        return IP_CONST_FEAT_SPELLFOCUSDIV;
    case FEAT_SPELL_FOCUS_ENCHANTMENT:
    case FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT:
    case FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT:
        return IP_CONST_FEAT_SPELLFOCUSENC;
    case FEAT_SPELL_FOCUS_EVOCATION:
    case FEAT_EPIC_SPELL_FOCUS_EVOCATION:
    case FEAT_GREATER_SPELL_FOCUS_EVOCATION:
        return IP_CONST_FEAT_SPELLFOCUSEVO;
    case FEAT_SPELL_FOCUS_ILLUSION:
    case FEAT_EPIC_SPELL_FOCUS_ILLUSION:
    case FEAT_GREATER_SPELL_FOCUS_ILLUSION:
        return IP_CONST_FEAT_SPELLFOCUSILL;
    case FEAT_SPELL_FOCUS_NECROMANCY:
    case FEAT_EPIC_SPELL_FOCUS_NECROMANCY:
    case FEAT_GREATER_SPELL_FOCUS_NECROMANCY:
        return IP_CONST_FEAT_SPELLFOCUSNEC;
    case FEAT_SPELL_PENETRATION:
    case FEAT_EPIC_SPELL_PENETRATION:
    case FEAT_GREATER_SPELL_PENETRATION:
        return IP_CONST_FEAT_SPELLPENETRATION;
    case FEAT_TWO_WEAPON_FIGHTING:
    case FEAT_IMPROVED_TWO_WEAPON_FIGHTING:
        return IP_CONST_FEAT_TWO_WEAPON_FIGHTING;
    case FEAT_WEAPON_FINESSE:
        return IP_CONST_FEAT_WEAPFINESSE;
    case FEAT_WEAPON_PROFICIENCY_EXOTIC:
        return IP_CONST_FEAT_WEAPON_PROF_EXOTIC;
    case FEAT_WEAPON_PROFICIENCY_MARTIAL:
        return IP_CONST_FEAT_WEAPON_PROF_MARTIAL;
    case FEAT_WEAPON_PROFICIENCY_SIMPLE:
        return IP_CONST_FEAT_WEAPON_PROF_SIMPLE;
    case FEAT_IMPROVED_UNARMED_STRIKE:
        return IP_CONST_FEAT_WEAPSPEUNARM;

    // Some undefined ones
    case FEAT_DISARM:
        return 28;
    case FEAT_HIDE_IN_PLAIN_SIGHT:
        return 31;
    case FEAT_MOBILITY:
        return 27;
    case FEAT_RAPID_SHOT:
        return 30;
    case FEAT_SHIELD_PROFICIENCY:
        return 35;
    case FEAT_SNEAK_ATTACK:
        return 32;
    case FEAT_USE_POISON:
        return 36;
    case FEAT_WHIRLWIND_ATTACK:
        return 29;
    case FEAT_WEAPON_PROFICIENCY_CREATURE:
        return 38;
        // whip disarm is 37
    }
    return (-1);
}
*/



// Determines if the target creature has a certain type of spell
// and sets the powers onto the object item
void SetItemSpellPowers(object oItem, object oCreature)
{
    itemproperty iProp;
    int total_props = 0; //max of 8 properties on one item

    //first, auras--only want to allow one aura power to transfer
    if ( GetHasSpell(SPELLABILITY_AURA_BLINDING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(750,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(751,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_ELECTRICITY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(752,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(753,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(754,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_MENACE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(755,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_PROTECTION, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(756,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_STUN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(757,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_UNEARTHLY_VISAGE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(758,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_UNNATURAL, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(759,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //now, bolts
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_CHARISMA, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(760,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_CONSTITUTION, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(761,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_DEXTERITY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(762,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_INTELLIGENCE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(763,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_STRENGTH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(764,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_WISDOM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(765,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ACID, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(766,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_CHARM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(767,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(768,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_CONFUSE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(769,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DAZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(770,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DEATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(771,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DISEASE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(772,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DOMINATE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(773,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(774,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_KNOCKDOWN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(775,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_LEVEL_DRAIN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(776,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_LIGHTNING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(777,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_PARALYZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(778,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_POISON, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(779,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_SHARDS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(780,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_SLOW, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(781,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_STUN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(782,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_WEB, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(783,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //now, cones
    if ( GetHasSpell(SPELLABILITY_CONE_ACID, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(784,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(785,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_DISEASE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(786,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(787,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_LIGHTNING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(788,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_POISON, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(789,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_SONIC, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(790,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //various petrify attacks
    if ( GetHasSpell(SPELLABILITY_BREATH_PETRIFY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(791,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_PETRIFY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(792,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_TOUCH_PETRIFY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(793,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //dragon stuff (fear aura, breaths)
    if ( GetHasSpell(SPELLABILITY_DRAGON_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(796,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_ACID, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(400,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(401,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(402,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(403,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_GAS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(404,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_LIGHTNING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(405,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(698, oCreature) && (total_props <= 7) ) //NEGATIVE
    {
        iProp = ItemPropertyCastSpell(794,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_PARALYZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(406,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_SLEEP, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(407,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_SLOW, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(408,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_WEAKEN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(409,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(771, oCreature) && (total_props <= 7) ) //PRISMATIC
    {
        iProp = ItemPropertyCastSpell(795,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //gaze attacks
    if ( GetHasSpell(SPELLABILITY_GAZE_CHARM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(797,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_CONFUSION, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(798,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DAZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(799,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DEATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(800,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_CHAOS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(801,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_EVIL, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(802,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_GOOD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(803,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_LAW, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(804,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DOMINATE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(805,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DOOM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(806,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(807,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_PARALYSIS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(808,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_STUNNED, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(809,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //miscellaneous abilities
    if ( GetHasSpell(SPELLABILITY_GOLEM_BREATH_GAS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(810,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HELL_HOUND_FIREBREATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(811,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_KRENSHAR_SCARE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(812,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //howls
    if ( GetHasSpell(SPELLABILITY_HOWL_CONFUSE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(813,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_DAZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(814,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_DEATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(815,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_DOOM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(816,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(817,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_PARALYSIS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(818,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_SONIC, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(819,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_STUN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(820,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //pulses
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_CHARISMA, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(821,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_CONSTITUTION, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(822,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_DEXTERITY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(823,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_INTELLIGENCE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(824,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_STRENGTH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(825,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_WISDOM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(826,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(827,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_DEATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(828,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_DISEASE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(829,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_DROWN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(830,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(831,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_HOLY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(832,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_LEVEL_DRAIN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(833,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_LIGHTNING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(834,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_NEGATIVE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(835,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_POISON, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(836,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_SPORES, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(837,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_WHIRLWIND, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(838,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //monster summon abilities
    if ( GetHasSpell(SPELLABILITY_SUMMON_SLAAD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(839,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_SUMMON_TANARRI, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(840,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //abilities without const refs
    if ( GetHasSpell(552, oCreature) && (total_props <= 7) ) //PSIONIC CHARM
    {
        iProp = ItemPropertyCastSpell(841,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(551, oCreature) && (total_props <= 7) ) //PSIONIC MINDBLAST
    {
        iProp = ItemPropertyCastSpell(842,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(713, oCreature) && (total_props <= 7) ) //MINDBLAST 10M
    {
        iProp = ItemPropertyCastSpell(843,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(741, oCreature) && (total_props <= 7) ) //PSIONIC BARRIER
    {
        iProp = ItemPropertyCastSpell(844,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(763, oCreature) && (total_props <= 7) ) //PSIONIC CONCUSSION
    {
        iProp = ItemPropertyCastSpell(845,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(731, oCreature) && (total_props <= 7) ) //BEBILITH WEB
    {
        iProp = ItemPropertyCastSpell(846,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(736, oCreature) && (total_props <= 7) ) //BEHOLDER EYES
    {
        iProp = ItemPropertyCastSpell(847,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(770, oCreature) && (total_props <= 7) ) //CHAOS SPITTLE
    {
        iProp = ItemPropertyCastSpell(848,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(757, oCreature) && (total_props <= 7) ) //SHADOWBLEND
    {
        iProp = ItemPropertyCastSpell(849,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(774, oCreature) && (total_props <= 7) ) //DEFLECTING FORCE
    {
        iProp = ItemPropertyCastSpell(850,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //some spell-like abilities
    if ((GetHasSpell(SPELL_DARKNESS,oCreature) ||
        GetHasSpell(SPELLABILITY_AS_DARKNESS,oCreature)) &&
        total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_DARKNESS_3,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_DISPLACEMENT,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPLACEMENT_9,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ((GetHasSpell(SPELLABILITY_AS_INVISIBILITY,oCreature) ||
        GetHasSpell(SPELL_INVISIBILITY,oCreature)) &&
        total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_WEB,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_WEB_3,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
// Shifter should not get spells, even at epic levels
/*    if (GetHasSpell(SPELL_MAGIC_MISSILE,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGIC_MISSILE_5,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_FIREBALL,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_FIREBALL_10,IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_CONE_OF_COLD,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_CONE_OF_COLD_9,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_LIGHTNING_BOLT,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHTNING_BOLT_10,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_CURE_CRITICAL_WOUNDS,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_12,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_HEAL,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_HEAL_11,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_FINGER_OF_DEATH,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_FINGER_OF_DEATH_13,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_FIRE_STORM,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_FIRE_STORM_13,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_HAMMER_OF_THE_GODS,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_12,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_GREATER_DISPELLING,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_GREATER_DISPELLING_7,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_DISPEL_MAGIC,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPEL_MAGIC_10,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_HARM,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_HARM_11,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
}




// Remove "dangling" aura effects on trueform shift
// Now only removes things it should remove (i.e., auras)
void RemoveAuraEffect( object oPC )
{
    if ( GetHasSpellEffect(SPELLABILITY_AURA_BLINDING, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_BLINDING, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_COLD, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_COLD, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_ELECTRICITY, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_ELECTRICITY, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_FEAR, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_FEAR, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_FIRE, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_FIRE, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_MENACE, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_MENACE, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_PROTECTION, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_PROTECTION, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_STUN, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_STUN, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_UNEARTHLY_VISAGE, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_UNEARTHLY_VISAGE, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_UNNATURAL, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_UNNATURAL, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_DRAGON_FEAR, oPC) )
        RemoveSpellEffects( SPELLABILITY_DRAGON_FEAR, oPC, oPC );
}




void DeleteFromKnownArray(int nIndex, object oPC)
{
    object oMimicForms = GetItemPossessedBy( oPC, "soul_prism" );
    int num_creatures = GetLocalInt( oMimicForms, "num_creatures" );
    int i;

    for ( i=nIndex; i<(num_creatures-1); i++ )
    {
        SetLocalArrayString( oMimicForms, "shift_choice", i,GetLocalArrayString( oMimicForms, "shift_choice", i+1 ));
        SetLocalArrayString( oMimicForms, "shift_choice_name", i,GetLocalArrayString( oMimicForms, "shift_choice_name", i+1 ));
    }
    SetLocalInt( oMimicForms, "num_creatures", num_creatures-1 );
}




int GetTrueForm(object oPC)
{
    int nRace = GetRacialType(OBJECT_SELF);
    int nPCForm;
    nPCForm = StringToInt(Get2DACache("racialtypes", "Appearance", nRace));
//      switch (nRace)
//      {
//      case RACIAL_TYPE_DWARF:
//          nPCForm = APPEARANCE_TYPE_DWARF;
//          break;
//      case RACIAL_TYPE_ELF:
//          nPCForm = APPEARANCE_TYPE_ELF;
//          break;
//      case RACIAL_TYPE_GNOME:
//          nPCForm = APPEARANCE_TYPE_GNOME;
//          break;
//      case RACIAL_TYPE_HALFELF:
//          nPCForm = APPEARANCE_TYPE_HALF_ELF;
//          break;
//      case RACIAL_TYPE_HALFLING:
//          nPCForm = APPEARANCE_TYPE_HALFLING;
//          break;
//      case RACIAL_TYPE_HALFORC:
//          nPCForm = APPEARANCE_TYPE_HALF_ORC;
//          break;
//      case RACIAL_TYPE_HUMAN:
//          nPCForm = APPEARANCE_TYPE_HUMAN;
//          break;
//      }
//  }
    return nPCForm;
}





