// Script original: Ne0nx3r0
// Modificado por dragoncin

void main()
{
object oPC = GetPCSpeaker();
int nMatch = GetListenPatternNumber();
string sqname = GetMatchedSubstring(0);  //Name

SendMessageToPC(oPC,"Nombre recibido: " + sqname);
SetCustomToken(5020, sqname);
SetLocalString(GetArea(OBJECT_SELF),"nombrePJnosalta",sqname);
}
