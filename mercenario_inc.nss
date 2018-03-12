/********************** Mercenario include ******************************
Package: Generador de mercenarios - include
Autor: Inquisidor
Descripcion: Generacion de mercenarios contratables por PJs.
*****************************************************************************/

#include "Mercenario_Itf"
#include "area_generic"
#include "NPC_inc"
#include "VNNPC_inc"
#include "Vendas_inc"
#include "ResourcesList"

// constants
const string MercSpawn_ENTRADA_WAYPOINT_TAG = "MSewt";
const string MercSpawn_WALK_WAYPOINT_TAG = "MSwwt";
const int MercSpawn_WALK_WAYPOINT_RANGE = 3;


void Mercenario_caminar( int tiempo, object camino );
void Mercenario_caminar( int tiempo, object camino ) {

    if( tiempo == 0 ) // si fue recien creado o abandonado, marcar que esta caminando
        SetLocalInt( OBJECT_SELF, Mercenario_estaCaminando_VN, TRUE );

    if( GetIsObjectValid( GetMaster(OBJECT_SELF) ) ) {
        DeleteLocalInt( OBJECT_SELF, Mercenario_estaCaminando_VN );
        return;

    } else if( IsInConversation(OBJECT_SELF) ) {
        DelayCommand( 12.0, Mercenario_caminar( tiempo, camino ) );

    } else if( tiempo < 3 ) {
        AssignCommand(OBJECT_SELF, ActionMoveToObject(GetNearestObjectByTag( MercSpawn_WALK_WAYPOINT_TAG, OBJECT_SELF, Random(MercSpawn_WALK_WAYPOINT_RANGE)+1 ), FALSE));
        DelayCommand( 9.0, Mercenario_caminar( tiempo + 1, camino ) );

    } else if( tiempo == 3 ) {
        AssignCommand(OBJECT_SELF, ActionMoveToObject( camino, FALSE));
        DelayCommand( 6.0, Mercenario_caminar( tiempo + 1, camino ) );

    } else { // si tiempo > 3
        AssignCommand(OBJECT_SELF, SetIsDestroyable(TRUE, FALSE, FALSE));
        DestroyObject(OBJECT_SELF );
    }
}


object Mercenario_crear( string sMerc, location ubicacion );
object Mercenario_crear( string sMerc, location ubicacion ) {
    object oMerc = CreateObject( OBJECT_TYPE_CREATURE, sMerc, ubicacion, FALSE, Mercenario_ES_DE_TABERNA_TAG );
    if( GetIsObjectValid( oMerc ) ) {
//        SendMessageToPC( GetFirstPC(), "creado="+GetName(oMerc) );
        ChangeToStandardFaction( oMerc, STANDARD_FACTION_COMMONER );
        ExecuteScript("nw_ch_ac9", oMerc);
    } else
        WriteTimestampedLogEntry( "Generador de mercenario: error, plantilla no encontrada. plantilla=["+sMerc+"], area=["+GetName(OBJECT_SELF)+"]" );
    return oMerc;
}


// Autor: inicial por Zero. Desacoplada, parametrizada y emprolijada por Inquisidor.
// TODO: reeimplementar usando en dado desbalanceado y permitiendo eleccion de clase
void Mercenario_generar( location ubicacion, int indiceGrupo, object camino );
void Mercenario_generar( location ubicacion, int indiceGrupo, object camino )
// Autor original: Zero
// Modificado por Inquisidor para que sea parametrizable.
{
    string sMerc;
    object spawnArea = GetAreaFromLocation(ubicacion);
    string colaAcomodados = GetLocalString( spawnArea, MercSpawn_colaAcomodados_VN );
    if( colaAcomodados != "" ) {
        sMerc = RL_getFront( colaAcomodados );
        SetLocalString( spawnArea, MercSpawn_colaAcomodados_VN, RL_removeFront( colaAcomodados ) );
    } else {
        string exclusionList = GetLocalString( spawnArea, MercSpawn_exclusionList_VN );
        int remainingRetries = 8;
        do {
            string sLetra;
            int nLetra;
            sLetra = "a";
            if(d2(1) == 1)
            {
                sLetra = "b";
                if(d2(1) == 1)
                {
                    sLetra = "c";
                    if(d2(1) == 1)
                    {
                        sLetra = "d";
                        if(d2(1) == 1)
                        {
                            sLetra = "e";
                        }
                    }
                }
            }

            if(sLetra == "a")
            {
                nLetra = 1 + Random(20) + indiceGrupo*20;
        //        if( nLetra > 49 ) nLetra += 10;         // parche provisorio, quitar cuando se corrija la numeracion de los mercenarios
            }
            if(sLetra == "b")
            {
                nLetra = 1 + Random(16) + indiceGrupo*16;
            }
            if(sLetra == "c")
            {
                nLetra = 1 + Random(18) + indiceGrupo*18;
            }
            if(sLetra == "d")
            {
                nLetra = 1 + Random(20) + indiceGrupo*20;
            }
            if(sLetra == "e")
            {
                nLetra = 1 + Random(12) + indiceGrupo*12;
            }
            string sLetra2 = "00" + IntToString(nLetra);

            sMerc = "party"+sLetra+sLetra2;
        } while( --remainingRetries >= 0 && FindSubString( exclusionList, sMerc ) >=0 );
    }

    object mercenario = Mercenario_crear( sMerc, ubicacion );
    SetName( mercenario, VNNPC_generateName( mercenario ) );
    DelayCommand( 2.0, AssignCommand( mercenario, Mercenario_caminar( 0, camino ) ) );
}

//Agrega el ResRef del mercenario contratado a la lista persistente de mercenarios preferidos por 'cliente', y el ResRef de 'mercenario' a la cola de mercenarios acomodados
//Debe ser llamado desde los handlers "on Action Performed" correspondientes los nodos de dialogo del mercenario en que se realiza la contratacion
void MercSpawn_onMercContracted( object cliente, object mercenario );
void MercSpawn_onMercContracted( object cliente, object mercenario ) {
    object mercenarioArea = GetArea(mercenario);
    // si el mercenario esta en un area donde se generan mercenarios (suelen ser tabernas).
    if( GetLocalInt( mercenarioArea, MercSpawn_isActive_VN ) ) {
        string mercenarioResRef = GetResRef(mercenario);

        // agregar el mercenario contratado a la lista persistente de mercenarios preferidos por el cliente
        object persistentVariablesHolder = GetItemPossessedBy( cliente, MercSpawn_PC_PERSISTENT_VARIABLES_HOLDER_ITEM_TAG );
        if( persistentVariablesHolder != OBJECT_INVALID ) {
            string mercsPreferidos = GetLocalString( persistentVariablesHolder, MercSpawn_mercsPreferidos_VN );
            if( !RL_isContained( mercsPreferidos, mercenarioResRef ) ) {
                mercsPreferidos = RL_addFront( mercsPreferidos, mercenarioResRef );
                mercsPreferidos = RL_trunkFront( mercsPreferidos, 4 );
                SetLocalString( persistentVariablesHolder, MercSpawn_mercsPreferidos_VN, mercsPreferidos );
            }
       }

        // agregar el ResRef de 'mercenario' a la cola de ResRef acomodados del area
        string colaAcomodados = GetLocalString( mercenarioArea, MercSpawn_colaAcomodados_VN );
        colaAcomodados = RL_addBack( colaAcomodados, mercenarioResRef );
        SetLocalString( mercenarioArea, MercSpawn_colaAcomodados_VN, colaAcomodados );
    }
}


struct MercSpawn_Censo {
    int cantMercenariosSueltos;
    int menorNivelPjs;
};

// da la cantidad de mercenarios sueltos, el nivel del PJ de menor nivel, y hace caminar a los abandonados
struct MercSpawn_Censo MercSpawn_censarYRetomar( object camino );
struct MercSpawn_Censo MercSpawn_censarYRetomar( object camino ) {
    struct MercSpawn_Censo censo;
    censo.menorNivelPjs = 40;

    object objectIterator = GetFirstObjectInArea();
    while( objectIterator != OBJECT_INVALID ) {
        if( GetIsPC( objectIterator ) ) {
            if( !GetIsDM(objectIterator) && GetHitDice( objectIterator ) < censo.menorNivelPjs )
                censo.menorNivelPjs = GetHitDice( objectIterator );
        }
        else if(
            GetObjectType( objectIterator ) == OBJECT_TYPE_CREATURE &&
            GetAssociateType( objectIterator ) == ASSOCIATE_TYPE_NONE &&
            GetTag( objectIterator ) == Mercenario_ES_DE_TABERNA_TAG
        ) {
            censo.cantMercenariosSueltos += 1;
            if( !GetLocalInt( objectIterator, Mercenario_estaCaminando_VN ) )
                AssignCommand( objectIterator, Mercenario_caminar( 0, camino ) );
        }

        objectIterator = GetNextObjectInArea();
    }
    return censo;
}


void MercSpawn_generarCr4( location ubicacion, object camino );
void MercSpawn_generarCr4( location ubicacion, object camino ) {
    Mercenario_generar( ubicacion, 0, camino );
}

void MercSpawn_generarCr6( location ubicacion, object camino );
void MercSpawn_generarCr6( location ubicacion, object camino ) {
    Mercenario_generar( ubicacion, 1, camino );
}

void MercSpawn_generarCr8( location ubicacion, object camino );
void MercSpawn_generarCr8( location ubicacion, object camino ) {
    Mercenario_generar( ubicacion, 2, camino );
}

void MercSpawn_generarCr11( location ubicacion, object camino );
void MercSpawn_generarCr11( location ubicacion, object camino ) {
    Mercenario_generar( ubicacion, 3, camino );
}

void MercSpawn_generarCr14( location ubicacion, object camino );
void MercSpawn_generarCr14( location ubicacion, object camino ) {
    Mercenario_generar( ubicacion, 4, camino );
}


void MercSpawn_generarCrMasCercano( location ubicacion, object camino, int cr );
void MercSpawn_generarCrMasCercano( location ubicacion, object camino, int cr ) {
    if( cr > 14 )
        cr = 14;
    else if ( cr < 4 )
        cr = 4;
    else if( cr == 5 )
        cr = 4 + 2 * Random( 2 );
    else if( cr == 7 )
        cr = 6 + 2*Random(2);
    else if( 8 < cr && cr < 11 )
        cr = 8 + 3*Random(2);
    else if( 11 < cr && cr < 14 )
        cr = 11 + 3*Random(2);


    if( cr == 4 )
        MercSpawn_generarCr4( ubicacion, camino );
    if( cr == 6 )
        MercSpawn_generarCr6( ubicacion, camino );
    if( cr == 8 )
        MercSpawn_generarCr8( ubicacion, camino );
    if( cr == 11)
        MercSpawn_generarCr11( ubicacion, camino );
    if( cr == 14)
        MercSpawn_generarCr14( ubicacion, camino );
}



// Prepara el inventario del mercenario
// Se asume que OBJECT_SELF es el mercenario
void Mercenario_prepararInventario();
void Mercenario_prepararInventario() {
    SetLootable( OBJECT_SELF, TRUE );
    SetIsDestroyable( TRUE, TRUE, TRUE );
    NPC_prepararInventario( "esDelMercenario" );
}


void MercSpawn_rutina( object camino ) {
//    SendMessageToPC( GetFirstPC(), "rituna begin" );
    if( GetLocalInt( OBJECT_SELF, MercSpawn_isActive_VN ) && Area_isAPjInside( OBJECT_SELF ) ) {
        struct MercSpawn_Censo censo = MercSpawn_censarYRetomar( camino );
//        SendMessageToPC( GetFirstPC(), "cantMercesSueltos="+IntToString(cantMercesSueltos) );
        if( censo.cantMercenariosSueltos < 4 ) {
            MercSpawn_generarCrMasCercano( GetLocation( camino ), camino, censo.menorNivelPjs );
        }
        DelayCommand( IntToFloat( 3 * censo.cantMercenariosSueltos + 5 ), MercSpawn_rutina( camino ) );

    } else {
        SetLocalInt( OBJECT_SELF, MercSpawn_estaGeneracionActiva_VN, FALSE );

    }
}

// Para que un area genere henchmans contratables por PJs deben cumplirse tres cosas:
// 1) su onAreaEnter handler debe llamar a esta funcion
// 2) el area debe contener un waypoint cuyo tag sea el valor de la constante MercSpawn_ENTRADA_WAYPOINT_TAG, y X o mas waypoints con tag igual al valor de la constante MercSpawn_WALK_WAYPOINT_TAG; donde X debe ser mayor al valor de la constante MercSpawn_WALK_WAYPOINT_RANGE
// 3) la variable de area de tipo int con nombre igual a la constante MercSpawn_isActive_VN debe ser distinta de cero.
void Mercenario_onPjEntersTavern( object pj );
void Mercenario_onPjEntersTavern( object pj ) {

    if( GetLocalInt( OBJECT_SELF, MercSpawn_isActive_VN ) && !GetLocalInt( OBJECT_SELF, MercSpawn_estaGeneracionActiva_VN ) ) {
        DeleteLocalString( OBJECT_SELF, MercSpawn_exclusionList_VN );

        //agregar los mercenarios preferidos del 'pj' a la cola de mercenarios acomodados
        object persistentVariablesHolder = GetItemPossessedBy( pj, MercSpawn_PC_PERSISTENT_VARIABLES_HOLDER_ITEM_TAG );
        if( persistentVariablesHolder != OBJECT_INVALID ) {
            string mercsPreferidos = GetLocalString( persistentVariablesHolder, MercSpawn_mercsPreferidos_VN );
            string colaAcomodados = GetLocalString( OBJECT_SELF, MercSpawn_colaAcomodados_VN );
            colaAcomodados = RL_appendBack( colaAcomodados, mercsPreferidos );
            SetLocalString( OBJECT_SELF, MercSpawn_colaAcomodados_VN, colaAcomodados );
        }

        object camino = GetNearestObjectByTag( MercSpawn_ENTRADA_WAYPOINT_TAG, pj );
//        SendMessageToPC( GetFirstPC(), "entradaWaypoint="+GetTag(entradaWaypoint) );

        struct MercSpawn_Censo censo = MercSpawn_censarYRetomar( camino );

        int i = 4;
        while( --i >= 0 ) {
            object walkWaypoint = GetNearestObjectByTag( MercSpawn_WALK_WAYPOINT_TAG, camino, Random( MercSpawn_WALK_WAYPOINT_RANGE )+1 );
//            SendMessageToPC( GetFirstPC(), "walkWaypoint="+GetTag(walkWaypoint) );
            DelayCommand( IntToFloat(i), MercSpawn_generarCrMasCercano( GetLocation(walkWaypoint), camino, censo.menorNivelPjs ) );
        }
        SetLocalInt( OBJECT_SELF, MercSpawn_estaGeneracionActiva_VN, TRUE );
        DelayCommand( 30.0, MercSpawn_rutina( camino ) );
    }
}


// Must be called from the onDeath handler of active henchmans
void Mercenario_onDeath();
void Mercenario_onDeath() {
    object master = GetMaster(OBJECT_SELF);
    if( GetIsObjectValid( master ) && GetLootable(OBJECT_SELF) ) {
        SetIsDestroyable( FALSE, TRUE, TRUE );
        SetLocalString( OBJECT_SELF, Mercenario_masterName_VN, GetName(master,TRUE) );

        object itemCuerpo = CreateItemOnObject( "cuerpo", OBJECT_SELF, 1, Mercenario_itemCuerpo_TAG );
        SetDroppableFlag( itemCuerpo, TRUE );
        SetName( itemCuerpo, GetName( OBJECT_SELF ) );
        SetLocalObject( itemCuerpo, Mercenario_criaturaCuerpo_VN, OBJECT_SELF );
        SetLocalString( itemCuerpo, Mercenario_resRef_VN, GetResRef( OBJECT_SELF ) );
        SetLocalString( itemCuerpo, Mercenario_masterName_VN, GetName( master, TRUE) );
    }
}


void Mercenario_destruirse() {
    SetIsDestroyable( TRUE );
    DestroyObject( OBJECT_SELF );
}

// Must be called from the onAcquire event handler when the acquirer is a player character.
// Note: only doees something if 'item' has a tag equal to Mercenario_itemCuerpo_TAG
void Mercenario_onPcAcquiresItem( object pj, object item, object sourceContainer );
void Mercenario_onPcAcquiresItem( object pj, object item, object sourceContainer ) {
//    SendMessageToPC( GetFirstPC(), "Mercenario_onPcAcquiresItem: sourceContainerName="+GetName(sourceContainer)+", sourceContainerTag="+GetTag(sourceContainer)+", sourceContainerResRef="+GetResRef(sourceContainer) );
    // si el item adquirido es un item que representa el cuerpo de un mercenario, y proviene de un cuerpo
    if ( GetTag(item) == Mercenario_itemCuerpo_TAG && GetTag(sourceContainer) == "BodyBag" ) {
        SetDroppableFlag( item, TRUE ); // necesario porque el motor automaticamente pone no droppable cualquier item cada vez que es adquirido por un PJ
        object criaturaCuerpo = GetLocalObject( item, Mercenario_criaturaCuerpo_VN );
//        SendMessageToPC( GetFirstPC(), "Mercenario_onPcAcquiresItem: criaturaCuerpo="+GetName(criaturaCuerpo) );
        AssignCommand( criaturaCuerpo, Mercenario_destruirse() );
        DeleteLocalObject( item, Mercenario_criaturaCuerpo_VN );
    }
}


void Mercenario_matarMercenarioMuerto(object itemCuerpo) {
    SetDroppableFlag( itemCuerpo, TRUE ); // por las dudas el motor ponga en no droppable cuando el item es desadquirido
    DeleteLocalInt( itemCuerpo, "esDelMercenario" ); // por las dudas el onSpawn del mercenario (que marca a todos sus items "esDelMercenario" ) se ejecuta luego de ponerle el itemCuerpo en su inventario, borrar tal marca.
    SetIsDestroyable( FALSE, TRUE, TRUE );
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints(OBJECT_SELF) + 50, DAMAGE_TYPE_MAGICAL), OBJECT_SELF );
}

// funcion privada llamada por 'Mercenario_onPcUnacquiresItem(..)'
void Mercenario_convertirItemEnCriatura() {
    object itemCuerpo = OBJECT_SELF;
    // si el 'itemCuerpo' fue puesto en el suelo
    if( !GetIsObjectValid(GetItemPossessor(itemCuerpo)) && GetIsObjectValid(GetArea(itemCuerpo)) ) {
        // crear cuerpo de mercenario. Notar que el mercenario creado no se activa, sino que solo se lo crea para matarlo y asi tener un cuerpo resusitable
        object criaturaCuerpo = Mercenario_crear( GetLocalString( itemCuerpo, Mercenario_resRef_VN ), GetLocation(itemCuerpo) );
        SetLocalString( criaturaCuerpo, Mercenario_masterName_VN, GetLocalString( itemCuerpo, Mercenario_masterName_VN ) );
        SetName( criaturaCuerpo, GetName(itemCuerpo) );
        SetLocalString( criaturaCuerpo, "master", GetLocalString( itemCuerpo, Mercenario_masterName_VN ) ); // la variable "master" es usada por lo que queda del sistema viejo de contratacion de mercenarios y sirve para distinguir quien es el master.

        DestroyObject(itemCuerpo);
        itemCuerpo = CopyItem( itemCuerpo, criaturaCuerpo, TRUE );
        SetLocalObject( itemCuerpo, Mercenario_criaturaCuerpo_VN, criaturaCuerpo );

        SetLootable( criaturaCuerpo, TRUE );
        AssignCommand( criaturaCuerpo, Mercenario_matarMercenarioMuerto(itemCuerpo) );
    }
}

// Must be called from the onUnacquire event handler when the unacquirer is a player character.
// Note: only doees something if 'item' has a tag equal to Mercenario_itemCuerpo_TAG
void Mercenario_onPcUnacquiresItem( object unacquirer, object item );
void Mercenario_onPcUnacquiresItem( object unacquirer, object item ) {
    if ( GetTag( item ) == Mercenario_itemCuerpo_TAG ) {
//        SendMessageToPC( GetFirstPC(), "Mercenario_onPcUnacquiresItem: itemName="+GetName(item)+", resRef="+GetLocalString( item, Mercenario_resRef_VN ) );
        AssignCommand( item, Mercenario_convertirItemEnCriatura() ); // el assignCommand es para que la accion se realice cuando el item ya este en su destino y asi poder saber cual es.
    }
}


// Must be called from the onSuccessfullRest event handler when the sleeping creature is a player character
void Mercenario_onPcSuccessfullyRest( object pc );
void Mercenario_onPcSuccessfullyRest( object pc ) {

    object area = GetArea( pc );

    // buscar mejor sanador del party
    object mejorSanadorRef;
    int mejorSanadorAptitud = -99; // -99 un valor superable por cualquiera
    object miembroIterado = GetFirstFactionMember( pc, FALSE );
    while( miembroIterado != OBJECT_INVALID ) {
        if(
            GetArea(miembroIterado) == area
            && ( GetIsPC(miembroIterado) || GetAssociateType(miembroIterado)==ASSOCIATE_TYPE_HENCHMAN )
        ) {
            int miembroIteradoAptitud = GetSkillRank( SKILL_HEAL, miembroIterado );
            if( miembroIteradoAptitud > mejorSanadorAptitud ) {
                mejorSanadorRef = miembroIterado;
                mejorSanadorAptitud = miembroIteradoAptitud;
            }
        }
        miembroIterado = GetNextFactionMember( pc, FALSE );
    }

    object iteratedObject = GetFirstObjectInArea( area );
    while( iteratedObject != OBJECT_INVALID ) {
        if(
            GetIsDead( iteratedObject )
            && GetTag( iteratedObject ) == Mercenario_ES_DE_TABERNA_TAG
            && GetDistanceBetween( iteratedObject, pc ) < 20.0
            && GetLocalString( iteratedObject, Mercenario_masterName_VN ) == GetName( pc, TRUE )
        ) {
            // revivir al mercenario ( a 1HP ).
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectResurrection(), iteratedObject );

            // luego sanarlo tanto como lo que lo sanaria una venda aplicada por el mejor sanador del party
            int sanado = Vendas_calcularSanado( mejorSanadorRef, iteratedObject, 0 );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( sanado ), iteratedObject );

            // destruir item que representa el cuerpo, agregar al mercenario al party, e inicializar su AI
            DestroyObject( GetItemPossessedBy( iteratedObject, Mercenario_itemCuerpo_TAG ) );
            AddHenchman( pc, iteratedObject );
            SetLocalInt(iteratedObject, "merc", 1);
        }
        iteratedObject = GetNextObjectInArea( area );
    }
}



