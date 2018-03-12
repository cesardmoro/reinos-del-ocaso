/******************************************************************************
Package: RandomSpawn - Area_onEnter handler
Author: Inquisidor
Version: 0.1
Descripcon: Aqui esta el handler que debe ser llamado desde el onEnter handler de
las areas que se pretenda generen random spawn.
*******************************************************************************/

#include "RS_inc"
#include "Area_generic"


// da la cantidad de henchmans asociados al pj dado
int getCantidadHenchman( object pj );
int getCantidadHenchman( object pj ) {
    int cantHenchmans = 0;
    int indexIterator = GetMaxHenchmen();
    do {
        if( GetIsObjectValid( GetHenchman( pj, indexIterator ) ) )
            cantHenchmans += 1;
    } while( --indexIterator > 0 );
    return cantHenchmans;
}


// Da la cantidad de sujetos (personajes y henchmans) que hay en este area
// Esta funcion es privada al RandomSpawn. No esta pensada para ser usada para otra cosa.
int RS_getCantidadSujetos();
int RS_getCantidadSujetos() {
    int cantSujetos = 0;

    object pjIterator = GetFirstPC();
    while( pjIterator != OBJECT_INVALID ) {
        if( GetArea( pjIterator ) == OBJECT_SELF && !GetIsDM(pjIterator) ) {
            cantSujetos += 1 + getCantidadHenchman( pjIterator );
        }
        pjIterator = GetNextPC();
    }
    return cantSujetos;
}


// Da TRUE si la criatura fue generada por el sistema de RandomSpawn
int RS_isRandomSpawn( object criatura );
int RS_isRandomSpawn( object criatura ) {
    return GetTag( criatura ) == RS_CRIATURA_TAG;
}


// Da la cantidad de segundos entre dos spawn sucesivos en un area con 'n' sujetos.
// Explicacion: Un aspecto de la dificultad a sobrevivir en un area, es la frecuencia
// a la que spawnean criaturas por cada sujeto dentro del area.
// O sea que este aspecto de la dificultad (abundancia) es proporcional a la frecuencia
// de spawn e inversamente proporcional a la cantidad de sujetos en el area: d ~ f / n
// Esta funcion da un periodo 'p' (=1/f) de spawn tal que:
// abundancia sea:
// a) la dificultad decrezca a medida que sube la cantidad de sujetos.
// b) la dificultad debida a la abundancia sea un 50% mayor para un PJ solitario
// que para un party de cinco sujetos ( d(1) == 3/2 d(5) ).
// c) la dificultad debida a la abundancia para un party de cinco miembros sea el doble
// que para un party de infinitos miembros ( d(5) = 2 d(infinito) )
// d) el periodo sea una funcion polinomica de orden bajo
// e) el periodo sea de RS_PERIODO_TIPICO_ENTRE_ENCUENTROS_SUCESIVOS_CUANDO_CINCO_SUJETOS segundos para un party de cinco miembros
float RS_periodoEnSegundos( int n );
float RS_periodoEnSegundos( int n ) {
    float periodo = IntToFloat( ( 3 + n ) * 10 * RS_PERIODO_TIPICO_ENTRE_ENCUENTROS_SUCESIVOS_CUANDO_CINCO_SUJETOS ) / IntToFloat( ( 11 + n ) * n );
    return periodo * IntToFloat( 70 + Random(61) ) / 100.0;
}


// Rutina de muestreo y generacion de ecuentros sucesivos. Se ejecuta
// periodicamente a una frecuencia que es funcion creciente respecto a cantiad
// de sujetos intrusos en el area.
// Llamada por primera vez desde RS_onEnter()
// Esta funcion es privada al RandomSpawn. No esta pensada para ser usada para otra cosa.
void RS_routine( int numeroEncuentroSucesivo, int temporizadorLimpieza );
void RS_routine( int numeroEncuentroSucesivo, int temporizadorLimpieza ) {

//    SendMessageToPC( GetFirstPC(), "routine: begin "+GetTag(OBJECT_SELF) );
    float periodo;
    int cantSujetos = RS_getCantidadSujetos();
    SetLocalInt( OBJECT_SELF, RS_cantSujetosEnArea_VN, cantSujetos );

    // si hay PJs en el area...
    if( cantSujetos > 0 ) {
        // resetear temporizador de limpieza
        temporizadorLimpieza = 0;

        // si el area tiene CR > 0...
        int crArea = GetLocalInt( OBJECT_SELF, RS_crArea_PN );
        if( crArea > 0 ) {

            // Si el area esta hostil, generar encuentro sucesivo
            if( GetLocalInt( OBJECT_SELF, RS_estado_VN ) == RS_Estado_HOSTIL  ) {
                // incrementar el numero de encuentro sucesivo. Inicialmente es cero, asi que para el primer encuentro sucesivo valdrá uno.
                numeroEncuentroSucesivo += 1;

                // guardar las variables que necesita el SGE donde las pueda obtener
                SetLocalInt( OBJECT_SELF, RS_numeroEncuentroSucesivo_VN, numeroEncuentroSucesivo );

                // ejecutar el SGE
                string sge = GetLocalString( OBJECT_SELF, RS_sge_PN );
                sge = GetStringLeft( sge, 16 ); // agregado porque lobo en algunas áreas se puso la propiedad RS_sge sin recortar el valor. Ejemplo: "sgeBosqueTemplado" en lugar de "sgeBosqueTemplad"
                ExecuteScript( sge, OBJECT_SELF );

                // calcular cuanto tiempo esperar para la generacion del proximo encuentro sucesivo
                periodo = RS_periodoEnSegundos( cantSujetos )*( 1.0 + GetLocalFloat( OBJECT_SELF, RS_modificadorPeriodoSpawn_PN ) ); // periodo de muestreo y generacion de encuentros cuando el area esta activa hostil
                if( GetIsAreaInterior( OBJECT_SELF ) )
                    periodo *= 0.75;
                if( numeroEncuentroSucesivo > RS_getCantidadRefuerzos(OBJECT_SELF) )
                    periodo *= 3.0;
            }
            else // si no esta hostil (esta alerta), seguir tomando muestras a periodo constante.
                periodo = 30.0; // periodo de muestreo (no se generan encuentros) cuando el area NO esta hostil
        }
        else // si el area tiene CR == 0, seguir tomando muestras a periodo constante, pero con el tiempo de actividad congelado (no sube la dificultad).
            periodo = 60.0;  // periodo de muestreo (no se generan encuentros) cuando el area esta activa con CR == 0 (algun DM la paralizo)

//        SendMessageToPC( GetFirstPC(), "routine: routine programed for "+GetTag(OBJECT_SELF) );

    }
    // si no hay sujetos en el area, incrementar el temporizador de limpieza y seguir tomando muestras a periodo constante,
    else if( ++temporizadorLimpieza <= 4 )
        periodo = 30.0;
    // si el area se mantuvo sin sujetos intrusos (al menos en los instantes de muestreo) durante cierto tiempo, limpiar el area y finalizar esta rutina de muestreo y generacion de spawn sucesivo.
    else {
        RS_Area_clean(OBJECT_SELF);
        return;
    }

    // ciclo de la rutina
    DelayCommand( periodo, RS_routine( numeroEncuentroSucesivo, temporizadorLimpieza ) );

//    SendMessageToPC( GetFirstPC(), "routine: end for "+GetTag(OBJECT_SELF) );
}


//________________________________________________________________________________


// genera el spawn inicial distribuido en el tiempo
// Esta funcion es privada al RandomSpawn. No esta pensada para ser usada para otra cosa.
void RS_distribuirSpawnInicial( string sge, int cantiEncuentrosFaltantes, float intervaloDistribucionTemporal ) {

    ExecuteScript( sge, OBJECT_SELF );
    if( --cantiEncuentrosFaltantes > 0 )
        DelayCommand( intervaloDistribucionTemporal, RS_distribuirSpawnInicial( sge, cantiEncuentrosFaltantes, intervaloDistribucionTemporal ) );
    else
        SetLocalObject( OBJECT_SELF, RS_enteringPj_VN, OBJECT_INVALID ); // esta variable es la que determina al SGE si generar un encuentro correspondiente al spawn inicial o al spawn sucesivo.
}


// Funcion que debe ser llamada desde el onEnter handler de las areas donde se pretenda haya random spawn cuando entra un personaje controlado por un jugador o DM.
// Se asume que GetIsPC(pc) da TRUE
void RS_onPcEntersArea( object pc );
void RS_onPcEntersArea( object pc ) {
//    SendMessageToPC( GetFirstPC(), "onEnter: begin for "+GetTag(OBJECT_SELF)+", enterigObject="+GetName(pc));
    if( !GetIsDM(pc) ) {
        string sge = GetLocalString( OBJECT_SELF, RS_sge_PN );
        if( sge == "" && GetLocalInt( OBJECT_SELF, RS_crArea_PN ) > 1 ) { // se compara con uno y no con cero porque el uno se usa para las áreas que no asimilan la XP transitoria al dormir.
            WriteTimestampedLogEntry( "RS: error, al area "+GetTag(OBJECT_SELF)+" le falta definir la propiedad "+RS_sge_PN );
            return;
        }
        // obtener el estado del area
        int estadoViejo = GetLocalInt( OBJECT_SELF, RS_estado_VN );
        int estadoNuevo = estadoViejo | RS_Estado_ACTIVO;
        string tipoSpawn = RS_getTipoSpawn( OBJECT_SELF );

        // si el area no esta hostil y entra un PJ que mato una criatura del tipo de este area, pasar a estado hostil
        if( estadoViejo != RS_Estado_HOSTIL && FindSubString( GetLocalString( pc, RS_tiposSpawnHostiles_VN ), tipoSpawn ) != -1 )
            estadoNuevo = RS_Estado_HOSTIL;

        // si el area estaba pasiva, generar el spawn inicial y programar la generación de los encuentros sucesivos
        if( estadoViejo == RS_Estado_PASIVO ) {

            // generar un numero al azar que se mantiene durante un ciclo del estado del area
            SetLocalInt( OBJECT_SELF, RS_dadoCicloEstado_VN, Random( 1000 ) );

            int cantRefuerzosSalteadosPorPersecucion = 0;

            // si CR > 0, generar spawn inicial
            int crArea = GetLocalInt( OBJECT_SELF, RS_crArea_PN );
            if( crArea > 0 ) {

                // calcular cuantos encuentros tiene el spawn inicial
                int superficieArea = GetAreaSize( AREA_WIDTH, OBJECT_SELF ) * GetAreaSize( AREA_HEIGHT, OBJECT_SELF );
                int superficieEncuentro = RS_getSuperficiePorEncuentro( OBJECT_SELF );
                int cantEncuentros = 1 + superficieArea / superficieEncuentro;

                // guardar las variables que usa el SGE donde las pueda obtener
                SetLocalObject( OBJECT_SELF, RS_enteringPj_VN, pc );

                // ejecutar el script de preparacion de area.
                string scriptPreparacionArea = GetLocalString( OBJECT_SELF, RS_scriptPreparacionArea_PN );
                if( GetStringLength(scriptPreparacionArea) != 0 )
                    ExecuteScript( scriptPreparacionArea, OBJECT_SELF );

                // Llamar al SGE para cada encuentro inicial. Para evitar los congelamientos, se distribuye el consumo de recursos del procesador del spawn inicial en el tiempo
                float intervaloDistribucionTemporal = 12.0 / IntToFloat( cantEncuentros );
                RS_distribuirSpawnInicial( sge, cantEncuentros, intervaloDistribucionTemporal );

                // si el tipo de spawn del area actual esta hostil con el PJ que entra, y el CR del area aterior es mayor o igual al CR del area actual, y el area anterior tiene el mismo tipo de spawn
                // calcular la cantidad de refuerzos salteados por persecucion. Los refuerzos salteados son los de menor poder. O sea que esto aumenta la dificultad del primer refuerzo, y disminuye la cantidad de refuerzos
                if( estadoNuevo == RS_Estado_HOSTIL ) {
                    object areaAnterior = GetLocalObject( pc, RS_areaAnterior_VN );
                    if(
                        GetIsObjectValid(areaAnterior)
                        && GetLocalInt( areaAnterior, RS_crArea_PN ) >= crArea
                        && tipoSpawn == RS_getTipoSpawn( areaAnterior )
                    ) {
                        int numeroEncuentroSucesivoAreaAnterior = GetLocalInt( areaAnterior, RS_numeroEncuentroSucesivo_VN );
                        int cantidadRefuerzosAreaAnterior = RS_getCantidadRefuerzos( areaAnterior );
                        if( numeroEncuentroSucesivoAreaAnterior <= cantidadRefuerzosAreaAnterior ) {
                            int cantidadRefuerzosAreaActual   = RS_getCantidadRefuerzos( OBJECT_SELF );
                            int numeroEncuentroAreaActualEquivalente = (cantidadRefuerzosAreaActual*numeroEncuentroSucesivoAreaAnterior)/cantidadRefuerzosAreaAnterior;
                            cantRefuerzosSalteadosPorPersecucion = numeroEncuentroAreaActualEquivalente - cantidadRefuerzosAreaActual/2;
                            if( cantRefuerzosSalteadosPorPersecucion < 0 )
                                cantRefuerzosSalteadosPorPersecucion = 0;
                        }
                        else
                            cantRefuerzosSalteadosPorPersecucion = 0;
                    }
                }
            }

            // poner en marcha la rutina de muestreo y generaciond del spawn sucesivo
            float retardoPrimerEncuentro = RS_RETARDO_TIPICO_PRIMER_ENCUENTRO*( 1.0 + GetLocalFloat( OBJECT_SELF, RS_modificadorPeriodoSpawn_PN ) );
            DelayCommand( retardoPrimerEncuentro, RS_routine( cantRefuerzosSalteadosPorPersecucion, 0 ) );
        }

        // guardar el estado actualizado. Lo usa la rutina de muestreo y generacion de spawn sucesivo.
        SetLocalInt( OBJECT_SELF, RS_estado_VN, estadoNuevo );

        if( GetPCPublicCDKey(pc)=="RFJKFCQW" )
            SendMessageToPC( pc, "CR="+IntToString(GetLocalInt( OBJECT_SELF, RS_crArea_PN ))+", fta="+IntToString(GetLocalInt(OBJECT_SELF,RS_factorTransitoArea_PN))+", sge="+sge+", tipo="+tipoSpawn );
    }

//    SendMessageToPC( GetFirstPC(), "onEnter: end for "+GetTag(OBJECT_SELF) );
}
