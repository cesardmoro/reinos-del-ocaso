#include "Mensajeria_inc"

void main()
{
    object oPC = GetPCSpeaker();
    SetLocalInt( oPC, Mensajeria_idiomaElegido_VN, IDIOMA_ORCO );
}
