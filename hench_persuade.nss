void main()
{
    object oPC = GetPCSpeaker();
    string sID = GetName(oPC); if(GetStringLength(sID) > 0) { sID = GetStringLeft(sID, 25); }
    int modificador = abs( GetAlignmentGoodEvil(OBJECT_SELF)-GetAlignmentGoodEvil(GetPCSpeaker()) )/10 - 2;
    if (GetRacialType(OBJECT_SELF)!=GetRacialType(GetPCSpeaker())) {
        modificador += 2;
    }
    int tirada = GetSkillRank(SKILL_PERSUADE, GetPCSpeaker());
    int dado = d20();
    int DC = 10 + GetLevelByPosition(1)+ GetLevelByPosition(2)+ GetLevelByPosition(3)+modificador;
    string mensaje = "Chequeo de Persuacion: ("+IntToString(dado)+" + "+IntToString(tirada)+") = "+IntToString(dado+tirada)+" vs DC: "+IntToString(DC);
    int PasaGratis = FALSE;

    SendMessageToPC(GetPCSpeaker(), mensaje);
    tirada = dado + tirada;

    if ( (GetDeity(OBJECT_SELF)==GetDeity(oPC)) && (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0) ) {
        SetLocalInt(OBJECT_SELF, "Accion"+sID, 1);
        SetCustomToken(102, "Pero claro que viajaria con un hermano de fe!");
        SetLocalInt(OBJECT_SELF, "vsDC", tirada);
    } else if (tirada>=DC) {
        SetLocalInt(OBJECT_SELF, "Accion"+sID, 1);
        SetCustomToken(102, "Pensandolo mejor, creo que podria divertirme con usted.");
        SetLocalInt(OBJECT_SELF, "vsDC", tirada);
    } else {
        SetLocalInt(OBJECT_SELF, "Accion"+sID, 2);
        SetCustomToken(102, "Bah! Tengo cosas mejores que hacer.");
    }
}
