/************************ Perception - Objects ******************************
Package: Perception - object - faccade
Author: Inquisidor
Version: 0.1
Descripcon: Sistema de perception especial. Envia mensajes a los PJs con la
ubicacion de la criatura que perciban. Si se lo percibio visualmente (spot vs hide)
la ubicacion se da en cordenadas cartecianas, y si se lo percibio auditivamente
(listen vs move silently) la ubicacion se da en cordenadas polares con magnitudes
difusas.
*******************************************************************************/
#include "SkillSys"

/////////////////////// class constants ///////////////////////////////////////

const float squareOfReferenceDistance = 36.0; // cuadrado de la distancia de referencia 6


/////////////////////// local variable names ///////////////////////////////

const string PerceptionSys_location_VN = "pct_location"; // recuerda la location del personaje


/////////////////////// class operations /////////////////////////////////////

// Da el angulo (intervalo (-180 y 180] ) que hay entre la direccion en que
// apunta el sujeto dado y algun punto del area.
// Nota: la componente vertical se descarta.
float PerceptionSys_getRelativeAngle( location subjectLocation, vector point );
float PerceptionSys_getRelativeAngle( location subjectLocation, vector point ) {

    vector subjectPosition = GetPositionFromLocation( subjectLocation );
    float directionAngle = VectorToAngle( point - subjectPosition ) - GetFacingFromLocation( subjectLocation );
    while( directionAngle > 180.0 )
        directionAngle -= 360.0;
    while( directionAngle <= -180.0 )
        directionAngle += 360.0;
    return directionAngle;
}


// Convierte un angulo relativo ( intervalo (-180,180] ) a texto
string PerceptionSys_relativeAngleToText( int relativeAngle );
string PerceptionSys_relativeAngleToText( int relativeAngle ) {
    if( relativeAngle > 157 )
        return "atras";
    if( relativeAngle > 112 )
        return "atras a la izquierda";
    if( relativeAngle > 67 )
        return "la izquierda";
    if( relativeAngle > 22 )
        return "adelante a la izquierda";
    if( relativeAngle >= -22 )
        return "adelante";
    if( relativeAngle >= -67 )
        return "adelante a la derecha";
    if( relativeAngle >= -112 )
        return "la derecha";
    if( relativeAngle >= -157 )
        return "atras a la derecha";
    return "atras";
}


// Convierte una distancia difusa a texto
string PerceptionSys_fuzzyDistanceToText( float distance );
string PerceptionSys_fuzzyDistanceToText( float distance ) {
    int d = FloatToInt( distance );
    if( d < 2 )
        return "junto a ti";
    else if( d < 4 )
        return "muy cercano";
    else if( d < 8 )
        return "cercano";
    else if( d < 16 )
        return "a media distancia";
    else if( d < 32 )
        return "lejano";
    return "muy lejano";
}


struct RelativePosition {
    float longitudinal; // componente longitudinal de la distancia que hay entre un punto y el sujeto respecto al sujeto. Es positivo si el punto esta delante del sujeto, y negativo si esta detras.
    float transversal; // componente transversal de la distancia que hay entre un punto y el sujeto respecto al sujeto. Es positivo si el punto esta a la izquierda del sujeto, y negativo si esta a la derecha.
};

struct RelativePosition PerceptionSys_getRelativePosition( location subjectLocation, vector point );
struct RelativePosition PerceptionSys_getRelativePosition( location subjectLocation, vector point ) {
    vector subjectPosition = GetPositionFromLocation( subjectLocation );
    subjectPosition.z = 0.0;
    point.z = 0.0;
    point -= subjectPosition;
    float directionAngle = VectorToAngle( point ) - GetFacingFromLocation( subjectLocation );
    float relativeDistance = VectorMagnitude( point );
    struct RelativePosition relativePosition;
    relativePosition.longitudinal = relativeDistance*cos( directionAngle );
    relativePosition.transversal = relativeDistance*sin( directionAngle );
    return relativePosition;
}


string PerceptionSys_relativePositionToText( struct RelativePosition relativePosition );
string PerceptionSys_relativePositionToText( struct RelativePosition relativePosition ) {

    int longitudinal = FloatToInt( relativePosition.longitudinal );
    string longitudinalText;
    if( longitudinal > 0 )
        longitudinalText = IntToString( longitudinal )+" metros hacia delante";
    if( longitudinal < 0 )
        longitudinalText = IntToString( longitudinal )+" metros hacia atras";

    int transversal = FloatToInt( relativePosition.transversal );
    string transversalText;
    if( transversal > 0 )
        transversalText = IntToString( transversal )+" metros hacia la izquierda";
    if( transversal < 0 )
        transversalText = IntToString( -transversal )+" metros hacia la derecha";

    if( longitudinal == 0 && transversal == 0 )
        return "pegada a ti";

    string conjuncion;
    if( transversal != 0 && longitudinal != 0 )
        conjuncion = " y ";

    return longitudinalText + conjuncion + transversalText;
}


// Da la esperanza de la relacion entre exitos y fallas del skill A con medida
// 'skillAMeasure' respecto al skill opueso B con medida 'skillBMeasure'.

// Calcula la esperanza de la relacion entre exitos y fallas, que el detector
// (usando el detectionSkill) detecte al detectable (contrarestando con counterSkill).
float PerceptionSys_detectionSuccessesPerFailsEsperance( object detector, float detectorSkillMeasure, object detectable, float detectableCounterSkillMeasure );
float PerceptionSys_detectionSuccessesPerFailsEsperance( object detector, float detectorSkillMeasure, object detectable, float detectableCounterSkillMeasure ) {

    // obtener la probabilidad de deteccion a la distancia de referencia
    float successesPerFailsAtReferenceDistance = SkillSys_opositesCheckSuccessesPerFailsEsperance( detectorSkillMeasure, detectableCounterSkillMeasure );
//    SendMessageToPC( detector, "successesPerFailsAtReferenceDistance="+FloatToString(successesPerFailsAtReferenceDistance) );

    // Para calcular la probabilidad de deteccion a la distancia dada por 'actualDistance'
    // se partio de lo siguiente: (pEa/pFa) / (pEr/pFr) == dr^2 / da^2  donde
    //      pEa: probabilidad de exito a distancia actual
    //      pFa: probabilidad de falla a distancia actual ( pFa = 1 - pEa )
    //      pEr: probatilidad de exito a distancia de referencia
    //      pFr: probabilidad de falla a distancia de referencia (pFr = 1 - pEr )
    //      dr: distancia de referencia
    //      da: distancia actual entre detector y detectable
    // Despejando queda: (pEa/pFa) = (pEr/pFr) * (dr^2/da^2)
    float actualDistance = GetDistanceBetween( detector, detectable );
    float squareOfActualDistance = actualDistance * actualDistance;
    float successesPerFailsAtActualDistance = successesPerFailsAtReferenceDistance * squareOfReferenceDistance / squareOfActualDistance ;
//    SendMessageToPC( detector, "actualDistance="+FloatToString(actualDistance)+", successesPerFailsAtActualDistance="+FloatToString(successesPerFailsAtActualDistance) );
    return successesPerFailsAtActualDistance;
}



// Toda criatura o PJ cuyo onHeartBeat handler llame a esta rutina, sera
// percibido con el sistema especial de percepcion por todos los PJs.
void PerceptionSys_playerHandler();
void PerceptionSys_playerHandler() {

    object detectable = OBJECT_SELF;
//    SendMessageToPC( GetFirstPC(), "detectable="+GetName(detectable) );

    // si detectable es invalido, o no esta oculto ni invisible, los notificado de deteccion no son necesarios, asi que saltearlo.
    int detectableHasInvisibilityEffect = GetHasSpellEffect( SPELL_INVISIBILITY, detectable );
    int detectableHasImprovedInvisibilityEffect = GetHasSpellEffect( SPELL_IMPROVED_INVISIBILITY, detectable );
    int detectableHasDarknessEffect = GetHasSpellEffect( SPELL_DARKNESS, detectable );
    int detectableIsInStealthMode = GetStealthMode(detectable) == STEALTH_MODE_ACTIVATED;

    vector actualPosition = GetPosition( detectable );
    // si 'detectable' esta oculto
    if(
        detectableHasInvisibilityEffect ||
        detectableHasImprovedInvisibilityEffect ||
        detectableHasDarknessEffect ||
        detectableIsInStealthMode
    ) {
        // averiguar si detectable permanecio inmovil. En caso afirmativo saltear los checkeos de listen contra el.
        vector previousPosition = GetPositionFromLocation( GetLocalLocation( detectable, PerceptionSys_location_VN ) );
        int detectableIsMoving = actualPosition != previousPosition;

        // resolver el hide measure del detectable. Si el detectable se esta moviendo, el hide efectivo es el minimo de hide y move silently
        float detectableHideMeasure = SkillSys_measure(
            detectable,
            ( detectableIsMoving && GetSkillRank( SKILL_MOVE_SILENTLY, detectable ) < GetSkillRank( SKILL_HIDE, detectable ) ) ? SKILL_MOVE_SILENTLY : SKILL_HIDE
        );

        // obtener la party del detectable
        object detectableParty = GetFactionLeader( detectable );

        object detector = GetFirstPC();
        while( detector != OBJECT_INVALID ) {
    //    SendMessageToPC( GetFirstPC(), "detector="+GetName(detector) );

            // ignorar detector si es invalido, es detectable, esta en otra area, esta en el mismo party que detectable, o esta viendo a detectable
            if(
                GetIsObjectValid(detector) &&
                detector != detectable &&
                !GetIsDM( detector ) &&
                GetArea( detector ) == GetArea( detectable ) &&
                GetFactionLeader( detector ) != detectableParty
                && !GetObjectSeen( detectable, detector ) //<----------  comentado para testeo, luego descomentar
            ) {

                // calcular la esperanza de la relacion entre exitos y fallas del "spot" de detector contra el "hide" de detectable.
                float spotSuccessesPerFailsEsperance = PerceptionSys_detectionSuccessesPerFailsEsperance(
                    detector,
                    SkillSys_measure( detector, SKILL_SPOT ),
                    detectable,
                    detectableHideMeasure
                );

                // si detectable esta magicamente invisible y detector no puede ver lo invisible, reducir la relacion entre exitos y fallas del spot contra hide
                if( detectableHasImprovedInvisibilityEffect ) {  // si detectable esta afectado por "improved invisibility", reducir la relacion entre exitos y fallas
                    if( !GetHasSpellEffect( SPELL_SEE_INVISIBILITY, detector ) && !GetHasSpellEffect( SPELL_TRUE_SEEING, detector ) )
                        spotSuccessesPerFailsEsperance /= 49.0;  // calculado para que, con todos los modificadores nulos, el detector gane una tirada cada cinco minutos (equivale a 20.4 skill points de bonus para el hide)

                } else if( detectableHasInvisibilityEffect ) {
                    if( !GetHasSpellEffect( SPELL_SEE_INVISIBILITY, detector ) && !GetHasSpellEffect( SPELL_TRUE_SEEING, detector ) )
                        spotSuccessesPerFailsEsperance /= 29.0;  // calculado para que, con todos los modificadores nulos, el detector gane una tirada cada tres minutos (equivale a 17.7 skill points de bonus para el hide)
                }

                // si detectable esta en oscuridad magica y el detector no tiene ultravision, reducir la relacion entre exitos y fallas del spot vs hide
                if( detectableHasDarknessEffect ) {
                    if( !GetHasSpellEffect( SPELL_DARKVISION, detector ) && !GetHasSpellEffect( SPELL_TRUE_SEEING, detector ) )
                        spotSuccessesPerFailsEsperance /= 19.0; // calculado para que, con todos los modificadores nulos, el detector gane una tirada cada dos minutos (equivale a 15.4 skill points de bonus para el hide)
                }

    //            SendMessageToPC( detector, "spotSuccessesPerFailsEsperance="+FloatToString( spotSuccessesPerFailsEsperance ) );

                // calcular probabilidad de deteccion  p = e/(f+e) = (e/f)/[1+(e/f)]
                float spotSuccessProbability = spotSuccessesPerFailsEsperance / ( 1.0 + spotSuccessesPerFailsEsperance );

                // tirar dado para determinar si detector detectaria a detectable si nada bloqueara su vision
                if( Random(10001) <= FloatToInt( 10000.0 * spotSuccessProbability ) ) {

                    struct RelativePosition relativePosition = PerceptionSys_getRelativePosition( GetLocation( detector ), GetPosition( detectable ) );

                    // si detectable esta delante de detector y nada bloquea la vision de detector para ver a detectable, entonces notificar al detector sobre la presencia de detectable.
                    if( relativePosition.longitudinal >= 0.0 && LineOfSightObject( detector, detectable ) ) {
                        string positionDescription = PerceptionSys_relativePositionToText( PerceptionSys_getRelativePosition( GetLocation( detector ), GetPosition( detectable ) ) );
                        SendMessageToPC( detector, "Notas una imagen " + positionDescription );

                        // continuar con siguiente detector. Notar que solo resuelve listen vs move silently si detector NO logra ver a detectable
                        detector = GetNextPC();
                        continue;
                    }
                }

                // si detectable se esta moviendo, resolver listen vs move silently
                if( detectableIsMoving ) {

                    // calcular la esperanza de la relacion entre exitos y fallas del "listen" de detector contra el "move silently" de detectable.
                    float listenSuccessesPerFailsEsperance = PerceptionSys_detectionSuccessesPerFailsEsperance(
                        detector,
                        SkillSys_measure( detector, SKILL_LISTEN ),
                        detectable,
                        SkillSys_measure( detectable, SKILL_MOVE_SILENTLY)
                    );

                    // si detectable esta dentro de un area de silencio, reducir la relacion entre exitos y fallas
                    if( GetHasSpellEffect( SPELL_SILENCE, detectable ) ) // si detectable esta afectado por "silence", reducir la relacion entre exitos y fallas
                        listenSuccessesPerFailsEsperance /= 49.0; // calculado para que, con todos los modificadores nulos, el detector gane una tirada cada cinco minutos (equivale a 20.4 skill points de bonus para el move silently)
                    else if( !detectableIsInStealthMode ) // si detectable NO esta afectado por "silence" y no esta en modo sigiloso, aumentar la relacion entre exitos y fallas
                        listenSuccessesPerFailsEsperance *= 6.1; // equivale a 10 skill points de pena para el move silently

    //                SendMessageToPC( detector, "listenSuccessesPerFailsEsperance="+FloatToString( listenSuccessesPerFailsEsperance ) );

                    // calcular probabilidad de deteccion  p = e/(f+e) = (e/f)/[1+(e/f)]
                    float listenSuccessProbability = listenSuccessesPerFailsEsperance / ( 1.0 + listenSuccessesPerFailsEsperance );

                    /// tirar dado para determinar si detector puede detectar a detectable
                    if( Random(10001) <= FloatToInt( 10000.0 * listenSuccessProbability ) ) {
                        float relativeAngle = PerceptionSys_getRelativeAngle( GetLocation(detector), GetPosition(detectable) );
                        string directionDescription = PerceptionSys_relativeAngleToText( FloatToInt( relativeAngle ) );
                        string fuzzyDistanceDescription = PerceptionSys_fuzzyDistanceToText( GetDistanceBetween( detectable, detector ) );
                        SendMessageToPC( detector, "Escuchas algo " + fuzzyDistanceDescription + " de " + directionDescription );

                    }
                }// end if( detectableIsMoving )

            }// end if
            detector = GetNextPC();

        }// end inner while

    }// end if 'detectable' esta oculto
    SetLocalLocation( detectable, PerceptionSys_location_VN, GetLocation( detectable ) );

}

