/********************** Detect Evil/Good/Law/Chaos ****************************
12/03/07 - Script By Dragoncin
Funciones comunes a los 4 conjuros de deteccion de alineamiento
*****************************************************************************/

#include "prc_class_const"
#include "location_tools"

//La tercera ronda de deteccion
//Esta ronda detecta el poder y la localizacion de cada aura
void Detect_Round3 ( object oCaster, int iAlineamientoBuscado, int iHPIniciales );
void Detect_Round3 ( object oCaster, int iAlineamientoBuscado, int iHPIniciales )
{
    float fEncaramientoCaster;
    float fPosicionCriatura;
    float fAnguloResultante;
    int iCuadrante;

    int iHPActuales = GetCurrentHitPoints(oCaster);
    int iModificadorTirada = 0;
    if (iHPIniciales<iHPActuales) {
        iModificadorTirada = iHPIniciales - iHPActuales;
    }
    //Si pasa una tirada de concentracion, sigue con el conjuro. Si no, ata se termina
    if ( !GetIsSkillSuccessful(oCaster, SKILL_CONCENTRATION, 10+iModificadorTirada) )
        return;

    int nCriaturas = 0;
    int nCriaturasTemp = 0;
    int HDCriatura = 0;
    string sMensaje;
    object oCriatura = GetFirstObjectInArea();
    while (oCriatura!=OBJECT_INVALID) {
        if ((GetObjectType(oCriatura)==OBJECT_TYPE_CREATURE) && (oCriatura!=oCaster) ) {
            nCriaturasTemp = nCriaturas;
            //Evita la deteccion con el conjuro Undetect Alignment
            if (GetLocalInt(oCriatura, "UndetectAlignment")==0) {
                if ( (iAlineamientoBuscado==ALIGNMENT_CHAOTIC) && (GetAlignmentLawChaos(oCriatura)==ALIGNMENT_CHAOTIC) )
                    nCriaturas++;
                else if ( (iAlineamientoBuscado==ALIGNMENT_EVIL) && (GetAlignmentGoodEvil(oCriatura)==ALIGNMENT_EVIL) )
                    nCriaturas++;
                else if ( (iAlineamientoBuscado==ALIGNMENT_GOOD) && (GetAlignmentGoodEvil(oCriatura)==ALIGNMENT_GOOD) )
                    nCriaturas++;
                else if ( (iAlineamientoBuscado==ALIGNMENT_LAWFUL) && (GetAlignmentLawChaos(oCriatura)==ALIGNMENT_LAWFUL) )
                    nCriaturas++;
            }
            //Si se detecto una criatura
            if ( nCriaturas > nCriaturasTemp ) {
                //Si esta no se encuentra cubierta por nada
                if (LineOfSightObject(oCaster, oCriatura)==TRUE) {
                    HDCriatura = GetLevelByPosition(1, oCriatura) + GetLevelByPosition(2, oCriatura) + GetLevelByPosition(3, oCriatura);
                    //Si la criatura esta dentro del angulo de vision del lanzador...
                    iCuadrante = Location_CuadrantePosicionRelativa(oCaster, oCriatura);
                    if (iCuadrante==POSICION_ADELANTE) {
                        if (LineOfSightObject(oCaster, oCriatura))
                            //Dar el nombre de la criatura...
                            sMensaje = GetName(oCriatura)+" tiene un aura ";
                        else
                            sMensaje = "Hay una criatura delante tuyo con un aura ";
                    } else if (iCuadrante==POSICION_IZQUIERDA)
                        //Dar solo la direcccion en la que se encuentra
                        sMensaje = "Hay una criatura a tu izquierda con un aura ";
                    else if (iCuadrante==POSICION_ATRAS)
                        sMensaje = "Hay una criatura detras tuyo con un aura ";
                    else
                        sMensaje = "Hay una criatura a tu derecha con un aura ";
                    switch (iAlineamientoBuscado) {
                        case ALIGNMENT_CHAOTIC:     sMensaje += "caotica ";
                                                    break;
                        case ALIGNMENT_EVIL:        sMensaje += "malvada ";
                                                    break;
                        case ALIGNMENT_GOOD:        sMensaje += "de bondad ";
                                                    break;
                        case ALIGNMENT_LAWFUL:      sMensaje += "legal ";
                                                    break;
                    }
                    if (GetLevelByClass(CLASS_TYPE_UNDEAD, oCriatura) > 0) {
                        if (HDCriatura >= 21) {
                            sMensaje += "extremadamente";
                        } else if (HDCriatura >= 9)
                            sMensaje += "fuertemente";
                        else if (HDCriatura >= 8)
                            sMensaje += "moderadamente";
                        else
                            sMensaje += "levemente";
                    } else if ( (GetLevelByClass(CLASS_TYPE_OUTSIDER, oCriatura) > 0) || (GetLevelByClass(CLASS_TYPE_CLERIC, oCriatura) > 0) || (GetLevelByClass(CLASS_TYPE_PALADIN, oCriatura) > 0) || (GetLevelByClass(CLASS_TYPE_ANTI_PALADIN, oCriatura) > 0) ) {
                        if (HDCriatura >= 11) {
                            sMensaje += "extremadamente";
                        } else if (HDCriatura >= 5)
                            sMensaje += "fuertemente";
                        else if (HDCriatura >= 2)
                            sMensaje += "moderadamente";
                        else
                            sMensaje += "levemente";
                    } else {
                        if (HDCriatura >= 51) {
                            sMensaje += "extremadamente";
                        } else if (HDCriatura >= 26)
                            sMensaje += "fuertemente";
                        else if (HDCriatura >= 11)
                            sMensaje += "moderadamente";
                        else
                            sMensaje += "levemente";
                    }
                    sMensaje += " poderosa!";
                    FloatingTextStringOnCreature(sMensaje, oCaster, FALSE);
                }
            }
        }
        oCriatura = GetNextObjectInArea();
    }
}

//La segunda ronda de deteccion
//Esta ronda detecta la cantidad de auras del alineamiento y el poder de la mas poderosa
void Detect_Round2 ( object oCaster, int iAlineamientoBuscado, int iHPIniciales, int metamagia );
void Detect_Round2 ( object oCaster, int iAlineamientoBuscado, int iHPIniciales, int metamagia )
{
    int iHPActuales = GetCurrentHitPoints(oCaster);
    int iModificadorTirada = 0;
    if (iHPIniciales<iHPActuales) {
        iModificadorTirada = iHPIniciales - iHPActuales;
    }
    //Si pasa una tirada de concentracion, sigue con el conjuro. Si no, ata se termina
    if ( !GetIsSkillSuccessful(oCaster, SKILL_CONCENTRATION, 10+iModificadorTirada) )
        return;

    effect eVisual = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    if (metamagia==METAMAGIC_STILL)
        AssignCommand(oCaster, ActionWait(6.0));
    else if (metamagia!=METAMAGIC_QUICKEN) {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisual, oCaster, 6.0f);
        AssignCommand(oCaster, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 6.0));
    }

    //Buscamos entre todas las criaturas del area
    int nCriaturas = 0;
    int nCriaturasTemp = 0;
    int HDCriatura = 0;
    int HDCriaturaTemp = 0;
    object oCriaturaMasPoderosa;
    object oCriatura = GetFirstObjectInArea();
    while (oCriatura!=OBJECT_INVALID) {
        if ( (GetObjectType(oCriatura)==OBJECT_TYPE_CREATURE) && (oCriatura!=oCaster) )  {
            nCriaturasTemp = nCriaturas;
            //Evita la deteccion con el conjuro Undetect Alignment
            if (GetLocalInt(oCriatura, "UndetectAlignment")!=TRUE) {
                if ( (iAlineamientoBuscado==ALIGNMENT_CHAOTIC) && (GetAlignmentLawChaos(oCriatura)==ALIGNMENT_CHAOTIC) )
                    nCriaturas++;
                else if ( (iAlineamientoBuscado==ALIGNMENT_EVIL) && (GetAlignmentGoodEvil(oCriatura)==ALIGNMENT_EVIL) )
                    nCriaturas++;
                else if ( (iAlineamientoBuscado==ALIGNMENT_GOOD) && (GetAlignmentGoodEvil(oCriatura)==ALIGNMENT_GOOD) )
                    nCriaturas++;
                else if ( (iAlineamientoBuscado==ALIGNMENT_LAWFUL) && (GetAlignmentLawChaos(oCriatura)==ALIGNMENT_LAWFUL) )
                    nCriaturas++;
            }
            //Si se detecto una criatura
            if ( nCriaturas > nCriaturasTemp ) {
                HDCriaturaTemp = GetLevelByPosition(1, oCriatura) + GetLevelByPosition(2, oCriatura) + GetLevelByPosition(3, oCriatura);
                //Si la criatura tiene mas HDs que la anterior, guardar esta criatura (asi se obtiene la de mayor HD)
                if ( HDCriaturaTemp > HDCriatura ) {
                    HDCriatura = HDCriaturaTemp;
                    oCriaturaMasPoderosa = oCriatura;
                }
            }
        }
        oCriatura = GetNextObjectInArea();
    }

    string sMensaje = "Hay "+IntToString(nCriaturas)+" criaturas ";
    switch (iAlineamientoBuscado) {
        case ALIGNMENT_CHAOTIC:     sMensaje += "caoticas";
                                    break;
        case ALIGNMENT_EVIL:        sMensaje += "malvadas";
                                    break;
        case ALIGNMENT_GOOD:        sMensaje += "buenas";
                                    break;
        case ALIGNMENT_LAWFUL:      sMensaje += "legales";
                                    break;
    }
    sMensaje += " y una de ellas es ";

    //Esta variable indica si el HD de la criatura alcanza para paralizar al lanzador del conjuro
    int iParaliza = FALSE;
    if (GetLevelByClass(CLASS_TYPE_UNDEAD, oCriaturaMasPoderosa) > 0) {
        if (HDCriatura >= 21) {
            sMensaje += "extremadamente";
            iParaliza = TRUE;
        } else if (HDCriatura >= 9)
            sMensaje += "fuertemente";
        else if (HDCriatura >= 8)
            sMensaje += "moderadamente";
        else
            sMensaje += "levemente";
    } else if ( (GetLevelByClass(CLASS_TYPE_OUTSIDER, oCriaturaMasPoderosa) > 0) || (GetLevelByClass(CLASS_TYPE_CLERIC, oCriaturaMasPoderosa) > 0) || (GetLevelByClass(CLASS_TYPE_PALADIN, oCriaturaMasPoderosa) > 0) || (GetLevelByClass(CLASS_TYPE_ANTI_PALADIN, oCriaturaMasPoderosa) > 0) ) {
        if (HDCriatura >= 11) {
            sMensaje += "extremadamente";
            iParaliza = TRUE;
        } else if (HDCriatura >= 5)
            sMensaje += "fuertemente";
        else if (HDCriatura >= 2)
            sMensaje += "moderadamente";
        else
            sMensaje += "levemente";
    } else {
        if (HDCriatura >= 51) {
            sMensaje += "extremadamente";
            iParaliza = TRUE;
        } else if (HDCriatura >= 26)
            sMensaje += "fuertemente";
        else if (HDCriatura >= 11)
            sMensaje += "moderadamente";
        else
            sMensaje += "levemente";
    }

    sMensaje += " poderosa!";
    FloatingTextStringOnCreature(sMensaje, oCaster, FALSE);

    //Si es posible que paralice...
    if (iParaliza==TRUE) {
        //Si supera al caster en el doble de sus HDs...
        if (GetLevelByPosition(1, oCaster)+(GetLevelByPosition(2, oCaster)+(GetLevelByPosition(3, oCaster))*2) < HDCriatura) {
            iParaliza = FALSE;
            //Si es del alineamiento opuesto a la criatura detectada...
                if ( (iAlineamientoBuscado==ALIGNMENT_CHAOTIC) && (GetAlignmentLawChaos(oCaster)==ALIGNMENT_LAWFUL) )
                    iParaliza = TRUE;
                else if ( (iAlineamientoBuscado==ALIGNMENT_EVIL) && (GetAlignmentGoodEvil(oCaster)==ALIGNMENT_GOOD) )
                    iParaliza = TRUE;
                else if ( (iAlineamientoBuscado==ALIGNMENT_GOOD) && (GetAlignmentGoodEvil(oCaster)==ALIGNMENT_EVIL) )
                    iParaliza = TRUE;
                else if ( (iAlineamientoBuscado==ALIGNMENT_LAWFUL) && (GetAlignmentLawChaos(oCaster)==ALIGNMENT_CHAOTIC) )
                    iParaliza = TRUE;

            //... al cumplirse todo eso, se paraliza al caster y se corta el conjuro
            if (iParaliza) {
                FloatingTextStringOnCreature("La criatura es tan poderosa que quedas mareado por un momento!", oCaster, FALSE);
                AssignCommand(oCaster, ClearAllActions());
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oCaster, 6.0f);
                return;
            }
        }
    }

    AssignCommand(oCaster, ActionDoCommand(Detect_Round3(oCaster, iAlineamientoBuscado, iHPActuales)));
}


//La primera ronda de deteccion
//En esta ronda solo se detecta si hay alguna criatura del alineamiento en el area
void Detect_Round1 ( object oCaster, int iAlineamientoBuscado, int metamagia );
void Detect_Round1 ( object oCaster, int iAlineamientoBuscado, int metamagia )
{
    string sMensaje;
    int iHP = GetCurrentHitPoints(oCaster);
    int HayCriatura = FALSE;

    effect eVisual = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    if (metamagia==METAMAGIC_STILL)
        AssignCommand(oCaster, ActionWait(6.0));
    else if (metamagia!=METAMAGIC_QUICKEN) {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisual, oCaster, 6.0f);
        AssignCommand(oCaster, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 6.0));
    }

    object oCriatura = GetFirstObjectInArea();
    while (oCriatura!=OBJECT_INVALID) {
        if ( (GetObjectType(oCriatura)==OBJECT_TYPE_CREATURE) && (oCriatura!=oCaster) ) {
            //Evita la deteccion con el conjuro Undetect Alignment
            if (GetLocalInt(oCriatura, "UndetectAlignment")!=TRUE) {
                if ( (iAlineamientoBuscado==ALIGNMENT_CHAOTIC) && (GetAlignmentLawChaos(oCriatura)==ALIGNMENT_CHAOTIC) )
                    HayCriatura = TRUE;
                else if ( (iAlineamientoBuscado==ALIGNMENT_EVIL) && (GetAlignmentGoodEvil(oCriatura)==ALIGNMENT_EVIL) )
                    HayCriatura = TRUE;
                else if ( (iAlineamientoBuscado==ALIGNMENT_GOOD) && (GetAlignmentGoodEvil(oCriatura)==ALIGNMENT_GOOD) )
                    HayCriatura = TRUE;
                else if ( (iAlineamientoBuscado==ALIGNMENT_LAWFUL) && (GetAlignmentLawChaos(oCriatura)==ALIGNMENT_LAWFUL) )
                    HayCriatura = TRUE;
            }
        }
        if (HayCriatura==TRUE) break;
        oCriatura = GetNextObjectInArea();
    }

    if (HayCriatura==TRUE) {
        switch (iAlineamientoBuscado) {
            case ALIGNMENT_CHAOTIC:     sMensaje = "Hay una criatura caotica cerca!";
                                        break;
            case ALIGNMENT_EVIL:        sMensaje = "Hay una criatura maligna cerca!";
                                        break;
            case ALIGNMENT_GOOD:        sMensaje = "Hay una criatura buena cerca!";
                                        break;
            case ALIGNMENT_LAWFUL:      sMensaje = "Hay una criatura legal cerca!";
                                        break;
        }
        AssignCommand( oCaster, ActionDoCommand(Detect_Round2(oCaster, iAlineamientoBuscado, iHP, metamagia)) );
    } else {
        switch (iAlineamientoBuscado) {
            case ALIGNMENT_CHAOTIC:     sMensaje = "No hay ninguna criatura caotica cerca!";
                                        break;
            case ALIGNMENT_EVIL:        sMensaje = "No hay ninguna criatura maligna cerca!";
                                        break;
            case ALIGNMENT_GOOD:        sMensaje = "No hay ninguna criatura buena cerca!";
                                        break;
            case ALIGNMENT_LAWFUL:      sMensaje = "No hay ninguna criatura legal cerca!";
                                       break;
        }
    }
    FloatingTextStringOnCreature(sMensaje, oCaster, FALSE);
    //Si no hay ninguna criatura del alineamiento, cortar el conjuro
    if (GetStringLeft(sMensaje, 2)=="No") {
        AssignCommand(oCaster, ClearAllActions());
        return;
    }
}
