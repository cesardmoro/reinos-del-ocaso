//::///////////////////////////////////////////////
//:: Name        Assassin Death Attack heartbeat
//:: FileName    prc_assn_da_hb
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// Death Attack for the assassin
// this function counts down till they get to perform the DA
// and then adds the slaytarget type property to their weapon

#include "NW_I0_GENERIC"
#include "x2_inc_itemprop"
#include "prc_class_const"

void main()
{
    object oPC = OBJECT_SELF;

    // Currently from the PnP rules they dont have to wait except for the study time
    // So this fWaitTime is not being used at all
    // Are we still counting down before they can do another DA?
    float fWaitTime = GetLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_WAITSEC");
    if (fWaitTime > 0.0)
    {
        // The wait is over they can do another DA
        DeleteLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_WAITSEC");
        return;
    }

    // We must be counting down until we can apply the slay property
    // Assasain must not be seen
    if (!((GetStealthMode(oPC) == STEALTH_MODE_ACTIVATED) ||
         (GetHasEffect(EFFECT_TYPE_INVISIBILITY,oPC)) ||
         !(GetIsInCombat(oPC)) ||
         (GetHasEffect(EFFECT_TYPE_SANCTUARY,oPC))))
    {
        FloatingTextStringOnCreature("El blanco te ah visto",OBJECT_SELF);
        DeleteLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_APPLY");
        return;
    }
    float fApplyDATime = GetLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_APPLY");
    // We run every 6 seconds
    fApplyDATime -= 6.0;
    SetLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_APPLY",fApplyDATime );

    // Times up, apply the slay to their primary weapon
    if (fApplyDATime <= 0.0)
    {
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
        switch (GetBaseItemType(oWeapon))
        {
        // FROM THE PNP rules (DM guide, must be a melee weapon)
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_SLING:
          SendMessageToPC(oPC,"No posees ningun arma melee");
          return;
          break;

        // Unarmed grab the glove, if no glove no luck
        case BASE_ITEM_INVALID:
          oWeapon=GetItemInSlot(INVENTORY_SLOT_ARMS);
          break;
    }
        // if we got something add the on hit slay racial type property to it
        // for 3 rounds

        if (GetIsObjectValid(oWeapon))
        {
            int nSaveDC = 10 + GetLevelByClass(CLASS_TYPE_BFZ,oPC) + GetLevelByClass(CLASS_TYPE_ASSASSIN,oPC) + GetLevelByClass(CLASS_TYPE_SHADOWLORD,oPC) + GetAbilityModifier(ABILITY_INTELLIGENCE,oPC);
            // Saves are capped at 70
            if (nSaveDC > 70)
                nSaveDC = 70;
            int nRace = GetLocalInt(oPC,"PRC_ASSN_TARGET_RACE");
            itemproperty ipSlay = ItemPropertyOnHitProps(IP_CONST_ONHIT_SLAYRACE,nSaveDC,nRace);
            IPSafeAddItemProperty(oWeapon, ipSlay, RoundsToSeconds(3));
            SendMessageToPC(oPC,"Ya has visto su punto debil tienes 3 rounds para acabar con el");
            return;
        }
        else
        {
            FloatingTextStringOnCreature("No tienes un arma Melee",OBJECT_SELF);
            return;
        }
    }
    else
    {
        SendMessageToPC(oPC,"Aun estas estudiando a tu victima espera "+IntToString(FloatToInt(fApplyDATime))+ " segundos mas");
        // Run more heartbeats
        DelayCommand(6.0,ExecuteScript("prc_assn_da_hb",oPC));
    }
    return;
}
