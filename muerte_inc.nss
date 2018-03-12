#include "matasumon"
#include "sacahench"
#include "location_tools"
#include "CIB_Oro"
#include "Muerte_goodslost"
#include "RDO_spinc"
#include "PenaPorPerdon"

///////////////////////////// CONSTANTES //////////////////////////////////////
const string WAYPOINT_FUGUE = "FugueMarker";

const string Muerte_condicionResurreccion_VN    = "resuby";
const int Muerte_REVIVIDO_CON_RAISE_DEAD        = 0;
const int Muerte_REVIVIDO_CON_RESURRECTION      = 1;
const int Muerte_REVIVIDO_CON_TRUERESURRECTION  = 2;


////////////////////////// module variable prefixs /////////////////////////////

const string Muerte_Penitencia_fechaFin_MVP = "MPff"
    // Mantiene la fecha en que termina la penitencia en el plano de la fuga del PJ asociado.
    // Su valor es puesto cuando el PJ asociado entra al plano de la fuga, y borrado (deleted) cuando entra al mundo (ver 'Muerte_onPjEntersArea(..)' ).
    // Ademas usarse para conocer la fecha del fin de la penitencia en el fugue, se usa como marca (aprovechando que las fechas son siempre distintas de cero) de que el PJ esta o viene del plano de la fuga.
;


/////////////////// DECLARACION PREVIA DE FUNCIONES ///////////////////////////

//esta funcion es pa revivir, es de bioware sin modificaciones.
// revive instantaneamente al PJ y le quita los efectos que pudieron haber quedado de cuando vivo.
// no se usan retardos ni colas
void Raise(object oPlayer);

void ExecDeathActions(object matador, object pjMatado);

void muerte_tratarTomaCuerpo( object oUser, object oItem );


const string Muerte_IndicesCadaveres_FILE_NAME = "Numerosde"; // tabla persistente de indices a los cadaveres. Hay un elemento por cada PJ y contiene el indice a las tablas 'Muerte_CadaveresCriatura_FILE_NAME' y 'Muerte_CadaveresLoc_FILE_NAME'
const string Muerte_IndicesCadaveres_ESTA_INICIALIZADO = "tiene"; // campo de la tabla persistente de indices a los cadaveres, que indica si el resto de los campos del elemento fueron inicializados
const string Muerte_IndicesCadaveres_INDICE_TABLA_CADAVERES = "Cuerponumeromuerto"; // campo de la tabla persistente de indices a los cadaveres, que contiene el índice a las tablas de cadaveres.
const string Muerte_ULTIMO_NUMERO_DE_SERIE = "Cuerponumero"; // Recuerda de forma persistente el último numero seriado generado. Estos numeros de serie se usan para darle unicidad a los indices de las tablas 'Muerte_CadaveresCriatura_FILE_NAME' y 'Muerte_CadaveresLoc_FILE_NAME'.

// Nota: la tabla de cadaveres esta dividida en dos archivos. En Muerte_CadaveresCriatura_FILE_NAME se guarda una criatura copia del PJ en bolas, y en Muerte_CadaveresLoc_FILE_NAME la posicion del cuerpo.
const string Muerte_CadaveresCriatura_FILE_NAME = "Cuerpos";  // tabla persistente con los cuerpos en bolas de todos los PJs. Cada elemento esta asociado a uno y solo un PJ por medio de un indice que se obtiene de la tabla 'Muerte_IndicesCadaveres_FILE_NAME'.
const string Muerte_CadaveresLoc_FILE_NAME = "Locacionescuerpo"; // tabla persistente con las posiciones donde se hallan los cadaveres de los PJs muertos. Cada elemento esta asociado a un y solo un PJ por medio de un indice que se obtiene de la tabla 'Muerte_IndicesCadaveres_FILE_NAME'. El valor es válido solo si el PJ esta muerto, nadie carga su cadaver, y el cadaver no fue destruido.
const string Muerte_CadaveresLoc_PREFIJO_INDICE_AREA = "area";
const string Muerte_CadaveresLoc_PREFIJO_INDICE_POSICION = "vector";
const string Muerte_CadaveresLoc_PREFIJO_INDICE_DIRECCION = "facing";

const string Muerte_PREFIJO_CADAVER_ITEM = "Cuerpo";
const int    Muerte_PREFIJO_CADAVER_ITEM_LENGTH = 6;

const string Muerte_CADAVER_RELACIONADO     = "Muerte_CADAVER_RELACIONADO"; // nombre de la referencia al cadaver (criatura copia del PJ), que tiene el item que representa el cuerpo del PJ
const string Muerte_ITEMCADAVER_RELACIONADO = "Muerte_ITEMCADAVER_RELACIONADO"; // nombre de la referencia al ítem que representa el cuerpo del PJ, que tiene el PJ
const string Muerte_PJ_RELACIONADO          = "Muerte_PJ_RELACIONADO"; // nombre de la referencia al PJ que tiene el ítem que representa al PJ
const string Muerte_PJ_RELACIONADO_NOMBRE   = "Muerte_NOMBRE_PJ_REL"; // nombre de la variable con el nombre del PJ que tiene el ítem que representa al PJ



// Asocia mutualmente a 'cuerpoItem' con 'pjMuerto' y con 'cadaver'.
// Nota: 'pjMuerto' y 'cadaver' no son asociados entre si.
void Muerte_asociarCadaverConPj( object pjMuerto, object cuerpoItem, object cadaver );
void Muerte_asociarCadaverConPj( object pjMuerto, object cuerpoItem, object cadaver ) {
    SetLocalObject( cuerpoItem, Muerte_CADAVER_RELACIONADO, cadaver);
    SetLocalObject( cadaver, Muerte_ITEMCADAVER_RELACIONADO, cuerpoItem);
    SetLocalObject( cuerpoItem, Muerte_PJ_RELACIONADO, pjMuerto );
    SetLocalObject( pjMuerto, Muerte_ITEMCADAVER_RELACIONADO, cuerpoItem);
    SetLocalString( cuerpoItem, Muerte_PJ_RELACIONADO_NOMBRE, GetName( pjMuerto ) );
}


// Da el item que representa el cadaver de pjMuerto
// se asume que 'pjMuerto' esta muerto.
object Muerte_getCadaverItem( object pjMuerto );
object Muerte_getCadaverItem( object pjMuerto ) {
    object cadaverItem = GetLocalObject( pjMuerto, Muerte_ITEMCADAVER_RELACIONADO );
    if( !GetIsObjectValid( cadaverItem ) ) {
        int indice = GetCampaignInt( Muerte_IndicesCadaveres_FILE_NAME, Muerte_IndicesCadaveres_INDICE_TABLA_CADAVERES, pjMuerto );
        cadaverItem = GetObjectByTag( Muerte_PREFIJO_CADAVER_ITEM + IntToString(indice) );
    }
    return cadaverItem;
}


// Averigua de que PJ es el 'cadaver' recibido.
object Muerte_getPjDadoCadaver( object cadaver );
object Muerte_getPjDadoCadaver( object cadaver ) {
    object pjMuerto;
    if( GetIsObjectValid( cadaver ) ) {
        object cuerpoItem = GetLocalObject( cadaver, Muerte_ITEMCADAVER_RELACIONADO );
        if( GetIsObjectValid( cuerpoItem ) ) {
            pjMuerto = GetLocalObject( cuerpoItem, Muerte_PJ_RELACIONADO );

            // si se arruinó la referencia entre PJ y cuerpoItem, buscar por nombre del PJ
            if( !GetIsObjectValid( pjMuerto ) ) {
                string nombrePjBuscado = GetLocalString( cuerpoItem, Muerte_PJ_RELACIONADO_NOMBRE );
                if( nombrePjBuscado != "" ) {
                    object pcIterator = GetFirstPC();
                    while( pcIterator != OBJECT_INVALID ) {
                        if( GetName(pcIterator) == nombrePjBuscado ) {
                            pjMuerto = pcIterator;
                            break;
                        }
                        object pcIterator = GetNextPC();
                    }
                }
            }
        }
    }
    return pjMuerto;
}


void destruirContenido( object container ) {
    object elementIterator = GetFirstItemInInventory(container);
    while( elementIterator != OBJECT_INVALID ) {
        SetPlotFlag( elementIterator, FALSE );
        DestroyObject( elementIterator );
        elementIterator = GetNextItemInInventory(container);
    }
}

// funcion privada usada solo por 'soltarCuerposCargados(..)'
void matarCuerpoSoltado( string indiceTablaCadaveres, int watchdog=5 ) {
    if( !GetIsObjectValid( GetArea( OBJECT_SELF ) ) ) {
        if( --watchdog >= 0 )
            DelayCommand( 1.0, matarCuerpoSoltado( indiceTablaCadaveres, watchdog ) );
    }
    else {
        SetLootable( OBJECT_SELF, TRUE );
        SetIsDestroyable( FALSE, TRUE, TRUE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints(OBJECT_SELF) + 50, DAMAGE_TYPE_MAGICAL), OBJECT_SELF );
        //aca tenemos q grabar la posicion DONDE esta el cuerpo actualmente
        SetCampaignString(  Muerte_CadaveresLoc_FILE_NAME, Muerte_CadaveresLoc_PREFIJO_INDICE_AREA      + indiceTablaCadaveres, GetTag(GetArea(OBJECT_SELF)) );
        SetCampaignVector(  Muerte_CadaveresLoc_FILE_NAME, Muerte_CadaveresLoc_PREFIJO_INDICE_POSICION  + indiceTablaCadaveres, GetPosition(OBJECT_SELF)     );
        SetCampaignFloat(   Muerte_CadaveresLoc_FILE_NAME, Muerte_CadaveresLoc_PREFIJO_INDICE_DIRECCION + indiceTablaCadaveres, GetFacing(OBJECT_SELF)       );
    }
}


// hace que 'OBJECT_SELF' suelte todos los cuerpos que carga.
// Nota: esta funcion es un estracto del antiguo todosin() de zero. Fue separada, emprolijada y mejorada por Inquisidor
void soltarCuerposCargados( object cargador ) {
    object itemIterator = GetFirstItemInInventory( cargador );
    while(itemIterator != OBJECT_INVALID) {
        string itemIteratorTag = GetTag( itemIterator );
        if( GetStringLeft( itemIteratorTag, Muerte_PREFIJO_CADAVER_ITEM_LENGTH ) == Muerte_PREFIJO_CADAVER_ITEM ) {
            string indiceTablaCadaveres = GetStringRight( itemIteratorTag, GetStringLength(itemIteratorTag)-Muerte_PREFIJO_CADAVER_ITEM_LENGTH );
            object cadaver = RetrieveCampaignObject( Muerte_CadaveresCriatura_FILE_NAME, indiceTablaCadaveres, /*Location_createRandom(*/ GetLocation(cargador)/*, 1.5, 2.5, TRUE )*/); //el Location_getRandomLocation() fue comentado por Inquisidor a pedido de Zero. Razon: causa el cuelgue del server cuando la locacion es inválida. Draco, ¡siempre verifica que los objetos sean válidos antes de usarlos!
            destruirContenido( cadaver ); // por las dudas quedó algo

            // crear cuerpoItem en el cadaver, y asociarlo mutuamente a pjMuerto y cadaver
            object cuerpoItem = CopyItem( itemIterator, cadaver );
            object pjMuerto = GetLocalObject( itemIterator, Muerte_PJ_RELACIONADO );
            Muerte_asociarCadaverConPj( pjMuerto, cuerpoItem, cadaver );

            // Matar la criatura que representa el cuerpo ya que se crea sanita. La accion de matar se la pone el la cola porque en la version de zero se usaba un delay, que aunque no signifique nada porque zero le pone innecesariamente delay a todo, por las dudas lo dejo. Y ya que esta, verifico que el cuerpo este en area válida para hacerle el daño.
            AssignCommand( cadaver, matarCuerpoSoltado( indiceTablaCadaveres ) );

            DestroyObject( itemIterator );
        }
        itemIterator = GetNextItemInInventory(cargador);
    }
}


// funcion privada usada solo por 'viajarAlFugue_paso2(..)'
int Muerte_TablaCadaveres_agregarCadaver( object pjMatado, object cadaver ) {
    // generar un indice univoco a partir de un numero de serie
    int indiceTablaCadaveres = 1 + GetCampaignInt(Muerte_IndicesCadaveres_FILE_NAME, Muerte_ULTIMO_NUMERO_DE_SERIE );
    SetCampaignInt( Muerte_IndicesCadaveres_FILE_NAME, Muerte_ULTIMO_NUMERO_DE_SERIE, indiceTablaCadaveres );

    // guardarlo para siempre en la tabla de indices a la tabla de cadaveres.
    SetCampaignInt( Muerte_IndicesCadaveres_FILE_NAME, Muerte_IndicesCadaveres_INDICE_TABLA_CADAVERES, indiceTablaCadaveres, pjMatado );
    SetCampaignInt( Muerte_IndicesCadaveres_FILE_NAME, Muerte_IndicesCadaveres_ESTA_INICIALIZADO, TRUE, pjMatado );

    // guardar el cuerpo y la posicion
    string indiceTablaCadaveresAsString = IntToString(indiceTablaCadaveres);
    StoreCampaignObject( Muerte_CadaveresCriatura_FILE_NAME, indiceTablaCadaveresAsString, cadaver );
    SetCampaignString(  Muerte_CadaveresLoc_FILE_NAME, Muerte_CadaveresLoc_PREFIJO_INDICE_AREA      + indiceTablaCadaveresAsString, GetTag(GetArea(cadaver)) );
    SetCampaignVector(  Muerte_CadaveresLoc_FILE_NAME, Muerte_CadaveresLoc_PREFIJO_INDICE_POSICION  + indiceTablaCadaveresAsString, GetPosition(cadaver)     );
    SetCampaignFloat(   Muerte_CadaveresLoc_FILE_NAME, Muerte_CadaveresLoc_PREFIJO_INDICE_DIRECCION + indiceTablaCadaveresAsString, GetFacing(cadaver)       );

    return indiceTablaCadaveres;
}


// funcion privada usada solo por 'viajarAlFugue_paso2(..)'
void viajarAlFugue_paso3() {
    object cuerpoPjMatado = OBJECT_SELF;

    // Hasta ahora la criatura que hace de cuerpo del PJ estuvo viva. Hacerla looteable y matarla ahora que ya esta preparada.
    SetLootable( cuerpoPjMatado, TRUE );
    SetIsDestroyable( FALSE, TRUE, TRUE ); // ¿esta bien asi? Los hechizos que reviven deben funcionar distinto con cuerpos de PJs, ¿lo hacen?
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetMaxHitPoints(cuerpoPjMatado) + 50, DAMAGE_TYPE_MAGICAL ), cuerpoPjMatado );
}

// funcion privada usada solo por 'viajarAlFugue_paso1(..)'
void viajarAlFugue_paso2( object matador, object cuerpoPjMatado, int oroCargado, int hayQueAgregarATablaCadaveres ) {
    object pjMatado = OBJECT_SELF;

    // obtener el indice a la tabla de cadaveres. Si el 'pjMatado' no estaba en la tabla aún, agregarlo.
    int indiceTablaCadaveres = hayQueAgregarATablaCadaveres ?
        Muerte_TablaCadaveres_agregarCadaver( pjMatado, cuerpoPjMatado )
        : GetCampaignInt( Muerte_IndicesCadaveres_FILE_NAME, Muerte_IndicesCadaveres_INDICE_TABLA_CADAVERES, pjMatado )
    ;
    // poner dentro del cadaver un item que represente el cadaver del 'pjMatado' cuando es cargado.
    string itemPjMuertoResRef = (GetGender(cuerpoPjMatado) == GENDER_MALE) ? "cuerpo" : "cuerpo2" ;
    object itemPjMuerto = CreateItemOnObject( itemPjMuertoResRef, cuerpoPjMatado, 1, Muerte_PREFIJO_CADAVER_ITEM + IntToString(indiceTablaCadaveres) );
    SetDroppableFlag( itemPjMuerto, TRUE );

    Muerte_asociarCadaverConPj( pjMatado, itemPjMuerto, cuerpoPjMatado );

    // se asume que Muerte_perdidaDeBienes(..) es instantanea ( al menos todo lo que afecta a 'cuerpoPjMatado'.
    Muerte_perdidaDeBienes( cuerpoPjMatado, oroCargado, matador );

    AssignCommand( cuerpoPjMatado, viajarAlFugue_paso3() );
}

// funcion privada usada solo por 'ExecDeathActions(..)'
void viajarAlFugue_paso1( object matador, int crearCadaver = TRUE ) {
    object pjMatado = OBJECT_SELF;
    object itemIterator;

    // recordar cuanto oro tiene el 'pjMatado' y quitarselo todo
    int oroCargado = GetGold( pjMatado );
    TakeGoldFromCreature( oroCargado, pjMatado, TRUE );

    // trasladar el 'pjMatado' al fugue. Advertencia. En el onEnter del fugue no debe haber nada que interfiera con lo que se realiza en el paso2
    Location_forcedJump( GetLocation( GetWaypointByTag(WAYPOINT_FUGUE) ) );

    // Esto permite que ciertos efectos de muerte no creen el cadaver
    if (crearCadaver)
    {
        // crear criatura copia de 'pjMatado' que hará de cadaver
        object cuerpoPjMatado = CopyObject(pjMatado, GetLocation(pjMatado), OBJECT_INVALID, "cuerpoPj" );
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSpellImmunity(), cuerpoPjMatado);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), cuerpoPjMatado);

        // si el indice a la tabla de cadaveres no fue inicializado para 'pjMatado', es porque 'pjMatado' aún no está en las tabla de cadaveres. Para agregarlo es necesario limpiar la criatura usada como cuerpo 'cuerpoPjMatado' para minimizar el peso de la tabla.
        if( !GetCampaignInt( Muerte_IndicesCadaveres_FILE_NAME, Muerte_IndicesCadaveres_ESTA_INICIALIZADO, pjMatado) ){
            // dado que en el paso 2 se agregará este cadaver a la tabla de cadaveres, se le quita todo al cadaver para minimizar el peso de la tabla
            destruirContenido( cuerpoPjMatado );
            int slotIterator = NUM_INVENTORY_SLOTS;
            while( --slotIterator >= 0 ) {
                itemIterator = GetItemInSlot( slotIterator, cuerpoPjMatado );
                DestroyObject( itemIterator );
            }
            // ir al paso 2. Se retarda la accion para dar tiempo a que se destruyan los items que posee el cadaver antes de guardarlo en la tabla de cadaveres.
            DelayCommand( 0.1, viajarAlFugue_paso2( matador, cuerpoPjMatado, oroCargado, TRUE ) );
        }
        // si el indice a la tabla de cadavers ya fue inicializado (en una muerte anterior), basta con tagear los items como no dropeables y pickpocketeables (es mas eficiente que destruirlos).
        else {
            //tagear todos los items del cadaver como no dropeables ni pickpocketeables
            itemIterator = GetFirstItemInInventory( cuerpoPjMatado );
            while( itemIterator != OBJECT_INVALID ) {
                SetDroppableFlag( itemIterator, FALSE );
                SetPickpocketableFlag( itemIterator, FALSE );
                itemIterator = GetNextItemInInventory( cuerpoPjMatado );
            }
            int slotIterator = NUM_INVENTORY_SLOTS;
            while( --slotIterator >= 0 ) {
                itemIterator = GetItemInSlot( slotIterator, cuerpoPjMatado );
                SetDroppableFlag( itemIterator, FALSE );
                SetPickpocketableFlag( itemIterator, FALSE );
            }

            viajarAlFugue_paso2( matador, cuerpoPjMatado, oroCargado, FALSE );
        }
        // no poner codigo acá
    }
}

// funcion privada usada solo por 'ExecDeathActions(..)'
void Raise(object oPlayer)
{

    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);

    effect eBad = GetFirstEffect(oPlayer);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPlayer);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oPlayer)), oPlayer);

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
            //Remove effect if it is negative.
            RemoveEffect(oPlayer, eBad);
        }
        eBad = GetNextEffect(oPlayer);
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oPlayer, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));
}


// Quita todos los conjuros memorizados de OBJECT_SELF.
// Nota: Como esta operación es prolongada, se la distribuye temporalmente en diez sesiones.
// Advertencia: Debe ser llamada usando el valor por defecto.
void consumirTodosLosConjuros( int distribucionTemporal=9 );
void consumirTodosLosConjuros( int distribucionTemporal=9 ) {
    int conjuroIterado;
    for( conjuroIterado=distribucionTemporal; conjuroIterado<=4100; conjuroIterado += 10 ) {
        while( GetHasSpell(conjuroIterado, OBJECT_SELF) > 0)
            DecrementRemainingSpellUses( OBJECT_SELF, conjuroIterado);
    }
    if( --distribucionTemporal >= 0 )
        DelayCommand( 1.0, consumirTodosLosConjuros( distribucionTemporal ) );
}


// funcion privada usada solo por 'Muerte_onPjEntersJailsArea(..)'
void Muerte_esperarEncarcelado( object areaJaulas, int minutosRestantes, int consumirHechizos ) {
    if( consumirHechizos )
        consumirTodosLosConjuros();

    if( GetArea(OBJECT_SELF) == areaJaulas ) {
        if( minutosRestantes > 0 )
            SendMessageToPC( OBJECT_SELF, "Te faltan "+IntToString( minutosRestantes )+" minutos para quedar en libertad." );
        else {
            SendMessageToPC( OBJECT_SELF, "Has cumplido con tu condena. ¡Estás en libertad!" );

            // Saltar al waypoint de salida del area.
            // este waypoint "salidaDelArea" debe estar sobre la transicion de salida del área cosa que si la marca persistente "estaEncarcelado" esta en TRUE cuando no debe y el PJ entra al área de las jaulas por sus propios medios, no sea teleportado lejos del punto donde le deja la puerta por la que entró.
            object entradaAlAreaWP = GetNearestObjectByTag( "salidaDelArea" );
            if( GetIsObjectValid( entradaAlAreaWP ) )
                JumpToLocation( GetLocation( entradaAlAreaWP ) );
            else // si el maper olvidó poner el waypoint, enviarlo al templo.
                Location_forcedJump( GetLocation(GetWaypointByTag("resuzone")) );
        }

        DelayCommand( 60.0, Muerte_esperarEncarcelado( areaJaulas, minutosRestantes - 1, FALSE ) );
    }
    else
        SetCampaignInt( "PVP", "estaEncarcelado", FALSE, OBJECT_SELF );
}

// Debe ser llamada desde el onAreaEnter de las áreas donde haya jaulas para PJs atrapados por la guardia,
// cuando es un PJ el que entra al área.
// Se encarga de programar la salida de la jaula.
void Muerte_onPjEntersJailsArea( object pj );
void Muerte_onPjEntersJailsArea( object pj ) {
    if( GetCampaignInt( "PVP", "estaEncarcelado", pj ) ) {

        // actualizar la posicion del personaje por las dudas el PJ desloguee antes que sea actualizada por el heartbeat
        SetLocalLocation( pj, "locacionPC", GetLocation(pj) );
        SetLocalInt( pj, "isExportPending", TRUE ); // Hace que se exporte el PJ en el proximo heartbeat.
        SetPlotFlag(pj, FALSE);

        // resetea la reputacoin de los guardias hacia el PJ. Ojo, esto no quita la reputacion personal que puedieran tener algunos guardias.
        SetStandardFactionReputation( STANDARD_FACTION_DEFENDER, 50, pj );

        int minutosPenitencia = GetCampaignInt( "PVP", "Carcel", pj ); // no se como calcula este tiempo ni si anda bien, asi que por las dudas le pongo un máximo
        if( minutosPenitencia <= 0 )
            minutosPenitencia = 1;
        if( minutosPenitencia > 8 )
            minutosPenitencia = 8;
        AssignCommand( pj, Muerte_esperarEncarcelado( GetArea(pj), minutosPenitencia, TRUE ) );
    }
}


// funcion privada usada solo por 'ExecDeathActions(..)'
void viajarALaCarcel() {
    object pjAtrapado = OBJECT_SELF;

    SisPremioCombate_quitarPorcentajeXpTransitoria( pjAtrapado, 20 );

    SetCampaignInt("PVP", "estaEncarcelado", TRUE, pjAtrapado );
    object carcelWaypoint = GetWaypointByTag("Carcel"+IntToString(d4(1)));
    Location_forcedJump( GetLocation(carcelWaypoint) );
}


void ExecDeathActions(object matador, object pjMatado)
{

    string pjMatadoNombre = GetName(pjMatado);
    string sID = GetStringLeft(pjMatadoNombre, 20);
    //si esta en party analiza y hace los cambios
    //if (GetLocalInt (pjMatado , "party") != 0) RemovefromParty (pjMatado);

    object oSummon = GetFirstFactionMember(pjMatado, FALSE);
    while(GetIsObjectValid(oSummon))
    {
        matasumon(oSummon, pjMatado);

        oSummon = GetNextFactionMember(pjMatado, FALSE);
    }


    object Asso = GetLocalObject(pjMatado, "BONDED");
    if (GetIsObjectValid(Asso))
    {
        effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetLocation(Asso));
        DestroyObject(Asso);
    }


    if(GetIsPC(matador) == TRUE && GetIsPC(pjMatado) == TRUE)
    {
        if(GetCampaignInt("PVP", "Carcel", pjMatado) == 0)
          {
            if(GetHitDice(pjMatado) < GetHitDice(matador))
            {
                SetCampaignInt("PVP", "Carcel", GetCampaignInt("PVP", "Carcel", matador)+12, matador);
                FloatingTextStringOnCreature("Asesinaste a "+ pjMatadoNombre, matador);
            }
            if(GetHitDice(pjMatado) >= GetHitDice(matador))
            {
                SetCampaignInt("PVP", "Carcel", GetCampaignInt("PVP", "Carcel", matador)+6, matador);
                FloatingTextStringOnCreature("Asesinaste a "+ pjMatadoNombre, matador);
            }
            if(GetCampaignInt("PVP", "Carcel", matador) > 30)
            {
               SetCampaignInt("PVP", "Assasin", 1, matador);
            }
       }
    }

    Raise(pjMatado);

    SetPlotFlag(pjMatado,TRUE);

    soltarCuerposCargados(pjMatado);

    //Si lo envian a la carcel...
    if (GetStringLeft(GetName(matador),7) == "Guardia") {
        AssignCommand( pjMatado, viajarALaCarcel() );
    }
    //si lo envian al fugue
    else
    {
        SisPremioCombate_quitarPorcentajeXpTransitoria( pjMatado, 100 );

        int crearCadaver = !GetLocalInt(pjMatado, RdO_NO_CREAR_CADAVER_AL_MORIR );

        AssignCommand( pjMatado, viajarAlFugue_paso1( matador, crearCadaver ) );
    }
}

// funcion privada usada solo por 'Muerte_onAcquire(..)'
void Muerte_onAcquire_step2( object oUser ) {
    SetIsDestroyable(TRUE, FALSE, FALSE);
    DestroyObject(OBJECT_SELF);

    if( GetIsObjectValid(oUser) )
        SetLocalInt( oUser, "isExportPending", TRUE ); // Hace que se exporte el PJ en el proximo heartbeat.
}

// Handler del sistema de muerte para el evento onAcquire
void Muerte_onAcquire( object oUser, object itemCadaver );
void Muerte_onAcquire( object oUser, object itemCadaver ) {
    string tagItemCadaver = GetTag(itemCadaver);

    if(GetStringLeft(tagItemCadaver, Muerte_PREFIJO_CADAVER_ITEM_LENGTH) == Muerte_PREFIJO_CADAVER_ITEM)
    {
        string indiceTablaCadaveres = GetStringRight(tagItemCadaver, (GetStringLength(tagItemCadaver)-Muerte_PREFIJO_CADAVER_ITEM_LENGTH));

        SetCampaignString(  Muerte_CadaveresLoc_FILE_NAME, Muerte_CadaveresLoc_PREFIJO_INDICE_AREA      + indiceTablaCadaveres, ""                       );
        SetCampaignVector(  Muerte_CadaveresLoc_FILE_NAME, Muerte_CadaveresLoc_PREFIJO_INDICE_POSICION  + indiceTablaCadaveres, GetPosition(itemCadaver) );
        SetCampaignFloat(   Muerte_CadaveresLoc_FILE_NAME, Muerte_CadaveresLoc_PREFIJO_INDICE_DIRECCION + indiceTablaCadaveres, GetFacing(itemCadaver)   );

        object cadaver = GetLocalObject( itemCadaver, Muerte_CADAVER_RELACIONADO );
        DeleteLocalObject( itemCadaver, Muerte_CADAVER_RELACIONADO );
        AssignCommand( cadaver, Muerte_onAcquire_step2( oUser) );
    }
}

// Handler del sistema de muerte para el evento onUnacquire
void Muerte_onUnacquire( object cargador, object item );
void Muerte_onUnacquire( object cargador, object item ) {
    string itemTag = GetTag( item );

    if ( GetStringLeft( itemTag, Muerte_PREFIJO_CADAVER_ITEM_LENGTH) == Muerte_PREFIJO_CADAVER_ITEM ) {
        // determinar posicion del cadaver
        location cadaverLocacion = GetLocation( item );
        if(!GetIsObjectValid(GetAreaFromLocation(cadaverLocacion)))
            cadaverLocacion = GetLocation(cargador);

        // crear cadaver
        string indiceTablaCadaveres = GetStringRight( itemTag, GetStringLength(itemTag)-Muerte_PREFIJO_CADAVER_ITEM_LENGTH);
        object cadaver = RetrieveCampaignObject( Muerte_CadaveresCriatura_FILE_NAME, indiceTablaCadaveres, cadaverLocacion );
        destruirContenido( cadaver );

        object cuerpoItem = CopyItem( item, cadaver );
        object pjMuerto = GetLocalObject( item, Muerte_PJ_RELACIONADO );
        Muerte_asociarCadaverConPj( pjMuerto, cuerpoItem, cadaver );

        AssignCommand( cadaver, matarCuerpoSoltado( indiceTablaCadaveres ) );
        DestroyObject(item);

        SetLocalInt( cargador, "isExportPending", TRUE ); // Hace que se exporte el PJ en el proximo heartbeat.
    }
}


// Destruye todos los cuerpos cargados por 'cargador'.
// Advertencia: no deben destruirse los cuerpos cargados a la ligera. Lo ideal es
// convertirlos en los correspondientes cadaveres. Esta funcion existe para casos
// en que lo segundo no es posible.
void Muerte_destruirCuerposCargados(object cargador);
void Muerte_destruirCuerposCargados(object cargador) {
    object itemIterado = GetFirstItemInInventory(cargador);
    while( GetIsObjectValid(itemIterado) ) {
        if( GetStringLeft( GetTag(itemIterado), Muerte_PREFIJO_CADAVER_ITEM_LENGTH) == Muerte_PREFIJO_CADAVER_ITEM )
            DestroyObject(itemIterado);
        itemIterado = GetNextItemInInventory(cargador);
    }
}


// funcion privada usada solo por 'Muerte_onPjEntersArea()'
void destruirse() {
    SetIsDestroyable( TRUE );
    DestroyObject( OBJECT_SELF );
}

// Debe ser llamada desde el onAreaEnter de todas las áreas del mundo, cuando quien entra es un PJ
// Advertencia: El plano de la fuga y el gate no son ni deben ser parte del mundo.
void Muerte_onPjEntersArea( object pj );
void Muerte_onPjEntersArea( object pj ) {
    string pcId = GetStringLeft( GetName(pj), 25 );
    string penitencaFechaFinRef = Muerte_Penitencia_fechaFin_MVP + pcId;
    if( GetLocalInt( GetModule(), penitencaFechaFinRef ) != 0 ) {

        // borrar marca de que se esta en el plano de la fuga. Se usa la fecha de fin de la penitencia como marca.
        DeleteLocalInt( GetModule(), penitencaFechaFinRef );

        // destruir cuerpoItem y cadaver asociados
        object cuerpoItem = Muerte_getCadaverItem(pj);
        if( GetIsObjectValid(cuerpoItem) ) {
            object cadaver = GetLocalObject( cuerpoItem, Muerte_CADAVER_RELACIONADO );
            if( GetIsObjectValid(cadaver) )
                AssignCommand( cadaver, destruirse() );
            DestroyObject(cuerpoItem);
            DeleteLocalObject( pj, Muerte_ITEMCADAVER_RELACIONADO );
        }

        // borrar posicion del cadaver de 'pj' en la DB
        int indiceCadaver = GetCampaignInt( Muerte_IndicesCadaveres_FILE_NAME, Muerte_IndicesCadaveres_INDICE_TABLA_CADAVERES, OBJECT_SELF );
        SetCampaignString( Muerte_CadaveresLoc_FILE_NAME, "area" + IntToString(indiceCadaver), "" );

        // resetea la reputacoin de los guardias hacia el PJ. Ojo, esto no quita la reputacion personal que puedieran tener algunos guardias.
        SetStandardFactionReputation( STANDARD_FACTION_DEFENDER, 50, pj );

        // aplicar castigos al PJ dependientes de como sea revivido
        int condicionResurreccion = GetLocalInt(pj, Muerte_condicionResurreccion_VN );
        if( condicionResurreccion == Muerte_REVIVIDO_CON_RAISE_DEAD) {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(pj)-1), pj);
            AssignCommand( pj, ActionPlayAnimation( ANIMATION_LOOPING_DEAD_BACK, 10.0, 18.0 ) );
        }
        if( condicionResurreccion != Muerte_REVIVIDO_CON_TRUERESURRECTION )
            AssignCommand( pj, consumirTodosLosConjuros() );

    }
}


// Traslada a OBJECT_SELF del fugue al sitio de resucitacion que le corresponda.
// Se asume que OBJECT_SELF es un PJ que esta en el fugue.
void Muerte_resucitar( int cantIntentosPrevios=0 );
void Muerte_resucitar( int cantIntentosPrevios=0 ) {
    object area = GetArea( OBJECT_SELF );
    if( GetIsObjectValid( area ) ) {
        string pcId = GetStringLeft( GetName(OBJECT_SELF), 25 );
        if( GetTag(area) == "fugue" ) {
            location sitioResurreccion = GetCampaignLocation("respawn", "lugar"+pcId);
            if( cantIntentosPrevios == 0 && GetIsObjectValid( GetAreaFromLocation( sitioResurreccion ) ) ) {
                //SendMessageToPC( GetFirstPC(), "Muerte_resucitar: 3" );
                JumpToLocation( sitioResurreccion );
                DelayCommand( 1.0, Muerte_resucitar(1+cantIntentosPrevios) );
            }
            else if( cantIntentosPrevios < 10 ) {
                if( GetLevelByClass(CLASS_TYPE_DRUID, OBJECT_SELF) > 0 )
                    JumpToLocation(GetLocation(GetWaypointByTag("DruidaSpawn"))); // ¿Que demoníaco criterio se usó para los nombres del los waypoints? *Se pega un tiro*
                else
                    JumpToLocation( GetLocation(GetWaypointByTag("resuzone")) ); // ¿Que demoníaco criterio se usó para los nombres del los waypoints? *Se pega un tiro*
                DelayCommand( 1.0, Muerte_resucitar(1+cantIntentosPrevios) );
            }
            else
                SendMessageToPC( OBJECT_SELF, "Error, no se logra sacar al PJ del fugue. Por avisar de este error en el foro. Disculpa las molestias." );
        }
        else {
            // ajustar la duracion de la penitencia.
            ajustarPenaEspera( pcId, OBJECT_SELF );

            SendMessageToPC( OBJECT_SELF, "¡Revives!");
        }
    }
    else
        DelayCommand( 10.0, Muerte_resucitar(cantIntentosPrevios) );
}

