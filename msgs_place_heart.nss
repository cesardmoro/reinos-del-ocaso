int HayPJsEnElArea( object area )
{
    int hayPJs = FALSE;
    object objetoIterado = GetFirstObjectInArea( area );
    while (GetIsObjectValid(objetoIterado))
    {
        if (GetIsPC(objetoIterado))
        {
            hayPJs = TRUE;
            break;
        }
        objetoIterado = GetNextObjectInArea( area );
    }
    return hayPJs;
}

void main()
{
    if (!HayPJsEnElArea( GetArea(OBJECT_SELF) ))
    {
        DestroyObject( OBJECT_SELF, 1.0 );
    }
}
