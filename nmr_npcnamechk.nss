// Written by: Ne0nx3r0
// for the Dot Hack Project mod,
// http://www.dothackproject.net/
// Ne0nx3r0@hotmail.com

void main()
{
object oPC        = GetPCSpeaker();
int i = 0;
int nMatch = GetListenPatternNumber();
string sqname = GetMatchedSubstring(0);  //Name

SendMessageToPC(oPC,"Name Received:" + sqname);
SetCustomToken(3201,"<c'fø>" + sqname + "</c>");
SetLocalString(OBJECT_SELF,"current_name",sqname);
}
