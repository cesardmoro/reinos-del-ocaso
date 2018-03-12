#include "CST_inc"

int StartingConditional() {
    object pc = GetPCSpeaker();
    return Time_secondsSince1300() - GetLocalInt( GetModule(), CST_LastCureDate_MVP + GetName(pc) ) > CST_MIN_TIME_BETWEEN_CURES;
}
