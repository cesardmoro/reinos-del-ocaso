/////////////////////////////////////
// Sistema de Caballos - Acciones y Handlers
//
/////////////////////////////////

#include "Horses_props_inc"
#include "Horses_persist"
#include "rdo_const_skill"
#include "item_inc"
#include "x2_inc_itemprop"
#include "rdo_spinc"
#include "Speed_inc"
#include "location_tools"
#include "phenos_inc"
#include "RS_inc"
#include "nw_i0_spells"
#include "RdO_const_feat"

///////////////////////////// CONSTANTES //////////////////////////////////

// Tag de la herramienta para usar los caballos
const string Horses_TOOL_TAG    = "Horses_TOOL";
const string Horses_TOOL_RESREF = "horses_tool";

// DCs de los distintos usos de la habilidad Ride
// Ver Player's Handbook pagina 80
const int Horses_GUIDE_WITH_KNEES_DC            = 5;
const int Horses_STAY_IN_SADDLE_DC              = 5;
const int Horses_SOFT_FALL_DC                   = 15;
const int Horses_CONTROL_MOUNT_IN_BATTLE_DC     = 20;

//Fenotipos
const int Horses_MASTER_PHENOTYPE       = 17;
const int Horses_MASTER_PHENOTYPE_BIG   = 27;

const string Horses_DOM_EFF_CREATOR = "Horses_DOM_EFF_CREATOR";

const string Horses_DELOG_VAR_ID = "Horses_delogId_";


///////////////////////// ACCIONES ////////////////////////////////////

// Desmonta al personaje y devuelve el caballo
// El parametro nJumpToOwner permite evitar o no que el caballo vaya al dueño.
// El parametro nDominate permite evitar que el caballo vuelva a ser dominado una vez desmontado
// (util en la muerte del personaje por ejemplo)
object Horses_disMount( object oPC = OBJECT_SELF, int nJumpToOwner = TRUE, int nDominate = TRUE );
object Horses_disMount( object oPC = OBJECT_SELF, int nJumpToOwner = TRUE, int nDominate = TRUE )
{
    object oHorse = OBJECT_INVALID;

    if (GetIsMounted(oPC)) {

        ReturnToNaturalPhenoType(oPC);
        ReturnToNaturalTail(oPC);

        oHorse = GetLocalObject(oPC, Horses_MOUNTED_HORSE_CREATURE);

        if (nJumpToOwner) {
            AssignCommand(oHorse, Location_forcedJump(GetLocation(oPC)));
        }

        RDO_RemoveEffectsByCreator(oPC, RDO_GetCreatorByTag(Horses_ATTACK_DEC_EFFECT_CREATOR));

        DeleteLocalObject(oPC, Horses_MOUNTED_HORSE_CREATURE);
        DeleteLocalInt(oPC, Horses_MOUNT_TYPE);
        DeleteLocalInt(GetModule(), Horses_DELOG_VAR_ID+GetStringLeft(GetName(oPC), 16));

        Speed_applyModifiedSpeed(oPC);

    }

    return oHorse;
}

void Horses_voidDisMount( object oPC = OBJECT_SELF, int nJumpToOwner = TRUE );
void Horses_voidDisMount( object oPC = OBJECT_SELF, int nJumpToOwner = TRUE )
{
    Horses_disMount( oPC, nJumpToOwner );
}

void Horses_FallFromMount_step2( object oPC, int isWarMount )
{
    object oHorse = Horses_disMount(oPC);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oHorse, 2.0);

    if (!GetIsSkillSuccessful(oPC, RDO_SKILL_RIDE, Horses_SOFT_FALL_DC)) {
        FloatingTextStringOnCreature("Y el caballo cae encima tuyo!", oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(), DAMAGE_TYPE_BLUDGEONING), oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 2.0);
    } else
        FloatingTextStringOnCreature("Atinas a esquivar al caballo en su caida.", oPC);

    if (!WillSave(oHorse, 10, SAVING_THROW_TYPE_FEAR) && !isWarMount)
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFrightened(), oHorse, RoundsToSeconds(d4()));
}

// Caerse del caballo
void Horses_FallFromMount( object oPC = OBJECT_SELF );
void Horses_FallFromMount( object oPC = OBJECT_SELF )
{
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 2.0));
    FloatingTextStringOnCreature("Te caes del caballo!", oPC);

    DelayCommand(2.0, Horses_FallFromMount_step2(oPC, Horses_GetHasWarMount(oPC)));
}

// Monta oPC en oHorse
void Horses_Mount( object oHorse, object oPC = OBJECT_SELF );
void Horses_Mount( object oHorse, object oPC = OBJECT_SELF )
{
    if (GetIsRidableHorse(oHorse) && GetCurrentHitPoints(oHorse) > 0) {
        RemoveSpecificEffect(EFFECT_TYPE_DOMINATED, oHorse);
        // Envia al caballo a la guarderia
        object daycareWP = GetWaypointByTag(Horses_DAYCARE_WP);
        AssignCommand( daycareWP, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oHorse) );
        AssignCommand(oHorse, Location_forcedJump(GetLocation(daycareWP)));

        //Cambio de fenotipo y cola
        if (GetNaturalPhenoType(oPC) == PHENOTYPE_BIG)
            SetPhenoType(Horses_MASTER_PHENOTYPE_BIG, oPC);
        else
            SetPhenoType(Horses_MASTER_PHENOTYPE, oPC);

        SetCreatureTailType(Horses_GetAssignedTailModelFromCreatureHorse(oHorse), oPC);

        // Ajuste de variables locales
        SetLocalInt(oPC, Horses_MOUNT_TYPE, Horses_GetCreatureMountType(oHorse));
        SetLocalObject(oPC, Horses_MOUNTED_HORSE_CREATURE, oHorse);
        SetLocalInt(GetModule(), Horses_DELOG_VAR_ID+GetStringLeft(GetName(oPC), 16), Horses_GetHorseId(oHorse));

        DelayCommand(1.5, Speed_applyModifiedSpeed(oPC));
        if (GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))) {

            int attackPenalty = (GetHasFeat(FEAT_MOUNTED_ARCHERY, oPC)) ? 2 : 4;
            AssignCommand(RDO_GetCreatorByTag(Horses_ATTACK_DEC_EFFECT_CREATOR),
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(attackPenalty)), oPC));
        }

        // caida por montar un caballo ajeno sin el permiso del dueño (se enfrentan tiradas de Ride)
        if (Horses_GetHorseOwner(oHorse)!=oPC) {
            int rideDC = d20() + GetLocalInt(oHorse, Horses_OWNER_ALLOWS_OTHERS_TO_RIDE);
            if (!GetIsSkillSuccessful(oPC, RDO_SKILL_RIDE, rideDC))
                Horses_FallFromMount(oPC);
        }
    }
}


const int Horses_TIED_HORSE         = 1;
const int Horses_LOOSE_HORSE        = 2;
const int Horses_DISPATCHED_HORSE   = 3;

// Envia el caballo al establo
//
// Si se esta en un area insegura, hace una tirada para ver si sobrevive
// Luego lo envia a la guarderia
void Horses_SendHorseToStable( object oHorse, int nHorseStatus = Horses_DISPATCHED_HORSE, object oOwner = OBJECT_INVALID );
void Horses_SendHorseToStable( object oHorse, int nHorseStatus = Horses_DISPATCHED_HORSE, object oOwner = OBJECT_INVALID )
{
    // Dado que esta funcion es usada en situaciones problematicas (con un DelayCommand()) chequeamos que exista
    if (GetIsObjectValid(oHorse)) {

        //RemoveSpecificEffect(EFFECT_TYPE_DOMINATED, oHorse);
        //RemoveFromParty(oHorse);

        object oPC = (GetIsObjectValid(oOwner)) ? oOwner : Horses_GetHorseOwner(oHorse);

        int areaCr = GetLocalInt(GetArea(oHorse), RS_crArea_PN);
        int survives = TRUE;
        if (areaCr > 0) {
            if (nHorseStatus==Horses_DISPATCHED_HORSE)
                survives = ( d100() > (areaCr/2) );
            else if (nHorseStatus==Horses_LOOSE_HORSE)
                survives = ( d100() > areaCr );
            else if (nHorseStatus==Horses_TIED_HORSE)
                survives = ( d100() > (areaCr*2) );
        }

        if ( survives ) {
            // Envia al caballo a la guarderia
            object daycareWP = GetWaypointByTag(Horses_DAYCARE_WP);
            if (GetArea(oHorse)!=GetArea(daycareWP))
                AssignCommand(oHorse, Location_forcedJump(GetLocation(daycareWP)));
        } else {
            Horses_DeletePersistantHorse(Horses_GetHorseId(oHorse), oPC);
            SendMessageToPC(oPC, "Tu caballo fue emboscado y no sobrevivio el trayecto de vuelta al establo.");
        }
    }
}

// Hace que oHorse siga a oPC marcandolo y aplicando el efecto de dominacion
void Horses_StartFollowing( object oHorse, object oPC );
void Horses_StartFollowing( object oHorse, object oPC )
{
    SetLocalInt( oHorse, Horses_isFollowing_LN, TRUE );
    AssignCommand( oPC, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDominated(), oHorse) );
}

// Marca al caballo como que no esta siguiendo a oPC y le quita el efecto de dominacion
void Horses_StopFollowing( object oHorse, object oPC );
void Horses_StopFollowing( object oHorse, object oPC )
{
    SetLocalInt( oHorse, Horses_isFollowing_LN, FALSE );
    effect efectoIterado = GetFirstEffect( oHorse );
    while ( GetIsEffectValid(efectoIterado) )
    {
        if ( GetEffectType(efectoIterado) == EFFECT_TYPE_DOMINATED && GetEffectCreator(efectoIterado) == oPC )
            RemoveEffect( oHorse, efectoIterado );
        efectoIterado = GetNextEffect( oHorse );
    }
}

////////////////////////// HANDLERS ////////////////////////////////////////

// Handler a ser usado en el Heartbeat
void Horses_onHeartBeat( object oPC = OBJECT_SELF );
void Horses_onHeartBeat( object oPC = OBJECT_SELF )
{
    if (GetIsMounted(oPC) && GetIsObjectValid(oPC)) {

        if (GetIsInCombat(oPC)) {

            // En combate, debe dirigirse el caballo con las rodillas o se pierde el uso de la mano izquierda
            // Esto lo represento con una penalidad al AC igual al bonus del escudo si esta usando escudo
            // o con una pena al ataque si esta usando un arma en la mano izquierda o un arma de 2 manos
            // No uso GetIsSkillSuccessfull para no llenar el log de tiradas
            int diceRoll = d20();
            int guideWithKneesRanks =  GetSkillRank(RDO_SKILL_RIDE, oPC);
            if ( (diceRoll+guideWithKneesRanks) < Horses_GUIDE_WITH_KNEES_DC ) {
                SendMessageToPC(oPC, "Tirada de Cabalgar (Guiar con las rodillas): "+IntToString(diceRoll)+" + "+IntToString(guideWithKneesRanks)+" = "+IntToString(guideWithKneesRanks+diceRoll)+" FALLO!");
                object leftHandItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
                if (GetIsObjectValid(leftHandItem)) {
                    if (IPGetIsMeleeWeapon(leftHandItem))
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(20, ATTACK_BONUS_OFFHAND), oPC, 6.0);
                    else {
                        int acPenalty = GetItemACValue(leftHandItem);
                        if (acPenalty > 0)
                            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACDecrease(acPenalty), oPC, 6.0);
                    }
                } else if (Item_GetIsTwoHandedWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)))
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(20, ATTACK_BONUS_MISC), oPC, 6.0);
            }

            // Si no tiene una montura de guerra, esta en combate y falla la tirada, se cae del caballo
            if (!Horses_GetHasWarMount(oPC)) {
                // No uso && por el feedback al usuario de la funcion GetIsSkillSuccessful()
                if (!GetIsSkillSuccessful(oPC, RDO_SKILL_RIDE, Horses_CONTROL_MOUNT_IN_BATTLE_DC)) {
                    Horses_FallFromMount(oPC);
                }
            }

        }
    }
}

// Handler a ser llamado desde el onHit del personaje u onDamaged de la criatura
void Horses_onHit( object oPC = OBJECT_SELF );
void Horses_onHit( object oPC = OBJECT_SELF )
{
    //SendMessageToPC(oPC, "Golpeado cabalgando!");
    if (GetSkillRank(RDO_SKILL_RIDE, oPC) < 4) {
        if (!GetIsSkillSuccessful(oPC, RDO_SKILL_RIDE, Horses_STAY_IN_SADDLE_DC))
           Horses_FallFromMount( oPC );
    }
}

// Handler para el evento OnPlayerEquipItem
void Horses_onEquip( object oItem, object oPC = OBJECT_SELF );
void Horses_onEquip( object oItem, object oPC = OBJECT_SELF )
{
    if (GetIsMounted(oPC)) {
        if (GetWeaponRanged(oItem)) {

            int attackPenalty = (GetHasFeat(FEAT_MOUNTED_ARCHERY, oPC)) ? 2 : 4;
            AssignCommand(RDO_GetCreatorByTag(Horses_ATTACK_DEC_EFFECT_CREATOR),
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(attackPenalty)), oPC));
        }
    }
}

// Handler para el evento OnPlayerEquipItem
void Horses_onUnequip( object oPC = OBJECT_SELF );
void Horses_onUnequip( object oPC = OBJECT_SELF )
{
    RDO_RemoveEffectsByCreator(oPC, RDO_GetCreatorByTag(Horses_ATTACK_DEC_EFFECT_CREATOR));
}


// Handler para el evento onPlayerDeath
// No debe ser llamado desde el ejecutable de la muerte sino efectivamente desde el evento
// para asegurarse que la posicion de oPC sea la correcta (y no mandar al caballo al fugue)
// Si no, esta funcion debe ser modificada para buscar la posicion del cuerpo
void Horses_onPlayerDeath( object oPC = OBJECT_SELF );
void Horses_onPlayerDeath( object oPC = OBJECT_SELF )
{
    int isWarMount = Horses_GetHasWarMount(oPC);

    object oHorse = Horses_disMount(oPC);

    float fDelay = RoundsToSeconds(d4());
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFrightened(), oHorse, fDelay));
    DelayCommand(fDelay+1.6, Horses_SendHorseToStable(oHorse, Horses_LOOSE_HORSE, oPC));
}

// Handler para el evento OnDeath de la criatura
void Horses_onHorseDeath( object oHorse = OBJECT_SELF );
void Horses_onHorseDeath( object oHorse = OBJECT_SELF )
{
    if (GetIsRidableHorse(oHorse))
        DelayCommand(60.0, Horses_DeletePersistantHorse( Horses_GetHorseId(oHorse), Horses_GetHorseOwner(oHorse) ));
}

const string Horses_AREA_IS_STABLE = "isStable";

// Handler para el evento OnAreaEnter
// No debe ser usado bajo el condicional GetIsPC() sino que debe afectar a todo objeto que entre
void Horses_areaOnEnter( object enteringObject, object oArea = OBJECT_SELF );
void Horses_areaOnEnter( object enteringObject, object oArea = OBJECT_SELF )
{
    int areaNatural = GetIsAreaNatural(oArea);
    if (GetIsPC(enteringObject)) {

        if (GetIsMounted(enteringObject)) {
            if (GetLocalInt(oArea, Horses_AREA_IS_STABLE))
                Horses_disMount(enteringObject);
            else if ( areaNatural==AREA_ARTIFICIAL && GetIsAreaInterior(oArea) ) {

                Horses_disMount(enteringObject, FALSE);
                SendMessageToPC(enteringObject, "No puedes cabalgar aquí dentro.");
                FloatingTextStringOnCreature("Tu caballo vuelve al establo", enteringObject);

            } else if ( areaNatural==AREA_NATURAL && GetIsAreaAboveGround(oArea)==AREA_UNDERGROUND ) {
                object oHorse = Horses_disMount(enteringObject, FALSE);
                SendMessageToPC(enteringObject, "No puedes cabalgar aquí dentro.");
                Horses_SendHorseToStable(oHorse);
            }
        }

    } else if (GetIsRidableHorse(enteringObject)) {

        if ( areaNatural==AREA_ARTIFICIAL && GetIsAreaInterior(oArea) && !GetLocalInt(oArea, Horses_AREA_IS_STABLE) ) {
            Horses_SendHorseToStable( enteringObject );
            FloatingTextStringOnCreature("Tu caballo no puede entrar aqui. Regresa al establo.", Horses_GetHorseOwner(enteringObject), FALSE);
        }
    }
}

// Handler para el evento onItemActivate
void Horses_onItemActivate( object oPC, object oTarget );
void Horses_onItemActivate( object oPC, object oTarget )
{
    //SendMessageToPC(oPC, "TargetTag: "+GetTag(oTarget));

    if (!GetIsPC(oTarget) || oTarget==oPC) {
        // Si no esta montado, puede querer montar
        if (!GetIsMounted(oPC)) {
            // Si el objetivo es un caballo
            if (GetIsRidableHorse(oTarget)) {

                if (GetDistanceBetween(oPC, oTarget) <= 5.0) {
                    // Si oTarget es un caballo y alguno de los 2 esta en combate, montarlo
                    if (GetIsInCombat(oPC) || GetIsInCombat(oTarget))
                        Horses_Mount(oTarget, oPC);
                    // Si no esta en combate, abrir el dialogo
                    else
                        AssignCommand(oPC, ActionStartConversation(oTarget, "horses_dialog", TRUE, FALSE));
                // Si no esta lo suficientemente cerca avisar al jugador
                } else
                    SendMessageToPC(oPC, "Debes estar mas cerca del caballo.");

            } else // Si no es un caballo, avisarle que debe usar esto sobre un caballo
                SendMessageToPC(oPC, "Debes usar esta herramienta sobre un caballo.");
        } else
            //Si esta montado, desmontar
            Horses_disMount(oPC);
    } else {
        if (GetIsMounted(oTarget)) {
            // Si el activador es el duenio del caballo que esta montando oTarget..
            object horseThatTargetRides = Horses_GetMountedHorse(oTarget);
            if (Horses_GetHorseOwner(horseThatTargetRides)==oPC) {
                //... darle la orden de tirarlo al piso
                int ownerRideRoll = d20() + GetSkillRank(RDO_SKILL_RIDE, oPC);
                AssignCommand(oTarget, PlayAnimation(ANIMATION_FIREFORGET_TAUNT));
                FloatingTextStringOnCreature("A la orden de su dueño, el caballo intenta tirarte al piso!", oTarget);
                if (!GetIsSkillSuccessful(oTarget, RDO_SKILL_RIDE, ownerRideRoll)) {
                    SendMessageToPC(oPC, "A tu orden, el caballo tira al piso a "+GetName(oTarget));
                    DelayCommand(2.0, Horses_FallFromMount(oTarget));
                } else {
                    SendMessageToPC(oPC, "A tu orden, el caballo intenta tirar al piso a "+GetName(oTarget)+" pero falla.");
                }
                SetLocalInt(horseThatTargetRides, Horses_OWNER_ALLOWS_OTHERS_TO_RIDE, ownerRideRoll);
            }
        }
    }
}

// Handler de los caballos pera el evento OnClientEnter
// Se ocupa de buscar el caballo que tenia oPC si estaba montado
// Si lo encuentra, deja a oPC como si estuviera montado
// Si no lo encuentra, le vuelve a la normalidad el fenotipo y la cola
void Horses_onClientEnter( object oPC );
void Horses_onClientEnter( object oPC )
{
    // Entrega la herramienta de uso de caballos
    if (!GetIsObjectValid(GetItemPossessedBy(oPC, Horses_TOOL_TAG)))
        CreateItemOnObject(Horses_TOOL_RESREF, oPC);

    object oModule = GetModule();
    int horseId = GetLocalInt(oModule, Horses_DELOG_VAR_ID+GetStringLeft(GetName(oPC), 16));

    object oHorse = Horses_GetHorseByIdAndOwner(horseId, oPC);

    if (GetIsObjectValid(oHorse)) {

        //SendMessageToPC(oPC, "Caballo "+IntToString(horseId)+" de "+GetName(oPC)+" encontrado.");
        Horses_Mount(oHorse, oPC);

    } else {

        //SendMessageToPC(oPC, "Caballo "+IntToString(horseId)+" de "+GetName(oPC)+" no encontrado.");
        ReturnToNaturalPhenoType(oPC);
        ReturnToNaturalTail(oPC);
        DeleteLocalObject(oPC, Horses_MOUNTED_HORSE_CREATURE);
        DeleteLocalInt(oPC, Horses_MOUNT_TYPE);
        DeleteLocalInt(oModule, Horses_DELOG_VAR_ID+GetStringLeft(GetName(oPC), 16));

    }
}

// Handler de los caballos para el evento onRest
// Desmonta al jugador antes de empezar a dormir
// Debe ser puesto al comienzo del script, bajo el condicional REST_EVENTTYPE_REST_STARTED
void Horses_onRest( object oPC );
void Horses_onRest( object oPC )
{
    Horses_disMount( oPC );
}
