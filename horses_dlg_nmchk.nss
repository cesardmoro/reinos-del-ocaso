#include "Horses_const"

void main()
{
    object oPC = GetPCSpeaker();

    int nMatch = GetListenPatternNumber();
    string sName = GetMatchedSubstring(0);

    SendMessageToPC(oPC, "Name: "+sName);
    SetCustomToken(3201, "<c'fø>" + sName + "</c>");
    SetLocalString(oPC, Horses_CURRENT_NAME, sName);
}
