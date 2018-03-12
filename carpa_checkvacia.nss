#include "carpas_itf"

int StartingConditional()
{
    int tentAreaId = Carpas_GetAreaIdFromPlaceable( OBJECT_SELF );
    object areaCarpa = Carpas_GetTentAreaFromAreaId( tentAreaId );

    object objetoIterado = GetFirstObjectInArea( areaCarpa );
    while (GetIsObjectValid( objetoIterado )) {
        if (GetIsPC( objetoIterado ))
            return FALSE;
        objetoIterado = GetNextObjectInArea( areaCarpa );
    }

    return TRUE;
}
