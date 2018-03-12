 #include "entradas"
#include "CIB_frente"
#include "deity_onlevel"
#include "prc_class_const"
#include "SPC_inc"
#include "muerte_inc"
#include "experience_inc"
#include "zep_inc_craft"
#include "reglasdelacasa"
#include "mod_inc"
#include "domains_inc"
#include "InvRed_inc"
#include "Skills_sinergy"
#include "DM_inc"
#include "Horses_inc"
#include "Phenos_inc"
#include "Speed_inc"
#include "dmfi_voice_inc"
#include "RdO_Races_inc"
#include "RdO_Clases_inc"
#include "FUW_inc"
#include "RCW_inc"
#include "XPW_inc"
#include "IPS_Pj_inc"
#include "Competencias_inc"
#include "Fly_inc"

// Prepara un personaje recien creado
void prepararPersonajeNivel1(object oPC);

// Le da a un DM todas las varitas que no posee
void darVaritas( object oDM );

void main()
{
    object oPC  = GetEnteringObject();
    string sCDK = GetPCPublicCDKey(oPC);
    string sCd  = GetPCPublicCDKey(oPC);
    string sIP  = GetPCIPAddress(oPC);

    if( GetLocalInt( GetModule(), Mod_IS_PC_INITIALIZED_REF_PREFIX + GetName(oPC) ) ) {
        string mensaje = "Mod_onEnter: error. Por favor avizar a Inquisidor si sale este mensajeves. No sirve el mecanismo que determia si el PJ esta inicializado";
        WriteTimestampedLogEntry( mensaje );
        SendMessageToAllDMs( mensaje );
        SendMessageToPC( oPC, mensaje );
    }
    SetLocalInt( GetModule(), Mod_IS_PC_INITIALIZED_REF_PREFIX + GetName(oPC), TRUE ); // ver Mod_inc
    SetLocalInt( oPC, Mod_ON_PC_ENTERS_WORLD_LATCH, TRUE ); // ver Mod_inc y Mod_onWorldEnter

    // Control de intercambio de bienes
    CIB_onClientEnter( oPC );
    
    if( GetIsPC(oPC) && !GetIsDM(oPC) ) {

        WriteTimestampedLogEntry(sIP);
        WriteTimestampedLogEntry(GetPCPlayerName(oPC));

        // Modificado por Inquisidor BEGIN:
        // Junte todo lo que hace boot a PJs, lo movi acá al comienzo, y le agregue la instruccion return.
        // Patea las cuentas de la Beta y los PJs nuevos con nombre igual a uno existente
        // Trasladé el control de XP de acá al gate (area de inicio). Ver "gatein" y "gateout"
        if(
            GetStringLeft(GetPCPlayerName(oPC), 4) == "BETA"
            || (GetXP(oPC)==0 && GetCampaignInt("XP", "Xp", oPC) != 0)  // esto se cumple si entra con un nuevo PJ con el mismo nombre que otro existente
            || FindSubString(GetName(oPC), "'") >= 0 // patea a todos los que tengan una comilla simple en el nombre
            || FindSubString(GetName(oPC), GetStringByStrRef(16777316)) >= 0 // patea a todos los que tengan una comilla doble en el nombre
        ) {
            BootPC(oPC);
            return;
        }
        // Modificado por Inquisidor END

        if((GetCampaignInt("Nordock", "SEGURIDAD", oPC) != 0) && (GetCampaignInt("Nordock", "SEGURIDAD", oPC) != 1))
            SetCampaignInt("Nordock", "SEGURIDAD", 0, oPC);

        if((sCd != GetCampaignString("Nordock", "CDKEY", oPC)) && (1 == GetCampaignInt("Nordock", "SEGURIDAD", oPC))) {
            SendMessageToAllDMs(sCd+" "+sIP);
            SendMessageToAllDMs("Anoten eso intento meterse ilegalmente");
            WriteTimestampedLogEntry(sCd+" "+sIP+" "+"ENTRADA ILEGAL");
            if (GetIsObjectValid(oPC)) BootPC(oPC);
        }

        // Iniciar el LetoScript
        Leto_onEnter( oPC );

        // Esto impide problemas con el inventario reducido al momento exacto de loguear
        // (Al loguear se adquieren todos los items de golpe y eso a veces genera perdida de items)
        InventarioReducido_onEnter(oPC);

        // Control anti duplicacion de items del CEP
        ZEP_PurifyAllItems(oPC, TRUE, TRUE);

        // Realmente no sé si es necesario (by drago) dado que tengo la impresion de que cualquiera que entre, entra sin Plot
        SetPlotFlag(oPC, FALSE);

        // Subrazas y razas
        Races_onEnter( oPC );
        // Mueve con el leto los puntos de las habilidades deshabilitadas a los puntos libres
        RdlC_recuperarSkillsDeshabilitadas( oPC );
        // Aplica penas a las habilidades deshabilitadas para que los jugadores no las usen
        //RdlC_AplicarPenasASkillsDeshabilitadas( oPC );
        // Entrega ciertas dotes gratis como los estilos de combate
        RdlC_entregarDotesGratuitas( oPC );

        // quitar permiso de quite de Items malditos que pudo haber quedado despues de una caida del servidor.
        IPS_Pj_onModuleEnter( oPC );

        // Si un personaje es recien creado, se lo prepara
        if (GetXP(oPC) == 0)
            prepararPersonajeNivel1(oPC);

        DestroyObject(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC), 0.0);

        // Ajuste de Disciplina
        // Se retrasa para darle tiempo al PRC de crear la nueva piel dado que le agrega una propiedad de item
        DelayCommand(3.0, Skills_ajustarDisciplina( oPC ));
        // Persistencia de los conjuros
        AVRestoreSpells(oPC);
        // reglas de la casa
        RdlC_onEnter(oPC);

        // persistencia de la vida
        //Entradas_AjusteDeVida_onClientEnter( oPC );   // se reemplazó por la funcionalidad de "Mod_onWorldEnter"

        string sID = GetName(oPC);
        if(GetStringLength(sID) > 0)
            sID = GetStringLeft(sID, 25);

        // Destruye la copia del PJ
        DestroyObject(GetLocalObject(GetModule(), sID));

        // Comienza el heartbeat.
        DelayCommand(30.0, ExecuteScript("heartbeat_pj", oPC));

      //  if( GetCampaignInt("PVP", "Assasin", oPC)==1)
        //    SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 0, oPC);
        //Si la copia Deslogue del personaje fue asesinada, matar al pj
        if(GetCampaignInt("delogs", "muerto" + sID) == 1)
            DelayCommand(3.0, ExecuteScript("matarpj", oPC));

        //Nota por dragoncin: esto se pisa con otros sistemas
        //Lo desactivo hasta que tenga algun sentido
        //if(GetLocalInt(GetModule(), "traer"+sID) == 1)
        //    DelayCommand(3.0, ExecuteScript("traerpj", oPC));

        /* Desactivado hasta que se implemente todo el control
        //Inicializacion del control de alineamientos
        if(GetCampaignInt("alin", "GE"+sID) == 0) {
            SetCampaignInt("alin" , "GE"+sID, GetAlignmentGoodEvil(oPC));
            SetCampaignInt("alin" , "LC"+sID, GetAlignmentLawChaos(oPC));
        }*/

        PhenoTypes_onEnter( oPC );
        Tails_onEnter( oPC );
        Wings_onEnter( oPC );

        Horses_onClientEnter( oPC );

        // Ajusta la reputacion de los druidas
        if(!(GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0)) {
            AdjustReputation(oPC, GetObjectByTag("Osos"),-100);
            //SendMessageToPC(oPC ,IntToString(GetReputation(GetObjectByTag("Osos"), oPC)));
            AdjustReputation(oPC, GetObjectByTag("Animales"),-100);
            AdjustReputation(oPC, GetObjectByTag("Felinos"),-100);
            AdjustReputation(oPC, GetObjectByTag("Serpientes"),-100);
            AdjustReputation(oPC, GetObjectByTag("Alimanias"),-100);
            //AdjustReputation(oPC, GetObjectByTag("Druida"),-48);
            //SendMessageToPC(oPC ,IntToString(GetReputation(GetObjectByTag("Druida"), oPC)));
        }

        // Entrega de items basicos a cada jugador
        if(!GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_pc_emote")))
            CreateItemOnObject("dmfi_pc_emote", oPC);
        if(!GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_pc_dicebag")))
            CreateItemOnObject("dmfi_pc_dicebag", oPC);
        if(!GetIsObjectValid(GetItemPossessedBy(oPC,"SEGURIDAD")))
            CreateItemOnObject("it_mthnmis002", oPC);
        if(!GetIsObjectValid(GetItemPossessedBy(oPC,"SEGURIDAD2")))
            CreateItemOnObject("it_mthnmis003", oPC);
        if(!GetIsObjectValid(GetItemPossessedBy(oPC,"summon")))
            CreateItemOnObject("summon", oPC);
        if(!GetIsObjectValid(GetItemPossessedBy(oPC,"meditar")))
            CreateItemOnObject("meditar", oPC);
        if(!GetIsObjectValid(GetItemPossessedBy(oPC,CIB_Oro_racionador_RR)))
            CreateItemOnObject(CIB_Oro_racionador_RR, oPC);
        string languageTag = "hlslang_"+IntToString(GetDefaultRacialLanguage(oPC, FALSE));
        if(!GetIsObjectValid(GetItemPossessedBy(oPC, languageTag)))
            CreateItemOnObject(languageTag, oPC);
        if(!GetIsObjectValid(GetItemPossessedBy(oPC, "hlslang_8")) && GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0)
            CreateItemOnObject("hlslang_8", oPC);
        if(!GetIsObjectValid(GetItemPossessedBy(oPC, "hlslang_9")) && GetLevelByClass(CLASS_TYPE_ROGUE, oPC) > 0)
            CreateItemOnObject("hlslang_9", oPC);
        if(!GetIsObjectValid(GetItemPossessedBy(oPC, "RDO_TUTORIAL")))
            CreateItemOnObject("rdo_tutorial_1", oPC);

        //Recupera la experiencia temporaria guardada en la base de datos
        SisPremioCombate_onPjEnterModule( oPC );

        // Aplica las sinergias entre skills
        Skills_Sinergy_applyGeneralSinergies( oPC );

        Domains_applyDomainPowers(oPC);
        RdO_Classes_onEnter( oPC );

        CambiosIPS_ajustarOro(oPC);

        Fly_onClientEnter( oPC );

        //Retrasado para que este seteada la piel
        DelayCommand(0.3, Competencias_onEnter(oPC));

        DelayCommand(4.0, Idiomas_accionAprenderNuevosIdiomas( oPC ));

    } else if (GetIsDM(oPC)) {

        if (!GetIsAllowedDM(oPC)) {
            if (GetIsObjectValid(oPC)) BootPC(oPC);
            WriteTimestampedLogEntry(sCd+" "+sIP+" "+"ENTRA ILEGAL DE DM");
            SendMessageToAllDMs(sCd+" "+sIP+" "+"ENTRA ILEGAL DE DM");
        }

        darVaritas( oPC );

    }

    // Inicio del sistema de muerte
    // Borra los cuerpos que tenga oPC
    Muerte_destruirCuerposCargados(oPC);

    ExecuteScript("prc_onenter", oPC);
}

void prepararPersonajeNivel1( object oPC )
{
       // Set the integer for stripping once
        SetLocalInt(oPC, "stripped", 1);

        /*Remove Gold   -   Default at destroy all*/

        TakeGoldFromCreature(GetGold(oPC), oPC, TRUE);

        /*Remove XP or give XP  -Default at 0
        To give XP: levels are the following:
        LVL 1:  0           LVL 11: 55000       LVL 21: 210000
        LVL 2:  1000        LVL 12: 66000       LVL 22: 231000
        LVL 3:  3000        LVL 13: 78000       LVL 23: 253000
        LVL 4:  6000        LVL 14: 91000       LVL 24: 276000
        LVL 5:  10000       LVL 15: 105000      LVL 25: 300000
        LVL 6:  15000       LVL 16: 120000      LVL 26: 325000
        LVL 7:  21000       LVL 17: 136000      LVL 27: 351000
        LVL 8:  28000       LVL 18: 153000      LVL 28: 378000
        LVL 9:  36000       LVL 19: 171000      LVL 29: 406000
        LVL 10: 45000       LVL 20: 190000      LVL 30: 435000*/
        //Change the 0 in anything

        int nivelInicial = 3 - CalculateSubRaceLevelAdjustment(oPC);
        int xpInicial = nivelInicial * (nivelInicial-1) * 1000 / 2;
        if (xpInicial <= 0) xpInicial = 1;

        if (GetLocalInt(oPC, STOP_ON_ENTER_STUFF)==FALSE)
        {
            Experience_poner( oPC, xpInicial );
            GiveGoldToCreature(oPC, 4000);
        }

        // ALIGNMENT_EVIL
        // ALIGNMENT_LAWFUL
        /// ALIGNMENT_CHAOTIC
        // ALIGNMENT_GOOD
        //  ALIGNMENT_NEUTRAL

        if (GetPhenoType(oPC)==PHENOTYPE_BIG)
            SetNaturalPhenoType(PHENOTYPE_BIG, oPC);

        /*Destroy all items on the PC   -   Default destroys everything*/

        //Chest item
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), 0.0);
        //Creature armor item. Might not be necesarry but is possibly equiped.
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC), 0.0);
        //Arms item
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC), 0.0);
        //Left hand item
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), 0.0);
        //Lef hand ring item
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC), 0.0);
        //Right hand item
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), 0.0);
        //Right hand ring item
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC), 0.0);
        //Neck item
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_NECK, oPC), 0.0);
        //Head item
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC), 0.0);
        //Creaure weapon item bite. Might not be necesarry but is possibly equiped.
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC), 0.0);
        //Creaure weapon item left hand. Might not be necesarry but is possibly equiped.
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC), 0.0);
        //Creaure weapon item right hand. Might not be necesarry but is possibly equiped.
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC), 0.0);
        //Cloak item
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC), 0.0);
        //Belt item
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_BELT, oPC), 0.0);
        //Arrows item
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC), 0.0);
        //Bolts item
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC), 0.0);
        //Bullets item
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC), 0.0);
        //Boots item
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC), 0.0);

        /*Create items on the PC. Put the resref in the commands.*/

 /*       //Chest item
        object oChest = CreateItemOnObject("resref", oPC, 1);
        //Arms item
        object oArms = CreateItemOnObject("resref", oPC, 1);
        //Right hand item
        object oRightHand = CreateItemOnObject("resref", oPC, 1);
        //Right hand ring item
        object oRightRing = CreateItemOnObject("resref", oPC, 1);
        //Left hand item
        object oLeftHand = CreateItemOnObject("resref", oPC, 1);
        //Left hand ring item
        object oLeftRing = CreateItemOnObject("resref", oPC, 1);
        //Cloak item
        object oCloak = CreateItemOnObject("resref", oPC, 1);
        //Neck item
        object oNeck = CreateItemOnObject("resref", oPC, 1);
        //Head item
        object oHead = CreateItemOnObject("resref", oPC, 1);
        //Boots item
        object oBoots = CreateItemOnObject("resref", oPC, 1);
        //Arrows item
        object oArrows = CreateItemOnObject("resref", oPC, 99);
        //Bolts item
        object oBolts = CreateItemOnObject("resref", oPC, 99);
        //Bullets item
        object oBullets = CreateItemOnObject("resref", oPC, 99);
        //Creature bite item
        object oCBite = CreateItemOnObject("resref", oPC, 1);
        //Creature left hand item
        object oCLeft = CreateItemOnObject("resref", oPC, 1);
        //Creature right hand item
        object oCRight = CreateItemOnObject("resref", oPC, 1);
        //Creatue armour
        object oCArmour = CreateItemOnObject("resref", oPC, 1);
        //Belt item
        object oBelt = CreateItemOnObject("resref", oPC, 1);

        // Equip items on the PC

        //Equip chest item
        AssignCommand(oPC, ActionEquipItem(oChest, INVENTORY_SLOT_CHEST));
        //Equip arms item
        AssignCommand(oPC, ActionEquipItem(oArms, INVENTORY_SLOT_ARMS));
        //Equip right hand item
        AssignCommand(oPC, ActionEquipItem(oRightHand, INVENTORY_SLOT_RIGHTHAND));
        //Equip right hand ring item
        AssignCommand(oPC, ActionEquipItem(oRightRing, INVENTORY_SLOT_RIGHTRING));
        //Equip left hand item
        AssignCommand(oPC, ActionEquipItem(oLeftHand, INVENTORY_SLOT_LEFTHAND));
        //Equip left hand ring item
        AssignCommand(oPC, ActionEquipItem(oLeftRing, INVENTORY_SLOT_LEFTRING));
        //Equip cloak item
        AssignCommand(oPC, ActionEquipItem(oCloak, INVENTORY_SLOT_CLOAK));
        //Equip neck item
        AssignCommand(oPC, ActionEquipItem(oNeck, INVENTORY_SLOT_NECK));
        //Equip head item
        AssignCommand(oPC, ActionEquipItem(oHead, INVENTORY_SLOT_HEAD));
        //Equip boots item
        AssignCommand(oPC, ActionEquipItem(oBoots, INVENTORY_SLOT_BOOTS));
        //Equip arrows
        AssignCommand(oPC, ActionEquipItem(oArrows, INVENTORY_SLOT_ARROWS));
        //Equip bolts
        AssignCommand(oPC, ActionEquipItem(oBolts, INVENTORY_SLOT_BOLTS));
        //Equip bullets
        AssignCommand(oPC, ActionEquipItem(oBullets, INVENTORY_SLOT_BULLETS));
        //Equip creature bite item
        AssignCommand(oPC, ActionEquipItem(oCBite, INVENTORY_SLOT_CWEAPON_B));
        //Equip creature left hand item
        AssignCommand(oPC, ActionEquipItem(oCLeft,INVENTORY_SLOT_CWEAPON_L));
        //Equip creature right hand item
        AssignCommand(oPC, ActionEquipItem(oCRight, INVENTORY_SLOT_CWEAPON_R));
        //Equip creature armour item
        AssignCommand(oPC, ActionEquipItem(oCArmour, INVENTORY_SLOT_CARMOUR));
        //Equip belt item
        AssignCommand(oPC, ActionEquipItem(oBelt, INVENTORY_SLOT_BELT));
        */

        // Destroy all inventory items

        object oDestroy = GetFirstItemInInventory(oPC);

        while (oDestroy != OBJECT_INVALID)
        {
            DestroyObject(oDestroy, 0.0);

            oDestroy = GetNextItemInInventory(oPC);
        }


         // AGREGADO POR DRAGONCIN: chequeos de deidad.
        // Before checking oPC, make sure oPC's deity is in standard form.
        StandardizeDeityName(oPC);

        // Check the restrictions for clerics based on their deities.
        // This will warn new clerics if they will not be able to advance.
        CheckDeityRestrictions(oPC);

        // Accept oPC's current level.
        DeityRestrictionsPostLevel(oPC);
}

void darVaritas( object oPC )
{
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_afflict"))==FALSE)
        CreateItemOnObject("dmfi_afflict", oPC);
    // Give DM's a DMHelper in inventory
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_dmw"))==FALSE)
        CreateItemOnObject("dmfi_dmw", oPC);
    // Give DM's a FXWand in inventory
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_fx"))==FALSE)
        CreateItemOnObject("dmfi_fx", oPC);
    // Give DM's a DiceBag in inventory
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_dicebag"))==FALSE)
        CreateItemOnObject("dmfi_dicebag", oPC);
    // Give DM's a Emote Wand in inventory
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_emote"))==FALSE)
        CreateItemOnObject("dmfi_emote", oPC);
    // Give DM's a Encounter Wand in inventory
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_encounter"))==FALSE)
        CreateItemOnObject("dmfi_encounter", oPC);
    // Give DM's a Faction Wand in inventory
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_faction"))==FALSE)
        CreateItemOnObject("dmfi_faction", oPC);
    // Give DM's a Music Wand in inventory
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_music"))==FALSE)
        CreateItemOnObject("dmfi_music", oPC);
    // Give DM's a Sound Wand in inventory
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_sound"))==FALSE)
        CreateItemOnObject("dmfi_sound", oPC);
    // Give DM's a Voice Wand in inventory
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_voice"))==FALSE)
        CreateItemOnObject("dmfi_voice", oPC);
    // Give DM's a Xp Wand in inventory
//    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_xp"))==FALSE)
//        CreateItemOnObject("dmfi_xp", oPC);
    // Give DM's a Party 500 XP Wand in inventory
//    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_500xp"))==FALSE)
//        CreateItemOnObject("dmfi_500xp", oPC);
    // Give DM's a Exploder Widget Wand in inventory
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_exploder"))==FALSE)
        CreateItemOnObject("dmfi_exploder", oPC);
    // Give DM's a Ditto Encounter Wand in inventory
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_en_ditto"))==FALSE)
        CreateItemOnObject("dmfi_en_ditto", oPC);
    // Give DM's a Mute all NPC'S Widget in inventory
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_mute"))==FALSE)
        CreateItemOnObject("dmfi_mute", oPC);
    // Give DM's a Stop Combat Widget in inventory
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_peace"))==FALSE)
        CreateItemOnObject("dmfi_peace", oPC);
    // Give DM's a Voice Widget in inventory
    if(GetIsObjectValid(GetItemPossessedBy(oPC,"dmfi_voicewidget"))==FALSE)
        CreateItemOnObject("dmfi_voicewidget", oPC);
    // Dar al DM la barita de control de spawn (Random Spawn DM Control Wand).
     if(GetIsObjectValid(GetItemPossessedBy(oPC,"RS_DMC_wand"))==FALSE)
         CreateItemOnObject("rs_dmc_wand", oPC);
    // Give DM's a Freeze Area wand
     if(GetIsObjectValid(GetItemPossessedBy(oPC, FUW_freeze_TAG ))==FALSE)
         CreateItemOnObject(FUW_freeze_RN, oPC);
    // Give DM's a Unfreeze Area wand
     if(GetIsObjectValid(GetItemPossessedBy(oPC, FUW_unfreeze_TAG ))==FALSE)
         CreateItemOnObject(FUW_unfreeze_RN, oPC);
    // Give DM's a Reputaton Control Wand
     if(GetIsObjectValid(GetItemPossessedBy(oPC, RCW_item_TAG ))==FALSE)
         CreateItemOnObject(RCW_item_RN, oPC);
    // Give DM's a Reputaton Control Wand
     if(GetIsObjectValid(GetItemPossessedBy(oPC, XPW_item_TAG ))==FALSE)
         CreateItemOnObject(XPW_item_RN, oPC);

    // destruir varita de XP del dmfi
     object dmfi_xp = GetItemPossessedBy( oPC, "dmfi_xp" );
     if( GetIsObjectValid( dmfi_xp ) )
        DestroyObject( dmfi_xp );
}

