//::///////////////////////////////////////////////
//:: FileName t_sellddm3
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 19/12/2005 02:56:05 p.m.
//:://////////////////////////////////////////////
void main()
{

    // Quitar algo de oro al jugador
    TakeGoldFromCreature(250, GetPCSpeaker(), TRUE);
        // Dar los objetos al que habla
    CreateItemOnObject("pasajeddm", GetPCSpeaker(), 3);
}
