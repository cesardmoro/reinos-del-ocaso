#include "CST_inc"

int StartingConditional() {
    object pc = GetPCSpeaker();
    return
        GetLocalInt( OBJECT_SELF, CST_DEAD_BODIES_ARRAY_SIZE ) > 0
        ;
}
