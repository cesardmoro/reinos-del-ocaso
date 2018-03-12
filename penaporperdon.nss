/***************** sistema de castigo por muertes *****************************
Package: Sistema de muerte - penitencia en el fugue
Author: Inquisidor
Descripcion: funciones usadas por el sistema de muerte para calcular la duracion
de la penitencia en el fugue.
******************************************************************************/
#include "SPC_inc"

/////////////////////////////////////////////////////////////////////////////
/////////////////////// private functions ///////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

string minutesToText( int minutes ) {
    int hours = minutes / 60;
    minutes -= hours * 60;
    int days = hours / 24;
    hours -= days * 24;
    string text = "";
    if( days!=0 )
        text += IntToString(days) + " dias ";
    if( hours!=0 )
        text += IntToString(hours) + " horas ";
    text += IntToString(minutes) + " minutos ";
    return text;
}

int getTimeInMinutes()
    /* Restricciones: el anio obtenido por GetCalendarYear() debe ser menor a 60/3*4438 */
{
    int hours = GetTimeHour();
    hours += ( GetCalendarDay()-1 ) * 24;
    hours += ( GetCalendarMonth()-1 ) * 672;
    hours += GetCalendarYear() * 8064;
    return hours * FloatToInt( HoursToSeconds(1)/60.0 + 0.5 ) + GetTimeMinute();

//    SendMessageToPC( GetFirstPC(), "time in minutes =" + IntToString( time ) );
}


//// Campos de personaje en la la DB del administrador de perdones de personajes //////////
const string instanteUltimoPerdon_FIELD = "ittUtmMt"
    // minuto (getTimeInMinutes()) en que sucedió el ultimo perdon de este personaje
;
const string estadoFiltroPasaBajosIntervaloEntrePerdones_FIELD = "etdFtPsBjItvlEtMt"
    // estado del filtro pasa bajos de intervalos entre perdones
;


///////////////////// FiltroPasaBajosIntervaloEntrePerdones //////////////////////////
    /* Suavisa el intervalo entre perdones' aplicandole un filtro pasa bajos
    de orden 1, cuyo estado se mantiene en la DB del administrador de perdones de
    personajes.*/

int FiltroPasaBajosIntervaloEntrePerdones_getEstado( string pcId )
    /* obtiene la salida del filtro sin afectar su estado */
{
    string estadoRef = estadoFiltroPasaBajosIntervaloEntrePerdones_FIELD + pcId;
    int estado = GetCampaignInt( "Death", estadoRef );

    // Si es un PJ nuevo, inicializar el estado del filtro como si viniera muriendo una vez por semana.
    if( estado == 0 ) {
//        SendMessageToPC( GetFirstPC(), "Filtro: inicializacion de " + pcId );
        estado = 604800;  // = 7dias * 24horas * 60minutos * 60segundos
        SetCampaignInt( "Death", estadoRef, estado );
    }

    return estado;
}

int FiltroPasaBajosIntervaloEntrePerdones_aplicar( string pcId, int intervaloEntrePerdones )
    /* Aplica la muestra 'intervaloEntrePerdones' al filtro con el estado
    correspondiente al personaje dado por 'pdId'.
    Nota: La entrada 'intervaloEntrePerdones' es en minutos, y la salida en segundos.
    Restriccion: 0 < intervaloEntrePerdones < 5965232minutos ~ 12anios */
{
    string estadoRef = estadoFiltroPasaBajosIntervaloEntrePerdones_FIELD + pcId;
    int estado = FiltroPasaBajosIntervaloEntrePerdones_getEstado( pcId );
//    SendMessageToPC( GetFirstPC(), "Filtro: oldState="+IntToString( estado ) );
    estado = ( 5*estado + 60*intervaloEntrePerdones )/6;  // newState = ( 5*oldState + input )/6
    SetCampaignInt( "Death", estadoFiltroPasaBajosIntervaloEntrePerdones_FIELD + pcId, estado );
//    SendMessageToPC( GetFirstPC(), "Filtro: newState="+IntToString( estado ) );
    return estado;
}


////////////////////////////////////////////////////////////////////////////
///////////////////////// public functions /////////////////////////////////
////////////////////////////////////////////////////////////////////////////

// Cada llamada a esta funcion agrega un perdon en el registro de perdones
// correspondiente al 'pcId'. La frecuencia de estos perdones determina la pena
// de espera en el fugue para el 'pcId' dado. La espera es proporcional a la
// frecuencia de perdones de la vida del 'pcId'.
// Devuelve un mensaje para ser enviado al controlador del personaje dado por 'pcId'.
// Uso: Llamar a esta funcion cada vez que el perdon de la vida del 'sujeto'
// meresca ser compensado con castigo.
void ajustarPenaEspera( string pcId, object oPC );
void ajustarPenaEspera( string pcId, object oPC )
    /* Calcula la penaEspera en funcion del intervalo entre perdones.
    El resultado es inversamente proporcional al resultado de aplicar un filtro
    pasa bajos al intervalo entre los sucesivos perdones del personaje.
    El resultado es guardado para ser usado la proxima vez que el sujeto muera.
    Nota: Se asume que 'sujeto' es un PJ. */
{
    int instanteActual = getTimeInMinutes();

    // obtener y actualizar instanteUltimoPerdon en la DB
    string instanteUltimoPerdonRef = instanteUltimoPerdon_FIELD + pcId;
    int instanteUltimoPerdon = GetCampaignInt( "Death", instanteUltimoPerdonRef );
    SetCampaignInt( "Death", instanteUltimoPerdonRef, instanteActual );

    string mensaje;
    if( instanteUltimoPerdon == 0 ) {
        // genera el mensaje para el caso singular de que sea el primer perdon.
        SendMessageToPC(oPC, "Esta es la primera vez que la muerte de tu personaje es perdonada. Por razones tecnicas, sin embargo, se inicializará la frecuencia promedio de perdones como si hubiera muerto seis veces en las últimas seis semanas.");
    }
    else {
        // aplicar el filtro pasabajos al intervalo entre los ultimos dos perdones
        int minutosDesdeUltimoPerdon = instanteActual - instanteUltimoPerdon;
        int intervaloEntrePerdonesSuavizado = FiltroPasaBajosIntervaloEntrePerdones_aplicar( pcId, minutosDesdeUltimoPerdon );
        // generar el mensaje
        int frecuencia = 2592000 / intervaloEntrePerdonesSuavizado; // 2592000 = segundos en un mes (de 30 dias)
        SendMessageToPC(oPC, "El tiempo transcurrido desde la última vez que la vida de tu personaje fue perdonada es de " + minutesToText(minutosDesdeUltimoPerdon) + " reales, y la taza de perdones es " + IntToString( frecuencia ) + " veces por mes (30 dias reales).");
     }
     //return mensaje;
}


// Da la pena de espera en el fugue para el 'sujeto' dado. La espera es
// proporcional a la frecuencia de perdones de la vida del 'sujeto'.
// El valor de la pena varia solo cuando la funcion 'ajustarPenaEspera()' es
// llamada.
// Uso: puede ser llamada en cualquier momento ya que no altera nada.
// Nota: el parametro 'sujeto' solo es usado para calcular el tope de la pena.
int getPenaEspera( string pcId, object sujeto );
int getPenaEspera( string pcId, object sujeto )
    /* obtiene la pena por perdones de muerte que fue calculada en el ultimo perdon
    Nota: No altera nada excepto cuando inicializa el filtro pero eso es
    transparente para el usuario.*/
{
    float intervaloEntrePerdonesSuavizado = IntToFloat( FiltroPasaBajosIntervaloEntrePerdones_getEstado( pcId ) );

    // calcula la pena (en segundos para que resulte un minutos de espera si muere una vez cada dos semanas
    float penaEspera = 60.0 * 1209600.0 / intervaloEntrePerdonesSuavizado; // 1209600 = segundos en dos semanas

    // pagar pena de espara con xpTransitoria
    int xpTransitoriaPorMil = GetLocalInt( sujeto, SPC_xpTransitoriaPorMil_VN );
    penaEspera *= pow( 2.0, IntToFloat(-xpTransitoriaPorMil) / 172715.0 ); // calculada para que con 300 de xp transitoria paguen un 70% del tiempo de espera

    int penaEsperaRedondeada = FloatToInt( penaEspera );
    // aplica el tope a la pena
    int topePenaEspera = 60*GetHitDice( sujeto );
    if( penaEsperaRedondeada > topePenaEspera )
        penaEsperaRedondeada = topePenaEspera;

//    SendMessageToPC( GetFirstPC(), "penaEspera="+IntToString( penaEspera ) );

    return penaEsperaRedondeada;
}

//void main(){}
