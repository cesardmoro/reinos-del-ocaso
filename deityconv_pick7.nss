#include "deityconv_inc"

void main()
{
    // Get the deity associated with the seventh token.
    int nDeity = GetLocalInt(OBJECT_SELF, "DeityList_" +
                    IntToString(GetLocalInt(OBJECT_SELF, "DeityList_Begin") + 6));

    // Record nDeity as the current one.
    SetLocalInt(OBJECT_SELF, "DeityToTalkAbout", nDeity);
    // Also set the tokens for the description.
    SetupDeityConversationTokens(nDeity);
}
