#include "CST_inc"

const int OPTION_INDEX = 1;

int StartingConditional() {
    return OPTION_INDEX < GetLocalInt( OBJECT_SELF, CST_DEAD_BODIES_ARRAY_SIZE );
}
