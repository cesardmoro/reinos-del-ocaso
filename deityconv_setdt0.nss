#include "deity_include"

void main()
{
    object oPC = GetPCSpeaker();
    // Set the PC's deity field.
    SetDeity( oPC,
              // Get the deity name for the current index.
              GetDeityName(GetLocalInt(OBJECT_SELF, "DeityToTalkAbout")) );
    string sBook = GetDeityBook(GetDeityIndex(oPC));
    object oControl = CreateItemOnObject(sBook, oPC, 1, sBook);
    if (oControl==OBJECT_INVALID) {
        SendMessageToPC(oPC, sBook);
        SendMessageToPC(oPC, "No se ha podido darte el dogma de tu dios. Por favor, informalo a un DM.");
    }
//    DelayCommand(0.5, AssignCommand(oPC, JumpToLocation(GetLocation(GetWaypointByTag("inicio2")))));
}
