///////////////////////
//
// EVENTO OnPlayerLevelUp
//
///////////////////////

#include "deity_eventonlvl"
#include "reglasdelacasa"
#include "dmfi_voice_inc"
#include "RdO_Clases_inc"

void main()
{
    object oPC = GetPCLevellingUp();

    ExecuteScript("prc_levelup", oPC);

    // Nota por dragoncin:
    // La idea de poner cada control dentro de un if se debe a que estos controles abren conversaciones con el PJ
    // Entonces, para evitar que se abra más de una, se ejecuta un control solo si el otro fue superado
    if (deity_eventOnLevelUp( oPC ))
    {
        if (RdlC_controlarReglasDeLaCasa( oPC ))
        {
            RdO_Classes_onLevelUp( oPC );
            Idiomas_aprenderNuevosIdiomas( oPC );
        }
    }
}
