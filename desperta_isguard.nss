int StartingConditional()
{
    string NombreNPC = GetName(OBJECT_SELF);
    if ( (NombreNPC=="Guardia de Benzor") || (NombreNPC=="Mercenario del Puño Silencioso") || (NombreNPC=="Soldado de la Orden de Torm") )
        return TRUE;

    return FALSE;
}
