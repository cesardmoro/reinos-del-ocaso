#include "dmfi_voice_inc"

void main()
{
    object oPC = GetPCSpeaker();
    int idiomaParaAprender = GetLocalInt(oPC, "idiomaParaAprender");
    DeleteLocalInt(oPC, "idiomaParaAprender");

    int esIdiomaBase = (idiomaParaAprender==1) ? TRUE :
                       (idiomaParaAprender==2) ? TRUE :
                       (idiomaParaAprender==3) ? TRUE :
                       (idiomaParaAprender==4) ? TRUE :
                       (idiomaParaAprender==5) ? TRUE :
                       (idiomaParaAprender==6) ? TRUE :
                       (idiomaParaAprender==18) ? TRUE :
                       (idiomaParaAprender==19) ? TRUE :
                       (idiomaParaAprender==20) ? TRUE :
                       FALSE;

    int lenguajesNivel1 = GetLocalInt(oPC, Idiomas_CANTIDAD_LENGUAJES_NIVEL1_PARA_APRENDER);
    //SendMessageToPC(oPC, "lenguajesNivel1: "+IntToString(lenguajesNivel1));
    int lenguajesPorSkill = GetLocalInt(oPC, Idiomas_CANTIDAD_LENGUAJES_PARA_APRENDER_POR_SKILL);
    //SendMessageToPC(oPC, "lenguajesPorSkill: "+IntToString(lenguajesPorSkill));
    if (lenguajesNivel1 > 0 && esIdiomaBase)
    {
        SetLocalInt(oPC, Idiomas_CANTIDAD_LENGUAJES_NIVEL1_PARA_APRENDER, lenguajesNivel1-1);
        int lenguajesBaseAprendidos = GetCampaignInt(Idiomas_DATABASE, Idiomas_DB_LENGUAJES_NIVEL1_APRENDIDOS, oPC) + 1;
        //SendMessageToPC(oPC, "lenguajesBaseAprendidos: "+IntToString(lenguajesBaseAprendidos));
        SetCampaignInt(Idiomas_DATABASE, Idiomas_DB_LENGUAJES_NIVEL1_APRENDIDOS, lenguajesBaseAprendidos, oPC);
        CreateItemOnObject("hlslang_"+IntToString(idiomaParaAprender), oPC);
    }
    else if (lenguajesPorSkill > 0)
    {
        SetLocalInt(oPC, Idiomas_CANTIDAD_LENGUAJES_PARA_APRENDER_POR_SKILL, lenguajesPorSkill-1);
        int lenguajesAprendidosPorSkill = GetCampaignInt(Idiomas_DATABASE, Idiomas_DB_LENGUAJES_APRENDIDOS_POR_SKILL, oPC) + 1;
        //SendMessageToPC(oPC, "lenguajesAprendidosPorSkill: "+IntToString(lenguajesAprendidosPorSkill));
        SetCampaignInt(Idiomas_DATABASE, Idiomas_DB_LENGUAJES_APRENDIDOS_POR_SKILL, lenguajesAprendidosPorSkill, oPC);
        CreateItemOnObject("hlslang_"+IntToString(idiomaParaAprender), oPC);
    }
}
