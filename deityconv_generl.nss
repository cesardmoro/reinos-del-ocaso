// Inicia la conversacion sobre los dioses del panteon general

#include "deityconv_inc"

void main()
{
    // Get the PC's current deity.
    int nDeity = GetDeityIndex(GetPCSpeaker());

    // If the current deity is unrecognized, choose the first.
    if ( nDeity < 0 )
        nDeity = 0;

    // Record this as the first deity.
    SetLocalInt(OBJECT_SELF, "DeityToTalkAbout", nDeity);
    SetLocalInt(OBJECT_SELF, "NroPanteon", 0);

    // Initialize the conversation tokens.
    SetupDeityConversationTokens(nDeity);
}
