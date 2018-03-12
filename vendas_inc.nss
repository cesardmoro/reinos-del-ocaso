/**************************** Vendas *******************************************
Package: Vendas - include
Autor: Inquisidor
*******************************************************************************/

//////////////////////////// INTERFACE /////////////////////////////////////////

// Funcion a llamar desde el onActivateItem handler cuando se activa una venda
// Nota: para que funcione bien; al final del descanzo de un personaje, henchman,
// o familiar; se debe llamar a Vendas_onRest().
void Vendas_onActivate();

void Vendas_onRest();

//////////////////////////// VARIABLES NAMES ///////////////////////////////////

const string Vendas_cantAplicadaDesdeUltimoDescanzo_VN = "cvadud";

//////////////////////////// IMPLEMENTATION ////////////////////////////////////

void acccionCuracion4( object paciente) {
        int targetCurrentHitPoints = GetCurrentHitPoints(paciente);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(3-targetCurrentHitPoints), paciente );
        ActionDoCommand( FloatingTextStringOnCreature( "Logras tratar con exito las heridas", OBJECT_SELF, TRUE) );
}
void acccionCuracion3( object paciente ) {
    //    ActionDoCommand( ActionPlayAnimation( ANIMATION_LOOPING_GET_MID, 1.0, 6.0 ) );
        ActionDoCommand( ActionPlayAnimation( ANIMATION_FIREFORGET_STEAL, 0.5 ) );
        if(GetIsSkillSuccessful(OBJECT_SELF, SKILL_HEAL, 5-GetCurrentHitPoints(paciente)) == TRUE)
        {
        ActionDoCommand( acccionCuracion4( paciente ));
         }
        else
        {
         ActionDoCommand( FloatingTextStringOnCreature( "No logras tratar las heridas", OBJECT_SELF, TRUE) );
        }
}

void acccionCuracion2( object paciente, int sanado ) {
    if(
        GetIsPlayableRacialType( paciente ) ||
        GetAssociateType( paciente ) == ASSOCIATE_TYPE_FAMILIAR ||
        GetAssociateType( paciente ) == ASSOCIATE_TYPE_ANIMALCOMPANION ||
        (GetRacialType( paciente ) == RACIAL_TYPE_ANIMAL && GetLevelByClass( CLASS_TYPE_DRUID ))
    ) {
        if( sanado >= 2 ) {
            effect curacion = ExtraordinaryEffect( EffectRegenerate( (sanado+2)/4, 10.0 ) );
            ActionDoCommand( ApplyEffectToObject( DURATION_TYPE_TEMPORARY, curacion, paciente, 45.0 ) );
            ActionDoCommand( FloatingTextStringOnCreature( "El vendaje aparenta estar bien aplicado", OBJECT_SELF, TRUE) );
        } else {
            ActionDoCommand( FloatingTextStringOnCreature( "El vendaje se desarma apenas lo sueltas", OBJECT_SELF, TRUE) );
        }
    } else if( GetRacialType( paciente ) == RACIAL_TYPE_ELEMENTAL ) {
        string nombreElemental = GetName(paciente);
        int tipoDanio;
        if (FindSubString(nombreElemental, "fuego") > 0 || FindSubString(nombreElemental, "fire") > 0)
            tipoDanio = DAMAGE_TYPE_FIRE;
        else if (FindSubString(nombreElemental, "agua") > 0 || FindSubString(nombreElemental, "water") > 0)
            tipoDanio = DAMAGE_TYPE_COLD;
        else if (FindSubString(nombreElemental, "tierra") > 0 || FindSubString(nombreElemental, "earth") > 0)
            tipoDanio = DAMAGE_TYPE_ACID;
        else if (FindSubString(nombreElemental, "fuego") > 0 || FindSubString(nombreElemental, "fire") > 0)
            tipoDanio = DAMAGE_TYPE_ELECTRICAL;
        else
            tipoDanio = DAMAGE_TYPE_MAGICAL;
        effect danio = EffectDamage( GetLevelByClass( CLASS_TYPE_ELEMENTAL, paciente )*2, tipoDanio );
        ActionDoCommand( ApplyEffectToObject( DURATION_TYPE_INSTANT, danio, paciente ) );
        ActionDoCommand( FloatingTextStringOnCreature( "la energia elemental lastima tus manos", OBJECT_SELF, TRUE) );
    } else if (GetRacialType( paciente ) == RACIAL_TYPE_UNDEAD)
        ActionDoCommand( FloatingTextStringOnCreature( "no puedes curar una criatura que no esta viva", OBJECT_SELF, TRUE) );
    else
        ActionDoCommand( FloatingTextStringOnCreature( "la criatura patalea y se retuerce hasta quitarse el vendaje", OBJECT_SELF, TRUE) );
}

void acccionCuracion1( object paciente, int sanado ) {
    ActionDoCommand( ActionPlayAnimation( ANIMATION_LOOPING_GET_MID, 1.0, 6.0 ) );
    ActionDoCommand( ActionPlayAnimation( ANIMATION_FIREFORGET_STEAL, 0.5 ) );
    ActionDoCommand( acccionCuracion2( paciente, sanado ) );
}


int Vendas_calcularSanado( object healer, object target, int cantidadVendasPreviamenteAplicadas );
int Vendas_calcularSanado( object healer, object target, int cantidadVendasPreviamenteAplicadas ) {
    // componente base del porcentaje de curacion base
    int factorCuracion = 2 * GetAbilityScore( target, ABILITY_CONSTITUTION, TRUE ); // aqui falta dividir por 100, asi que hacerlo depues

    // componente al azar del porcentaje de curacion
    factorCuracion += Random(11) - 5;

    factorCuracion *= 10 - cantidadVendasPreviamenteAplicadas;  // aqui falta dividir por 10 asi que hacerlo despues

    return 1 + ( GetSkillRank( SKILL_HEAL, healer ) * factorCuracion * GetMaxHitPoints( target ) ) / ( GetHitDice( target ) * 1000 ); // 1000 = 100 * 10 que dejeraon para despues (ver mas arriba).
}

void Vendas_onActivate() {

    object target = GetItemActivatedTarget();
    object activator = GetItemActivator();

    int targetCurrentHitPoints = GetCurrentHitPoints(target);
    if( targetCurrentHitPoints > 0) {
        // quitar el efecto de la venda previa si es que aun perciste.
        effect iterator = GetFirstEffect( target );
        while( GetIsEffectValid( iterator ) ) {
            if( GetEffectType( iterator ) == EFFECT_TYPE_REGENERATE && GetEffectSubType( iterator )== SUBTYPE_EXTRAORDINARY ) {
                RemoveEffect( target, iterator );
                break;  // se asume que un sujeto nunca esta bajo el efecto de mas de una venda.
            }
            iterator = GetNextEffect( target );
        }

        // pena por Cantidad de Vendas Aplicadas Desde Ultimo Descanso sobre el mismo target
        int cantidadVendasAplicadas = GetLocalInt( target, Vendas_cantAplicadaDesdeUltimoDescanzo_VN );
        SetLocalInt( target, Vendas_cantAplicadaDesdeUltimoDescanzo_VN, cantidadVendasAplicadas + 1 );
        if( cantidadVendasAplicadas < 10 ) {

            int sanado = Vendas_calcularSanado( activator, target, cantidadVendasAplicadas );
            int daniado = GetMaxHitPoints( target ) - targetCurrentHitPoints;
            if( sanado > daniado )
                sanado = daniado;

            AssignCommand( activator, acccionCuracion1( target, sanado ) );
        }
        else
            FloatingTextStringOnCreature( "El herido tiene demasiados vendajes", activator, TRUE);

    }

    else if( targetCurrentHitPoints > -11 ) {


         AssignCommand( activator, acccionCuracion3( target ) );

    }

}

void Vendas_onRest() {
    SetLocalInt( OBJECT_SELF, Vendas_cantAplicadaDesdeUltimoDescanzo_VN, 0 );
}
