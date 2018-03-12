#include "location_tools"

void CrearPlaceable(int TargetArea, location lTarget, object oPC)
{
    string NameWP = "CARPA_WPOINT0"+IntToString(TargetArea);
    int GlobalID = GetLocalInt(GetModule(), "Carpas");
    GlobalID++;
    SetLocalInt(GetModule(), "Carpas", GlobalID);
    string sID = "CARPA"+IntToString(GlobalID);
    object CarpaPlaceable = GetObjectByTag(sID);
    CreateObject(OBJECT_TYPE_PLACEABLE, "carpa_blueprnt", lTarget, FALSE, sID);
    SendMessageToPC(oPC, "Terminas de armar la tienda");
    DestroyObject(GetItemActivated(), 0.1);
    float TargetFace = GetFacingFromLocation(lTarget);
    location lWay = Location_createRelative(lTarget, -5.0, 0.0, -TargetFace);
    CreateObject(OBJECT_TYPE_WAYPOINT, "out_wpoint0", lWay, FALSE, "OUT_WPOINT"+IntToString(GlobalID));
    SetLocalInt(GetObjectByTag(NameWP), "aOwner", GlobalID);
    SetLocalInt(GetObjectByTag(sID), "aOwner", GlobalID);
    SetLocalInt(GetObjectByTag(sID), "nID", TargetArea);
}

void AnimarCarpa(int TargetArea, location lTarget, object oPC)
{
    SendMessageToPC(oPC, "Te dispones a armar la tienda...");
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 5.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 5.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 5.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 5.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 5.0));
    AssignCommand(oPC, ActionDoCommand(CrearPlaceable(TargetArea, lTarget, oPC)));
}

void main()
{
    int MaxAreas = 9;

    object oPC = GetItemActivator();
    location lTarget = GetItemActivatedTargetLocation();
    object oAreaPC = GetArea(oPC);

    if(GetDistanceBetweenLocations(GetLocation(oPC), lTarget) > 5.0)
    {
        SendMessageToPC(oPC, "Estas muy lejos de ese lugar");
        return;
    }
    if(!((GetIsAreaInterior(oAreaPC) == FALSE) && (GetIsAreaAboveGround(oAreaPC) == TRUE) && (GetIsAreaNatural(oAreaPC) == TRUE)))
    {
        SendMessageToPC(oPC, "Solo puedes armar una tienda en areas exteriores sobre la tierra y no artificiales");
        return;
    }
    if (GetItemActivatedTarget()!=OBJECT_INVALID) {
        SendMessageToPC(oPC, "Este objeto debe ser usado sobre el piso");
        return;
    }
    if (oAreaPC==GetArea(GetWaypointByTag("FugueMarker"))) {
        SendMessageToPC(oPC, "No puedes armar una carpa en este lugar.");
        return;
    }
    int i;
    string Carpa_WPTag;
    object Carpa_WPo;
    int AreaDisponible;
    for (i=1;i<=MaxAreas;i++) {
        Carpa_WPTag = "CARPA_WPOINT0"+IntToString(i);
        Carpa_WPo = GetObjectByTag(Carpa_WPTag);
        if (GetLocalInt(Carpa_WPo, "aOwner") == 0) {
            AreaDisponible = i;
            break;
        }
    }
    if (AreaDisponible!=0) {
        AnimarCarpa(AreaDisponible, lTarget, oPC);
    } else {
        object oPri;
        int nroPCs;
        int AreasLlenas = 0;
        for (i=1;i<=MaxAreas;i++) {
            Carpa_WPTag = "CARPA_WPOINT0"+IntToString(i);
            Carpa_WPo = GetObjectByTag(Carpa_WPTag);
            nroPCs = 0;
            oPri = GetFirstObjectInArea(Carpa_WPo);
            while (oPri!=OBJECT_INVALID) {
                if (GetIsPC(oPri))
                    nroPCs++;
                oPri = GetNextObjectInArea(Carpa_WPo);
            }
            if (nroPCs==0) {
                AnimarCarpa(i, lTarget, oPC);
                break;
            } else {
                AreasLlenas++;
            }
        }
        if (AreasLlenas==MaxAreas)
            SendMessageToPC(oPC, "Todas las areas estan ocupadas. Por favor, espera a que se desocupe alguna para armar tu carpa");
    }
}
