#include "Cochero"

int StartingConditional() {
    return Cochero_getEstado( OBJECT_SELF ) == Cochero_Estado_VIAJANDO;
}
