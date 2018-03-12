#include "location_tools"

void drogas_SmokePipe(object oActivator)
{
    string sEmote1 = "*Fumas la hierba*";
    //  string sEmote2 = "*inhales from a pipe*";
    //   string sEmote3 = "*pulls a mouthful of smoke from a pipe*";
    float fHeight = 1.7;
    float fDistance = 0.1;
    // Set height based on race and gender
    if (GetGender(oActivator) == GENDER_MALE)
    {
        switch (GetRacialType(oActivator))
        {
        case RACIAL_TYPE_HUMAN:
        case RACIAL_TYPE_HALFELF: fHeight = 1.7; fDistance = 0.12; break;
        case RACIAL_TYPE_ELF: fHeight = 1.55; fDistance = 0.08; break;
        case RACIAL_TYPE_GNOME:
        case RACIAL_TYPE_HALFLING: fHeight = 1.15; fDistance = 0.12; break;
        case RACIAL_TYPE_DWARF: fHeight = 1.2; fDistance = 0.12; break;
        case RACIAL_TYPE_HALFORC: fHeight = 1.9; fDistance = 0.2; break;
        }
    }
    else
    {
        // FEMALES
        switch (GetRacialType(oActivator))
        {
        case RACIAL_TYPE_HUMAN:
        case RACIAL_TYPE_HALFELF: fHeight = 1.6; fDistance = 0.12; break;
        case RACIAL_TYPE_ELF: fHeight = 1.45; fDistance = 0.12; break;
        case RACIAL_TYPE_GNOME:
        case RACIAL_TYPE_HALFLING: fHeight = 1.1; fDistance = 0.075; break;
        case RACIAL_TYPE_DWARF: fHeight = 1.2; fDistance = 0.1; break;
        case RACIAL_TYPE_HALFORC: fHeight = 1.8; fDistance = 0.13; break;
        }
    }
    location lAboveHead = Location_GetLocationAboveAndInFrontOf(oActivator, fDistance, fHeight);
    // emotes

    AssignCommand(oActivator, ActionSpeakString(sEmote1));
    //   case 2: AssignCommand(oActivator, ActionSpeakString(sEmote2)); break;
    //   case 3: AssignCommand(oActivator, ActionSpeakString(sEmote3));break;

    // glow red
    AssignCommand(oActivator, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_RED_5), oActivator, 0.15)));
    // wait a moment
    AssignCommand(oActivator, ActionWait(3.0));
    // puff of smoke above and in front of head
    AssignCommand(oActivator, ActionDoCommand(ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), lAboveHead)));
    // if female, turn head to left
    if ((GetGender(oActivator) == GENDER_FEMALE) && (GetRacialType(oActivator) != RACIAL_TYPE_DWARF))
        AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 5.0));
}
