string Tester_getVerboseRacialType( object oCreature );
string Tester_getVerboseRacialType( object oCreature )
{
    switch (GetRacialType(oCreature)) {
        case RACIAL_TYPE_ABERRATION:        return "ABERRACION";
        case RACIAL_TYPE_ANIMAL:            return "ANIMAL";
        case RACIAL_TYPE_BEAST:             return "BESTIA";
        case RACIAL_TYPE_CONSTRUCT:         return "CONSTRUCTO";
        case RACIAL_TYPE_DRAGON:            return "DRAGON";
        case RACIAL_TYPE_DWARF:             return "ENANO";
        case RACIAL_TYPE_ELEMENTAL:         return "ELEMENTAL";
        case RACIAL_TYPE_ELF:               return "ELFO";
        case RACIAL_TYPE_FEY:               return "HADA";
        case RACIAL_TYPE_GIANT:             return "GIGANTE";
        case RACIAL_TYPE_GNOME:             return "GNOMO";
        case RACIAL_TYPE_HALFELF:           return "SEMIELFO";
        case RACIAL_TYPE_HALFLING:          return "MEDIANO";
        case RACIAL_TYPE_HALFORC:           return "SEMIORCO";
        case RACIAL_TYPE_HUMAN:             return "HUMANO";
        case RACIAL_TYPE_HUMANOID_GOBLINOID:    return "GOBLINOIDE";
        case RACIAL_TYPE_HUMANOID_MONSTROUS:    return "HUMANOIDE MONSTRUOSO";
        case RACIAL_TYPE_HUMANOID_ORC:          return "ORCO";
        case RACIAL_TYPE_HUMANOID_REPTILIAN:    return "REPTILIANO";
        case RACIAL_TYPE_MAGICAL_BEAST:         return "BESTIA MAGICA";
        case RACIAL_TYPE_OOZE:                  return "GELATINA";
        case RACIAL_TYPE_OUTSIDER:              return "AJENO";
        case RACIAL_TYPE_SHAPECHANGER:          return "CAMBIAFORMAS";
        case RACIAL_TYPE_UNDEAD:                return "NO MUERTO";
        case RACIAL_TYPE_VERMIN:                return "INSECTO";
        default:                                return "RAZA INVALIDA";
    }
    return "RAZA INVALIDA";
}

void Tester_traceAllObjectsInArea( object oPC );
void Tester_traceAllObjectsInArea( object oPC )
{
    object oArea = GetArea(oPC);
    object objetoIterado = GetFirstObjectInArea( oArea );
    string debug_message = "";
    while ( GetIsObjectValid(objetoIterado) )
    {
        if ( GetObjectType(objetoIterado) == OBJECT_TYPE_CREATURE ) {
            debug_message += "Criatura: "+GetName(objetoIterado)+" ("+Tester_getVerboseRacialType(objetoIterado)+") "+IntToString(GetCurrentHitPoints(objetoIterado))+"/"+IntToString(GetMaxHitPoints(objetoIterado))+" HP\n";
        } else if ( GetObjectType(objetoIterado) == OBJECT_TYPE_PLACEABLE ) {
            debug_message += "Placeable: "+GetName(objetoIterado)+"\n";
        }
        objetoIterado = GetNextObjectInArea( oArea );
    }
    SendMessageToPC( oPC, debug_message );
}

int Tester_GetIsTester( object oPC );
int Tester_GetIsTester( object oPC )
{
    string cdKey = GetPCPublicCDKey(oPC);
    return ( cdKey == "MLQCEL4J" );
}

void Tester_onPlayerChat( string message, object oPC );
void Tester_onPlayerChat( string message, object oPC )
{
    if ( Tester_GetIsTester(oPC) )
    {
        if ( GetStringUpperCase(message) == "TRACE OBJECTS" ) {
            Tester_traceAllObjectsInArea( oPC );
        }
    }
}

