#include "prc_ccc_inc_a"

void AddAppearance(int i)
{
    string sName;
    sName = Get2DACache("appearance", "STRING_REF", i);
    sName = GetStringByStrRef(StringToInt(sName));
    array_set_string(OBJECT_SELF, "ChoiceTokens",
        array_get_size(OBJECT_SELF, "ChoiceTokens"),
            sName);
    array_set_int(OBJECT_SELF, "ChoiceValue",
        array_get_size(OBJECT_SELF, "ChoiceValue"),
            i);
}

void SetupRacialAppearances()
{
    /*
        for races:
        RACIAL_TYPE_RAKSHASA
        RACIAL_TYPE_MINOTAUR
        RACIAL_TYPE_OGRE
        RACIAL_TYPE_GOBLIN
        RACIAL_TYPE_HOBGOBLIN
        RACIAL_TYPE_BUGBEAR
        RACIAL_TYPE_GNOLL
        RACIAL_TYPE_KOBOLD
        RACIAL_TYPE_ASABI
        RACIAL_TYPE_DRIDER
        RACIAL_TYPE_TROLL
        RACIAL_TYPE_ILLITHID
        RACIAL_TYPE_LIZARDFOLK
        RACIAL_TYPE_KRYNN_MINOTAUR
        RACIAL_TYPE_BEHOLDER
    */
    int i;
    int nRace = GetLocalInt(OBJECT_SELF, "Race");
    int nSex  = GetLocalInt(OBJECT_SELF, "Gender");
    if(nRace == RACIAL_TYPE_RAKSHASA)
    {
        if(nSex == GENDER_MALE)
        {
            AddAppearance(APPEARANCE_TYPE_RAKSHASA_BEAR_MALE);
            AddAppearance(APPEARANCE_TYPE_RAKSHASA_TIGER_MALE);
            AddAppearance(APPEARANCE_TYPE_RAKSHASA_WOLF_MALE);
        }
        else if(nSex == GENDER_FEMALE)
            AddAppearance(APPEARANCE_TYPE_RAKSHASA_TIGER_FEMALE);
    }
    else if(nRace == RACIAL_TYPE_MINOTAUR)
    {
        AddAppearance(APPEARANCE_TYPE_MINOTAUR);
        AddAppearance(APPEARANCE_TYPE_MINOTAUR_CHIEFTAIN);
        AddAppearance(APPEARANCE_TYPE_MINOTAUR_SHAMAN);
    }
    else if(nRace == RACIAL_TYPE_KRYNN_MINOTAUR)
    {
        AddAppearance(APPEARANCE_TYPE_MINOTAUR);
        AddAppearance(APPEARANCE_TYPE_MINOTAUR_CHIEFTAIN);
        AddAppearance(APPEARANCE_TYPE_MINOTAUR_SHAMAN);
    }
    else if(nRace == RACIAL_TYPE_OGRE)
    {
        AddAppearance(APPEARANCE_TYPE_OGRE);
        AddAppearance(APPEARANCE_TYPE_OGRE_CHIEFTAIN);
        AddAppearance(APPEARANCE_TYPE_OGRE_CHIEFTAINB);
        AddAppearance(APPEARANCE_TYPE_OGRE_MAGE);
        AddAppearance(APPEARANCE_TYPE_OGRE_MAGEB);
        AddAppearance(APPEARANCE_TYPE_OGREB);
    }
    else if(nRace == RACIAL_TYPE_GOBLIN)
    {
        AddAppearance(APPEARANCE_TYPE_GOBLIN_A);
        AddAppearance(APPEARANCE_TYPE_GOBLIN_B);
        AddAppearance(APPEARANCE_TYPE_GOBLIN_CHIEF_A);
        AddAppearance(APPEARANCE_TYPE_GOBLIN_CHIEF_B);
        AddAppearance(APPEARANCE_TYPE_GOBLIN_SHAMAN_A);
        AddAppearance(APPEARANCE_TYPE_GOBLIN_SHAMAN_B);
    }
    else if(nRace == RACIAL_TYPE_HOBGOBLIN)
    {
        AddAppearance(APPEARANCE_TYPE_HOBGOBLIN_WARRIOR);
        AddAppearance(APPEARANCE_TYPE_HOBGOBLIN_WIZARD);
    }
    else if(nRace == RACIAL_TYPE_BUGBEAR)
    {
        AddAppearance(APPEARANCE_TYPE_BUGBEAR_A);
        AddAppearance(APPEARANCE_TYPE_BUGBEAR_B);
        AddAppearance(APPEARANCE_TYPE_BUGBEAR_CHIEFTAIN_A);
        AddAppearance(APPEARANCE_TYPE_BUGBEAR_CHIEFTAIN_B);
        AddAppearance(APPEARANCE_TYPE_BUGBEAR_SHAMAN_A);
        AddAppearance(APPEARANCE_TYPE_BUGBEAR_SHAMAN_B);
    }
    else if(nRace == RACIAL_TYPE_GNOLL)
    {
        AddAppearance(APPEARANCE_TYPE_GNOLL_WARRIOR);
        AddAppearance(APPEARANCE_TYPE_GNOLL_WIZ);
    }
    else if(nRace == RACIAL_TYPE_KOBOLD)
    {
        AddAppearance(APPEARANCE_TYPE_KOBOLD_A);
        AddAppearance(APPEARANCE_TYPE_KOBOLD_B);
        AddAppearance(APPEARANCE_TYPE_KOBOLD_CHIEF_A);
        AddAppearance(APPEARANCE_TYPE_KOBOLD_CHIEF_B);
        AddAppearance(APPEARANCE_TYPE_KOBOLD_SHAMAN_A);
        AddAppearance(APPEARANCE_TYPE_KOBOLD_SHAMAN_B);
    }
    else if(nRace == RACIAL_TYPE_ASABI)
    {
        AddAppearance(APPEARANCE_TYPE_ASABI_CHIEFTAIN);
        AddAppearance(APPEARANCE_TYPE_ASABI_SHAMAN);
        AddAppearance(APPEARANCE_TYPE_ASABI_WARRIOR);
    }
    else if(nRace == RACIAL_TYPE_DRIDER)
    {
        if(nSex == GENDER_MALE)
        {
            AddAppearance(APPEARANCE_TYPE_DRIDER);
            AddAppearance(APPEARANCE_TYPE_DRIDER_CHIEF);
        }
        else if (nSex == GENDER_FEMALE)
            AddAppearance(APPEARANCE_TYPE_DRIDER_FEMALE);
    }
    else if(nRace == RACIAL_TYPE_TROLL)
    {
        AddAppearance(APPEARANCE_TYPE_TROLL);
        AddAppearance(APPEARANCE_TYPE_TROLL_CHIEFTAIN);
        AddAppearance(APPEARANCE_TYPE_TROLL_SHAMAN);
    }
    else if(nRace == RACIAL_TYPE_ILLITHID)
    {
        AddAppearance(APPEARANCE_TYPE_MINDFLAYER);
        AddAppearance(APPEARANCE_TYPE_MINDFLAYER_2);
        AddAppearance(APPEARANCE_TYPE_MINDFLAYER_ALHOON);
    }
    else if(nRace == RACIAL_TYPE_LIZARDFOLK)
    {
        AddAppearance(APPEARANCE_TYPE_LIZARDFOLK_A);
        AddAppearance(APPEARANCE_TYPE_LIZARDFOLK_B);
        AddAppearance(APPEARANCE_TYPE_LIZARDFOLK_SHAMAN_A);
        AddAppearance(APPEARANCE_TYPE_LIZARDFOLK_SHAMAN_B);
        AddAppearance(APPEARANCE_TYPE_LIZARDFOLK_WARRIOR_A);
        AddAppearance(APPEARANCE_TYPE_LIZARDFOLK_WARRIOR_B);
    }
    else if(nRace == RACIAL_TYPE_BEHOLDER)
    {
        AddAppearance(APPEARANCE_TYPE_BEHOLDER);
        AddAppearance(APPEARANCE_TYPE_BEHOLDER_MAGE);
        AddAppearance(APPEARANCE_TYPE_BEHOLDER_MOTHER);
    }
    else
    {
        SetLocalInt(OBJECT_SELF, "Stage", GetLocalInt(OBJECT_SELF, "Stage")+2);
        SetupStage();
    }
}

void AddPortrait(int i)
{
    string sName;
    sName = Get2DACache("portraits", "BaseResRef", i);
    sName = GetStringByStrRef(StringToInt(sName));
    sName += " "+GetStringByStrRef(StringToInt(Get2DACache("gender", "NAME", StringToInt(Get2DACache("portraits", "Sex", i)))));
    sName += " "+GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", StringToInt(Get2DACache("portraits", "Race", i)))));
    array_set_string(OBJECT_SELF, "ChoiceTokens",
        array_get_size(OBJECT_SELF, "ChoiceTokens"),
            sName);
    array_set_int(OBJECT_SELF, "ChoiceValue",
        array_get_size(OBJECT_SELF, "ChoiceValue"),
            i);
}

void SetupRacialPortrait()
{
    int i;
    int nRace = GetLocalInt(OBJECT_SELF, "Race");
    int nSex  = GetLocalInt(OBJECT_SELF, "Gender");
    if(nRace == RACIAL_TYPE_HUMAN)
    {

    }
    else
    {
        SetLocalInt(OBJECT_SELF, "Stage", GetLocalInt(OBJECT_SELF, "Stage")+2);
        SetupStage();
    }
}

void AddSoundset(int i)
{
    string sName;
    sName = Get2DACache("soundset", "STRREF", i);
    sName = GetStringByStrRef(StringToInt(sName));
    array_set_string(OBJECT_SELF, "ChoiceTokens",
        array_get_size(OBJECT_SELF, "ChoiceTokens"),
            sName);
    array_set_int(OBJECT_SELF, "ChoiceValue",
        array_get_size(OBJECT_SELF, "ChoiceValue"),
            i);
}

void SetupRacialSoundset()
{
    int i;
    int nRace = GetLocalInt(OBJECT_SELF, "Race");
    int nSex  = GetLocalInt(OBJECT_SELF, "Gender");
    if(nRace == RACIAL_TYPE_HUMAN)
    {

    }
    else
    {
        SetLocalInt(OBJECT_SELF, "Stage", GetLocalInt(OBJECT_SELF, "Stage")+2);
        SetupStage();
    }
}
