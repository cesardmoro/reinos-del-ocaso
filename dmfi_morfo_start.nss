void main()
{
    object oDM = GetPCSpeaker();
    object oTarget = GetLocalObject(oDM, "oTargetCreature");
    string sNombre = GetName(oTarget);
    SetCustomToken(9001, sNombre);
}
