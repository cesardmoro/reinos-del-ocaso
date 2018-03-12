/************************* Time ************************************************
Author: Inquisidor
Descripcion: funciones para medicion de intervalos de tiempo
*******************************************************************************/

// convierte la hora dada a segundos desde el comienzo del dia
int DateTime_timeToSeconds( int hours, int minutes, int seconds );
int DateTime_timeToSeconds( int hours, int minutes, int seconds ) {
    seconds += minutes * 60;
    seconds += FloatToInt( HoursToSeconds( hours ) );
    return seconds;
}


// da los segundos transcurridos desde las 0:0:0 del 1/1/1300
int DateTime_getActual();
int DateTime_getActual() {
    int hours = (GetCalendarYear()-1400) * 8064;
    hours += (GetCalendarMonth()-1) * 672;
    hours += (GetCalendarDay()-1) * 24;
    hours += GetTimeHour();
    int seconds = hours * FloatToInt( HoursToSeconds(1) );
    seconds += GetTimeMinute() * 60;
    seconds += GetTimeSecond();
//    SendMessageToPC( GetFirstPC(), "DateTime_getActualTime: seconds=" + IntToString( seconds ) );
    return seconds;
}


// da el resto de dividir el 'interval' dado por la cantidad de segundos en un dia
int DateTime_intervalModulusDay( int interval );
int DateTime_intervalModulusDay( int interval ) {
    int SECONDS_IN_A_DAY = FloatToInt( HoursToSeconds( 24 ) );
    int days = interval / SECONDS_IN_A_DAY;
    return interval - days * SECONDS_IN_A_DAY;
}

