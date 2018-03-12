#include "Horses_persist"

void main()
{
    object oPC = GetPCSpeaker();

    int maxHorseIndex = Horses_GetDBMaxHorseIndex( oPC );

    int i;
    for (i=1; i<=10; i++) {
        SetLocalInt(OBJECT_SELF, Horses_HORSE_IN_SLOT+IntToString(i), 0);
    }

    int horseIndex = 1;
    string horseName;
    int horseCounter;
    string currentStableTag = GetTag(GetArea(oPC));
    while ( horseIndex <= maxHorseIndex && horseCounter <= 10 ){
        horseName = Horses_GetPersistantHorseName(horseIndex, oPC);
        string horseStableTag = Horses_GetHorseStableTag(horseIndex, oPC);
        // ---> Arreglo para pasar todos los caballos antiguos al nuevo sistema de establos
        if (horseStableTag=="")
        {
            Horses_SetHorseStableTag(horseIndex, oPC, "benzorstables");
            horseStableTag = "benzorstables";
        }
        if (horseName != "" && horseStableTag==currentStableTag) {
            SetCustomToken(1400+horseCounter, horseName);
            SetLocalInt(OBJECT_SELF, Horses_HORSE_IN_SLOT+IntToString(horseCounter), horseIndex);
            horseCounter++;
        }
        horseIndex++;
    }
}
