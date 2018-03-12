#include "kpb_inc"
#include "goods_inc"

const int KPB_CANTIDAD_DEPOSITADA = 100;

void main()
{
    object oPC = GetPCSpeaker();
    int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
    nBalance += KPB_CANTIDAD_DEPOSITADA;

    int excedente = nBalance + KPB_CANTIDAD_DEPOSITADA - Goods_GetStandardTotalWealth(oPC);
    excedente = (excedente > 0) ? excedente : 0;
    // El impuesto es el 3% del excedente por encima de la fortuna estandar
    int impuesto = FloatToInt(excedente*0.03);

    if (impuesto > 0)
        SetCustomToken(99001, KPB_Bank_CONFIRMACION_IMPUESTO_PARTE1+IntToString(impuesto)+KPB_Bank_CONFIRMACION_IMPUESTO_PARTE2);
    else
        SetCustomToken(99001, KPB_Bank_CONFIRMACION_EXCENCION_IMPUESTO_PARTE1+IntToString(KPB_CANTIDAD_DEPOSITADA)+KPB_Bank_CONFIRMACION_EXCENCION_IMPUESTO_PARTE2);

    SetLocalInt(oPC, KPB_Bank_CANTIDAD_DEPOSITO_VAR, KPB_CANTIDAD_DEPOSITADA);
    SetLocalInt(oPC, KPB_Bank_IMPUESTO_VAR, impuesto);
}
