#include "Horses_persist"

const string Stable_HAS_TO_CRAFT = "Stable_HAS_TO_CRAFT";
const string Stable_HAS_TO_NAME  = "Stable_HAS_TO_NAME";

/////////////////////////// ESTABLO /////////////////////////////

const string Horses_STABLE_WP_PREFIX            = "_Horses_STABLE_WP_";
const string Horses_STABLE_WP_STATUS            = "Horses_STABLE_WP_STATUS";
const string Horses_Stable_NUMBER_OF_STABLES    = "Stable_NUMBER_OF_STABLES";
const string Horses_Stable_LAST_WP              = "A_Horses_STABLE_WP_";

// Devuelve la ubicacion del primer waypoint libre en el establo
// Si no hay ninguno libre, devuelve la ubicacion de oPC
location Horses_Stable_GetFirstAvailableLocation( object oPC, object oArea = OBJECT_INVALID );
location Horses_Stable_GetFirstAvailableLocation( object oPC, object oArea = OBJECT_INVALID )
{
    object area = (GetIsObjectValid(oArea)) ? oArea : GetArea(oPC);
    string areaTag = GetStringLeft(GetTag(GetArea(area)), 16);
    int numberOfStables = GetLocalInt(area, Horses_Stable_NUMBER_OF_STABLES);

    int i = 1;
    string wpTag = IntToString(i)+Horses_STABLE_WP_PREFIX+areaTag;
    //SendMessageToPC(oPC, "Horses_Stable_GetFirstAvailableLocation: areaTag="+areaTag+"  wpTag="+wpTag+"  numberOfStables="+IntToString(numberOfStables));
    object stableWP = GetWaypointByTag(wpTag);
    //if (!GetIsObjectValid(stableWP)) SendMessageToPC(oPC, "waypoint "+wpTag+" no encontrado!");
    while (GetLocalInt(oArea, Horses_STABLE_WP_STATUS+IntToString(i)) > 0 && i <= (numberOfStables+1)) {
        //SendMessageToPC(oPC, "wpName: "+GetName(stableWP));
        i++;
        wpTag = IntToString(i)+Horses_STABLE_WP_PREFIX+areaTag;
        stableWP = GetWaypointByTag(wpTag);
    }

    location availableLocation;
    if (GetIsObjectValid(stableWP))
        availableLocation = GetLocation(stableWP);
    else {
        stableWP = GetWaypointByTag(Horses_Stable_LAST_WP+areaTag);
        if (GetIsObjectValid(stableWP))
            availableLocation = GetLocation(stableWP);
        else
            availableLocation = GetLocation(oPC);
    }

    return availableLocation;
}

// Evento onEnter para los triggers que marcan los establos
void Horses_Stable_Trigger_onEnter( object enteringObject, object oTrigger = OBJECT_SELF );
void Horses_Stable_Trigger_onEnter( object enteringObject, object oTrigger = OBJECT_SELF )
{
    if (GetIsRidableHorse(enteringObject)) {

        string triggerId = GetStringLeft(GetTag(oTrigger), 1);

        object oArea = GetArea(oTrigger);

        int numberOfHorses = GetLocalInt(oArea, Horses_STABLE_WP_STATUS+triggerId);
        SetLocalInt(oArea, Horses_STABLE_WP_STATUS+triggerId, numberOfHorses+1);

        //SendMessageToPC(GetFirstPC(), "triggerOnEnter: triggerId="+triggerId+"  numberOfHorses="+IntToString(numberOfHorses));
    }
}


// Evento onExit para los triggers que marcan los establos
void Horses_Stable_Trigger_onExit( object exitingObject, object oTrigger = OBJECT_SELF );
void Horses_Stable_Trigger_onExit( object exitingObject, object oTrigger = OBJECT_SELF )
{
    if (GetIsRidableHorse(exitingObject)) {

        string triggerId = GetStringLeft(GetTag(oTrigger), 1);

        object oArea = GetArea(oTrigger);

        int numberOfHorses = GetLocalInt(oArea, Horses_STABLE_WP_STATUS+triggerId);
        SetLocalInt(oArea, Horses_STABLE_WP_STATUS+triggerId, numberOfHorses-1);

        //SendMessageToPC(GetFirstPC(), "triggerOnExit: triggerId="+triggerId+"  numberOfHorses="+IntToString(numberOfHorses));
    }
}

void Horses_Stable_retrieveHorse( object oPC, int scriptIndex, object oSpeaker = OBJECT_SELF );
void Horses_Stable_retrieveHorse( object oPC, int scriptIndex, object oSpeaker = OBJECT_SELF )
{
    object oArea = GetArea(oPC);

    int nIndex = GetLocalInt(oSpeaker, Horses_HORSE_IN_SLOT+IntToString(scriptIndex));

    // Chequeamos que la montura de oPC no sea la que queremos rescatar
    if (Horses_GetHorseId(Horses_GetMountedHorse(oPC)) != nIndex) {
        location whereToRetrieve = Horses_Stable_GetFirstAvailableLocation(oPC, oArea);
        object oHorse = Horses_RetrievePersistantHorse(nIndex, oPC, whereToRetrieve);

        if (whereToRetrieve==GetLocation(GetWaypointByTag(Horses_Stable_LAST_WP+GetStringLeft(GetTag(oArea), 16)))) {
            AssignCommand(oHorse, ActionMoveToObject(oPC));
            AssignCommand(oSpeaker, SpeakString("Alli se acerca su caballo"));
        }
    }
}
