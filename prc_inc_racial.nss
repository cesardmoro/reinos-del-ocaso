// Useful includes for dealing with races.

#include "prc_class_const"
#include "prc_feat_const"
#include "prc_racial_const"

//function prototypes
//use this to get class/race adjusted racial type back to one of the bioware bases
//includes shifter changed forms
int MyPRCGetRacialType(object oTarget);

int MyPRCGetRacialType(object oCreature)
{
    if (GetLevelByClass(CLASS_TYPE_LICH,oCreature) >= 4)
        return RACIAL_TYPE_UNDEAD;
    if (GetLevelByClass(CLASS_TYPE_MONK,oCreature) >= 20)
        return RACIAL_TYPE_OUTSIDER;
    if (GetLevelByClass(CLASS_TYPE_OOZEMASTER,oCreature) >= 10)
        return RACIAL_TYPE_OOZE;
    if (GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE,oCreature) >= 10)
        return RACIAL_TYPE_DRAGON;
    if (GetLevelByClass(CLASS_TYPE_ACOLYTE,oCreature) >= 10)
        return RACIAL_TYPE_OUTSIDER;
    if (GetLevelByClass(CLASS_TYPE_ES_FIRE,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_ES_COLD,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_ES_ELEC,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_ES_ACID,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_DIVESF,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_DIVESC,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_DIVESE,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_DIVESA,oCreature) >= 10)
        return RACIAL_TYPE_ELEMENTAL;
    if (GetLevelByClass(CLASS_TYPE_HEARTWARDER,oCreature) >= 10)
        return RACIAL_TYPE_FEY;
    if (GetLevelByClass(CLASS_TYPE_WEREWOLF,oCreature) >= 10)
        return RACIAL_TYPE_SHAPECHANGER;

    //race pack racial types
    if(GetHasFeat(FEAT_DWARVEN, oCreature))
        return RACIAL_TYPE_DWARF;
    if(GetHasFeat(FEAT_ELVEN, oCreature))
        return RACIAL_TYPE_ELF;
    if(GetHasFeat(FEAT_GNOMISH, oCreature))
        return RACIAL_TYPE_GNOME;
    if(GetHasFeat(FEAT_HALFLING, oCreature))
        return RACIAL_TYPE_HALFLING;
    if(GetHasFeat(FEAT_ORCISH, oCreature))
        return RACIAL_TYPE_HUMANOID_ORC;
    if(GetHasFeat(FEAT_HUMAN, oCreature))
        return RACIAL_TYPE_HUMAN;
    if(GetHasFeat(FEAT_GOBLINOID, oCreature))
        return RACIAL_TYPE_HUMANOID_GOBLINOID;
    if(GetHasFeat(FEAT_REPTILIAN, oCreature))
        return RACIAL_TYPE_HUMANOID_REPTILIAN;
    if(GetHasFeat(FEAT_MONSTEROUS, oCreature))
        return RACIAL_TYPE_HUMANOID_MONSTROUS;
    if(GetHasFeat(FEAT_UNDEAD, oCreature))
        return RACIAL_TYPE_UNDEAD;
    if(GetHasFeat(FEAT_BEAST, oCreature))
        return RACIAL_TYPE_BEAST;
    if(GetHasFeat(FEAT_VERMIN, oCreature))
        return RACIAL_TYPE_VERMIN;
    if(GetHasFeat(FEAT_DRAGON, oCreature))
        return RACIAL_TYPE_DRAGON;
    if(GetHasFeat(FEAT_ELEMENTAL, oCreature))
        return RACIAL_TYPE_ELEMENTAL;
    if(GetHasFeat(FEAT_GIANT, oCreature))
        return RACIAL_TYPE_GIANT;
    if(GetHasFeat(FEAT_FEY, oCreature))
        return RACIAL_TYPE_FEY;
    if(GetHasFeat(FEAT_ABERRATION, oCreature))
        return RACIAL_TYPE_ABERRATION;
    if(GetHasFeat(FEAT_OUTSIDER, oCreature))
        return RACIAL_TYPE_OUTSIDER;

    // check for a local variable that overrides the race
    // the shifter will use this everytime they change
    // the racial types are zero based, use 1 based to ensure the variable is set
    int nRace = GetLocalInt(oCreature,"RACIAL_TYPE");
    if (nRace)
        return (nRace-1);

    return GetRacialType(oCreature);
}
