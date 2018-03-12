/************************* Time ************************************************
Author: Inquisidor
Descripcion: funciones para medicion de intervalos de tiempo
*******************************************************************************/


const int Time_MINUTES_IN_AN_HOUR = 3;
const int Time_SECONDS_IN_AN_HOUR = 180; // = Time_MINUTES_IN_AN_HOUR*60
const int Time_SECONDS_IN_A_DAY = 4320; // = 24*Time_MINUTES_IN_AN_HOUR*60

//////////////////////// Module Variable Prefixes //////////////////////////////
const string Time_LastRestDate_MVP         = "TmLRestD";


// da los segundos que transcurrieron desde el 1/1/1500 a las 00:00:00
int Time_secondsSince1300();
int Time_secondsSince1300()
    /* Restricciones: el anio obtenido por GetCalendarYear() debe ser menor a 60/3*4438 */
{
    int hours = GetTimeHour();
    hours += ( GetCalendarDay()-1 ) * 24;
    hours += ( GetCalendarMonth()-1 ) * 672;
    hours += (GetCalendarYear()-1300) * 8064;
    return hours * FloatToInt( HoursToSeconds(1) + 0.5 ) + 60*GetTimeMinute() + GetTimeSecond();
//    SendMessageToPC( GetFirstPC(), "time in minutes =" + IntToString( time ) );
}


const int Time_SECONDS_BETWEEN_RESTS = 720; //= 4*Time_MINUTES_IN_AN_HOUR*60

int Time_getSecondsSinceLastRest( object subject );
int Time_getSecondsSinceLastRest( object subject ) {
    int lastTimeRested = GetLocalInt( GetModule(), Time_LastRestDate_MVP + GetName(subject, TRUE) );
    return Time_secondsSince1300() - lastTimeRested;
}
void Time_registerRestTime( object subject );
void Time_registerRestTime( object subject ) {
    SetLocalInt( GetModule(), Time_LastRestDate_MVP + GetName(subject, TRUE), Time_secondsSince1300() );
}


