void main()
{
    object oPC = GetPCSpeaker();
    int posicionClase = GetLocalInt(oPC, "CLASS_POSITION");
    int nivelConjuro = GetLocalInt(oPC, "SPELL_LEVEL");

    string dbVN = "DraDis_Clase"+IntToString(posicionClase)+"_SpellLvl"+IntToString(nivelConjuro);
    SetCampaignInt("classes", dbVN, GetCampaignInt("classes", dbVN, oPC)+1, oPC);

    ExecuteScript("prc_dradis", oPC);
}
