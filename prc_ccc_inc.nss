#include "prc_feat_const"
#include "inc_utility"
#include "inc_dynconv"



//define constants
//stage of development
const int STAGE_INTRODUCTION        =  0;
const int STAGE_GENDER              =  1;
const int STAGE_GENDER_CHECK        =  2;
const int STAGE_RACE                =  3;
const int STAGE_RACE_CHECK          =  4;
const int STAGE_CLASS               =  5;
const int STAGE_CLASS_CHECK         =  6;
const int STAGE_ALIGNMENT           =  7;
const int STAGE_ALIGNMENT_CHECK     =  8;
const int STAGE_ABILITY             =  9;
const int STAGE_ABILITY_CHECK       = 10;
const int STAGE_SKILL               = 11;
const int STAGE_SKILL_CHECK         = 12;
const int STAGE_FEAT                = 13;
const int STAGE_FEAT_CHECK          = 14;
const int STAGE_BONUS_FEAT          = 15;
const int STAGE_BONUS_FEAT_CHECK    = 16;
const int STAGE_WIZ_SCHOOL          = 17;
const int STAGE_WIZ_SCHOOL_CHECK    = 18;
const int STAGE_SPELLS              = 19;
const int STAGE_SPELLS_CHECK        = 20;
const int STAGE_FAMILIAR            = 21;
const int STAGE_FAMILIAR_CHECK      = 22;
const int STAGE_ANIMALCOMP          = 23;
const int STAGE_ANIMALCOMP_CHECK    = 24;
const int STAGE_DOMAIN1             = 25;
const int STAGE_DOMAIN2             = 26;
const int STAGE_DOMAIN_CHECK        = 27;
const int STAGE_APPEARANCE          = 28;
const int STAGE_APPEARANCE_CHECK    = 29;
const int STAGE_SKIN                = 30;
const int STAGE_SKIN_CHECK          = 31;
const int STAGE_HAIR                = 32;
const int STAGE_HAIR_CHECK          = 33;
const int STAGE_WINGS               = 34;
const int STAGE_WINGS_CHECK         = 35;
const int STAGE_TAIL                = 36;
const int STAGE_TAIL_CHECK          = 37;
const int STAGE_SOUNDSET            = 38;
const int STAGE_SOUNDSET_CHECK      = 39;
const int STAGE_PORTRAIT            = 40;
const int STAGE_PORTRAIT_CHECK      = 41;
const int STAGE_HEAD                = 42;
const int STAGE_HEAD_CHECK          = 43;
const int STAGE_TATTOOCOLOUR1       = 44;
const int STAGE_TATTOOCOLOUR1_CHECK = 45;
const int STAGE_TATTOOCOLOUR2       = 46;
const int STAGE_TATTOOCOLOUR2_CHECK = 47;
const int STAGE_TATTOOPART          = 48;
const int STAGE_TATTOOPART_CHECK    = 49;
const int STAGE_RACIAL_ABILITY      = 50;
const int STAGE_RACIAL_ABILITY_CHECK= 51;
const int STAGE_RACIAL_SKILL        = 52;
const int STAGE_RACIAL_SKILL_CHECK  = 53;
const int STAGE_RACIAL_FEAT         = 54;
const int STAGE_RACIAL_FEAT_CHECK   = 55;
const int FINAL_STAGE               = 56;

//void SetToken(int nTokenID, string sString);
int GetCost(int nAbilityScore);

#include "prc_ccc_inc_a"
#include "prc_ccc_inc_b"
#include "prc_ccc_inc_c"
#include "prc_ccc_inc_d"
#include "prc_ccc_inc_e"
#include "prc_ccc_inc_f"

//this returns the cost to get to a score
//or the cost saved by dropping from that score
int GetCost(int nAbilityScore)
{
    int nCost = (nAbilityScore-11)/2;
    if(nCost < 1)
        nCost = 1;
    return nCost;
}



void SetupHeader();

void SetupHeader()
{
    int nStage  = GetStage(OBJECT_SELF);
    int nClass  = GetLocalInt(OBJECT_SELF, "Class");
    int nRace   = GetLocalInt(OBJECT_SELF, "Race");
    int nLevel  = GetLocalInt(OBJECT_SELF, "Level");
    string sText;
    int i;


    //header
    switch(nStage)
    {
        case STAGE_INTRODUCTION:
            sText = "This is the Conversation Character Creator (CCC) by Primogenitor.\n";
            sText+= "This is a replicate of the bioware character creator, but it will allow you to select custom content at level 1.\n";
            sText+= "Simply follow the step by step instructions and select what you want. ";
            sText+= "If you dont get all the options you think you should at a stage, select one, then select No at the confirmation step";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_GENDER:
            sText = GetStringByStrRef(158);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, GetStringByStrRef(158));
            break;
        case STAGE_GENDER_CHECK:
            sText = "You have selected:\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("gender", "NAME", GetLocalInt(OBJECT_SELF, "Gender"))));
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_RACE:
            sText = GetStringByStrRef(162);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, GetStringByStrRef(162));
            break;
        case STAGE_RACE_CHECK:
            sText = GetStringByStrRef(16824209)+"\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", GetLocalInt(OBJECT_SELF, "Race"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Description", GetLocalInt(OBJECT_SELF, "Race"))));
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_CLASS:
            sText = "Select Class";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select Class");
            break;
        case STAGE_CLASS_CHECK:
            sText = GetStringByStrRef(16824209)+"\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", GetLocalInt(OBJECT_SELF, "Class"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("classes", "Description", GetLocalInt(OBJECT_SELF, "Class"))));
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_ALIGNMENT:
            sText = GetStringByStrRef(111);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, GetStringByStrRef(111));
            break;
        case STAGE_ALIGNMENT_CHECK:
            sText = GetStringByStrRef(16824209)+"\n";
            if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==85
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==85)
                    sText+= GetStringByStrRef(112);
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==50
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==85)
                    sText+= GetStringByStrRef(115);
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==15
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==85)
                    sText+= GetStringByStrRef(118);
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==85
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==50)
                    sText+= GetStringByStrRef(113);
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==50
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==50)
                    sText+= GetStringByStrRef(116);
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==15
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==50)
                    sText+= GetStringByStrRef(119);
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==85
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==15)
                    sText+= GetStringByStrRef(114);
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==50
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==15)
                    sText+= GetStringByStrRef(117);
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==15
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==15)
                    sText+= GetStringByStrRef(120);
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_ABILITY:
            sText = "Select Ability " + IntToString(GetLocalInt(OBJECT_SELF, "Points"))+" points remaining";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select Ability " + IntToString(GetLocalInt(OBJECT_SELF, "Points"))+" points remaining");
            break;
        case STAGE_ABILITY_CHECK:
            sText = GetStringByStrRef(16824209)+"\n";
            sText+= IntToString(GetLocalInt(OBJECT_SELF, "Str"))+" ("+Get2DACache("racialtypes", "StrAdjust", nRace)+") Strength\n";
            sText+= IntToString(GetLocalInt(OBJECT_SELF, "Dex"))+" ("+Get2DACache("racialtypes", "DexAdjust", nRace)+") Dexterity\n";
            sText+= IntToString(GetLocalInt(OBJECT_SELF, "Con"))+" ("+Get2DACache("racialtypes", "ConAdjust", nRace)+") Constitution\n";
            sText+= IntToString(GetLocalInt(OBJECT_SELF, "Int"))+" ("+Get2DACache("racialtypes", "IntAdjust", nRace)+") Intelligence\n";
            sText+= IntToString(GetLocalInt(OBJECT_SELF, "Wis"))+" ("+Get2DACache("racialtypes", "WisAdjust", nRace)+") Wisdom\n";
            sText+= IntToString(GetLocalInt(OBJECT_SELF, "Cha"))+" ("+Get2DACache("racialtypes", "ChaAdjust", nRace)+") Charisma\n";
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_SKILL:
            sText = "Select Skills " + IntToString(GetLocalInt(OBJECT_SELF, "Points"))+" points remaining";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select Skills " + IntToString(GetLocalInt(OBJECT_SELF, "Points"))+" points remaining");
            break;
        case STAGE_SKILL_CHECK:
            sText = GetStringByStrRef(16824209)+"\n";
            if(GetPRCSwitch(PRC_CONVOCC_ALLOW_SKILL_POINT_ROLLOVER))
            {
                    sText+= "Stored skill points:";
                    sText+= " "+IntToString(array_get_int(OBJECT_SELF, "Skills",-1))+"\n";
            }
            for(i=0;i<GetPRCSwitch(FILE_END_SKILLS);i++)
            {
                if(Get2DACache("skills", "Name", i) != "" && array_get_int(OBJECT_SELF, "Skills",i) != 0)
                {
                    sText+= GetStringByStrRef(StringToInt(Get2DACache("skills", "Name", i)));
                    sText+= " "+IntToString(array_get_int(OBJECT_SELF, "Skills",i))+"\n";
                }
            }
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_FEAT:
            sText = GetStringByStrRef(397);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, GetStringByStrRef(397));
            break;
        case STAGE_FEAT_CHECK:
            sText = GetStringByStrRef(16824209)+"\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", GetLocalInt(OBJECT_SELF, "StartingFeat"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("feat", "Description", GetLocalInt(OBJECT_SELF, "StartingFeat"))));
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_BONUS_FEAT:
            sText = GetStringByStrRef(397);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, GetStringByStrRef(397));
            break;
        case STAGE_BONUS_FEAT_CHECK:
            sText = GetStringByStrRef(16824209)+"\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", GetLocalInt(OBJECT_SELF, "BonusFeat"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("feat", "Description", GetLocalInt(OBJECT_SELF, "BonusFeat"))));
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_WIZ_SCHOOL:
            sText = GetStringByStrRef(381);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, GetStringByStrRef(381));
            break;
        case STAGE_WIZ_SCHOOL_CHECK:
            sText = GetStringByStrRef(16824209)+"\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", GetLocalInt(OBJECT_SELF, "School"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("spellschools", "Description", GetLocalInt(OBJECT_SELF, "School"))));
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_FAMILIAR:
            sText = GetStringByStrRef(5607);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, GetStringByStrRef(5607));
            break;
        case STAGE_FAMILIAR_CHECK:
            sText = GetStringByStrRef(16824209)+"\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("hen_familiar", "STRREF", GetLocalInt(OBJECT_SELF, "Familiar"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("hen_familiar", "DESCRIPTION", GetLocalInt(OBJECT_SELF, "Familiar"))));
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_ANIMALCOMP:
            sText = "Select Animal Companion";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select Animal Companion");
            break;
        case STAGE_ANIMALCOMP_CHECK:
            sText = GetStringByStrRef(16824209)+"\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("hen_companion", "STRREF", GetLocalInt(OBJECT_SELF, "AnimalCompanion"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("hen_companion", "DESCRIPTION", GetLocalInt(OBJECT_SELF, "AnimalCompanion"))));
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_DOMAIN1:
            sText = "Select first Domain";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select first Domain");
            break;
        case STAGE_DOMAIN2:
            sText = "Select second Domain";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select second Domain");
            break;
        case STAGE_DOMAIN_CHECK:
            sText = GetStringByStrRef(16824209)+"\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("domains", "Name", GetLocalInt(OBJECT_SELF, "Domain1"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("domains", "Description", GetLocalInt(OBJECT_SELF, "Domain1"))));
            sText+= "\nAnd: ";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("domains", "Name", GetLocalInt(OBJECT_SELF, "Domain2"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("domains", "Description", GetLocalInt(OBJECT_SELF, "Domain2"))));
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_SPELLS:
            switch(nClass)
            {
                case CLASS_TYPE_WIZARD:
                case CLASS_TYPE_SORCERER:
                case CLASS_TYPE_BARD:
                    sText = "Select spells ("+IntToString(GetLocalInt(OBJECT_SELF, "NumberOfSpells"))+" remaining)";
                    SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select spells ("+IntToString(GetLocalInt(OBJECT_SELF, "NumberOfSpells"))+" remaining)");
                    break;
                default:
                    sText = "You are unable to select spells";
                    SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "You are unable to select spells");
                    break;
            }
            break;
        case STAGE_SPELLS_CHECK:
            sText = GetStringByStrRef(16824209)+" ";
            for(i=0;i<array_get_size(OBJECT_SELF, "SpellLvl0");i++)
                sText+= "\n"+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", array_get_int(OBJECT_SELF, "SpellLvl0", i))));
            for(i=0;i<array_get_size(OBJECT_SELF, "SpellLvl1");i++)
                sText+= "\n"+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", array_get_int(OBJECT_SELF, "SpellLvl1", i))));
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_APPEARANCE:
            sText = "Select an appearance";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select an appearance.");
            break;
        case STAGE_APPEARANCE_CHECK:
            sText = "Is this appearance correct?";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Is this appearance correct?");
            break;
        case STAGE_HAIR:
            sText = "Select hair colour.";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select hair colour.");
            break;
        case STAGE_HAIR_CHECK:
            sText = "Is this hair colour correct?";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Is this hair colour correct?");
            break;
        case STAGE_HEAD:
            sText = "Select head number.";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select head number.");
            break;
        case STAGE_HEAD_CHECK:
            sText = "Is this head correct?";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Is this head correct?");
            break;
        case STAGE_PORTRAIT:
            sText = "Select a portrait.";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select a portrait.");
            break;
        case STAGE_PORTRAIT_CHECK:
            sText = "Is this portrait correct?";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Is this portrait correct?");
            break;
        case STAGE_SKIN:
            sText = "Select skintone.";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select skintone.");
            break;
        case STAGE_SKIN_CHECK:
            sText = "Is this skintone correct?";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Is this skintone correct?");
            break;
        case STAGE_SOUNDSET:
            sText = "Select a soundset.";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select a soundset.");
            break;
        case STAGE_SOUNDSET_CHECK:
            sText = "Is this soundset correct?";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Is this soundset correct?");
            break;
        case STAGE_TAIL:
            sText = "Select tail.";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select tail.");
            break;
        case STAGE_TAIL_CHECK:
            sText = "Is this tail correct?";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Is this tail correct?");
            break;
        case STAGE_WINGS:
            sText = "Select wings.";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select wings.");
            break;
        case STAGE_WINGS_CHECK:
            sText = "Is this set of wings correct?";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Is this set of wings correct?");
            break;
        case STAGE_TATTOOPART:
            sText = "Select a bodypart to alter the tattoo of.";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select a bodypart to alter the tattoo of.");
            break;
        case STAGE_TATTOOPART_CHECK:
            sText = "Is this tattoo placement correct?";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Is this tattoo placement correct?");
            break;
        case STAGE_TATTOOCOLOUR1:
            sText = "Select a colour for the first part of your tattoos";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select a colour for the first part of your tattoos");
            break;
        case STAGE_TATTOOCOLOUR1_CHECK:
            sText = "Is this tattoo colour correct?";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Is this tattoo colour correct?");
            break;
        case STAGE_TATTOOCOLOUR2:
            sText = "Select a colour for the second part of your tattoos";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select a colour for the second part of your tattoos");
            break;
        case STAGE_TATTOOCOLOUR2_CHECK:
            sText = "Is this tattoo colour correct?";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Is this tattoo colour correct?");
            break;
        case FINAL_STAGE:
            sText = "Your character will now be generated. As part of this process, you will be booted. Please exit NWN completely before rejoining.";
//            SetToken(DYNCONV_TOKEN_HEADER, "Your character is ready to be generated. You will now be passed to the appearance selection system.");
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Your character will now be generated. As part of this process, you will be booted. Please exit NWN completely before rejoining.");
            break;
        case STAGE_RACIAL_ABILITY:
            sText = "Select an ability to increase.";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select an ability to increase.");
            break;
        case STAGE_RACIAL_ABILITY_CHECK:
            sText = GetStringByStrRef(16824209)+"\n";
            switch(GetLocalInt(OBJECT_SELF, "RaceLevel"+IntToString(nLevel)+"Ability"))
            {
                case ABILITY_STRENGTH:
                    sText += "Strength";
                    break;
                case ABILITY_DEXTERITY:
                    sText += "Dexterity";
                    break;
                case ABILITY_CONSTITUTION:
                    sText += "Constitution";
                    break;
                case ABILITY_INTELLIGENCE:
                    sText += "Intelligence";
                    break;
                case ABILITY_WISDOM:
                    sText += "Wisdom";
                    break;
                case ABILITY_CHARISMA:
                    sText += "Charisma";
                    break;
            }
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_RACIAL_SKILL:
            sText = "Select Skills " + IntToString(GetLocalInt(OBJECT_SELF, "Points"))+" points remaining";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select Skills " + IntToString(GetLocalInt(OBJECT_SELF, "Points"))+" points remaining");
            break;
        case STAGE_RACIAL_SKILL_CHECK:
            sText = GetStringByStrRef(16824209)+"\n";
            if(GetPRCSwitch(PRC_CONVOCC_ALLOW_SKILL_POINT_ROLLOVER))
            {
                    sText+= "Stored skill points:";
                    sText+= " "+IntToString(array_get_int(OBJECT_SELF, "RaceLevel"+IntToString(nLevel)+"Skills",-1))+"\n";
            }
            for(i=0;i<GetPRCSwitch(FILE_END_SKILLS);i++)
            {
                if(Get2DACache("skills", "Name", i) != "" && array_get_int(OBJECT_SELF, "RaceLevel"+IntToString(nLevel)+"Skills",i) != 0)
                {
                    sText+= GetStringByStrRef(StringToInt(Get2DACache("skills", "Name", i)));
                    sText+= " "+IntToString(array_get_int(OBJECT_SELF, "RaceLevel"+IntToString(nLevel)+"Skills",i))+"\n";
                }
            }
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        case STAGE_RACIAL_FEAT:
            sText = "Select Feat";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Select Feat");
            break;
        case STAGE_RACIAL_FEAT_CHECK:
            sText = GetStringByStrRef(16824209)+"\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", GetLocalInt(OBJECT_SELF, "RaceLevel"+IntToString(nLevel)+"Feat"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("feat", "Description", GetLocalInt(OBJECT_SELF, "RaceLevel"+IntToString(nLevel)+"Feat"))));
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, sText);
            break;
        default:
            sText = "Error";
            SetHeader(sText);
            //SetToken(DYNCONV_TOKEN_HEADER, "Error");
            break;
    }

    SetDefaultTokens();
    // While not in the last stage, the exit token should read "Abort"
    if(nStage != FINAL_STAGE)
        SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(16824213)); //abort

    ClearAllActions();
    ActionPauseConversation();
    //DelayCommand(1.0, ClearAllActions());
    DelayCommand(0.1, ActionResumeConversation());
}

void DoCleanup()
{
    object oPC = OBJECT_SELF;
    //clean up in all aisles :-)
    DeleteLocalInt(oPC, "Str");
    DeleteLocalInt(oPC, "Dex");
    DeleteLocalInt(oPC, "Con");
    DeleteLocalInt(oPC, "Int");
    DeleteLocalInt(oPC, "Wis");
    DeleteLocalInt(oPC, "Cha");
    DeleteLocalInt(oPC, "Race");
    DeleteLocalInt(oPC, "Class");
    DeleteLocalInt(oPC, "QTMFeat");
    DeleteLocalInt(oPC, "StartingFeat");
    DeleteLocalInt(oPC, "BonusFeat");
    DeleteLocalInt(oPC, "HitPoints");
    DeleteLocalInt(oPC, "Gender");
    DeleteLocalInt(oPC, "LawfulChaotic");
    DeleteLocalInt(oPC, "GoodEvil");
    DeleteLocalInt(oPC, "Portrait");
    DeleteLocalString(oPC, "PortraitResRef");
    DeleteLocalInt(oPC, "Appearance");
    DeleteLocalInt(oPC, "Voiceset");
    DeleteLocalInt(oPC, "Skin");
    DeleteLocalInt(oPC, "Hair");
    DeleteLocalInt(oPC, "Wings");
    DeleteLocalInt(oPC, "Tail");
    DeleteLocalInt(oPC, "Head");
    DeleteLocalInt(oPC, "SoundSet");
    DeleteLocalInt(oPC, "Familiar");
    DeleteLocalInt(oPC, "AnimalCompanion");
    DeleteLocalInt(oPC, "Domain1");
    DeleteLocalInt(oPC, "Domain2");
    DeleteLocalInt(oPC, "Points");
    DeleteLocalInt(oPC, "Stage");
    DeleteLocalInt(oPC, "School");
    DeleteLocalInt(oPC, "CurrentSpellLevel");
    DeleteLocalInt(oPC, "i");
    DeleteLocalInt(oPC, "Level");
    DeleteLocalString(oPC, "TOKEN50");
    array_delete(oPC, "Feats");
    array_delete(oPC, "SpecAbilID");
    array_delete(oPC, "SpecAbilFlag");
    array_delete(oPC, "SpecAbilLvl");
    array_delete(oPC, "Skills");
    array_delete(oPC, "SpellLvl1");
    array_delete(oPC, "SpellLvl0");
}

/*
Gender
Race
Class
Alignment
Ability
Skills
Feats
Domains
Familiars
Specialist School
Bonus Feat

[done at random]
Portrait
Name
Head
Voiceset
Skincolor(s)


Spells
    Cleric
    Druid
    Ranger
    Paladin
            ClassList/[_]/MemorizedListX/Spell
            ClassList/[_]/MemorizedListX/Ready
            ClassList/[_]/MemorizedListX/SpellMetaMagic
    Sorcerer
    Bard
            ClassList/[_]/MemorizedListX/Spell
            ClassList/[_]/SpellsPerDayList/[_]/NumSpellsLeft
            LvlStatList/[_]/KnownListX/[_]/Spell
            LvlStatList/[_]/KnownRemoveListX/[_]/Spell
    Wizard
            ClassList/[_]/MemorizedListX/Spell
            ClassList/[_]/MemorizedListX/Ready
            ClassList/[_]/MemorizedListX/SpellMetaMagic
            ClassList/[_]/KnownListX/Spell
            LvlStatList/[_]/KnownListX/[_]/Spell

*/
