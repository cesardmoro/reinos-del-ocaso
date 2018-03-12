#include "kpb_inc"
#include "goods_inc"

void main()
{
    object oPC = GetPCSpeaker();

    int deposito = GetGold(oPC);
    int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
    nBalance += deposito;

    int excedente = nBalance + deposito - Goods_GetStandardTotalWealth(oPC);
    excedente = (excedente > 0) ? excedente : 0;
    // El impuesto es el 3% del excedente por encima de la fortuna estandar
    int impuesto = FloatToInt(excedente*0.03);

    if (impuesto > 0)
        SetCustomToken(99001, KPB_Bank_CONFIRMACION_IMPUESTO_PARTE1+IntToString(impuesto)+KPB_Bank_CONFIRMACION_IMPUESTO_PARTE2);
    else
        SetCustomToken(99001, KPB_Bank_CONFIRMACION_EXCENCION_IMPUESTO_PARTE1+IntToString(deposito)+KPB_Bank_CONFIRMACION_EXCENCION_IMPUESTO_PARTE2);

    SetLocalInt(oPC, KPB_Bank_CANTIDAD_DEPOSITO_VAR, deposito);
    SetLocalInt(oPC, KPB_Bank_IMPUESTO_VAR, impuesto);
}
