// SGE deprecado
void main() {
    WriteTimestampedLogEntry( "Error, uso de SGE deprecado en area="+GetName(OBJECT_SELF)+", tag="+GetTag(OBJECT_SELF) );
    ExecuteScript( "sgeOrco1", OBJECT_SELF );
}

