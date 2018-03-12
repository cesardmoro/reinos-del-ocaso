#include "Time_inc"

void main() {
    object pc = GetPCSpeaker();
    SetLocalInt( GetModule(), CST_LastResurrectionDate_MVP + GetName(pc), Time_secondsSince1300() );
}
