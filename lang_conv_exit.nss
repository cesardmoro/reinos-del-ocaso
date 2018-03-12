#include "dmfi_voice_inc"

void main()
{
    object oPC = GetPCSpeaker();
    DeleteLocalInt(oPC, Idiomas_CANTIDAD_LENGUAJES_NIVEL1_PARA_APRENDER);
    DeleteLocalInt(oPC, Idiomas_CANTIDAD_LENGUAJES_PARA_APRENDER_POR_SKILL);
}
