// Inicia la conversacion sobre los dioses del panteon gnomo

#include "deityconv_inc"

void main()
{
    // Get the PC's current deity.
    int nDeity = GetDeityIndex(GetPCSpeaker());

    object oModule = GetModule();
    int iInicio = GetLocalInt(oModule, "NroDiosesPanteonGeneral") + GetLocalInt(oModule, "NroDiosesPanteonElfico") + GetLocalInt(oModule, "NroDiosesPanteonEnano");
    // If the current deity is unrecognized, choose one at random.
    if ( nDeity < 0 )
        nDeity = iInicio;

    // Record this as the first deity.
    SetLocalInt(OBJECT_SELF, "DeityToTalkAbout", nDeity);
    SetLocalInt(OBJECT_SELF, "NroPanteon", 3);

    // Initialize the conversation tokens.
    SetupDeityConversationTokens(nDeity);
}
