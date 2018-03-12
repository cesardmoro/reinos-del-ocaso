#include "deity_include"

void main()
{
    object oPC = GetPCSpeaker();
    // Set the PC's deity field.
    SetDeity( oPC,
              // Get the deity name for the current index.
              GetDeityName(GetLocalInt(OBJECT_SELF, "DeityToTalkAbout")) );
//    DelayCommand(0.5, AssignCommand(oPC, JumpToLocation(GetLocation(GetObjectByTag("inicio2")))));

    // Si se trata de un paladin de Torm...
    if ((GetDeity(oPC)=="Torm") && (GetLevelByClass(CLASS_TYPE_PALADIN, oPC)>0)) {
        //... darle el Codigo de Torm
        CreateItemOnObject("codigo_torm", oPC);
    }
}
