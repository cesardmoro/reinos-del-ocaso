
//////////////////////////////////////////
//:: FileName  av_spelltrack
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Include script for saving and restoring spell uses.

This is a bare-bones system which is NOT PERSISTENT over server restarts and
crashes, but could easily be converted to be so. A single parsed string stores
everything. Spells are saved on client leave and restored on client enter (just
include this script and call the appropriate functions). The strings are stored
as local data on the module and referenced by character ID (sID = Player Name +
Character Name). You must add this local string (sID) to each character on
enter before running the functions. You can also use the AVGetIsSpellCaster
function to bypass characters without spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Choirmaster
//:: Created On: 5/11/04
//:://////////////////////////////////////////////

#include "location_tools"
#include "muerte_inc"
//#include "ips_inc"
#include "inventario_inc"


int AVGetIsSpellCaster(object oPC)
{
    int nCount, nClass;
    for(nCount=1; nCount<=3; nCount++) {
        nClass = GetClassByPosition(nCount, oPC);
        //Paladins and Rangers don't have spells at low level, but it's not
        //really worth the effort adding the extra level check
        switch(nClass) {
            case CLASS_TYPE_BARD:
            case CLASS_TYPE_CLERIC:
            case CLASS_TYPE_DRUID:
            case CLASS_TYPE_PALADIN:
            case CLASS_TYPE_RANGER:
            case CLASS_TYPE_SORCERER:
            case CLASS_TYPE_WIZARD: return TRUE;
        }
    }
    return FALSE;
}

string AVRemoveStringToken(string sString, string sSep="|")
{
    int nPos=FindSubString(sString, sSep);

    if (nPos<0) return "";

    int nStrLen=GetStringLength(sString);
    nStrLen -= nPos + 1;
    return GetStringRight(sString, nStrLen);
}

string AVAddStringToken(string sString, string sTag, string sValue, string sSpacer="#", string sSep="|")
{
    if (sString=="") return sTag + sSpacer + sValue;
    return sString + sSep + sTag + sSpacer + sValue;
}

string AVGetStringToken(string sString, string sSep="|")
{
    int nPos = FindSubString(sString, sSep);
    if(nPos < 0) return sString;
    return GetStringLeft(sString, nPos);
}

int AVGetTokenIntTag(string sToken, string sSpacer="#")
{
    int nPos = FindSubString(sToken, sSpacer);
    return StringToInt(GetStringLeft(sToken, nPos));
}

int AVGetTokenIntValue(string sToken, string sSpacer="#")
{
    int nPos = FindSubString(sToken, sSpacer)+1;
    int nLength = GetStringLength(sToken);
    return StringToInt(GetSubString(sToken, nPos, nLength-nPos));
}

//OnClientEnter function
void AVRestoreSpells(object oPC)
{
    string sID = GetName(oPC);
    string sSpells = GetLocalString(GetModule(), "AVSS"+sID);

    int nSpell, nQty, nKnown;
    string sSpell;

    //break off if nothing is recorded (all spells restored on server reload)
    if (sSpells == "") return;

    //First remove all spells not recorded (prevents an exploit where a player
    //can change spells before exiting to have a full compliment on return).
   // for(nSpell=0; nSpeange spells before exiting to have a full compliment on return).
    for(nSpell=0; nSpell<550; nSpell++) {
        nKnown = GetHasSpell(nSpell, oPC);
        if(nKnown) {
            if(FindSubString(sSpells, IntToString(nSpell)+"#") == -1) {
                while(nKnown > 0) {
                    DecrementRemainingSpellUses(oPC, nSpell);
                    nKnown--;
                }
            }
        }
    }

    //Then decrement recorded spells to proper levels
    while(sSpells != "") {
        sSpell = AVGetStringToken(sSpells);
        nSpell = AVGetTokenIntTag(sSpell);
        nQty = AVGetTokenIntValue(sSpell);
        nKnown = GetHasSpell(nSpell, oPC);

        while(nKnown > nQty) {
            DecrementRemainingSpellUses(oPC, nSpell);
            nKnown--;
        }

        sSpells = AVRemoveStringToken(sSpells);
    }
    DeleteLocalString(GetModule(), "AVSS"+sID);
}

void Entradas_ajustarVida( object oPC )
{
    string sID = GetName(oPC);
    if(GetStringLength(sID))
        sID = GetStringLeft(sID, 25);
    int databaseHP = GetCampaignInt("Vidade","vida"+sID);
    int playerHP = GetCurrentHitPoints(oPC);

    //FloatingTextStringOnCreature(sID, oPC);
    //FloatingTextStringOnCreature(IntToString(databaseHP), oPC);
    if (databaseHP != playerHP && databaseHP != 0 && databaseHP > -11) {
        int iDanio = playerHP - databaseHP;
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDanio, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL), oPC);
    }
}

void Entradas_volver(object oPC)
{
    string sID = GetName(oPC);
    if(GetStringLength(sID) > 25)
        sID = GetStringLeft(sID, 25);

    string locationAreaTag = GetCampaignString("Lugares", "area" + sID);;
    if(locationAreaTag!="") {
        object locationArea = GetObjectByTag(locationAreaTag);
        if (locationArea != OBJECT_INVALID) {
            vector locationPosition = GetCampaignVector("Lugares", "vector" + sID);
            float locationFacing = GetCampaignFloat("Lugares", "mirando" + sID);
            location pjLocation = Location(locationArea, locationPosition, locationFacing);

            AssignCommand( oPC, Location_forcedJump( pjLocation ) );
        }
    }
}

void CambiosIPS_ajustarOro( object oPC );
void CambiosIPS_ajustarOro( object oPC )
{
    return; // esta operacion ha caducado
    /*
    if (GetCampaignInt(IPS_ADJUSTMENTS_DATABASE, "ORO_AJUSTADO", oPC)==FALSE) {
        //SendMessageToPC(oPC, "Ajustando tu oro...");

        int oroCargadoActual = GetGold(oPC);
        int oroBancoActual   = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
        int oroTotalActual   = oroCargadoActual + oroBancoActual;

        int oroFinal;
        if (oroTotalActual > 5000) {
            oroFinal = FloatToInt(5000 + pow(IntToFloat(oroTotalActual - 5000), 0.67));

            SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oroFinal, oPC);

            object quitador = GetLocalObject(GetModule(), Inventario_EFFECT_CREATOR);
            if (!GetIsObjectValid(quitador)) {
                quitador = GetObjectByTag("Inventario_effectCreator");
                SetLocalObject(GetModule(), Inventario_EFFECT_CREATOR, quitador);
            }
            AssignCommand(quitador, TakeGoldFromCreature(oroCargadoActual, oPC, TRUE));

            SendMessageToPC(oPC, "Se han ajustado tus recursos para equilibrarlos con el nuevo sistema.");
            SendMessageToPC(oPC, "Antes tenias "+IntToString(oroTotalActual)+" po y ahora tienes "+IntToString(oroFinal)+" po.");
            ExportSingleCharacter(oPC);
        }

        SetCampaignInt(IPS_ADJUSTMENTS_DATABASE, "ORO_AJUSTADO", TRUE, oPC);
    }
    */
}


