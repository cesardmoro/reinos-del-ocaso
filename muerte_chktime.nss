#include "muerte_inc"
#include "Time_inc"

int StartingConditional() {
    string pcId = GetStringLeft( GetName(GetLastSpeaker()), 25 );
    int penitenciaFaltante = GetLocalInt( GetModule(), Muerte_Penitencia_fechaFin_MVP + pcId ) - Time_secondsSince1300();
    SetCustomToken( 5850, IntToString( penitenciaFaltante ) );
    return penitenciaFaltante > 0;
}
