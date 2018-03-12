
/////////////////// constants //////////////////////////////////////////////////

const int Confuse_Option_doNothing_CN = -1;
const int Confuse_Option_standard_CN = 0;
const int Confuse_Option_attackNearestCreatureAndAbsorbDamage_CN = 1; // no tolera superposicion
const int Confuse_Option_attackSpecifiedCreature_CN = 2; // no tolera superposicion

const string Confuse_effectHolder_TAG = "ConfuseEffectHolder";

/////////////////// PJ variables ///////////////////////////////////////////////

const string Confuse_option_VN = "ConfuseOption";
const string Confuse_specifiedCreature_VN = "ConfuseSpecCreature";
const string Confuse_remainingRounds_VN = "ConfuseRemainingRounds";
const string Confuse_previousDamage_VN = "ConfusePreviousDamage";

/////////////////// Module variables ///////////////////////////////////////////

const string Confuse_effectHolder_VN = "ConfuseEffectHolder";


//////////////////// operations ////////////////////////////////////////////////

// debe ser llamado desde el handler del onWorldEnter para resetear cualquier estado espurio que haya quedado guardado en el PJ.
void Confuse_onWorldEnter( object client );
void Confuse_onWorldEnter( object client ) {
    SetLocalInt( client, Confuse_option_VN, Confuse_Option_standard_CN );
}

// obtiene el efecto usado en las opciones que no toleran superposicion
effect Confuse_getEffect();
effect Confuse_getEffect() {
    object holder = GetLocalObject( GetModule(), Confuse_effectHolder_VN );
    if( !GetIsObjectValid( holder ) ) {
        holder = GetObjectByTag( Confuse_effectHolder_TAG );
        SetLocalObject( GetModule(), Confuse_effectHolder_VN, holder );
        SetLocalInt( holder, Confuse_option_VN, Confuse_Option_doNothing_CN );
        ExecuteScript( "confuse_effectcr", holder ); // se uso el ExecuteScript para que el creador del efecto sea 'holder' y no OBJECT_SELF
    }
    return GetFirstEffect( holder );
}


// Da TRUE si 'creature' no esta bajo el efecto de confusion o lo esta en una de las variantes que tolera superposicion.
int Confuse_isCurrentSuperposeable( object creature );
int Confuse_isCurrentSuperposeable( object creature ) {
    int currentOption = GetLocalInt( creature, Confuse_option_VN );
    if( currentOption == Confuse_Option_standard_CN )
        return TRUE;
    else {
        effect confuseEffect = Confuse_getEffect();
        effect effectIterator = GetFirstEffect( creature );
        while( GetIsEffectValid( effectIterator ) ) {
            if( effectIterator == confuseEffect )
                return FALSE; // si sale por acá significa que 'creature' esta bajo el efecto de una variante que no tolera superposicion.
            effectIterator = GetNextEffect( creature );
        }
//        SendMessageToPC( GetFirstPC(), "ADVERTENCIA: salvaguarda ejecutada" );
        SetLocalInt( creature, Confuse_option_VN, Confuse_Option_standard_CN ); // Salvaguarda: si 'creature' no esta bajo el efecto de la confusion usada en las variantes que no toleran superposición, y 'creature' esta marcada con una opcion que no tolera superposicion, entonces algo interrumpio forzadamente una confusion intolerante y por ende hay que volver el valor de 'Confuse_option_VN' a 'Confuse_Option_standard_CN'.
        FadeFromBlack( creature );
        return FALSE; // si sale por acá significa que el efecto de alguna variedad que no tolera superposicion fue quitado por medios externos, cosa que no deberia poder hacerse, pero no hay forma de evitarlo (force rest, y cualquier funcion que quite todos los efectos de 'creature'). Se devuelve false para quien use la operación no llame a alguno de los Confuse_applyXXX(..) que no toleran superposicion.
    }
}


// Da la cantidad faltante de rondas para que el efecto se consuma.
// El resultado solo es válido cuando 'creature' esta bajo el efecto de una variante que no tolera superposicion ('Confuse_isCurrentSuperposeable(..)==FALSE').
int Confuse_getRemainingRounds( object creature );
int Confuse_getRemainingRounds( object creature ) {
    return GetLocalInt( creature, Confuse_remainingRounds_VN );
}


// Le pone a 'creature' la variante "Standard" del efecto confusion durante al menos 'numberOfRounds'.
// ADVERTENCIA: Se asume que 'creature' no esta bajo el efecto confusion en alguna de las variantes que no tolera superposicion ( 'Confuse_isCurrentSuperposeable(creature)==TRUE' ).
void Confuse_applyStandard( object affectedCreature, int numberOfRounds );
void Confuse_applyStandard( object affectedCreature, int numberOfRounds ) {
    SetLocalInt( affectedCreature, Confuse_option_VN, Confuse_Option_standard_CN );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectConfused(), affectedCreature, IntToFloat(6*numberOfRounds) );
}


// Le pone a 'creature' la variante "AttackNearestCreatureAndAbsorbDamage" del efecto confusion durante al menoss 'numberOfRounds'.
// ADVERTENCIA: Se asume que 'creature' no esta bajo el efecto confusion en alguna de las variantes que no tolera superposicion ( 'Confuse_isCurrentSuperposeable(creature)==TRUE' ).
void Confuse_applyAttackNearestCreatureAndAbsorbDamage( object affectedCreature, int numberOfRounds, int initialDamage );
void Confuse_applyAttackNearestCreatureAndAbsorbDamage( object affectedCreature, int numberOfRounds, int initialDamage ) {
    SetLocalInt( affectedCreature, Confuse_option_VN, Confuse_Option_attackNearestCreatureAndAbsorbDamage_CN );
    SetLocalInt( affectedCreature, Confuse_remainingRounds_VN, numberOfRounds );
    SetLocalInt( affectedCreature, Confuse_previousDamage_VN, initialDamage );
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, Confuse_getEffect(), affectedCreature );
}


// Le pone a 'creature' la variante "AttackSpecifiedCreature" del efecto confusion durante 'numberOfRounds'.
// ADVERTENCIA: Se asume que 'creature' no esta bajo el efecto confusion en alguna de las variantes que no tolera superposicion ( 'Confuse_isCurrentSuperposeable(creature)==TRUE' ).
void Confuse_applyAttackSpecifiedCreature( object affectedCreature, int numberOfRounds, object specifiedCreature );
void Confuse_applyAttackSpecifiedCreature( object affectedCreature, int numberOfRounds, object specifiedCreature ) {
    SetLocalInt( affectedCreature, Confuse_option_VN, Confuse_Option_attackSpecifiedCreature_CN );
    SetLocalInt( affectedCreature, Confuse_remainingRounds_VN, numberOfRounds );
    SetLocalObject( affectedCreature, Confuse_specifiedCreature_VN, specifiedCreature );
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, Confuse_getEffect(), affectedCreature );
}

