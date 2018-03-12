#include "dmfi_voice_inc"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    return (!GetIsObjectValid(GetItemPossessedBy(oPC, "hlslang_4")) &&
             (GetLocalInt(oPC, Idiomas_CANTIDAD_LENGUAJES_PARA_APRENDER_POR_SKILL) > 0 ||
             GetLocalInt(oPC, Idiomas_CANTIDAD_LENGUAJES_NIVEL1_PARA_APRENDER) > 0)
            );
}
