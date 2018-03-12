#include "Horses_persist"
#include "Horses_stableinc"

void main()
{
    object oPC = GetPCSpeaker();
    object oArea = GetArea(oPC);

    int nMountType;
    int horsePrice = GetLocalInt(OBJECT_SELF, Horses_Conversation_PRICE);

    if (GetGold(oPC) >= horsePrice) {

        switch (horsePrice) {
            case Horses_Price_HORSE_CARGO:      nMountType = MOUNT_TYPE_HORSE_CARGO; break;
            case Horses_Price_HORSE_LIGHT:      nMountType = MOUNT_TYPE_HORSE_LIGHT; break;
            case Horses_Price_HORSE_HEAVY:      nMountType = MOUNT_TYPE_HORSE_HEAVY; break;
            case Horses_Price_WARHORSE_LIGHT:   nMountType = MOUNT_TYPE_WARHORSE_LIGHT; break;
            case Horses_Price_WARHORSE_HEAVY:   nMountType = MOUNT_TYPE_WARHORSE_HEAVY; break;
        }

        TakeGoldFromCreature(horsePrice, oPC, TRUE);

        location whereToCreate;
        object oWPbuy = GetWaypointByTag(Horses_Stable_LAST_WP + GetStringLeft(GetTag(oArea), 16));
        if (GetIsObjectValid(oWPbuy))
            whereToCreate = GetLocation(oWPbuy);
        else
            whereToCreate = Horses_Stable_GetFirstAvailableLocation(oPC, oArea);

        object oHorse = Horses_CreateNewPersistantHorse(nMountType, whereToCreate, oPC);

        if (whereToCreate==GetLocation(oWPbuy)) {
            AssignCommand(oHorse, ActionMoveToObject(oPC));
            AssignCommand(OBJECT_SELF, SpeakString("Alli lo tiene"));
        }

        SetLocalInt(oPC, Horses_CURRENT_HORSE, Horses_GetHorseId(oHorse));

        SetLocalInt(oPC, Stable_HAS_TO_CRAFT, TRUE);

    } else
        SpeakString("No tiene suficiente dinero para comprar este caballo.");
}
