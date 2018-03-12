#include "Experience_inc"
#include "XPW_inc"

void main() {
    object targetObject = GetLocalObject( GetPCSpeaker(), XPW_targetObject_VN );
    Experience_dar( targetObject, 1000 );
}
