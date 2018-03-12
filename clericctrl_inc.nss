#include "Time_inc"
#include "Deity_core"

/////////////////////////////// CONSTANTES ////////////////////////////////////

const string ClericControl_database_RN = "classes";
const string ClericControl_timeUntilClericCantCast_DBVN = "timeUntilClericCantCast";

const string ClericControl_itemResRef_RN = "clericcontrol";

const string ClericControl_wandTargetObject_LN = "clericCtrlTarget";

/////////////////////////////   FUNCIONES  /////////////////////////////////////

// Devuelve si el dios del clerigo le permite lanzar conjuros
//
// En caso que el tiempo haya pasado, borra el control de la base de datos
// y le avisa al jugador
int GetClericGodLetsHimCastSpells( object cleric );
int GetClericGodLetsHimCastSpells( object cleric )
{
    int timeUntilClericCantCast = GetCampaignInt( ClericControl_database_RN, ClericControl_timeUntilClericCantCast_DBVN, cleric );
    if (timeUntilClericCantCast > 0)
    {
        if (timeUntilClericCantCast > Time_secondsSince1300())
        {
            SendMessageToPC( cleric, "Has perdido la gracia de tu dios.");
            return FALSE;
        }
        else
        {
            SetCampaignInt( ClericControl_database_RN, ClericControl_timeUntilClericCantCast_DBVN, 0, cleric );
            SendMessageToPC( cleric, "Has recuperado el favor de tu dios!");
            return TRUE;
        }
    }
    // Caso permanente
    else if (timeUntilClericCantCast == -1)
    {
        SendMessageToPC( cleric, "Has perdido la gracia de tu dios.");
        return FALSE;
    }
    // En base al alineamiento
    else if (!CheckClericAlignment( cleric, GetDeityIndex(cleric) ))
    {
        SendMessageToPC( cleric, "Te has alejado del camino de tu dios, por lo que el te ha quitado su favor.");
        return FALSE;
    }
    else
        return TRUE;
}

// Setea por cuanto tiempo (dias del juego) el clerigo no puede usar favores divinos
void SetTimeClericCantCastSpellsFor( object cleric, int gameDays );
void SetTimeClericCantCastSpellsFor( object cleric, int gameDays )
{
    if (gameDays == -1)
        SetCampaignInt( ClericControl_database_RN, ClericControl_timeUntilClericCantCast_DBVN, -1, cleric );
    else if (gameDays == 0)
        SetCampaignInt( ClericControl_database_RN, ClericControl_timeUntilClericCantCast_DBVN, 0, cleric );
    else
    {
        // El tiempo se calcula en segundos desde 1300
        int segundosFinales = Time_secondsSince1300() + gameDays * Time_SECONDS_IN_A_DAY;
        SetCampaignInt( ClericControl_database_RN, ClericControl_timeUntilClericCantCast_DBVN, segundosFinales, cleric );
    }
}

void ClericControl_onActivateItem( object wandActivator, object wandTarget );
void ClericControl_onActivateItem( object wandActivator, object wandTarget )
{
    if (GetIsPC( wandTarget ))
    {
        SetLocalObject( wandActivator, ClericControl_wandTargetObject_LN, wandTarget );
        AssignCommand( wandActivator, ActionStartConversation( wandActivator, "clericctrl_dlg", TRUE, FALSE ) );
    }
    else
        SendMessageToPC( wandActivator, "Debes usar esta varita sobre un PJ.");
}

void ClericControl_onRest( object cleric );
void ClericControl_onRest( object cleric )
{
    if (!GetClericGodLetsHimCastSpells( cleric ))
    {
        while (GetHasFeat( FEAT_TURN_UNDEAD, cleric ))
        {
            DecrementRemainingFeatUses( cleric, FEAT_TURN_UNDEAD );
        }
    }
}
