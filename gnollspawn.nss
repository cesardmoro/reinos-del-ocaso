// DEPRECATED: borrar cuando se este seguro que no se usa mas
void main() {
    WriteTimestampedLogEntry( "Error, deprecated script 'gnollSpawn' was called from:"+GetName(OBJECT_SELF) );
    ExecuteScript( "sgeGnoll1", OBJECT_SELF );
}

