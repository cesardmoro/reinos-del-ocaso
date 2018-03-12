#include "pregunta"
void main()
{
SetLocalInt(GetModule(), "iNum", 0);

object oArea = GetObjectByTag("resuzone2");
object oMuerto = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(GetNearestObjectByTag("resuzone")), TRUE, OBJECT_TYPE_CREATURE);
//object oMuerto = GetFirstObjectInArea(oArea);
while(GetIsObjectValid(oMuerto))
{
//SetCustomToken(2000+GetLocalInt(GetModule(), "iNum"), GetName(oMuerto));
//SetLocalObject(GetModule(), IntToString(2000+GetLocalInt(GetModule(), "iNum")), oMuerto);
pregunta(oMuerto, oArea);
oMuerto = GetNextObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(GetNearestObjectByTag("resuzone")), TRUE, OBJECT_TYPE_CREATURE);
//oMuerto = GetNextObjectInArea(oArea);
}

}
