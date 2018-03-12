//////////////////////////
// 11/04/07 Script By Dragoncin
//
// Conjuro Animate Dead
// Se usa la funcion lanzarAnimarMuertos() en el script del conjuro y se corta la ejecución del mismo
//////////
/*

CONJURO SEGUN EL MANUAL:

ANIMATE DEAD
Necromancy [Evil]
Level: Clr 3, Death 3, Sor/Wiz 4
Components: V, S, M
Casting Time: 1 standard action
Range: Touch
Targets: One or more corpses touched
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

This spell turns the bones or bodies of dead creatures into undead skeletons or
zombies that follow your spoken commands.

The undead can follow you, or they can remain in an area and attack any creature
(or just a specific kind of creature) entering the place. They remain animated
until they are destroyed. (A destroyed skeleton or zombie can’t be animated again.)

Regardless of the type of undead you create with this spell, you can’t create
more HD of undead than twice your caster level with a single casting of animate
dead. (The desecrate spell doubles this limit)

The undead you create remain under your control indefinitely. No matter how many
times you use this spell, however, you can control only 4 HD worth of undead
creatures per caster level. If you exceed this number, all the newly created
creatures fall under your control, and any excess undead from previous castings
become uncontrolled. (You choose which creatures are released.) If you are a
cleric, any undead you might command by virtue of your power to command or rebuke
undead do not count toward the limit.

Skeletons: A skeleton can be created only from a mostly intact corpse or
skeleton. The corpse must have bones. If a skeleton is made from a corpse, the
flesh falls off the bones.

Zombies: A zombie can be created only from a mostly intact corpse. The corpse
must be that of a creature with a true anatomy.

Material Component: You must place a black onyx gem worth at least 25 gp per
Hit Die of the undead into the mouth or eye socket of each corpse you intend
to animate. The magic of the spell turns these gems into worthless, burned-out shells.


VARIACIONES DE LA CASA:

- Dura indefinidamente (hasta que muera la criatura)
. Cuesta 3gp por HD de la criatura creada
- En un cementerio si no se tiene cuerpos a disposicion, las criaturas se crean al azar
*/

#include "deity_core"
#include "nigromancia_inc"
#include "inventario_inc"
#include "prc_feat_const"
#include "x0_inc_henai"

///////////////////////////////// CONSTANTES //////////////////////////////////

const int APARIENCIA_NOMUERTO_ENANO         = 4;
const int APARIENCIA_NOMUERTO_HUMANOIDE     = 5;

// Apariencias sacadas del appearances.2da
const int APARIENCIA_BONEBAT                = 1282;
const int APARIENCIA_ESQUELETO_DRAGON       = 1031;
const int APARIENCIA_ESQUELETO_MINUSCULO    = 1049;
const int APARIENCIA_ESQUELETO_OGRO         = 1451;
const int APARIENCIA_ESQUELETO_DINAMICO     = 1769;
const int APARIENCIA_ESQUELETO_ENANO        = 1277;

const int APARIENCIA_ZOMBIE_1               = 195;
const int APARIENCIA_ZOMBIE_2               = 196;
const int APARIENCIA_ZOMBIE_3               = 197;
const int APARIENCIA_ZOMBIE_4               = 198;
const int APARIENCIA_ZOMBIE_5               = 199;

const int APARIENCIA_ESQUELETO_PIRATA_1     = 1440;
const int APARIENCIA_ESQUELETO_PIRATA_2     = 1441;
const int APARIENCIA_ESQUELETO_PIRATA_3     = 1442;
const int APARIENCIA_ESQUELETO_PIRATA_4     = 1445;
const int APARIENCIA_ESQUELETO_PIRATA_5     = 1446;
const int APARIENCIA_ESQUELETO_PIRATA_6     = 1447;

const int APARIENCIA_ZOMBIE_PIRATA_1        = 1439;
const int APARIENCIA_ZOMBIE_PIRATA_2        = 1443;
const int APARIENCIA_ZOMBIE_PIRATA_3        = 1444;
const int APARIENCIA_ZOMBIE_PIRATA_4        = 1448;

//constantes varias
const string ESTADO_MODO_PIRATA     = "animdead_estadoModoPirata";
const int MODO_PIRATA_ACTIVADO      = 1;
const int MODO_PIRATA_DESACTIVADO   = 0;

// Las criaturas que sirven de ResRef para crear los esqueletos y zombies tienen
// un valor de fuerza y destreza que debe ser en todas igual y estar anotado aqui
// Se eligio 22 porque el maximo de incremento y decremento de habilidad que se
// puede aplicar con un efecto es de 10/12. De esa manera se obtiene el rango mayor (10-34)
const int FUERZA_BASE_ESQUELETO = 22;
const int DESTREZA_BASE_ESQUELETO = 22;

//////////////////// FUNCIONES /////////////////////////////////////////////

const int AnimateDead_COSTO_POR_HD  = 3;

// Devuelve el precio en oro que cuesta conjurar una criatura no muerta de hdCriatura dados de golpe
// El costo de una criatura es:
//      AnimateDead_COSTO_POR_HD * hdCriatura
int AnimateDead_getCastingCostFromHD( int hdCriatura );
int AnimateDead_getCastingCostFromHD( int hdCriatura )
{
    return AnimateDead_COSTO_POR_HD * hdCriatura ;
}

// Crea un no-muerto del tipo especificado a partir de la criatura dada
object noMuertoAPartirDeCriatura( object criaturaBase, int hdCriatura, location locacionMuerto, int subtipoNoMuerto, int aparienciaBuscada, object oCreador = OBJECT_SELF );
object noMuertoAPartirDeCriatura( object criaturaBase, int hdCriatura, location locacionMuerto, int subtipoNoMuerto, int aparienciaBuscada, object oCreador = OBJECT_SELF )
{
    if (criaturaBase == OBJECT_INVALID) {
        SendMessageToPC(oCreador, "No se encontro la criatura base.");
        return OBJECT_INVALID;
    }

    if( hdCriatura > 20 )
        hdCriatura = 20;

    // elijo el ResRef correspondiente en base al subtipo de no-muerto que quiero crear
    string resRefNoMuerto;
    if (subtipoNoMuerto == SUBTIPO_ESQUELETO) {
        resRefNoMuerto = PREFIJO_RESREF_ESQUELETO+IntToString(hdCriatura);
        if (GetGender(criaturaBase)==GENDER_FEMALE)
            resRefNoMuerto += "f"; //Los resRef de esqueleto femenino terminan en f, los masculinos no tienen la letra extra
    } else if (subtipoNoMuerto == SUBTIPO_ZOMBIE)
        resRefNoMuerto = PREFIJO_RESREF_ZOMBIE+IntToString(hdCriatura);
    else {
        SendMessageToPC(oCreador, "El subtipo es invalido.");
        return OBJECT_INVALID; // De paso ya chequeo que el subtipo sea valido
    }

    // Queda bastante fea la aparicion de un esqueleto dragon sin su animacion.
    // El resto es al contrario, queda fea la aparicion de un esqueleto comun.
    // Por eso, solo los dragones mantienen su animacion de aparicion.
    int animacionAparece = (aparienciaBuscada == APARIENCIA_ESQUELETO_DRAGON) ? TRUE : FALSE;

    object criaturaNoMuerto = CreateObject(OBJECT_TYPE_CREATURE, resRefNoMuerto, locacionMuerto, animacionAparece);

    // Debug
    if (criaturaNoMuerto==OBJECT_INVALID) {
        SendMessageToPC(oCreador, "No se encontro el ResRef '"+resRefNoMuerto+"'.");
        return OBJECT_INVALID;
    }

    // Se obtiene la pocision del No Muerto porque CreateObject mueve la posicion
    // si hay algun impedimento. De esta manera, nos aseguramos que el efecto visual
    // coincida con la posicion de la criatura.
    location locacionNoMuerto = GetLocation(criaturaNoMuerto);

    // Efecto visual de la invocacion
    effect visualInvocacion = (aparienciaBuscada == APARIENCIA_ESQUELETO_DRAGON)? EffectVisualEffect(VFX_FNF_SUMMONDRAGON): EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, visualInvocacion, locacionNoMuerto);

    // Le aplico la apariencia correcta. Es preferible aplicar la apariencia luego
    // del efecto visual para que este tape el cambio
    int aparienciaNoMuerto = APARIENCIA_ESQUELETO_DINAMICO;
    if (subtipoNoMuerto == SUBTIPO_ESQUELETO) {
        if (aparienciaBuscada != APARIENCIA_NOMUERTO_ENANO && aparienciaBuscada != APARIENCIA_NOMUERTO_HUMANOIDE)
            aparienciaNoMuerto = aparienciaBuscada;
        else if (aparienciaBuscada == APARIENCIA_NOMUERTO_ENANO)
            aparienciaNoMuerto = APARIENCIA_ESQUELETO_ENANO;
        else if (GetLocalInt(oCreador, ESTADO_MODO_PIRATA)==MODO_PIRATA_ACTIVADO) {
            switch (d6()) {
                case 1:     aparienciaNoMuerto = APARIENCIA_ESQUELETO_PIRATA_1; break;
                case 2:     aparienciaNoMuerto = APARIENCIA_ESQUELETO_PIRATA_2; break;
                case 3:     aparienciaNoMuerto = APARIENCIA_ESQUELETO_PIRATA_3; break;
                case 4:     aparienciaNoMuerto = APARIENCIA_ESQUELETO_PIRATA_4; break;
                case 5:     aparienciaNoMuerto = APARIENCIA_ESQUELETO_PIRATA_5; break;
                case 6:     aparienciaNoMuerto = APARIENCIA_ESQUELETO_PIRATA_6; break;
            }
        }
    } else if (subtipoNoMuerto == SUBTIPO_ZOMBIE) {
        if (GetLocalInt(oCreador, ESTADO_MODO_PIRATA) == MODO_PIRATA_ACTIVADO) {
            switch (d4()) {
                case 1:     aparienciaNoMuerto = APARIENCIA_ZOMBIE_PIRATA_1; break;
                case 2:     aparienciaNoMuerto = APARIENCIA_ZOMBIE_PIRATA_2; break;
                case 3:     aparienciaNoMuerto = APARIENCIA_ZOMBIE_PIRATA_3; break;
                case 4:     aparienciaNoMuerto = APARIENCIA_ZOMBIE_PIRATA_4; break;
            }
        } else {
            switch (Random(5)+1) {
                case 1:     aparienciaNoMuerto = APARIENCIA_ZOMBIE_1; break;
                case 2:     aparienciaNoMuerto = APARIENCIA_ZOMBIE_2; break;
                case 3:     aparienciaNoMuerto = APARIENCIA_ZOMBIE_3; break;
                case 4:     aparienciaNoMuerto = APARIENCIA_ZOMBIE_4; break;
                case 5:     aparienciaNoMuerto = APARIENCIA_ZOMBIE_5; break;
            }
        }
    }

    // La apariencia normal del blueprint de esqueleto es la del esqueleto dinamico
    // porque si se cambia a un esqueleto dinamico, se obtiene una criatura invisible (bug del CEP?)
    if (aparienciaNoMuerto != APARIENCIA_ESQUELETO_DINAMICO)
        SetCreatureAppearanceType(criaturaNoMuerto, aparienciaNoMuerto);

    if (GetIsPlayableRacialType(criaturaBase))
        SetName(criaturaNoMuerto, GetName(criaturaBase));

    // Dotes de creacion de No Muertos. No se encuentran en uso ni definidas en
    // prc_feat_const.nss. Estan implementadas pero hay que des-comentar esta parte
    // al momento de incluirlas en los 2da.
    int nCorpsecrafter              = GetHasFeat(FEAT_CORPSE_CRAFTER);
    int nBolsterResistance          = GetHasFeat(FEAT_BOLSTER_RESISTANCE);
    int nDeadlyChill                = GetHasFeat(FEAT_DEADLY_CHILL);
    int nDestructionRetribution     = GetHasFeat(FEAT_DESTRUCTION_RETRIBUTION);
    int nHardenedFlesh              = GetHasFeat(FEAT_HARDENED_FLESH);
    int nNimbleBones                = GetHasFeat(FEAT_NIMBLE_BONES);

    // Si se trata de un esqueleto, copia la velocidad de la criatura base en la criatura nueva
    if (subtipoNoMuerto == SUBTIPO_ESQUELETO)
        copiarVelocidad(criaturaBase, criaturaNoMuerto);

    // Activa el modo "Stand your ground" para que pueda equiparse correctamente
    SetLocalInt(criaturaNoMuerto, "Seguir", TRUE);
    SetAssociateState(NW_ASC_MODE_STAND_GROUND, TRUE, criaturaNoMuerto);
    //SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE, criaturaNoMuerto);
    AssignCommand(criaturaNoMuerto, ClearActions(CLEAR_X0_INC_HENAI_RespondToShout1));

    // Copiamos los items que tenga la criatura base en el esqueleto
    copiarInventarioEquipadoCriaturaAenCriaturaB(criaturaBase, criaturaNoMuerto, TRUE);

    // Aplica los razgos de Undead
    aplicarUndeadTraits(criaturaNoMuerto, SUBTIPO_ESQUELETO, GetCreatureSize(criaturaBase), nCorpsecrafter, nBolsterResistance, nDeadlyChill, nDestructionRetribution, nHardenedFlesh, nNimbleBones);

    // El esqueleto mantiene la puntuacion de fuerza y destreza de la criatura.
    // Como se debe crear una criatura a partir de un Blueprint, esta ya tiene una puntuacion de fuerza y destreza
    // Para equipararla, se toma la diferencia y se aplica un efecto de incremento o decremento de habilidad
    int fuerzaBase = GetAbilityScore(criaturaBase, ABILITY_STRENGTH);
    int bonoFuerza = FUERZA_BASE_ESQUELETO-fuerzaBase;
    bonoFuerza -= (nCorpsecrafter) ? 4 : 0;
    bonoFuerza -= (subtipoNoMuerto == SUBTIPO_ZOMBIE) ? 2 : 0; // Los zombies tienen +2 de fuerza
    effect efectoAjusteDeFuerza = EffectAbilityDecrease(ABILITY_STRENGTH, (bonoFuerza));
    if (fuerzaBase > FUERZA_BASE_ESQUELETO) {
        bonoFuerza = -bonoFuerza;
        efectoAjusteDeFuerza = EffectAbilityIncrease(ABILITY_STRENGTH, (bonoFuerza));
    }
    int destrezaBase = GetAbilityScore(criaturaBase, ABILITY_DEXTERITY);
    int bonoDestreza = DESTREZA_BASE_ESQUELETO-destrezaBase;
    bonoDestreza -= (subtipoNoMuerto == SUBTIPO_ESQUELETO) ? 2 : 0; // Los esqueletos tienen +2 de destreza
    effect efectoAjusteDeDestreza = EffectAbilityDecrease(ABILITY_DEXTERITY, (bonoDestreza));
    if (destrezaBase > DESTREZA_BASE_ESQUELETO){
        bonoDestreza = -bonoDestreza;
        efectoAjusteDeDestreza = EffectAbilityIncrease(ABILITY_DEXTERITY, (bonoDestreza));
    }
    effect efectoAjusteDeHabilidad = EffectLinkEffects(efectoAjusteDeFuerza, efectoAjusteDeDestreza);
    efectoAjusteDeHabilidad = SupernaturalEffect(efectoAjusteDeHabilidad);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, efectoAjusteDeHabilidad, criaturaNoMuerto);

    return criaturaNoMuerto;
}


// Devuelve TRUE si la criatura oCriatura es una criatura creada por el conjuro AnimateDead
int AnimateDead_getIsCreatureUndeadCreatedByAnimateDead( object oCriatura );
int AnimateDead_getIsCreatureUndeadCreatedByAnimateDead( object oCriatura )
{
    return ( GetStringLeft( GetResRef(oCriatura), GetStringLength(PREFIJO_RESREF_ESQUELETO) ) == PREFIJO_RESREF_ESQUELETO ||
             GetStringLeft( GetResRef(oCriatura), GetStringLength(PREFIJO_RESREF_ZOMBIE) ) == PREFIJO_RESREF_ZOMBIE
            );
}

// Devuelve el numero de HDs de no muertos generados por este conjuro controlados por oCaster
int AnimateDead_getNumberOfUndeadHDsControlledByCaster( object oCaster );
int AnimateDead_getNumberOfUndeadHDsControlledByCaster( object oCaster )
{
    int hdsControlados = 0;

    object objetoIterado = GetFirstFactionMember( oCaster, FALSE );
    while (GetIsObjectValid(objetoIterado))
    {
        if ( GetMaster(objetoIterado) == oCaster && AnimateDead_getIsCreatureUndeadCreatedByAnimateDead(objetoIterado) )
        {
            hdsControlados += GetHitDice( objetoIterado );
        }
        objetoIterado = GetNextFactionMember( oCaster, FALSE );
    }
    hdsControlados += GetLocalInt( oCaster, HD_CONTROLADOS_POR_ANIMATEDEAD );
    return hdsControlados;
}

// Controla un no-muerto generado por el conjuro Animate Dead, teniendo en cuenta
// que no puede controlar mas que (4 * casterLevel) HDs
void animateDead_controlarNoMuerto( object noMuerto, int casterLevel, object pjControlador = OBJECT_SELF );
void animateDead_controlarNoMuerto( object noMuerto, int casterLevel, object pjControlador = OBJECT_SELF )
{
    int hdControlados = AnimateDead_getNumberOfUndeadHDsControlledByCaster( pjControlador );
    //SendMessageToPC( pjControlador, "hdControlados= "+IntToString(hdControlados) );
    int hdNoMuerto = GetHitDice(noMuerto);
    //SendMessageToPC( pjControlador, "hdNoMuerto= "+IntToString(hdNoMuerto) );

    if ( (hdControlados+hdNoMuerto) <= (casterLevel * 4) ) {
        SetLocalInt( pjControlador, HD_CONTROLADOS_POR_ANIMATEDEAD, GetLocalInt( pjControlador, HD_CONTROLADOS_POR_ANIMATEDEAD )+hdNoMuerto );
        AssignCommand( pjControlador, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneDominated()), noMuerto) );
        //AddHenchman(pjControlador, noMuerto);
        //SetLocalInt(noMuerto, "merc", TRUE);

    }
    // Guardo el creador para el evento onDeath de la criatura
    // (en onDeath GetMaster() no funciona)
    SetLocalObject(noMuerto, CREADOR_NO_MUERTO, pjControlador);
}


// Elige al azar entre crear un zombie y un esqueleto si se cumplen las condiciones validas para hacerlo
object crearNoMuertoAPartirDeCriatura( object criaturaBase, int hdCriatura, location locacionCriatura, object creadorNoMuerto = OBJECT_SELF );
object crearNoMuertoAPartirDeCriatura( object criaturaBase, int hdCriatura, location locacionCriatura, object creadorNoMuerto = OBJECT_SELF )
{
    int aparienciaNoMuerto;
    object noMuertoCreado;

    // Seteo la apariencia buscada para el no-muerto a ser creado
    int tipoRacial = GetRacialType(criaturaBase);
    if (tipoRacial == RACIAL_TYPE_ANIMAL)
        aparienciaNoMuerto = APARIENCIA_BONEBAT;
    else if (tipoRacial == RACIAL_TYPE_DRAGON)
        aparienciaNoMuerto = APARIENCIA_ESQUELETO_DRAGON;
    else if (tipoRacial == RACIAL_TYPE_ELF || tipoRacial == RACIAL_TYPE_HUMAN || tipoRacial == RACIAL_TYPE_HALFORC || tipoRacial == RACIAL_TYPE_HALFELF)
        aparienciaNoMuerto = APARIENCIA_NOMUERTO_HUMANOIDE;
    else if (tipoRacial == RACIAL_TYPE_GNOME || tipoRacial == RACIAL_TYPE_HALFLING || tipoRacial == RACIAL_TYPE_DWARF)
        aparienciaNoMuerto = APARIENCIA_NOMUERTO_ENANO;
    else if (
        tipoRacial != RACIAL_TYPE_CONSTRUCT
        && tipoRacial != RACIAL_TYPE_ELEMENTAL
        && tipoRacial != RACIAL_TYPE_INVALID
        && tipoRacial != RACIAL_TYPE_OOZE
        && tipoRacial != RACIAL_TYPE_OUTSIDER
        && tipoRacial != RACIAL_TYPE_UNDEAD
        && tipoRacial != RACIAL_TYPE_VERMIN
    ) {
        switch (GetCreatureSize(criaturaBase)) {
            case CREATURE_SIZE_TINY:        aparienciaNoMuerto = APARIENCIA_ESQUELETO_MINUSCULO; break;
            case CREATURE_SIZE_SMALL:       aparienciaNoMuerto = APARIENCIA_NOMUERTO_ENANO; break;
            case CREATURE_SIZE_MEDIUM:      aparienciaNoMuerto = APARIENCIA_NOMUERTO_HUMANOIDE; break;
            default:                        aparienciaNoMuerto = APARIENCIA_ESQUELETO_OGRO; break;
        }
    } else
        return OBJECT_INVALID; //Ciertas razas no pueden ser hecas no muertos (por ejemplo, los no muertos =P)

    // Solo se pueden crear zombies a partir de criaturas con HD <= 10
    if (hdCriatura <= 10 && d2()==2 && (aparienciaNoMuerto == APARIENCIA_NOMUERTO_HUMANOIDE || aparienciaNoMuerto == APARIENCIA_NOMUERTO_ENANO) )
        noMuertoCreado = noMuertoAPartirDeCriatura(criaturaBase, hdCriatura, locacionCriatura, SUBTIPO_ZOMBIE, aparienciaNoMuerto);
    else
        noMuertoCreado = noMuertoAPartirDeCriatura(criaturaBase, hdCriatura, locacionCriatura, SUBTIPO_ESQUELETO, aparienciaNoMuerto);

    return noMuertoCreado;
}


// Funcion principal
void lanzarAnimarMuertos( object oTarget, location targetLocation, int casterLevel, int metaMagic, object oCaster = OBJECT_SELF );
void lanzarAnimarMuertos( object oTarget, location targetLocation, int casterLevel, int metaMagic, object oCaster = OBJECT_SELF )
{
    if ( deidadPermiteLanzarConjurosNigromanticos(oCaster) )
    {
        // Efecto visual comun a cualquier resultado
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), targetLocation);

        // Duracion de las invocaciones
        float duracionConjuro = RoundsToSeconds(casterLevel);
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oCaster))
            duracionConjuro += 240.0;
        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oCaster))
            duracionConjuro += 120.0;
        else if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oCaster))
            duracionConjuro += 60.0;
        if (metaMagic == METAMAGIC_EXTEND) duracionConjuro += duracionConjuro;

        int hdCriatura = 0;
        object noMuerto;
        location locacionIterado;
        int hdCreados = 0;
        string mensaje = "";
        float distancia;
        int hp;

        int iterador = 1;
        object objetoIterado = GetNearestCreatureToLocation(CREATURE_TYPE_IS_ALIVE, FALSE, targetLocation, iterador);
        while (GetIsObjectValid(objetoIterado)) {
            //mensaje = GetName(objetoIterado);
            // Solo las criaturas dentro de un radio de 30 pies
            locacionIterado = GetLocation(objetoIterado);
            distancia = GetDistanceBetweenLocations(locacionIterado, targetLocation);
            //mensaje += " esta a distancia "+FloatToString(distancia);
            if (distancia <= 30.0) {
                // Solo las criaturas muertas
                hp = GetCurrentHitPoints(objetoIterado);
                //mensaje += ", tiene "+IntToString(hp)+" puntos de vida";
                if (hp < -10) {
                    hdCriatura = GetHitDice(objetoIterado);
                    //mensaje += " y "+IntToString(hdCriatura)+" dados de golpe";
                    // El lanzador no puede crear mas HDs de no-muertos que el doble de su nivel y la criatura no puede tener HD > 20
                    if ( hdCreados+hdCriatura <= casterLevel * 2  ) {
                        noMuerto = crearNoMuertoAPartirDeCriatura(objetoIterado, hdCriatura, locacionIterado, oCaster);
                        int costoCriatura = AnimateDead_getCastingCostFromHD( hdCriatura );
                        if ( GetGold(oCaster) >= costoCriatura )
                        {
                            if (GetIsObjectValid(noMuerto)) {
                                animateDead_controlarNoMuerto(noMuerto, casterLevel, oCaster);
                                TakeGoldFromCreature(costoCriatura, oCaster, TRUE);
                                AssignCommand(objetoIterado, SetIsDestroyable(TRUE, FALSE, FALSE));
                                DestroyObject(objetoIterado);
                                hdCreados += hdCriatura;
                            }
                        }
                        else
                            SendMessageToPC( oCaster, "No tienes dinero suficiente para lanzar este conjuro" );
                    }
                }
            }
            //SendMessageToPC(oCaster, mensaje);
            iterador++;
            objetoIterado = GetNearestCreatureToLocation(CREATURE_TYPE_IS_ALIVE, FALSE, targetLocation, iterador);
        }
        // Esto es un control temporario que se usa unicamente durante la duracion de la ejecucion del conjuro.
        // Esto se debe a que la accion de controlar el muerto se aplica con AssignCommand() y por ende se ejecuta
        // luego de que se ejecute el conjuro, por lo que durante la ejecucion del mismo no se puede contar
        // el numero de muertos generados.
        SetLocalInt( oCaster, HD_CONTROLADOS_POR_ANIMATEDEAD, 0 );
    }
}
