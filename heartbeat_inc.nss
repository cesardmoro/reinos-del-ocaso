///////////////////////////////////////////////////////////////////////////////
// HeartBeat
// Script by Zero
// Emprolijado y anotado por Dragoncin
//
// Scripts que incluyen a este:
// - heartbeat_pj
//////////////////////////////////////////////////////////////////////////////

#include "pct_obj_inc"
#include "Horses_inc"

// Esta funcion debe llamarse desde el evento OnClientEnter
void heartbeat_onClientEnter( object oPC );

// Guarda en la base de datos la vida del personaje
void heartbeat_controlVida( object oPC, string sID )
{
    int hp = GetCurrentHitPoints(oPC);
    if (hp > -10)
        SetLocalInt(oPC, "vida", hp);
}

void heartbeat_controlLugar( object oPC, string sID )
{
    string tagAreaPJ = GetTag(GetArea(oPC));
    if ((tagAreaPJ != "inicio") && !(GetStringLeft(tagAreaPJ, 9) == "AreaCarpa")) {
        /* Dado que el acceso a la base de datos es lento, es mejor guardar
        esto como variables locales y escribir la base de datos unicamente
        en el evento OnClientLeave */
        SetLocalLocation(oPC, "locacionPC", GetLocation(oPC));
    }
}


void heartbeat_aplicarEfectos( object oPC )
{
    int iInteligencia = GetAbilityScore(oPC, ABILITY_INTELLIGENCE);
    int iSabiduria = GetAbilityScore(oPC, ABILITY_WISDOM);

    if(iInteligencia < 4)
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),oPC);
    else if(iInteligencia < 5)
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectSleep(),oPC, 10.0);
    else if(iInteligencia < 6)
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(),oPC, 10.0);

    if(iSabiduria < 5)
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(),oPC, 10.0);
    else if(iSabiduria < 6)
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(),oPC, 10.0);
}

void heartbeat_sangrado(object oPC)
{
    int maxHP = GetMaxHitPoints(oPC);
    int playerHP = GetCurrentHitPoints(oPC) * 100;
    if (maxHP != 0) {
        if((playerHP/maxHP) < 25) {
            object oSangre = CreateObject(OBJECT_TYPE_PLACEABLE, "sangre"+IntToString(d4(1)), GetLocation(oPC), FALSE);
            DestroyObject(oSangre, 60.0);
        }
    }
}

void heartbeat_controlAlineamientos( object oPC, string sID )
{
    // El control de cambio de alineamientos NO debe ocurrir tan seguido.
    // Con ejecutarse al dormir, al entrar al módulo y al subir de nivel alcanza
    // Tambien hay que hacer una varita para que los DMs Control aprueben el cambio.

    //if(GetCampaignInt("alin" , "GE"+sID) != GetAlignmentGoodEvil(oPC))
        // AssignCommand(oPC, ActionJumpToLocation(GetLocation(GetObjectByTag("Chekeo"))));

    //if(GetCampaignInt("alin" , "LC"+sID) != GetAlignmentLawChaos(oPC))
        // AssignCommand(oPC, ActionJumpToLocation(GetLocation(GetObjectByTag("Chekeo"))));
}

void heartbeat_adminPcExportation() {
    if( GetLocalInt( OBJECT_SELF, "isExportPending" ) ) {
        SetLocalInt( OBJECT_SELF, "isExportPending", FALSE );
        ExportSingleCharacter( OBJECT_SELF );
    }
}

void heartbeat_ejecutar() {
    object oPC = OBJECT_SELF;
    if ( GetIsObjectValid(oPC) ) { // el if es al pedo pero por las dudas.
        DelayCommand(6.0, heartbeat_ejecutar()); // movido al comienzo por las dudas haya algun error ocacional.

        string sID = GetName(oPC);
        if(GetStringLength(sID))
            sID = GetStringLeft(sID, 25);

        heartbeat_controlVida(oPC, sID);
        heartbeat_controlLugar(oPC, sID);
        heartbeat_aplicarEfectos(oPC);
        heartbeat_sangrado(oPC);
        //heartbeat_controlAlineamientos(oPC, sID);
        heartbeat_adminPcExportation();

        PerceptionSys_playerHandler();

        Horses_onHeartBeat( oPC );
    }
}
