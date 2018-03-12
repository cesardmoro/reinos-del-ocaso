#include "horses_stableinc"

int StartingConditional()
{
    return (GetGold(GetPCSpeaker()) >= GetLocalInt(OBJECT_SELF, Horses_Conversation_PRICE));
}
