#include "CST_inc"

int StartingConditional() {
    object pc = GetPCSpeaker();
    return
        GetLocalInt( OBJECT_SELF, CST_DEAD_BODIES_ARRAY_SIZE ) > 0
        && Time_secondsSince1300() - GetLocalInt( GetModule(), CST_LastResurrectionDate_MVP + GetName(pc) ) > CST_MIN_TIME_BETWEEN_RESURRECTS
    ;
}
