void AddColour(string sName, int nID)
{
    array_set_string(OBJECT_SELF, "ChoiceTokens",
        array_get_size(OBJECT_SELF, "ChoiceTokens"),
            sName);
    array_set_int(OBJECT_SELF, "ChoiceValue",
        array_get_size(OBJECT_SELF, "ChoiceValue"),
            nID);
}

void SetupSkin()
{
    AddColour("Very pale"          ,  0);
    AddColour("Pale"               ,  1);
    AddColour("Slightly pale"      ,  2);
    AddColour("'Normal'"           ,  3);
    AddColour("Slightly tanned"    ,  4);
    AddColour("Tanned"             ,  5);
    AddColour("Very tanned"        ,  6);
    AddColour("Extremely tanned"   ,  7);
    AddColour("Very light yellow A",  8);
    AddColour("Very light yellow B", 24);
    AddColour("Light yellow A"     ,  9);
    AddColour("Light yellow B"     , 25);
    AddColour("Dark yellow A"      , 10);
    AddColour("Dark yellow B"      , 26);
    AddColour("Very dark yellow A" , 11);
    AddColour("Very dark yellow B" , 27);
    AddColour("Very light grey A"  , 16);
    AddColour("Very light grey B"  , 40);
    AddColour("Light grey A"       , 17);
    AddColour("Light grey B"       , 41);
    AddColour("Dark grey A"        , 18);
    AddColour("Dark grey B"        , 42);
    AddColour("Very dark grey A"   , 19);
    AddColour("Very dark grey B"   , 43);
    AddColour("Very pale blue-grey", 20);
    AddColour("Pale blue-grey"     , 21);
    AddColour("Slightly pale blue-grey",22);
    AddColour("Blue-grey"          , 23);
    AddColour("Slightly dark blue-grey",28);
    AddColour("Dark blue-grey"     , 29);
    AddColour("Very dark blue-grey", 30);
    AddColour("Extremely dark blue-grey", 31);
    AddColour("Very light yellow-green ", 32);
    AddColour("Light yellow-green" , 33);
    AddColour("Yellow-green"       , 34);
    AddColour("Dark yellow-green"  , 35);
    AddColour("Very light green"   , 36);
    AddColour("Light green"        , 37);
    AddColour("Green"              , 38);
    AddColour("Dark green"         , 39);
    AddColour("Red A"              , 44);
    AddColour("Red B"              , 45);
    AddColour("Pink A"             , 46);
    AddColour("Pink B"             , 47);
    AddColour("Blue A"             , 48);
    AddColour("Blue B"             , 49);
    AddColour("Turquoise A"        , 50);
    AddColour("Turquoise B"        , 51);
    AddColour("Green A"            , 52);
    AddColour("Green B"            , 53);
    AddColour("Amber A"            , 54);
    AddColour("Amber B"            , 55);
    if(GetPRCSwitch(PRC_CONVOCC_ALLOW_HIDDEN_SKIN_COLOURS))
    {
        AddColour("Silver"             , 56);
        AddColour("Obsidian"           , 57);
        AddColour("Gold"               , 58);
        AddColour("Bronze"             , 59);
        AddColour("Odd grey"           , 60);
        AddColour("Odd metalic"        , 61);
        AddColour("Matt while"         , 62);
        AddColour("Matt black"         , 63);
    }
}

void SetupHair()
{

    AddColour("Light brown A"      ,  0);
    AddColour("Light brown B"      , 12);
    AddColour("Brown A"            ,  1);
    AddColour("Brown B"            , 13);
    AddColour("Dark brown A"       ,  2);
    AddColour("Dark brown B"       , 14);
    AddColour("Darkest brown A"    ,  3);
    AddColour("Darkest brown B"    , 15);
    AddColour("Light red"          ,  4);
    AddColour("Red"                ,  5);
    AddColour("Dark red"           ,  6);
    AddColour("Darkest red"        ,  7);
    AddColour("Light blonde"       ,  8);
    AddColour("Blonde"             ,  9);
    AddColour("Dark blonde"        , 10);
    AddColour("Darkest blonde"     , 11);
    AddColour("Silver grey"        , 16);
    AddColour("Lightest grey"      , 17);
    AddColour("Light grey"         , 18);
    AddColour("Grey"               , 19);
    AddColour("Dark grey"          , 20);
    AddColour("Darkest grey"       , 21);
    AddColour("Black with grey highights", 22);
    AddColour("Black"               , 23);
    AddColour("Light violet"        , 24);
    AddColour("Dark violet"         , 25);
    AddColour("Light purple"        , 26);
    AddColour("Dark purple"         , 27);
    AddColour("Light blue"          , 28);
    AddColour("Dark blue"           , 29);
    AddColour("Light blue-grey"     , 30);
    AddColour("Dark blue-grey"      , 31);
    AddColour("Light blue-green"    , 32);
    AddColour("Dark blue-green"     , 33);
    AddColour("Light blue-grey-green", 34);
    AddColour("Dark blue-grey-green", 35);
    AddColour("Light green"         , 36);
    AddColour("Dark green"          , 37);
    AddColour("Light green-grey"    , 38);
    AddColour("Dark green-grey"     , 39);
    AddColour("Light snot green"    , 40);
    AddColour("Dark snot green"     , 41);
    AddColour("Light green-yellow"  , 42);
    AddColour("Dark green-yellow"   , 43);
    AddColour("Light yellow"        , 44);
    AddColour("Dark yellow"         , 45);
    AddColour("Light yellow-grey"   , 46);
    AddColour("Dark yellow-grey"    , 47);
    AddColour("Light orange"        , 48);
    AddColour("Dark orange"         , 49);
    AddColour("Light orange-grey"   , 50);
    AddColour("Dark orange-grey"    , 51);
    AddColour("Light pink"          , 52);
    AddColour("Dark pink"           , 53);
    AddColour("Light pink-grey"     , 54);
    AddColour("Dark pink-grey"      , 55);
    if(GetPRCSwitch(PRC_CONVOCC_ALLOW_HIDDEN_HAIR_COLOURS))
    {
        AddColour("Silver"              , 56);
        AddColour("Obsidian"            , 57);
        AddColour("Gold"                , 58);
        AddColour("Bronze"              , 59);
        AddColour("Odd grey"            , 60);
        AddColour("Odd metalic"         , 61);
        AddColour("Matt while"          , 62);
        AddColour("Matt black"          , 63);
    }
}

void SetupTattooColours()
{
    AddColour("Lightest tan/brown", 1);
    AddColour("Light tan/brown", 2);
    AddColour("Dark tan/brown", 3);
    AddColour("Darkest tan/brown", 4);
    AddColour("Lightest tan/red", 5);
    AddColour("Light tan/red", 6);
    AddColour("Dark tan/red", 7);
    AddColour("Darkest tan/red", 8);
    AddColour("Lightest tan/yellow", 9);
    AddColour("Light tan/yellow", 10);
    AddColour("Dark tan/yellow", 11);
    AddColour("Darkest tan/yellow", 12);
    AddColour("Lightest tan/grey", 13);
    AddColour("Light tan/grey", 14);
    AddColour("Dark tan/grey", 15);
    AddColour("Darkest tan/grey", 16);
    AddColour("Lightest olive", 17);
    AddColour("Light olive", 18);
    AddColour("Dark olive", 19);
    AddColour("Darkest olive", 20);
    AddColour("White", 21);
    AddColour("Light grey", 22);
    AddColour("Dark grey", 23);
    AddColour("Black", 24);
    AddColour("Light blue", 25);
    AddColour("Dark blue", 26);
    AddColour("Light aqua", 27);
    AddColour("Dark aqua", 28);
    AddColour("Light teal", 29);
    AddColour("Dark teal", 30);
    AddColour("Light green", 31);
    AddColour("Dark green", 32);
    AddColour("Light yellow", 33);
    AddColour("Dark yellow", 34);
    AddColour("Light orange", 35);
    AddColour("Dark orange", 36);
    AddColour("Light red", 37);
    AddColour("Dark red", 38);
    AddColour("Light pink", 39);
    AddColour("Dark pink", 40);
    AddColour("Light purple", 41);
    AddColour("Dark purple", 42);
    AddColour("Light violet", 43);
    AddColour("Dark violet", 44);
    AddColour("Shiny white", 45);
    AddColour("Shiny black", 46);
    AddColour("Shiny blue", 47);
    AddColour("Shiny aqua", 48);
    AddColour("Shiny teal", 49);
    AddColour("Shiny green", 50);
    AddColour("Shiny yellow", 51);
    AddColour("Shiny irange", 52);
    AddColour("Shiny red", 53);
    AddColour("Shiny pink", 54);
    AddColour("Shiny purple", 55);
    AddColour("Shiny violet", 56);
    if(GetPRCSwitch(PRC_CONVOCC_ALLOW_HIDDEN_TATTOO_COLOURS))
    {
        AddColour("Silver"           , 56);
        AddColour("Obsidian"         , 57);
        AddColour("Gold"             , 58);
        AddColour("Bronze"           , 59);
        AddColour("Odd grey"         , 60);
        AddColour("Odd metalic"      , 61);
        AddColour("Matt while"       , 62);
        AddColour("Matt black"       , 63);
    }
}
void SetupTattooParts()
{
    AddColour("Done", 0);
    //AddColour("Neck", 1);
    AddColour("Torso", 2);
    //AddColour("Belt", 3);
    //AddColour("Pelvis", 4);
    //AddColour("Left shoulder", 5);
    AddColour("Left bicep", 6);
    AddColour("Left forearm", 7);
    //AddColour("Left hand", 8);
    AddColour("Left thigh", 9);
    AddColour("Left shin", 10);
    //AddColour("Left foot", 11);
    //AddColour("Right shoulder", 12);
    AddColour("Right bicep", 13);
    AddColour("Right forearm", 14);
    //AddColour("Right hand", 15);
    AddColour("Right thigh", 16);
    AddColour("Right shin", 17);
    //AddColour("Right foot", 18);
}

void AddHead(int nHead)
{
    array_set_string(OBJECT_SELF, "ChoiceTokens",
        array_get_size(OBJECT_SELF, "ChoiceTokens"),
            IntToString(nHead));
    array_set_int(OBJECT_SELF, "ChoiceValue",
        array_get_size(OBJECT_SELF, "ChoiceValue"),
            nHead);
}

void SetupHead()
{
    int nGender = GetLocalInt(OBJECT_SELF, "Gender");
    int nAppearance = GetLocalInt(OBJECT_SELF, "Appearance");
    int i;
    if(nAppearance == APPEARANCE_TYPE_HUMAN
        || nAppearance == APPEARANCE_TYPE_HALF_ELF)
    {
        if(nGender == GENDER_MALE)
        {
            for(i=1;i<=21;i++)
                AddHead(i);
            AddHead(143);
        }
        else if(nGender == GENDER_FEMALE)
        {
            for(i=1;i<=15;i++)
                AddHead(i);
            AddHead(143);
        }
    }
    else if(nAppearance == APPEARANCE_TYPE_ELF)
    {
        if(nGender == GENDER_MALE)
        {
            for(i=1;i<=10;i++)
                AddHead(i);
        }
        else if(nGender == GENDER_FEMALE)
        {
            for(i=1;i<=16;i++)
                AddHead(i);
        }
    }
    else if(nAppearance == APPEARANCE_TYPE_HALFLING)
    {
        if(nGender == GENDER_MALE)
        {
            for(i=1;i<=8;i++)
                AddHead(i);
        }
        else if(nGender == GENDER_FEMALE)
        {
            for(i=1;i<=11;i++)
                AddHead(i);
        }
    }
    else if(nAppearance == APPEARANCE_TYPE_HALF_ORC)
    {
        if(nGender == GENDER_MALE)
        {
            for(i=1;i<=11;i++)
                AddHead(i);
        }
        else if(nGender == GENDER_FEMALE)
        {
            for(i=1;i<=11;i++)
                AddHead(i);
        }
    }
    else if(nAppearance == APPEARANCE_TYPE_DWARF)
    {
        if(nGender == GENDER_MALE)
        {
            for(i=1;i<=10;i++)
                AddHead(i);
        }
        else if(nGender == GENDER_FEMALE)
        {
            for(i=1;i<=12;i++)
                AddHead(i);
        }
    }
    else if(nAppearance == APPEARANCE_TYPE_GNOME)
    {
        if(nGender == GENDER_MALE)
        {
            for(i=1;i<=11;i++)
                AddHead(i);
        }
        else if(nGender == GENDER_FEMALE)
        {
            for(i=1;i<=9;i++)
                AddHead(i);
        }
    }
    else
    {
        array_set_string(OBJECT_SELF, "ChoiceTokens",
            array_get_size(OBJECT_SELF, "ChoiceTokens"),
                "You cannot change your head");
        array_set_int(OBJECT_SELF, "ChoiceValue",
            array_get_size(OBJECT_SELF, "ChoiceValue"),
                -1);

    }
}
