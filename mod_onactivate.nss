/////////////////////////////////////////
//:: Example XP2 OnActivate Script Script
//:: x2_mod_def_act
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
Put into: OnItemActivate Event

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "Vendas_inc"
#include "RS_DMC_onActivat"
#include "CIB_Oro"
#include "IPS_inc"
#include "VNNPC_inc"
#include "scanner"
#include "deity_onload"
#include "drogas_inc"
#include "Horses_inc"
#include "FUW_inc"
#include "RCW_inc"
#include "XPW_inc"
#include "DeadMagic_inc"
#include "ClericCtrl_inc"
#include "Carpas_inc"
#include "Mensajeria_inc"
#include "DMSpy_inc"
#include "VolumeCtrl_inc"
#include "TorreOrvin_inc"

void main()
{
    object activatedItem = GetItemActivated();
    object itemActivator = GetItemActivator();
    object targetedObject = GetItemActivatedTarget();
    location targetLocation = GetItemActivatedTargetLocation();
    string activatedItemTag = GetTag( activatedItem );
    string activatedItemResRef = GetResRef( activatedItem );
    string itemActivatorId = GetStringLeft( GetName(itemActivator), 10 );
    int activadorEsDM = GetIsDM( itemActivator );

    if( activatedItemResRef == "vendas" )
        Vendas_onActivate();

    else if (activatedItemTag==Horses_TOOL_TAG)
    ¨   Horses_onItemActivate(itemActivator, targetedObject);
    else if( activatedItemResRef == "ips_magnifyglass" ) {
        if( GetIsObjectValid( targetedObject ) )
        IPS_Subject_onInspectItem( itemActivator, targetedObject );
    }
    else if(activatedItemTag == "meditar")
        ExecuteScript("meditar", itemActivator);

    else if( activatedItemResRef == CIB_Oro_racionador_RR )
        CIB_Oro_onActivate();

    else if(
           GetStringLeft(activatedItemTag, 5) == "dmfi_"
        || GetStringLeft(activatedItemTag, 8) == "hlslang_"
    ) {
        SetLocalObject(itemActivator, "dmfi_item", activatedItem);
        SetLocalObject(itemActivator, "dmfi_target", targetedObject);
        SetLocalLocation(itemActivator, "dmfi_location", targetLocation);
        ExecuteScript("dmfi_activate", itemActivator);
    }
    else if( activatedItemResRef == "rs_dmc_wand" )
        RS_DMC_onActivate();
    else if( activatedItemResRef == FUW_freeze_RN )
        FUW_onFreezeActivated( activatedItem, itemActivator );
    else if( activatedItemResRef == FUW_unfreeze_RN )
        FUW_onUnfreezeActivated( activatedItem, itemActivator );
    else if( activatedItemResRef == RCW_item_RN )
        RCW_onActivated( activatedItem, itemActivator, targetedObject, targetLocation );

    // Varita Examinadora de Personajes
    // Por ahora solo devuelve la deidad del personaje. Mas adelante le pondre mas habilidades.
    else if ((activatedItemTag=="dmc_examinepc_wand") && activadorEsDM) {
        SendMessageToPC(itemActivator, GetDeity(targetedObject));
    }

    // Varita de morfosis - permite el cambio de distintas partes de la apariencia de una criatura
    // Si el objetivo de la varita no es una criatura, envia un mensaje de error. Si lo es, empieza el dialogo.
    else if ((activatedItemTag=="dmc_morfosis_wand") && activadorEsDM) {
        if (GetObjectType(targetedObject)==OBJECT_TYPE_CREATURE) {
            SetLocalObject(itemActivator, "oTargetCreature", targetedObject);
            AssignCommand(itemActivator, ActionStartConversation(OBJECT_SELF, "dmfi_morfosis", TRUE, FALSE));
        } else {
            SendMessageToPC(itemActivator, "Debes seleccionar una criatura");
        }
    }

    // Ocasionalmente las variables de modulo del sistema de panteones se borran. Esta varita las vuelve a generar.
    else if ((activatedItemTag=="dmc_panteonrestart") && activadorEsDM) {
        InitializePantheon();
        SendMessageToPC(itemActivator, "Se reinicia el sistema de panteones");
    }

    // Varita de Suenio - permite prohibir el suenio de un party
    // Si el objetivo no es un pj, envia un mensaje de error. Si lo es, cambia la variable DMNoPermiteDormir.
    else if ((activatedItemTag=="dmc_sleep_wand") && activadorEsDM) {
        if (GetIsPC(targetedObject)) {
            object oFirstPC = GetFirstFactionMember(targetedObject, TRUE);
            int iSuenioInt = GetLocalInt(oFirstPC, "DMNoPermiteDormir");
            if (iSuenioInt == 0) {
                iSuenioInt = 1;
                SendMessageToPC(itemActivator, "Se ha prohibido dormir al party de "+GetName(targetedObject));
            } else {
                iSuenioInt = 0;
                SendMessageToPC(itemActivator, "Se ha permitido dormir al party de "+GetName(targetedObject));
            }
            while (oFirstPC!=OBJECT_INVALID) {
                SetLocalInt(oFirstPC, "DMNoPermiteDormir", iSuenioInt);
                oFirstPC = GetNextFactionMember(oFirstPC, TRUE);
            }
        } else {
            SendMessageToPC(itemActivator, "Debes seleccionar un Personaje Jugador");
        }
    }
    else if (activatedItemTag=="dmc_appear")
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectAppear(), targetedObject);

    //Varita Nombradora de PNJs
    else if (activatedItemTag=="vnnpc_wand")
        VNNPC_onActivateItem();

    // Varita de Areas de Magia Muerta
    else if (activatedItemResRef == MagiaMuerta_itemResRef_RN && activadorEsDM)
        MagiaMuerta_onActivateItem( itemActivator );

    // Varita de Control de Clerigos
    else if (activatedItemResRef == ClericControl_itemResRef_RN && activadorEsDM)
        ClericControl_onActivateItem( itemActivator, targetedObject );

    else if ( activatedItemResRef == DMSpy_dmWand_RN && activadorEsDM ) {
        DMSpy_onWandActivate( itemActivator, targetedObject );
    } else if ( activatedItemResRef == VolumeControl_dmWand_RN && activadorEsDM ) {
        VolumeControl_onWandActivate( itemActivator, targetedObject );
    }

    else if (activatedItemResRef == Carpas_carpaItemResRef_RN)
        Carpas_onActivate( itemActivator, targetLocation, activatedItem, targetedObject );

    else if (activatedItemTag=="leno2")
        ExecuteScript("leno", activatedItem);

    else if(activatedItemTag == "summon")
        AssignCommand(itemActivator, ActionStartConversation(OBJECT_SELF, "summon", TRUE, FALSE));

    else if(GetName(activatedItem) == "Runa sin usar") {
        SetCampaignString("Teleport", "loct"+itemActivatorId+GetStringLeft(GetName(GetArea(itemActivator)),15), GetTag(GetArea(itemActivator)), GetModule());
        SetCampaignVector("Teleport", "locv"+itemActivatorId+GetStringLeft(GetName(GetArea(itemActivator)),15), GetPositionFromLocation(GetLocation(itemActivator)), GetModule());
        SetCampaignFloat("Teleport", "locf"+itemActivatorId+GetStringLeft(GetName(GetArea(itemActivator)),15), GetFacing(itemActivator), GetModule());

        SetName(activatedItem, GetName(GetArea(itemActivator)));
    }
    else if(activatedItemTag == "Runa") {
        SetCampaignLocation("Teleport", "loc", Location(GetObjectByTag(GetCampaignString("Teleport", "loct"+itemActivatorId+GetStringLeft(GetName(activatedItem),15), GetModule())), GetCampaignVector("Teleport", "locv"+itemActivatorId+GetStringLeft(GetName(activatedItem),15), GetModule()), GetCampaignFloat("Teleport", "locf"+itemActivatorId+GetStringLeft(GetName(activatedItem),15), GetModule())), itemActivator);
        SendMessageToPC(itemActivator, "Runa activada");
    }
    else if(activatedItemTag == "Droga1") {
        drogas_SmokePipe(targetedObject);

        SetLocalInt(targetedObject, "Sobredosis", GetLocalInt(targetedObject, "Sobredosis")+d2(1));
        if(GetLocalInt(targetedObject, "Sobredosis") > GetAbilityModifier(ABILITY_CONSTITUTION, targetedObject)+10)
        {
            FloatingTextStringOnCreature("La sobredosis termina con tu vida", targetedObject, TRUE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),targetedObject);
            return;
        }
        int nTime = d6(1);
        effect eDroga1 = EffectSavingThrowIncrease(SAVING_THROW_WILL,4, SAVING_THROW_TYPE_FEAR);
        effect eDroga2 = EffectSavingThrowIncrease(SAVING_THROW_FORT,4, SAVING_THROW_TYPE_DEATH);
        //effect eDroga1N = EffectSavingThrowDecrease(SAVING_THROW_WILL,4, SAVING_THROW_TYPE_FEAR);
        //effect eDroga2N = EffectSavingThrowDecrease(SAVING_THROW_FORT,4, SAVING_THROW_TYPE_DEATH);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga1, targetedObject, TurnsToSeconds(nTime));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga2, targetedObject, TurnsToSeconds(nTime));
        //DelayCommand(TurnsToSeconds(nTime), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga1N, targetedObject, TurnsToSeconds(nTime)));
        //DelayCommand(TurnsToSeconds(nTime), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga2N, targetedObject, TurnsToSeconds(nTime)));
    }
    else if(activatedItemTag == "Droga2") {
        drogas_SmokePipe(targetedObject);
        SetLocalInt(targetedObject, "Sobredosis", GetLocalInt(targetedObject, "Sobredosis")+d4(1));
        if(GetLocalInt(targetedObject, "Sobredosis") > GetAbilityModifier(ABILITY_CONSTITUTION, targetedObject)+10)
        {
            FloatingTextStringOnCreature("La sobredosis termina con tu vida", targetedObject, TRUE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),targetedObject);
            return;
        }
        int nTime = d6(1);
        effect eDroga1 = EffectAbilityIncrease(ABILITY_STRENGTH,2);
        effect eDroga2 = EffectAbilityIncrease(ABILITY_CHARISMA,1);
        effect eDroga1N = EffectAbilityDecrease(ABILITY_WISDOM,2);
        effect eDroga2N = EffectSavingThrowDecrease(SAVING_THROW_WILL,2, SAVING_THROW_TYPE_ALL);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga1, targetedObject, TurnsToSeconds(nTime));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga2, targetedObject, TurnsToSeconds(nTime));
        DelayCommand(TurnsToSeconds(nTime), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga1N, targetedObject, TurnsToSeconds(nTime)));
        DelayCommand(TurnsToSeconds(nTime), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga2N, targetedObject, TurnsToSeconds(nTime)));
    }
    else if(activatedItemTag == "Droga3") {
        SetLocalInt(targetedObject, "Sobredosis", GetLocalInt(targetedObject, "Sobredosis")+d4(1));
        if(GetLocalInt(targetedObject, "Sobredosis") > GetAbilityModifier(ABILITY_CONSTITUTION, targetedObject)+10)
        {
            FloatingTextStringOnCreature("La sobredosis termina con tu vida", targetedObject, TRUE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),targetedObject);
            return;
        }
        drogas_SmokePipe(targetedObject);
        int nTime = d6(1);
        effect eDroga1 = EffectAbilityIncrease(ABILITY_DEXTERITY,2);
        effect eDroga2 = EffectAbilityIncrease(ABILITY_CONSTITUTION,2);
        effect eDroga3 = EffectSavingThrowIncrease(SAVING_THROW_FORT,4, SAVING_THROW_TYPE_ALL);
        effect eDroga1N = EffectAbilityDecrease(ABILITY_WISDOM,2);
        effect eDroga2N = EffectAbilityDecrease(ABILITY_INTELLIGENCE,2);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga1, targetedObject, TurnsToSeconds(nTime));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga2, targetedObject, TurnsToSeconds(nTime));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga3, targetedObject, TurnsToSeconds(nTime));
        DelayCommand(TurnsToSeconds(nTime), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga1N, targetedObject, TurnsToSeconds(nTime)));
        DelayCommand(TurnsToSeconds(nTime), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga2N, targetedObject, TurnsToSeconds(nTime)));
    }
    else if(activatedItemTag == "Droga4") {
        SetLocalInt(targetedObject, "Sobredosis", GetLocalInt(targetedObject, "Sobredosis")+d6(1));
        if(GetLocalInt(targetedObject, "Sobredosis") > GetAbilityModifier(ABILITY_CONSTITUTION, targetedObject)+10)
        {
            FloatingTextStringOnCreature("La sobredosis termina con tu vida", targetedObject, TRUE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),targetedObject);
            return;
        }

        int nTime = d3(1);
        effect eDroga1 = EffectAbilityIncrease(ABILITY_WISDOM,2);
        effect eDroga2 = EffectAbilityIncrease(ABILITY_INTELLIGENCE,2);
        //effect eDroga3 = EffectSavingThrowIncrease(SAVING_THROW_FORT,4, SAVING_THROW_TYPE_ALL);
        effect eDroga1N = EffectAbilityDecrease(ABILITY_DEXTERITY,2);
        effect eDroga2N = EffectAbilityDecrease(ABILITY_CONSTITUTION,2);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga1, targetedObject, HoursToSeconds(nTime));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga2, targetedObject, HoursToSeconds(nTime));
        //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga3, targetedObject, TurnsToSeconds(nTime));
        DelayCommand(HoursToSeconds(nTime), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga1N, targetedObject, HoursToSeconds(nTime)));
        DelayCommand(HoursToSeconds(nTime), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDroga2N, targetedObject, HoursToSeconds(nTime)));
    }

    else if( activatedItemResRef == XPW_item_RN )
        XPW_onActivated( activatedItem, itemActivator, targetedObject, targetLocation );

    else if( activatedItemTag == "SEGURIDAD" ) {
        string itemActivatorCdKey = GetPCPublicCDKey( itemActivator );
        if( GetCampaignInt("Nordock", "SEGURIDAD", itemActivator) == 1 ) {
            SetCampaignInt("Nordock", "SEGURIDAD", 0, itemActivator);
            SetCampaignString("Nordock", "CDKEY", itemActivatorCdKey, itemActivator);
            FloatingTextStringOnCreature("Seguridad Desactivada", itemActivator);
        } else {
            SetCampaignInt("Nordock", "SEGURIDAD", 1, itemActivator);
            SetCampaignString("Nordock", "CDKEY", itemActivatorCdKey, itemActivator);
            FloatingTextStringOnCreature("Seguridad Activada", itemActivator);
        }
    }
    else if( activatedItemTag=="scanner" ) // el item se llama Debug Cleaner y esta en Custom/Tutorial
        scanner( itemActivator );

    else if( activatedItemResRef == "debug_ips" ) // el ítem se llama Debug_IPS y esta en Custom/Tutorial
        IPS_Item_debug( targetedObject, itemActivator );

    else if (activatedItemResRef == "patapalo") {
        // ---> Activa el modo pirata para el conjuro Animate Dead
        // Esto hace que los esqueletos y zombies creados surjan con la apariencia de piratas muertos
        int pirateMode = (GetLocalInt(itemActivator, "animdead_estadoModoPirata") == 0) ? 1 : 0;
      string mensajePirata = "Modo Pirata: ";
        mensajePirata += (pirateMode == 1) ? "Activado" : "Desactivado";
      SendMessageToPC(itemActivator, mensajePirata);
        SetLocalInt(itemActivator, "animdead_estadoModoPirata", pirateMode);
        // <---
    } else if (activatedItemTag == "RDO_TUTORIAL") {
        AssignCommand( itemActivator, ActionStartConversation( itemActivator, "rdo_tutorial", TRUE, FALSE ) );

    // --> Cartas BEGIN
    } else if ( activatedItemResRef == Mensajeria_papel_RN ) {
        Mensajeria_activarPapelVacio( activatedItem, itemActivator );
    } else if ( activatedItemResRef == Mensajeria_sobre_RN ) {
        Mensajeria_activarSobre( activatedItem, itemActivator );
    } else if ( activatedItemResRef == Mensajeria_carta_RN ) {
        Mensajeria_activarCarta( activatedItem, itemActivator );
    // <-- Cartas END

    // Generador de llaves para la "Torre de Orvin el rojo"
    } else if( activatedItemResRef == TorreOrvin_generadorLlaves_RN ) {
        TorreOrvin_generarLlave( itemActivator, targetedObject );

    // Si no es ninguna de las anteriores
    } else {
        ExecuteScript("prc_onactivate", itemActivator);

        object oTarget = GetSpellTargetObject();
        location lLocal = GetSpellTargetLocation();

        if(activatedItemTag == "X1_WMGRENADE002") {
            object oArma = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d4),oArma, RoundsToSeconds(d6(2)));
        }
        else if(activatedItemTag == "X1_WMGRENADE005") {
            object oArma = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6),oArma, RoundsToSeconds(d6(2)));
        }

    }
}

/*void dmw_CleanUp(object oMySpeaker)
{
    int nCount;
    int nCache;
    DeleteLocalObject(oMySpeaker, "dmfi_univ_target");
    DeleteLocalLocation(oMySpeaker, "dmfi_univ_location");
    DeleteLocalObject(oMySpeaker, "dmw_item");
    DeleteLocalString(oMySpeaker, "dmw_repamt");
    DeleteLocalString(oMySpeaker, "dmw_repargs");
    nCache = GetLocalInt(oMySpeaker, "dmw_playercache");
    for(nCount = 1; nCount <= nCache; nCount++)
    {
        DeleteLocalObject(oMySpeaker, "dmw_playercache" + IntToString(nCount));
    }
    DeleteLocalInt(oMySpeaker, "dmw_playercache");
    nCache = GetLocalInt(oMySpeaker, "dmw_itemcache");
    for(nCount = 1; nCount <= nCache; nCount++)
    {
        DeleteLocalObject(oMySpeaker, "dmw_itemcache" + IntToString(nCount));
    }
    DeleteLocalInt(oMySpeaker, "dmw_itemcache");
    for(nCount = 1; nCount <= 10; nCount++)
    {
        DeleteLocalString(oMySpeaker, "dmw_dialog" + IntToString(nCount));
        DeleteLocalString(oMySpeaker, "dmw_function" + IntToString(nCount));
        DeleteLocalString(oMySpeaker, "dmw_params" + IntToString(nCount));
    }
    DeleteLocalString(oMySpeaker, "dmw_playerfunc");
    DeleteLocalInt(oMySpeaker, "dmw_started");
} */
