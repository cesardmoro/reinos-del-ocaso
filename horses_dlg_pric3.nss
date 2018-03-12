#include "Horses_const"

void main()
{
    SetLocalInt(OBJECT_SELF, Horses_Conversation_PRICE, Horses_Price_HORSE_HEAVY);
    SetCustomToken(237, IntToString(Horses_Price_HORSE_HEAVY));
}
