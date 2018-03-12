void main()
{
    object oPC = GetPCSpeaker();
    string sID = GetName(oPC); if(GetStringLength(sID) > 0) { sID = GetStringLeft(sID, 25); }
    int tirada = GetSkillRank(SKILL_INTIMIDATE, oPC);
    int dado = d20();
    int DC = 10 + GetHitDice(OBJECT_SELF);
    string mensaje = "Chequeo de Intimidacion: ("+IntToString(dado)+" + "+IntToString(tirada)+") = "+IntToString(dado+tirada)+" vs DC: "+IntToString(DC);

    SendMessageToPC(oPC, mensaje);
    tirada = dado + tirada;
    if ( (tirada>=DC) && (GetLevelByClass(CLASS_TYPE_PALADIN, OBJECT_SELF) < 1) ) {
        SetLocalInt(OBJECT_SELF, "Accion"+sID, 1);
        SetCustomToken(102, "Vale, vale, no te pongas asi!");
        SetLocalInt(OBJECT_SELF, "vsDC", tirada);
    } else if (tirada<=(DC-10)) {
        SetLocalInt(OBJECT_SELF, "Accion"+sID, 3);
        SetCustomToken(102, "Me tomas por tonto!");
    } else {
        SetLocalInt(OBJECT_SELF, "Accion"+sID, 2);
        SetCustomToken(102, "Bah! Tengo cosas mejores que hacer.");
    }
    if( GetAlignmentLawChaos( oPC ) > 71 )
        AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, 1);
}
