//:://////////////////////////////////////////////////
//:: X0_CH_HEN_REST
/*
  OnRest event handler for henchmen/associates.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/06/2003
//:://////////////////////////////////////////////////
#include "prc_alterations"
#include "inc_newspellbook"

void main()
{
    // modifed by primogenitor
    // aribeth uses her blackguard spellbook
    if (GetTag(OBJECT_SELF) == "H2_Aribeth")
    {
        //check spellbook has been setup
        if(!GetLocalInt(OBJECT_SELF, "PRC_Aribeth_Spellbook"))
        {
        object oPC = OBJECT_SELF;
            persistant_array_create(oPC, "Spellbook1_31");
            persistant_array_create(oPC, "Spellbook2_31");
            persistant_array_create(oPC, "Spellbook3_31");
            persistant_array_create(oPC, "Spellbook4_31");
            persistant_array_set_int(oPC, "Spellbook1_31", 0, 15); //magic weapon
            persistant_array_set_int(oPC, "Spellbook1_31", 1, 6); //Doom
            persistant_array_set_int(oPC, "Spellbook1_31", 2, 6); //Doom
            persistant_array_set_int(oPC, "Spellbook1_31", 3, 6); //Doom
            persistant_array_set_int(oPC, "Spellbook1_31", 4, 6); //Doom
            persistant_array_set_int(oPC, "Spellbook1_31", 5, 6); //Doom
            persistant_array_set_int(oPC, "Spellbook1_31", 6, 6); //Doom
            persistant_array_set_int(oPC, "Spellbook1_31", 7, 6); //Doom

            persistant_array_set_int(oPC, "Spellbook2_31", 0, 23); //Bulls Strength
            persistant_array_set_int(oPC, "Spellbook2_31", 1, 32); //Darkness
            persistant_array_set_int(oPC, "Spellbook2_31", 2, 35); //Eagles Splendor
            persistant_array_set_int(oPC, "Spellbook2_31", 3, 32); //Darkness
            persistant_array_set_int(oPC, "Spellbook2_31", 4, 40); //inflict moderate
            persistant_array_set_int(oPC, "Spellbook2_31", 5, 40); //inflict moderate
            persistant_array_set_int(oPC, "Spellbook2_31", 6, 40); //inflict moderate
            persistant_array_set_int(oPC, "Spellbook2_31", 7, 40); //inflict moderate

            persistant_array_set_int(oPC, "Spellbook3_31", 0, 57); //Prot Ele
            persistant_array_set_int(oPC, "Spellbook3_31", 1, 57); //Prot Ele
            persistant_array_set_int(oPC, "Spellbook3_31", 2, 48); //contagion
            persistant_array_set_int(oPC, "Spellbook3_31", 3, 48); //contagion
            persistant_array_set_int(oPC, "Spellbook3_31", 4, 48); //contagion
            persistant_array_set_int(oPC, "Spellbook3_31", 5, 48); //contagion
            persistant_array_set_int(oPC, "Spellbook3_31", 6, 48); //contagion
            persistant_array_set_int(oPC, "Spellbook3_31", 7, 48); //contagion

            persistant_array_set_int(oPC, "Spellbook4_31", 0, 69); //summon IV
            persistant_array_set_int(oPC, "Spellbook4_31", 1, 67); //inflict critical
            persistant_array_set_int(oPC, "Spellbook4_31", 2, 69); //summon IV
            persistant_array_set_int(oPC, "Spellbook4_31", 3, 67); //inflict critical
            persistant_array_set_int(oPC, "Spellbook4_31", 4, 67); //inflict critical
            persistant_array_set_int(oPC, "Spellbook4_31", 5, 67); //inflict critical
            SetLocalInt(OBJECT_SELF, "PRC_Aribeth_Spellbook", TRUE);
        }
        CheckNewSpellbooks(OBJECT_SELF);
    }
}