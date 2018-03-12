#include "confuse_itf"

// usado exclusivamente por 'Confuse_getEffect()'
void main() {
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectConfused()), OBJECT_SELF );
}
