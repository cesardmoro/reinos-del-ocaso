/************** Control de intercambio de bienes - cheatHandler *********************
Package: Control de intercambio de bienes - cheatHandler
Autor: Inquisidor
Descripcion: este script es llamado desde Item_tirar(..) cuando el ítem que ha sido forzado a ser tirado
al suelo fue movido a una ventana de trueque para burlar al CIB.
*******************************************************************************/

#include "item_inc"
#include "CIB_frente"

void main() {
    object burlador = OBJECT_SELF;
    object item = GetLocalObject( burlador, Item_burladorTirar_VN );

    // mover el item al propietario
    object propietarioDelItem = GetLocalObject( item, CIB_refPropietario_VN );
    CopyItem( item, propietarioDelItem, TRUE );
    DestroyObject( item );
    FloatingTextStringOnCreature( "Tyr te ha puesto en penitencia por intentar burlar su preciada justicia. //sistema de control de intercambio de bienes", burlador );

    // penar al tramposo
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWKILL), burlador );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_GATE), burlador );
    TakeGoldFromCreature( GetGold(burlador), burlador, TRUE );
    DelayCommand( 5.0, Location_forcedJump( GetLocation( GetWaypointByTag( "banishWP" ) ) ) );
}


