#include "inc_utility"
#include "inc_letocommands"
#include "prc_racial_const"
#include "prc_ccc_inc"
#include "inc_encrypt"

void main()
{
    //define some varaibles
//    object oPC = GetPCSpeaker();//OBJECT_SELF;
//    if(!GetIsObjectValid(oPC))
//        oPC = OBJECT_SELF;
//    if(!GetIsObjectValid(oPC))
//        return;
    object oPC = OBJECT_SELF;
    int i;
    //get some stored data
    int         nStr =              GetLocalInt(oPC, "Str");
    int         nDex =              GetLocalInt(oPC, "Dex");
    int         nCon =              GetLocalInt(oPC, "Con");
    int         nInt =              GetLocalInt(oPC, "Int");
    int         nWis =              GetLocalInt(oPC, "Wis");
    int         nCha =              GetLocalInt(oPC, "Cha");

    int         nRace =             GetLocalInt(oPC, "Race");

    int         nClass =            GetLocalInt(oPC, "Class");
    int         nHitPoints =        GetLocalInt(oPC, "HitPoints");

    int         nSex =              GetLocalInt(oPC, "Gender");

    int         nOrder =            GetLocalInt(oPC, "LawfulChaotic");
    int         nMoral =            GetLocalInt(oPC, "GoodEvil");


    int         nFamiliar =         GetLocalInt(oPC, "Familiar");

    int         nAnimalCompanion =  GetLocalInt(oPC, "AnimalCompanion");

    int         nDomain1 =          GetLocalInt(oPC, "Domain1");
    int         nDomain2 =          GetLocalInt(oPC, "Domain2");

    int         nSchool =           GetLocalInt(oPC, "School");

    int         nSpellsPerDay0 =    GetLocalInt(oPC, "SpellsPerDay0");
    int         nSpellsPerDay1 =    GetLocalInt(oPC, "SpellsPerDay1");
    int         nVoiceset =         GetLocalInt(oPC, "Soundset");
    int         nSkin =             GetLocalInt(oPC, "Skin");
    int         nHair =             GetLocalInt(oPC, "Hair");
    int         nTattooColour1 =    GetLocalInt(oPC, "TattooColour1");
    int         nTattooColour2 =    GetLocalInt(oPC, "TattooColour2");

    int         nLevel =            GetLocalInt(oPC, "Level");

//game does this for you
//    nStr+= StringToInt(Get2DACache("racialtypes", "StrAdjust", nRace));
//    nDex+= StringToInt(Get2DACache("racialtypes", "DexAdjust", nRace));
//    nCon+= StringToInt(Get2DACache("racialtypes", "ConAdjust", nRace));
//    nInt+= StringToInt(Get2DACache("racialtypes", "IntAdjust", nRace));
//    nWis+= StringToInt(Get2DACache("racialtypes", "WisAdjust", nRace));
//    nCha+= StringToInt(Get2DACache("racialtypes", "ChaAdjust", nRace));
//    nHitPoints += (nCon-10)/2;

    //clear existing stuff
    string sScript;
    sScript += LetoDelete("FeatList");
    sScript += LetoDelete("ClassList");
    sScript += LetoDelete("LvlStatList");
    sScript += LetoDelete("SkillList");
    sScript += LetoAdd("FeatList", "", "list");
    sScript += LetoAdd("ClassList", "", "list");
    sScript += LetoAdd("LvlStatList", "", "list");
    sScript += LetoAdd("SkillList", "", "list");

    //Sex
    sScript += SetGender(nSex);

    //Race
    sScript += SetRace(nRace);

    //Class
    sScript += LetoAdd("ClassList/Class", IntToString(nClass), "int");
    sScript += LetoAdd("ClassList/[0]/ClassLevel", IntToString(nLevel+1), "short");
    sScript += LetoAdd("LvlStatList/LvlStatClass", IntToString(nClass), "byte");
    sScript += LetoAdd("LvlStatList/[0]/EpicLevel", "0", "byte");
    sScript += LetoAdd("LvlStatList/[0]/LvlStatHitDie", IntToString(nHitPoints), "byte");
    sScript += LetoAdd("LvlStatList/[0]/FeatList", "", "list");
    sScript += LetoAdd("LvlStatList/[0]/SkillList", "", "list");

    //Alignment
    sScript += LetoAdd("LawfulChaotic", IntToString(nOrder), "byte");
    sScript += LetoAdd("GoodEvil", IntToString(nMoral), "byte");

    //Familiar
    //has a random name
    if((nClass == CLASS_TYPE_WIZARD
        || nClass == CLASS_TYPE_SORCERER)
            && !GetPRCSwitch(PRC_PNP_FAMILIARS))
    {
        sScript += LetoAdd("FamiliarType", IntToString(nFamiliar), "int");
        if(GetFamiliarName(oPC) == "")
            sScript += LetoAdd("FamiliarName", RandomName(NAME_FAMILIAR), "string");
    }

    //Animal Companion
    //has a random name
    if(nClass == CLASS_TYPE_DRUID)
    {
        sScript += LetoAdd("CompanionType", IntToString(nAnimalCompanion), "int");
        if(GetAnimalCompanionName(oPC) == "")
            sScript += LetoAdd("CompanionName", RandomName(NAME_ANIMAL), "string");
    }

    //Domains
    if(nClass == CLASS_TYPE_CLERIC)
    {
        sScript += LetoAdd("ClassList/[0]/Domain1", IntToString(nDomain1), "byte");
        sScript += LetoAdd("ClassList/[0]/Domain2", IntToString(nDomain2), "byte");
    }

    //Ability Scores
    sScript += SetAbility(ABILITY_STRENGTH, nStr);
    sScript += SetAbility(ABILITY_DEXTERITY, nDex);
    sScript += SetAbility(ABILITY_CONSTITUTION, nCon);
    sScript += SetAbility(ABILITY_INTELLIGENCE, nInt);
    sScript += SetAbility(ABILITY_WISDOM, nWis);
    sScript += SetAbility(ABILITY_CHARISMA, nCha);

    //Feats
    //Make sure the list exists
    //Populate the list from array
    for(i=0;i<array_get_size(oPC, "Feats"); i++)
    {
        string si = IntToString(i);
        int nFeatID =array_get_int(oPC, "Feats", i);
        if(nFeatID != 0)
        {
            if(nFeatID == -1)//alertness fix
                nFeatID = 0;
//            DoDebug("Feat array positon "+IntToString(i)+" is "+IntToString(nFeatID));
            sScript += LetoAdd("FeatList/Feat", IntToString(nFeatID), "word");
            sScript += LetoAdd("LvlStatList/[0]/FeatList/Feat", IntToString(nFeatID), "word");
        }
    }

    //Skills
    for (i=0;i<GetPRCSwitch(FILE_END_SKILLS);i++)
    {
        sScript += LetoAdd("SkillList/Rank", IntToString(array_get_int(oPC, "Skills", i)), "byte");
        sScript += LetoAdd("LvlStatList/[_]/SkillList/Rank", IntToString(array_get_int(oPC, "Skills", i)), "char");
    }
    sScript += LetoAdd("SkillPoints", IntToString(array_get_int(oPC, "Skills", -1)), "word");
    sScript += LetoAdd("LvlStatList/[_]/SkillPoints", IntToString(array_get_int(oPC, "Skills", -1)), "word");

    //Spells
    if(nClass == CLASS_TYPE_WIZARD)
    {
        sScript += LetoAdd("ClassList/[_]/KnownList0", "", "list");
        sScript += LetoAdd("ClassList/[_]/KnownList1", "", "list");
        sScript += LetoAdd("LvlStatList/[_]/KnownList0", "", "list");
        sScript += LetoAdd("LvlStatList/[_]/KnownList1", "", "list");
        for (i=0;i<array_get_size(oPC, "SpellLvl0");i++)
        {
            sScript += LetoAdd("ClassList/[_]/KnownList0/Spell", IntToString(array_get_int(oPC, "SpellLvl0", i)), "word");
            sScript += LetoAdd("LvlStatList/[_]/KnownList0/Spell", IntToString(array_get_int(oPC, "SpellLvl0", i)), "word");
        }
        for (i=0;i<array_get_size(oPC, "SpellLvl1");i++)
        {
            sScript += LetoAdd("ClassList/[_]/KnownList1/Spell", IntToString(array_get_int(oPC, "SpellLvl1", i)), "word");
            sScript += LetoAdd("LvlStatList/[_]/KnownList1/Spell", IntToString(array_get_int(oPC, "SpellLvl1", i)), "word");
        }
        //throw spellschoool in here too
        if(GetPRCSwitch(PRC_PNP_SPELL_SCHOOLS))
            sScript += LetoAdd("ClassList/[_]/School", IntToString(9), "byte");
        else
            sScript += LetoAdd("ClassList/[_]/School", IntToString(nSchool), "byte");
    }
    else if (nClass == CLASS_TYPE_BARD)
    {
        sScript += LetoAdd("ClassList/[_]/KnownList0", "", "list");
        sScript += LetoAdd("ClassList/[_]/SpellsPerDayList", "", "list");
        sScript += LetoAdd("LvlStatList/[_]/KnownList0", "", "list");
        for (i=0;i<array_get_size(oPC, "SpellLvl0");i++)
        {
            sScript += LetoAdd("ClassList/[_]/KnownList0/Spell", IntToString(array_get_int(oPC, "SpellLvl0", i)), "word");
            sScript += LetoAdd("LvlStatList/[_]/KnownList0/Spell", IntToString(array_get_int(oPC, "SpellLvl0", i)), "word");
        }
        //spells per day
        sScript += LetoAdd("ClassList/[_]/SpellsPerDayList/NumSpellsLeft", IntToString(nSpellsPerDay0), "word");
    }
    else if (nClass == CLASS_TYPE_SORCERER)
    {
        sScript += LetoAdd("ClassList/[_]/KnownList0", "", "list");
        sScript += LetoAdd("ClassList/[_]/KnownList1", "", "list");
        sScript += LetoAdd("ClassList/[_]/SpellsPerDayList", "", "list");
        sScript += LetoAdd("LvlStatList/[_]/KnownList0", "", "list");
        sScript += LetoAdd("LvlStatList/[_]/KnownList1", "", "list");
        for (i=0;i<array_get_size(oPC, "SpellLvl0");i++)
        {
            sScript += LetoAdd("ClassList/[_]/KnownList0/Spell", IntToString(array_get_int(oPC, "SpellLvl0", i)), "word");
            sScript += LetoAdd("LvlStatList/[_]/KnownList0/Spell", IntToString(array_get_int(oPC, "SpellLvl0", i)), "word");
        }
        for (i=0;i<array_get_size(oPC, "SpellLvl1");i++)
        {
            sScript += LetoAdd("ClassList/[_]/KnownList1/Spell", IntToString(array_get_int(oPC, "SpellLvl1", i)), "word");
            sScript += LetoAdd("LvlStatList/[_]/KnownList1/Spell", IntToString(array_get_int(oPC, "SpellLvl1", i)), "word");
        }
        //spells per day
        sScript += LetoAdd("ClassList/[_]/SpellsPerDayList/NumSpellsLeft", IntToString(nSpellsPerDay0), "word");
        sScript += LetoAdd("ClassList/[_]/SpellsPerDayList/NumSpellsLeft", IntToString(nSpellsPerDay1), "word");
    }

    //Appearance stuff
    if(nVoiceset != -1) //keep existing portrait
        sScript += LetoAdd("SoundSetFile", IntToString(nVoiceset), "word");
    sScript += SetSkinColor(nSkin);
    sScript += SetHairColor(nHair);
    sScript += SetTatooColor(nTattooColour1, 1);
    sScript += SetTatooColor(nTattooColour2, 2);

    //Special abilities
    //since bioware screws this up in 1.64 its not needed
    //the PRC does this via feats instead
/*    sScript += "<gff:add 'SpecAbilityList' {type='list'}>";
    for(i=0;i<array_get_size(oPC, "SpecAbilID"); i++)
    {
//        sScript += AddSpecialAbility(array_get_int(oPC, "SpecAbilID",i), 1, array_get_int(oPC, "SpecAbilLvl",i));
        sScript +="<gff:add 'SpecAbilityList/Spell' {type='word' value="+IntToString(array_get_int(oPC, "SpecAbilID",i))+"}>";
        sScript +="<gff:add 'SpecAbilityList/[_]/SpellCasterLevel' {type='byte' value="+IntToString(array_get_int(oPC, "SpecAbilLvl",i))+"}>";
        sScript +="<gff:add 'SpecAbilityList/[_]/SpellFlags' {type='char' value="+IntToString(array_get_int(oPC, "SpecAbilFlag",i))+"}>";
    } */

    //Racial hit dice
    for(i=1;i<=nLevel;i++)
    {
        //class
        sScript += LetoAdd("LvlStatList/LvlStatClass", Get2DACache("ECL", "RaceClass", nRace), "byte");
        //ability
        if(i == 3 || i == 7 || i == 11 || i == 15
                || i == 19 || i == 23 || i == 27 || i == 31
                || i == 13 || i == 39)
        {
            sScript += AdjustAbility(GetLocalInt(OBJECT_SELF, "RaceLevel"+IntToString(i)+"Ability"),i);
        }
        //skills
        sScript += LetoAdd("LvlStatList/["+IntToString(i-1)+"]/SkillList", "", "list");
        int j;
        for (j=0;j<GetPRCSwitch(FILE_END_SKILLS);j++)
        {
            int nMod = array_get_int(oPC, "RaceLevel"+IntToString(nLevel)+"Skills", j);
            if(nMod)
                sScript += AdjustSkill(j, nMod, i);
        }
        sScript += AdjustSpareSkill(array_get_int(oPC, "RaceLevel"+IntToString(i)+"Skills", -1), i);
        //feat
        if(i == 3 || i == 5 || i == 8 || i == 11
                || i == 14 || i == 17 || i == 20 || i == 23
                || i == 26 || i == 29 || i == 32 || i == 35
                || i == 38 )
        {
            int nFeatID = GetLocalInt(OBJECT_SELF, "RaceLevel"+IntToString(i)+"Feat");
            //alertness correction
            if(nFeatID == -1)
                nFeatID = 0;
            sScript += LetoAdd("LvlStatList/["+IntToString(i-1)+"]/FeatList", "", "list");
            sScript += LetoAdd("FeatList/Feat", IntToString(nFeatID), "word");
            sScript += LetoAdd("LvlStatList/["+IntToString(i-1)+"]/FeatList/Feat", IntToString(nFeatID), "word");
        }
        //epic level
        if(nLevel <21)
            sScript += LetoAdd("LvlStatList/["+IntToString(i-1)+"]/EpicLevel", "0", "byte");
        else
            sScript += LetoAdd("LvlStatList/["+IntToString(i-1)+"]/EpicLevel", "1", "byte");
        //hitdice
        int nRacialHitPoints = StringToInt(Get2DACache("classes", "HitDie", StringToInt(Get2DACache("ECL", "RacialClass", nRace))));
        //first 3 racial levels get max HP
        if(i > 3)
            nRacialHitPoints = 1+Random(nRacialHitPoints);
        sScript += LetoAdd("LvlStatList/["+IntToString(i-1)+"]/LvlStatHitDie", IntToString(nHitPoints), "byte");
    }

    //change the tag to mark the player as done
    sScript += LetoAdd("Tag", Encrypt(oPC), "string");
    //give an XP so the XP switch works
    SetXP(oPC, 1);
    //racial xp
    if(nLevel > 0)
    {
        int nXP = nLevel*(nLevel-1)*500;
        SetXP(oPC, nXP);
        SetLocalInt(oPC, "sXP_AT_LAST_HEARTBEAT", nXP);//simple XPmod bypassing
    }

    SetLocalInt(oPC, "StopRotatingCamera", TRUE);
    SetCutsceneMode(oPC, FALSE);
    DoCleanup();
    object oClone = GetLocalObject(oPC, "Clone");
    AssignCommand(oClone, SetIsDestroyable(TRUE));
    DestroyObject(oClone);
    //do anti-hacker stuff
    SetPlotFlag(oPC, FALSE);
    SetImmortal(oPC, FALSE);
    AssignCommand(oPC, SetIsDestroyable(TRUE));
    ForceRest(oPC);
    StackedLetoScript(sScript);
    if(GetLocalInt(oPC, "NewCohort"))
    {
        object oCopy = CopyObject(oPC, GetLocation(oPC));
        StackedLetoScript(SetCreatureName(RandomName(), FALSE));
        StackedLetoScript(SetCreatureName(RandomName(), TRUE));
        RunStackedLetoScriptOnObject(oCopy, "OBJECT", "SPAWN");
    }
    else
        RunStackedLetoScriptOnObject(oPC, "OBJECT", "SPAWN");
}
