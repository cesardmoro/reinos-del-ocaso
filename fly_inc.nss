#include "Phenos_inc"
#include "RdO_spell_const"
#include "Horses_inc"

const string Fly_IS_FLYING = "Fly_IS_FLYING";

// Devuelve TRUE si el personaje puede volar (tiene alas o esta bajo el efecto del conjuro)
int Fly_GetCanFly( object oPC = OBJECT_SELF );
int Fly_GetCanFly( object oPC = OBJECT_SELF )
{
    int wingModel = GetCreatureWingType(oPC);
    return (GetHasSpellEffect(SPELL_FLY, oPC) || (wingModel > 0 && wingModel < 60));
}

// Devuelve si el personaje puede flotar (quedarse en el lugar flotando es algo que no se puede hacer con alas)
int Fly_GetCanHover( object oPC = OBJECT_SELF );
int Fly_GetCanHover( object oPC = OBJECT_SELF )
{
    return GetHasSpellEffect(SPELL_FLY, oPC);
}

// Devuelve si oPC esta flotando o no
int Fly_GetIsHovering( object oPC = OBJECT_SELF );
int Fly_GetIsHovering( object oPC = OBJECT_SELF )
{
    int phenotype = GetPhenoType(oPC);
    int phenoVolando = (GetNaturalPhenoType(oPC)==PHENOTYPE_BIG) ? PHENOTYPE_FLY_RDO_FAT : PHENOTYPE_FLY_RDO;
    return (phenotype == PHENOTYPE_FLY_RDO || phenotype == PHENOTYPE_FLY_RDO_FAT);
}

void Fly_StartHovering( object oPC = OBJECT_SELF );
void Fly_StartHovering( object oPC = OBJECT_SELF )
{
    if (GetIsMounted(oPC))
        Horses_disMount(oPC);

    switch (GetNaturalPhenoType(oPC)) {
        case PHENOTYPE_NORMAL:          SetPhenoType(PHENOTYPE_FLY_RDO, oPC); break;
        case PHENOTYPE_BIG:             SetPhenoType(PHENOTYPE_FLY_RDO_FAT, oPC); break;
    }
}

void Fly_StopHovering( object oPC = OBJECT_SELF );
void Fly_StopHovering( object oPC = OBJECT_SELF )
{
    ReturnToNaturalPhenoType(oPC);
}

// Handler para el evento onClientEnter del conjuro volar
//
// La razon de la existencia de este handler es que la dote Volar permite volver
// a flotar siempre que se tenga el efecto del conjuro Volar activo.
// Como cuando al reloguear se mantienen los efectos de conjuro pero se pierden
// las acciones retardadas con DelayCommand() y el conjuro usa un DelayCommand()
// para quitar el fenotipo flotador, el pj podria volver a flotar y no ser
// forzado a bajar al piso cuando se acabe el conjuro.
// Por esta razon al entrar se quita el efecto del conjuro
void Fly_onClientEnter( object oPC );
void Fly_onClientEnter( object oPC )
{
    if (GetHasSpellEffect( SPELL_FLY, oPC ))
    {
        effect efectoIterado = GetFirstEffect( oPC );
        while (GetIsEffectValid( efectoIterado ))
        {
            if (GetEffectSpellId( efectoIterado ) == SPELL_FLY)
                RemoveEffect( oPC, efectoIterado );
            efectoIterado = GetNextEffect( oPC );
        }
    }
}
