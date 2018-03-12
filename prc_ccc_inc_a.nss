

//make the array of tokens for that stage
void SetupStage();

#include "inc_utility"
#include "prc_ccc_inc_b"
#include "prc_ccc_inc_e"
#include "prc_ccc_inc_f"

void SetupStage()
{
    //setup variables
    int nStage  = GetStage(OBJECT_SELF);
    int nRace = GetLocalInt(OBJECT_SELF, "Race");
    int nClass = GetLocalInt(OBJECT_SELF, "Class");
    int nGender = GetLocalInt(OBJECT_SELF, "Gender");
    int nStr = GetLocalInt(OBJECT_SELF, "Str");
    int nDex = GetLocalInt(OBJECT_SELF, "Dex");
    int nCon = GetLocalInt(OBJECT_SELF, "Con");
    int nInt = GetLocalInt(OBJECT_SELF, "Int");
    int nWis = GetLocalInt(OBJECT_SELF, "Wis");
    int nCha = GetLocalInt(OBJECT_SELF, "Cha");
    int nPoints = GetLocalInt(OBJECT_SELF, "Points");
    int nMaxStat;

    //switch to different stages
    int i;
    string sName;
    string sFile;
    switch(nStage)
    {
        case STAGE_INTRODUCTION:
            AddChoice("continue", 0);
            MarkStageSetUp(nStage);
            break;
        case STAGE_GENDER:
            sName = Get2DACache("gender", "NAME", i);
            while(i < GetPRCSwitch(FILE_END_GENDER))
            {
                AddChoice(GetStringByStrRef(StringToInt(sName)), i);
                i++;
                sName = Get2DACache("gender", "NAME", i);
            }
            MarkStageSetUp(nStage);
            break;

        case STAGE_RACE:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DelayCommand(0.01, RaceLoop());
            MarkStageSetUp(nStage);
            break;

        case STAGE_CLASS:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DelayCommand(0.01, ClassLoop());
            MarkStageSetUp(nStage);
            break;

        case STAGE_ALIGNMENT:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            i=0;
            if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_GOOD,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                AddChoice(GetStringByStrRef(112), 0);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                AddChoice(GetStringByStrRef(115), 1);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                AddChoice(GetStringByStrRef(118), 2);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                AddChoice(GetStringByStrRef(113), 3);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                AddChoice(GetStringByStrRef(116), 4);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                AddChoice(GetStringByStrRef(119), 5);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_EVIL,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                AddChoice(GetStringByStrRef(114), 6);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                AddChoice(GetStringByStrRef(117), 7);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                AddChoice(GetStringByStrRef(120), 8);
                i++;
            }
            DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
            MarkStageSetUp(nStage);
            break;

        case STAGE_ABILITY:
            //this one is done manually
            //first setup
            if(GetLocalInt(OBJECT_SELF, "Str") == 0)
            {
                nPoints = GetPRCSwitch(PRC_CONVOCC_STAT_POINTS);
                if(nPoints == 0)
                    nPoints = 30;
                SetLocalInt(OBJECT_SELF, "Points", nPoints);
                //add race bonuses
                SetLocalInt(OBJECT_SELF, "Str", 8);
                SetLocalInt(OBJECT_SELF, "Dex", 8);
                SetLocalInt(OBJECT_SELF, "Con", 8);
                SetLocalInt(OBJECT_SELF, "Int", 8);
                SetLocalInt(OBJECT_SELF, "Wis", 8);
                SetLocalInt(OBJECT_SELF, "Cha", 8);
                nStr = GetLocalInt(OBJECT_SELF, "Str");
                nDex = GetLocalInt(OBJECT_SELF, "Dex");
                nCon = GetLocalInt(OBJECT_SELF, "Con");
                nInt = GetLocalInt(OBJECT_SELF, "Int");
                nWis = GetLocalInt(OBJECT_SELF, "Wis");
                nCha = GetLocalInt(OBJECT_SELF, "Cha");
            }
            nMaxStat = GetPRCSwitch(PRC_CONVOCC_MAX_STAT);
            if(nMaxStat == 0)
                nMaxStat = 18;
            if(nStr < nMaxStat  && nPoints >= GetCost(nStr+1))
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i,
                    IntToString(nStr)+" "+GetStringByStrRef(135)+". "+GetStringByStrRef(137)+" "
                        +IntToString(GetCost(nStr+1))+"."
                        +" (Racial "+Get2DACache("racialtypes", "StrAdjust", nRace)+")");
                array_set_int(OBJECT_SELF, "ChoiceValue", i, ABILITY_STRENGTH);
                i++;
            }
            if(nDex < nMaxStat && nPoints >= GetCost(nDex+1))
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i,
                    IntToString(nDex)+" "+GetStringByStrRef(133)+". "+GetStringByStrRef(137)+" "
                        +IntToString(GetCost(nDex+1))+"."
                        +" (Racial "+Get2DACache("racialtypes", "DexAdjust", nRace)+")");
                array_set_int(OBJECT_SELF, "ChoiceValue", i, ABILITY_DEXTERITY);
                i++;
            }
            if(nCon < nMaxStat && nPoints >= GetCost(nCon+1))
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i,
                    IntToString(nCon)+" "+GetStringByStrRef(132)+". "+GetStringByStrRef(137)+" "
                        +IntToString(GetCost(nCon+1))+"."
                        +" (Racial "+Get2DACache("racialtypes", "ConAdjust", nRace)+")");
                array_set_int(OBJECT_SELF, "ChoiceValue", i, ABILITY_CONSTITUTION);
                i++;
            }
            if(nInt < nMaxStat && nPoints >= GetCost(nInt+1))
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i,
                    IntToString(nInt)+" "+GetStringByStrRef(134)+". "+GetStringByStrRef(137)+" "
                        +IntToString(GetCost(nInt+1))+"."
                        +" (Racial "+Get2DACache("racialtypes", "IntAdjust", nRace)+")");
                array_set_int(OBJECT_SELF, "ChoiceValue", i, ABILITY_INTELLIGENCE);
                i++;
            }
            if(nWis < nMaxStat && nPoints >= GetCost(nWis+1))
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i,
                    IntToString(nWis)+" "+GetStringByStrRef(136)+". "+GetStringByStrRef(137)+" "
                        +IntToString(GetCost(nWis+1))+"."
                        +" (Racial "+Get2DACache("racialtypes", "WisAdjust", nRace)+")");
                array_set_int(OBJECT_SELF, "ChoiceValue", i, ABILITY_WISDOM);
                i++;
            }
            if(nCha < nMaxStat && nPoints >= GetCost(nCha+1))
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i,
                    IntToString(nCha)+" "+GetStringByStrRef(131)+". "+GetStringByStrRef(137)+" "
                        +IntToString(GetCost(nCha+1))+"."
                        +" (Racial "+Get2DACache("racialtypes", "ChaAdjust", nRace)+")");
                array_set_int(OBJECT_SELF, "ChoiceValue", i, ABILITY_CHARISMA);
                i++;
            }
            //Dont mark it as setup, needs to be recreated
            //MarkStageSetUp(nStage);
            break;

        case STAGE_SKILL:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DelayCommand(0.01, SkillLoop());
            MarkStageSetUp(nStage);
            break;

    // this has a wait while lookup
        case STAGE_FEAT:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DelayCommand(0.01, FeatLoop());
            MarkStageSetUp(nStage);
            break;

        case STAGE_FAMILIAR:
            if(nClass != CLASS_TYPE_WIZARD
                && nClass != CLASS_TYPE_SORCERER)
            {
                AddChoice("You cannot select a familiar.", -1);
                MarkStageSetUp(nStage);
                break;
            }
            sName = Get2DACache("hen_familiar", "STRREF", i);
            while(i < GetPRCSwitch(FILE_END_FAMILIAR))
            {
                if(sName != "")
                {
                    AddChoice(GetStringByStrRef(StringToInt(sName)), i);
                }
                i++;
                sName = Get2DACache("hen_familiar", "STRREF", i);
            }
            MarkStageSetUp(nStage);
            break;

        case STAGE_ANIMALCOMP:
            if(nClass != CLASS_TYPE_DRUID)
            {
                AddChoice("You cannot select an animal companion.", -1);
                MarkStageSetUp(nStage);
                break;
            }
            sName = Get2DACache("hen_companion", "STRREF", i);
            while(i < GetPRCSwitch(FILE_END_ANIMALCOMP))
            {
                if(sName != "")
                {
                    AddChoice(GetStringByStrRef(StringToInt(sName)), i);
                }
                i++;
                sName = Get2DACache("hen_companion", "STRREF", i);
            }
            MarkStageSetUp(nStage);
            break;

        case STAGE_DOMAIN1:
            if(nClass != CLASS_TYPE_CLERIC)
            {
                AddChoice("You cannot select domains.", -1);
                MarkStageSetUp(nStage);
                break;
            }
            sName = Get2DACache("domains", "Name", i);
            while(i < GetPRCSwitch(FILE_END_DOMAINS))
            {
                if(sName != "")
                {
                    if((nRace == RACIAL_TYPE_AIR_GEN
                            && i != 0
                            && GetPRCSwitch(PRC_CONVOCC_GENASI_ENFORCE_DOMAINS))
                        || (nRace == RACIAL_TYPE_EARTH_GEN
                            && i != 5
                            && GetPRCSwitch(PRC_CONVOCC_GENASI_ENFORCE_DOMAINS))
                        || (nRace == RACIAL_TYPE_FIRE_GEN
                            && i != 7
                            && GetPRCSwitch(PRC_CONVOCC_GENASI_ENFORCE_DOMAINS))
                        || (nRace == RACIAL_TYPE_WATER_GEN
                            && i != 21
                            && GetPRCSwitch(PRC_CONVOCC_GENASI_ENFORCE_DOMAINS))
                        )
                    {
                    }
                    else
                    {
                        AddChoice(GetStringByStrRef(StringToInt(sName)), i);
                    }
                }
                i++;
                sName = Get2DACache("domains", "Name", i);
            }
            MarkStageSetUp(nStage);
            break;

        case STAGE_DOMAIN2:
            if(nClass != CLASS_TYPE_CLERIC)
            {
                AddChoice("You cannot select domains.", -1);
                MarkStageSetUp(nStage);
                break;
            }
            sName = Get2DACache("domains", "Name", i);
            while(i < GetPRCSwitch(FILE_END_DOMAINS))
            {
                if(sName != "" &&
                    GetLocalInt(OBJECT_SELF, "Domain1") != i)
                {
                    AddChoice(GetStringByStrRef(StringToInt(sName)), i);
                }
                i++;
                sName = Get2DACache("domains", "Name", i);
            }
            MarkStageSetUp(nStage);
            break;

        case STAGE_SPELLS:
            switch(nClass)
            {
                case CLASS_TYPE_WIZARD:
                    //check for first spell
                    if(GetLocalInt(OBJECT_SELF, "NumberOfSpells") <=0)
                    {
                        //wizards get to pick 6 spells at level 1
                        //and 2 at each level thereafter
                        SetLocalInt(OBJECT_SELF, "NumberOfSpells",6);
                        //wizards also get all cantrips known for free
                            //this is done in the loop however
                        //now start the loop to fill in the choices
                        SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
                        DelayCommand(0.01, SpellLoop());
                        MarkStageSetUp(nStage);
                    }
                    break;
                case CLASS_TYPE_SORCERER:
                    //check for first spell
                    if(GetLocalInt(OBJECT_SELF, "NumberOfSpells") <=0)
                    {
                        //sorcerers get 4 level 0 spells and 2 level 1 spells
                        SetLocalInt(OBJECT_SELF, "NumberOfSpells", StringToInt(
                            Get2DACache("cls_spkn_sorc", "SpellLevel"+IntToString(
                                GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")),0 )));
                        //spells per day for this level
                        SetLocalInt(OBJECT_SELF, "SpellsPerDay"+IntToString(GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")),
                            StringToInt(Get2DACache("cls_spgn_sorc", "SpellLevel"+IntToString(GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")),0)));
                        //now start the loop to fill in the choices
                        SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
                        DelayCommand(0.01, SpellLoop());
                        MarkStageSetUp(nStage);
                    }
                    break;
                case CLASS_TYPE_BARD:
                    if(GetLocalInt(OBJECT_SELF, "NumberOfSpells") <=0)
                    {
                        //sorcerers get 4 level 0 spells and 2 level 1 spells
                        SetLocalInt(OBJECT_SELF, "NumberOfSpells", StringToInt(
                            Get2DACache("cls_spkn_bard", "SpellLevel"+IntToString(
                                GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")),0 )));
                        //spells per day for this level
                        SetLocalInt(OBJECT_SELF, "SpellsPerDay"+IntToString(GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")),
                            StringToInt(Get2DACache("cls_spgn_bard", "SpellLevel"+IntToString(GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")),0)));
                        //now start the loop to fill in the choices
                        SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
                        DelayCommand(0.01, SpellLoop());
                        MarkStageSetUp(nStage);
                    }
                    break;
                default:
                    //if the character is not a wizard/bard/sorcerer
                    //then go to next stage
                    AddChoice("You cannot select spells to learn.", -1);
                    MarkStageSetUp(nStage);
                break;
            }
            break;

        case STAGE_WIZ_SCHOOL:
            if(nClass !=CLASS_TYPE_WIZARD)
            {
                //if the character is not a wizard
                //then go to next stage
                AddChoice("You cannot select a spell school.", -1);
            }
            else
            {
                if(GetPRCSwitch(PRC_PNP_SPELL_SCHOOLS))
                {
                    AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", 9))), 9);
                }
                else
                {
                    for(i=0;i<9;i++)
                    {
                        if(StringToInt(Get2DACache("spellschools", "StringRef", i)) != 0)
                        {
                    AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", i))), i);
                        }
                    }
                }
            }
            MarkStageSetUp(nStage);
            break;

        case STAGE_BONUS_FEAT:
            if(StringToInt(Get2DACache(Get2DACache("Classes", "BonusFeatsTable", nClass), "Bonus", 0))<=0)
            {
                //if the character canot take any bonus feats
                //then go to next stage
                AddChoice("You cannot select a bonus feat.", -1);
            }
            else
            {
                SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
                DelayCommand(0.01, BonusFeatLoop());
            }
            MarkStageSetUp(nStage);
            break;

        case STAGE_GENDER_CHECK:
        case STAGE_RACE_CHECK:
        case STAGE_CLASS_CHECK:
        case STAGE_ALIGNMENT_CHECK:
        case STAGE_ABILITY_CHECK:
        case STAGE_SKILL_CHECK:
        case STAGE_FEAT_CHECK:
        case STAGE_FAMILIAR_CHECK:
        case STAGE_ANIMALCOMP_CHECK:
        case STAGE_DOMAIN_CHECK:
        case STAGE_SPELLS_CHECK:
        case STAGE_BONUS_FEAT_CHECK:
        case STAGE_WIZ_SCHOOL_CHECK:
        case STAGE_HAIR_CHECK:
        case STAGE_HEAD_CHECK:
        case STAGE_SKIN_CHECK:
        case STAGE_TAIL_CHECK:
        case STAGE_WINGS_CHECK:
        case STAGE_APPEARANCE_CHECK:
        case STAGE_TATTOOCOLOUR1_CHECK:
        case STAGE_TATTOOCOLOUR2_CHECK:
        case STAGE_TATTOOPART_CHECK:
        case STAGE_RACIAL_ABILITY_CHECK:
        case STAGE_RACIAL_SKILL_CHECK:
        case STAGE_RACIAL_FEAT_CHECK:
            AddChoice("No.", -1);
            AddChoice("Yes.", 1);
            MarkStageSetUp(nStage);
            break;
        case STAGE_APPEARANCE:
            if(GetPRCSwitch(PRC_CONVOCC_USE_RACIAL_APPEARANCES))
                SetupRacialAppearances();
            else
            {
                AppearanceLoop();
                SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            }
            MarkStageSetUp(nStage);
            break;
        case STAGE_HAIR:
            SetupHair();
            MarkStageSetUp(nStage);
            break;
        case STAGE_HEAD:
            SetupHead();
            MarkStageSetUp(nStage);
            break;
        case STAGE_PORTRAIT:
            if(GetPRCSwitch(PRC_CONVOCC_ALLOW_TO_KEEP_PORTRAIT))
            {
                AddChoice("Keep exisiting portrait.", -1);
            }
            if(GetPRCSwitch(PRC_CONVOCC_USE_RACIAL_PORTRAIT))
            {
                SetupRacialPortrait();
            }
            else
            {
                PortraitLoop();
                SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            }
            MarkStageSetUp(nStage);
            break;
        case STAGE_PORTRAIT_CHECK:
            AddChoice("View this portrait.", 2);
            AddChoice("No.", -1);
            AddChoice("Yes", 1);
            MarkStageSetUp(nStage);
            break;
        case STAGE_SKIN:
            SetupSkin();
            MarkStageSetUp(nStage);
            break;
        case STAGE_SOUNDSET:
            if(GetPRCSwitch(PRC_CONVOCC_ALLOW_TO_KEEP_VOICESET))
            {
                AddChoice("keep exisitng soundset.", -1);
            }
            if(GetPRCSwitch(PRC_CONVOCC_USE_RACIAL_VOICESET))
                SetupRacialSoundset();
            else
            {
                SoundsetLoop();
                SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            }
            MarkStageSetUp(nStage);
            break;
        case STAGE_SOUNDSET_CHECK:
            AddChoice("Listen to this soundset.", 2);
            AddChoice("No.", -1);
            AddChoice("Yes", 1);
            MarkStageSetUp(nStage);
            break;
        case STAGE_TAIL:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            TailLoop();
            MarkStageSetUp(nStage);
            break;
        case STAGE_WINGS:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            WingLoop();
            MarkStageSetUp(nStage);
            break;
        case STAGE_TATTOOCOLOUR1:
        case STAGE_TATTOOCOLOUR2:
            SetupTattooColours();
            MarkStageSetUp(nStage);
            break;
        case STAGE_TATTOOPART:
            SetupTattooParts();
            MarkStageSetUp(nStage);
            break;


        case STAGE_RACIAL_ABILITY:
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Strength");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    ABILITY_STRENGTH);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Dexterity");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    ABILITY_DEXTERITY);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Constitution");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    ABILITY_CONSTITUTION);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Intelligence");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    ABILITY_INTELLIGENCE);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Wisdom");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    ABILITY_WISDOM);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Charisma");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    ABILITY_CHARISMA);
            //Dont set it up, needs to be recreated
            //MarkStageSetUp(nStage);
            break;
        case STAGE_RACIAL_SKILL:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DelayCommand(0.01, SkillLoop());
            MarkStageSetUp(nStage);
            break;
        case STAGE_RACIAL_FEAT:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DeleteLocalInt(OBJECT_SELF, "i");
            DelayCommand(0.01, FeatLoop());
            MarkStageSetUp(nStage);
            break;

        case FINAL_STAGE:
            MarkStageSetUp(nStage);
            AddChoice("Make character.", 1);
            break;
        default:
            break;
    }
}
