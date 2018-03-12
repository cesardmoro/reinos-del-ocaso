//::///////////////////////////////////////////////
//:: FileName t_llaveposada
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 19/12/2005 02:56:05 p.m.
//:://////////////////////////////////////////////
void main()
{
   int iResult;

   iResult = (GetGold(GetPCSpeaker()) >= 100);
   return iResult;

    // Quitar algo de oro al jugador
    TakeGoldFromCreature(20, GetPCSpeaker(), TRUE);
    // Dar los objetos al que habla
    CreateItemOnObject("llavedehabitacio", GetPCSpeaker(), 1);

}
