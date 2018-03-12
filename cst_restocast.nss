#include "CST_inc"

const int OPTION_INDEX = 0;

/* QUITADO porque si llega a interrumpirse el cast del main(), esta operacioni nunca se ejecuta.
// codigo copiado del spell restoration "nw_s0_restore"
void restoration( object oTarget ) {
    effect eBad = GetFirstEffect(oTarget);
    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL)
            {
                // Nota por Dragoncin: esto evita que este conjuro quite efectos aplicados por
                // sistemas del modulo
                if(GetTag(GetArea(GetEffectCreator(eBad))) != "AreadeServicioCreadores")
                    RemoveEffect(oTarget, eBad);
            }
        eBad = GetNextEffect(oTarget);
    }
}*/


void rememberLastRestorationDate( object requester ) {
    if( GetIsObjectValid( requester ) ) {
        SetLocalInt( GetModule(), CST_LastRestorationDate_MVP + GetName(requester), Time_secondsSince1300() );

        // QUITADO porque si llega a interrumpirse el cast del main(), esta operacioni nunca se ejecuta.
        //// la siguiente linea vuelve a realizar el cast con trampa por las dudas no se haya hecho.
        //restoration( requester );
    }
}

void main() {
    object requester = GetPCSpeaker();

    ClearAllActions();

    ActionDoCommand( ActionCastSpellAtObject(
        SPELL_RESTORATION
        , requester
        , METAMAGIC_ANY
        , TRUE
        , 0
        , PROJECTILE_PATH_TYPE_DEFAULT
        , TRUE
    ) );

    ActionDoCommand( ActionDoCommand( rememberLastRestorationDate( requester) ) ); // el doble ActionDoCommand() es necesario para que el procedimiento suceda despues de la acción de la linea anterior.

    ActionDoCommand( ActionCastSpellAtObject(
        SPELL_RESTORATION
        , requester
        , METAMAGIC_ANY
        , TRUE
    ) );
}

