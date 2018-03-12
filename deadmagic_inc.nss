/***************************************************************************
MagiaMuerta_inc.nss - 21/10/07 Script By Dragoncin e Inquisidor

Eventos para una zona de magia muerta (puede ser un area o un area de efecto)
************************************************************************/
#include "IPS_inc"
#include "nw_i0_spells"

////////////////////////////////// CONSTANTES ////////////////////////////////

const string MagiaMuerta_areaEsZonaDeMagiaMuerta_LN = "isDeadMagicZone";

const string MagiaMuerta_itemResRef_RN = "deadmagic_wand";

const string MagiaMuerta_vieneDeAreaConMagiaMuerta_VN = "MMvdacmm";

/////////////////////////////////// FUNCIONES ////////////////////////////////

// Evento de entrada a una zona de magia muerta (puede ser un area o un area de efecto)
void MagiaMuerta_onEnter( object sujeto );
void MagiaMuerta_onEnter( object sujeto )
{
    // ---> Se destruyen las invocaciones
    if ( GetAssociateType( sujeto ) == ASSOCIATE_TYPE_DOMINATED ||
         GetAssociateType( sujeto ) == ASSOCIATE_TYPE_SUMMONED
         )
    {
        SetIsDestroyable(TRUE, FALSE, FALSE);
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation( sujeto ) );
        DestroyObject( sujeto );
        return;
    }
    // <---

    // ---> Anular todos los items
    object itemIterado = GetFirstItemInInventory( sujeto );
    while (GetIsObjectValid( itemIterado ))
    {
        if (IPS_Item_getIsAdept( itemIterado ))
            IPS_Item_disableProperties( itemIterado, OBJECT_INVALID );  // Draco, no leiste la descripcion de la funcio parece. El parámetro 'equiper' debe ser OBJECT_INVALID si el ítem no esta equipado.

        itemIterado = GetNextItemInInventory( sujeto );
    }
    int i;
    for (i=0; i<NUM_INVENTORY_SLOTS; i++)
    {
        itemIterado = GetItemInSlot( i, sujeto );
        if (GetIsObjectValid( itemIterado ))
        {
            if (IPS_Item_getIsAdept( itemIterado ))
                IPS_Item_disableProperties( itemIterado, sujeto );
        }
    }
    // <---

    // Remover todos los efectos magicos
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDispelMagicAll(80), sujeto );

    // Aplicar el fallo de los conjuros
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSpellFailure( 100 )), sujeto );
}

// Evento de salida de una zona de magia muerta (puede ser un area o un area de efecto)
void MagiaMuerta_onExit( object sujeto );
void MagiaMuerta_onExit( object sujeto )
{
    // ---> Habilitar todos los items
    object itemIterado = GetFirstItemInInventory( sujeto );
    while (GetIsObjectValid( itemIterado ))
    {
        if (IPS_Item_getIsAdept( itemIterado ))
            IPS_Item_enableProperties( itemIterado, OBJECT_INVALID ); // Draco, no leiste la descripcion de la funcio parece. El parámetro 'equiper' debe ser OBJECT_INVALID si el ítem no esta equipado.

        itemIterado = GetNextItemInInventory( sujeto );
    }
    int i;
    for (i=0; i<NUM_INVENTORY_SLOTS; i++)
    {
        itemIterado = GetItemInSlot( i, sujeto );
        if (GetIsObjectValid( itemIterado ))
        {
            if (IPS_Item_getIsAdept( itemIterado ))
                IPS_Item_enableProperties( itemIterado, sujeto );
        }
    }
    // <---

    // Quitar el fallo de los conjuros
    RemoveSpecificEffect( EFFECT_TYPE_SPELL_FAILURE, sujeto );
}

// Debe ser llamado desde el handler del evento onAreaEnter si se pretende que este sistema funcione
void MagiaMuerta_onAreaEnter( object enteringObject, object area = OBJECT_SELF );
void MagiaMuerta_onAreaEnter( object enteringObject, object area = OBJECT_SELF ) {
    int vieneDeAreaConMagiaMuerta = GetLocalInt( enteringObject, MagiaMuerta_vieneDeAreaConMagiaMuerta_VN );
    int areaEsZonaDeMagiaMuerta = GetLocalInt( area, MagiaMuerta_areaEsZonaDeMagiaMuerta_LN );
    if( !vieneDeAreaConMagiaMuerta && areaEsZonaDeMagiaMuerta )
        MagiaMuerta_onEnter( enteringObject );
    else if ( vieneDeAreaConMagiaMuerta && !areaEsZonaDeMagiaMuerta )
        MagiaMuerta_onExit( enteringObject );
}

// Debe ser llamado desde el handler del evento onAreaExit si se pretende que este sistema funcione
void MagiaMuerta_onAreaExit( object exitingObject, object area = OBJECT_SELF );
void MagiaMuerta_onAreaExit( object exitingObject, object area = OBJECT_SELF ) {
    SetLocalInt(
        exitingObject
        , MagiaMuerta_vieneDeAreaConMagiaMuerta_VN
        , GetLocalInt( area, MagiaMuerta_areaEsZonaDeMagiaMuerta_LN )
    );
}

// Activacion de la varita
void MagiaMuerta_onActivateItem( object activador );
void MagiaMuerta_onActivateItem( object activador )
{
    object area = GetArea( activador );

    if (GetLocalInt( area, MagiaMuerta_areaEsZonaDeMagiaMuerta_LN ) == TRUE)
    {
        SendMessageToPC( activador, "Area de Magia Muerta Desactivada." );
        SetLocalInt( area, MagiaMuerta_areaEsZonaDeMagiaMuerta_LN, FALSE );

        object objetoIterado = GetFirstObjectInArea( area );
        while (GetIsObjectValid( objetoIterado ))
        {
            if (GetObjectType( objetoIterado ) == OBJECT_TYPE_CREATURE)
            //    ExecuteScript( "deadmagic_exit", objetoIterado );
                MagiaMuerta_onExit( objetoIterado );

            objetoIterado = GetNextObjectInArea( area );
        }
    }
    else
    {
        SendMessageToPC( activador, "Area de Magia Muerta Activada." );
        SetLocalInt( area, MagiaMuerta_areaEsZonaDeMagiaMuerta_LN, TRUE );

        object objetoIterado = GetFirstObjectInArea( area );
        while (GetIsObjectValid( objetoIterado ))
        {
            if (GetObjectType( objetoIterado ) == OBJECT_TYPE_CREATURE)
            //    ExecuteScript( "deadmagic_enter", objetoIterado );
                MagiaMuerta_onEnter( objetoIterado );

            objetoIterado = GetNextObjectInArea( area );
        }
    }
}
