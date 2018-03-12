#include "dmfi_voice_inc"

void main()
{

    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();

    if (GetIsDM(oShouter))
        SetLocalInt(GetModule(), "dmfi_Admin" + GetPCPublicCDKey(oShouter), 1);

    if (GetIsDMPossessed(oShouter))
        SetLocalObject(GetMaster(oShouter), "dmfi_familiar", oShouter);

    object oIntruder;
    object oTarget = GetLocalObject(oShouter, "dmfi_VoiceTarget");
    object oMaster = OBJECT_INVALID;
    if (GetIsObjectValid(oTarget))
        oMaster = oShouter;

    int iPhrase = GetLocalInt(oShouter, "hls_EditPhrase");

    object oSummon;

    if (nMatch == 20600 && GetIsObjectValid(oShouter) && GetIsDM(oShouter))
    {
    string sSaid = GetMatchedSubstring(0);

    if (GetTag(OBJECT_SELF) == "dmfi_setting" && GetLocalString(oShouter, "EffectSetting") != "")
        {
            string sPhrase = GetLocalString(oShouter, "EffectSetting");
            SetLocalFloat(oShouter, sPhrase, StringToFloat(sSaid));
            SetCampaignFloat("dmfi", sPhrase, StringToFloat(sSaid), oShouter);
            DeleteLocalString(oShouter, "EffectSetting");
            DelayCommand(0.5, ActionSpeakString("The setting " + sPhrase + " has been changed to " + FloatToString(GetLocalFloat(oShouter, sPhrase))));
            DelayCommand(1.5, DestroyObject(OBJECT_SELF));
            //maybe add a return here
        }
    }

    if (nMatch == 0 && GetIsObjectValid(oShouter) && GetIsPC(oShouter))

    {
        string sSaid = GetMatchedSubstring(0);

        if (sSaid != GetLocalString(GetModule(), "hls_voicebuffer"))
            SetLocalString(GetModule(), "hls_voicebuffer", sSaid);
        else
            {
            return;
            }
        // DM spy code right at the top - this basically will send the DM what has been spoken anywhere
        if (GetCampaignInt("dmfi", "dmfi_DMSpy"))
            {
                object oTempPC = GetFirstPC();
                while(GetIsObjectValid(oTempPC))
                {
                    if (GetIsDM(oTempPC))
                    {
                        if (GetCampaignInt("dmfi", "dmfi_DMSpy", oTempPC))
                        {
                        if (GetIsPC(GetLocalObject(oTempPC, "dmfi_familiar")))
                            SendMessageToPC(GetLocalObject(oTempPC, "dmfi_familiar"), "(" + GetName(GetArea(oShouter)) + ") " + GetName(oShouter) + ": " + sSaid);
                        else
                            SendMessageToPC(oTempPC, "(" + GetName(GetArea(oShouter)) + ") " + GetName(oShouter) + ": " + sSaid);
                        }
                    }
                oTempPC = GetNextPC();
                }
            }

        PrintString("<Conv>"+GetName(GetArea(oShouter))+ " " + GetName(oShouter) + ": " + sSaid + " </Conv>");
        //if the phrase begins with .MyName, reparse the string as a voice throw
        if (GetStringLeft(sSaid, GetStringLength("." + GetName(OBJECT_SELF))) == "." + GetName(OBJECT_SELF) &&
            (GetLocalInt(GetModule(), "dmfi_Admin" + GetPCPublicCDKey(oShouter)) ||
             GetIsDM(oShouter) || GetIsDMPossessed(oShouter)))

        {
            oTarget = OBJECT_SELF;
            sSaid = GetStringRight(sSaid, GetStringLength(sSaid) - GetStringLength("." + GetName(OBJECT_SELF)));
            if (GetStringLeft(sSaid, 1) == " ") sSaid = GetStringRight(sSaid, GetStringLength(sSaid) - 1);
            sSaid = ":" + sSaid;
            return;
        }

        if (iPhrase)
        {
            SetCustomToken(iPhrase, sSaid);
            SetCampaignString("dmfi", "hls" + IntToString(iPhrase), sSaid);
            DeleteLocalInt(oShouter, "hls_EditPhrase");
            FloatingTextStringOnCreature("Phrase " + IntToString(iPhrase) + " has been recorded", oShouter, FALSE);

            return;
        }

        if (GetStringLeft(sSaid, 1) == "[")
        {
            TranslateToLanguage(sSaid, oShouter);
            return;
        }

        if (GetStringLeft(sSaid, 1) == "*" && !GetLocalInt(oShouter, "hls_emotemute"))
        {
            ParseEmote(sSaid, oShouter);
            return;
        }

        if (GetStringLeft(sSaid, 1) == ":")
        {
            //This "throws" your voice to an object and properly dumps it into the log
            if (GetIsObjectValid(oTarget))
            {
                sSaid = GetStringRight(sSaid, GetStringLength(sSaid)-1);

                if (GetStringLeft(sSaid, 1) == "[")
                    {
                    TranslateToLanguage(sSaid, oTarget);
                    return;
                    }

                if (GetStringLeft(sSaid, 1) == "*")
                    {
                    ParseEmote(sSaid, oTarget);
                    return;
                    }

             AssignCommand(oTarget, SpeakString(sSaid));
             //PrintString("<Conv>"+GetName(GetArea(oTarget))+ " " + GetName(oTarget) + ": " + sSaid + " </Conv>");
             return;
            }
        return;
        }

        if (GetStringLeft(sSaid, 1) == ";" && //Voicethrow ";" prioritizes animal companions
        (GetIsObjectValid(GetMaster(oShouter)) ||
        GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oShouter)) ||
        GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oShouter)) ||
        GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oShouter)) ||
        GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oShouter))))
        {
            if (GetIsObjectValid(GetMaster(oShouter)))
                oSummon = GetMaster(oShouter);
            else if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oShouter)))
                oSummon = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oShouter);
            else if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oShouter)))
                oSummon = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oShouter);
            else if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oShouter)))
                oSummon = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oShouter);
            else if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oShouter)))
                oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oShouter);

            if (GetIsObjectValid(oSummon))
            {
                sSaid = GetStringRight(sSaid, GetStringLength(sSaid)-1);

                if (GetStringLeft(sSaid, 1) == "[")
                    {
                    TranslateToLanguage(sSaid, oSummon);
                    return;
                    }

                if (GetStringLeft(sSaid, 1) == "*")
                    {
                    ParseEmote(sSaid, oSummon);
                    return;
                    }

                AssignCommand(oSummon, SpeakString(sSaid));
                PrintString("<Conv>"+GetName(GetArea(oSummon))+ " " + GetName(oSummon) + ": " + sSaid + " </Conv>");
                return;
            }
        return;
        }

        if (GetStringLeft(sSaid, 1) == "," && //Voicethrow "," prioritizes summons
        (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oShouter)) ||
        GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oShouter)) ||
        GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oShouter)) ||
        GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oShouter))))
        {
            if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oShouter)))
                oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oShouter);
            else if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oShouter)))
                oSummon = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oShouter);
            else if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oShouter)))
                oSummon = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oShouter);
            else if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oShouter)))
                oSummon = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oShouter);

           if (GetIsObjectValid(oSummon))
            {
                sSaid = GetStringRight(sSaid, GetStringLength(sSaid)-1);

                if (GetStringLeft(sSaid, 1) == "[")
                    {
                    TranslateToLanguage(sSaid, oSummon);
                    return;
                    }

                if (GetStringLeft(sSaid, 1) == "*")
                    {
                    ParseEmote(sSaid, oSummon);
                    return;
                    }

                AssignCommand(oSummon, SpeakString(sSaid));
                PrintString("<Conv>"+GetName(GetArea(oSummon))+ " " + GetName(oSummon) + ": " + sSaid + " </Conv>");
                return;
            }
        return;
        }

        if (GetIsObjectValid(GetLocalObject(GetModule(), "hls_NPCControl" + GetStringLeft(sSaid, 1))) && GetLocalInt(GetModule(), "dmfi_Admin" + GetPCPublicCDKey(oShouter)))
        {
            object oControl = GetLocalObject(GetModule(), "hls_NPCControl" + GetStringLeft(sSaid, 1));
            sSaid = GetStringRight(sSaid, GetStringLength(sSaid)-1);

            if (GetStringLeft(sSaid, 1) == "[")
                {
                TranslateToLanguage(sSaid, oControl);
                return;
                }
            if (GetStringLeft(sSaid, 1) == "*")
                {
                ParseEmote(sSaid, oControl);
                return;
                }
            if (GetStringLeft(sSaid, 1) == ".")
                {
                ParseCommand(oControl, oShouter, sSaid);
                return;
                }

                //This "throws" your voice to an object and properly dumps it into the log
                AssignCommand(oControl, SpeakString(sSaid));
                PrintString("<Conv>"+GetName(GetArea(oControl))+ " " + GetName(oControl) + ": " + sSaid + " </Conv>");
                return;
        }

        if (GetStringLeft(sSaid, 1) == "." && GetIsObjectValid(oMaster))
        {
            ParseCommand(oTarget, oMaster, sSaid);
            return;
        }



        }
    }

