void main() {
    object exitingObject = GetExitingObject();

    if( GetIsPC(exitingObject) && !GetIsDM(exitingObject) ) {
        // quitar a 'exitingObject' todos los efectos de tipo EFFECT_TYPE_SPELL_FAILURE
        effect effectIterator = GetFirstEffect( exitingObject );
        while( GetIsEffectValid( effectIterator ) ) {
            if( GetEffectType( effectIterator ) == EFFECT_TYPE_SPELL_FAILURE )
                RemoveEffect( exitingObject, effectIterator );
            effectIterator = GetNextEffect( exitingObject );
        }
    }
}
