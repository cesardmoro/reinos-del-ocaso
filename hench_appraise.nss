void main()
{
    string sID = GetName(GetPCSpeaker()); if(GetStringLength(sID) > 0) { sID = GetStringLeft(sID, 25); }
    int nivel = GetLevelByPosition(1)+GetLevelByPosition(2)+GetLevelByPosition(3);
    int Dif = 10 + nivel;
    int Nuevo = GetLocalInt(OBJECT_SELF, "Precio") - nivel;
    if (GetIsSkillSuccessful(GetPCSpeaker(), SKILL_APPRAISE, Dif)) {
        SetLocalInt(OBJECT_SELF, "Precio", Nuevo);
        SetCustomToken(100, "Esta bien. Es un trato justo. Seran "+IntToString(Nuevo)+" monedas.");
    }
    else {
        SetCustomToken(100, "Olvidalo. "+IntToString(GetLocalInt(OBJECT_SELF, "Precio"))+" monedas o nada.");
    }
    SetLocalInt(OBJECT_SELF, "yaregateo"+sID, 1);
}
