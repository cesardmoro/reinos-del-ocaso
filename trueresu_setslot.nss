#include "sp_resu_inc"

void main()
{
    object oCaster = GetPCSpeaker();
    object fugueArea = GetArea(GetWaypointByTag(WAYPOINT_FUGUE));
    int i = 1;
    object objetoIterado = GetFirstObjectInArea(fugueArea);
    while (GetIsObjectValid(objetoIterado) && i <= 5)
    {
        if (GetIsPC(objetoIterado) && !GetIsDM(objetoIterado))
        {
            SetLocalObject(oCaster, TrueResurrection_deadPlayerSlot_VN_PREFIX+IntToString(i), objetoIterado);
            SetCustomToken(430+i, GetName(objetoIterado));
            i++;
        }
        objetoIterado = GetNextObjectInArea(fugueArea);
    }
}
