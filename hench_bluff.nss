void main()
{
    string sID = GetName(GetPCSpeaker()); if(GetStringLength(sID) > 0) { sID = GetStringLeft(sID, 25); }
    int tirada = GetSkillRank(SKILL_BLUFF, GetPCSpeaker());
    int dado = d20();
    int DC = 10 + GetLevelByPosition(1)+ GetLevelByPosition(2)+ GetLevelByPosition(3);
    string mensaje = "Chequeo de Mentira: ("+IntToString(dado)+" + "+IntToString(tirada)+") = "+IntToString(dado+tirada)+" vs DC: "+IntToString(DC);
    object oPC = GetPCSpeaker();

    SendMessageToPC(oPC, mensaje);
    tirada = dado + tirada;
    if (tirada>=DC) {
        SetLocalInt(OBJECT_SELF, "Accion"+sID, 1);
        SetCustomToken(102, "Eso suena interesante!");
        SetLocalInt(OBJECT_SELF, "vsDC", tirada);
    } else if (tirada<=(DC-10)) {
        SetLocalInt(OBJECT_SELF, "Accion"+sID, 3);
        SetCustomToken(102, "Me tomas por tonto!");
    } else {
        SetLocalInt(OBJECT_SELF, "Accion"+sID, 2);
        SetCustomToken(102, "Bah! Tengo cosas mejores que hacer.");
    }
    if( GetAlignmentGoodEvil( oPC ) > 71 )
        AdjustAlignment(oPC, ALIGNMENT_EVIL, 1);
}
