/********************** RandomWay - Popultaton tools ***************************
Author: Inquisidor
Descripcion: funciones para poblar instancias de RandomWay con criaturas y placeables obstaculizadores
*******************************************************************************/
#include "RW_RandomWay"
#include "RS_inc"
#include "RS_dmc_inc"
#include "spc_poderRel_inc"
#include "SPC_cofre_inc"

const float fpK1 = 9.0; // 6.0 vale para las áreas normales

struct CrAndPenalty {
    int cr;
    float penalty;
};

// 'porcentagePena' debe ser un número negativo entero entre 0 y -99
void RW_PopulationTools_mountTrapsAndLocksOnDoors( object areaBody, int crIngeniero );
void RW_PopulationTools_mountTrapsAndLocksOnDoors( object areaBody, int crIngeniero ) {
    object iteratedObject = GetFirstObjectInArea( areaBody );
    while( iteratedObject != OBJECT_INVALID ) {
        if( GetObjectType(iteratedObject) == OBJECT_TYPE_DOOR && !GetPlotFlag(iteratedObject) ) {
            SPC_Placeable_montarObstaculo( iteratedObject, crIngeniero, 3, 2 );
        }
        iteratedObject = GetNextObjectInArea( areaBody );
    }
}


float RW_PopulationTools_calculatePenalty( int currentCr, int previousCr, float previousPenalty ) {
    float penaltyDueToCrChange = 0.0;
    if( currentCr <= 0 || currentCr < previousCr )
        return 0.0;
    else if( currentCr > previousCr ) {
        float relativePower = SisPremioCombate_poderRelativoSujeto(previousCr, currentCr);
        penaltyDueToCrChange = (1.0 - previousPenalty) * (1.0 - relativePower*relativePower);
    }
    return (previousPenalty + penaltyDueToCrChange) / (1.0 + fpK1 / currentCr );
}


struct CrAndPenalty RW_PopulationTools_generateCrAndPenalty( struct CrAndPenalty previous, float threshold=0.25 );
struct CrAndPenalty RW_PopulationTools_generateCrAndPenalty( struct CrAndPenalty previous, float threshold=0.25 ) {
    struct CrAndPenalty current;
    current.cr = previous.cr;
    current.penalty = previous.penalty / (1.0 + fpK1 / current.cr );

    while( current.penalty < threshold/(1.0 + fpK1 / current.cr) ) {
        current.cr += 1;
        current.penalty = RW_PopulationTools_calculatePenalty( current.cr, previous.cr, previous.penalty );
    }
    return current;
}


// sets the CR and the safety penalty for all the areas of the received randomWay
// For every area whose RS_sge_PN property is not specified, the received 'defaultSge' is used.
struct CrAndPenalty RW_PopulationTools_populate( struct Address randomWay, int firstAreaCr, string defaultSge, float threshold=0.25 );
struct CrAndPenalty RW_PopulationTools_populate( struct Address randomWay, int firstAreaCr, string defaultSge, float threshold=0.25 ) {
//    SendMessageToPC( GetFirstPC(), "RW_PopulationTools_populate: begin" );

    struct CrAndPenalty iteratedProp;
    if( firstAreaCr == 0 )
        return iteratedProp;

    struct Address femaleTransitionsList = randomWay;
    femaleTransitionsList.path += RW_RandomWay_femaleTransitionsList_FIELD;

    object baseAreaBody = GetArea( randomWay.nbh ); // obtains the area where lays the initiator transition.
    int baseAreaCr = GetLocalInt( baseAreaBody, RS_crArea_PN );
    float baseAreaPenalty = -0.01 * GetLocalInt( baseAreaBody, RS_factorTransitoArea_PN );

    iteratedProp.cr = firstAreaCr;
    iteratedProp.penalty = RW_PopulationTools_calculatePenalty( firstAreaCr, baseAreaCr, baseAreaPenalty );

    int femaleTransitionsListSize = VectorObj_getSize( femaleTransitionsList );
    int iteratedIndex;
    for( iteratedIndex=0; iteratedIndex < femaleTransitionsListSize; ++iteratedIndex ) {
        object iteratedAreaBody = GetArea( VectorObj_getAt( femaleTransitionsList, iteratedIndex ) );

        // Undo any change, on the 'iteratedAreaBody' properties corresponding to the RandomSpawn, that have been done by a DM using a Random Spawn Control Wand
        RS_DMC_restore( iteratedAreaBody );
        // Reset the RandomSpawn state of the area in order to it behaves like being the firt time any PC enters into it.
        RS_Area_clean(iteratedAreaBody);

        int factorTransitoArea = FloatToInt(-100.0 * iteratedProp.penalty);

        SetLocalInt( iteratedAreaBody, RS_crArea_PN, iteratedProp.cr );
        SetLocalInt( iteratedAreaBody, RS_factorTransitoArea_PN, factorTransitoArea );
        if( GetLocalInt( iteratedAreaBody, RW_Area_noSgeWasSpecified_VN ) || GetLocalString( iteratedAreaBody, RS_sge_PN ) == "" ) {
            SetLocalInt( iteratedAreaBody, RW_Area_noSgeWasSpecified_VN, TRUE );
            SetLocalString( iteratedAreaBody, RS_sge_PN, defaultSge );
        }

        RW_PopulationTools_mountTrapsAndLocksOnDoors( iteratedAreaBody, iteratedProp.cr );

        iteratedProp = RW_PopulationTools_generateCrAndPenalty( iteratedProp, threshold );
    }

//    SendMessageToPC( GetFirstPC(), "RW_PopulationTools_populate: end" );
    return iteratedProp;
}


struct NumAreasAndFirstCr {
    int numAreas;
    int firstCr;
};


// calculates minimum number of areas and the maximun CR of the first area such that the CR of the area X after the last area of the way is less than the 'finalCr', or they are equal and the penalty of X is less than or equal to finalPenalty
struct NumAreasAndFirstCr RW_PopulationTools_calculateNumAreasAndCrOfTheFirst( int baseCr, float basePenalty, int minNumAreas, int finalCr, float finalPenalty );
struct NumAreasAndFirstCr RW_PopulationTools_calculateNumAreasAndCrOfTheFirst( int baseCr, float basePenalty, int minNumAreas, int finalCr, float finalPenalty ) {
//    SendMessageToPC( GetFirstPC(), "RW_PopulationTools_calculateNumAreasAndCrOfTheFirst: begin - finalCr="+IntToString(finalCr)+", finalPenalty="+FloatToString(finalPenalty) );
    struct NumAreasAndFirstCr result;

    result.numAreas = minNumAreas;
    result.firstCr = finalCr;
    while( result.firstCr > 0 ) {
        struct CrAndPenalty iteratedProp;
        iteratedProp.cr = result.firstCr;
        iteratedProp.penalty = RW_PopulationTools_calculatePenalty( result.firstCr, baseCr, basePenalty );

        int iteratedIndex = result.numAreas;
        while( --iteratedIndex >= 0 ) {
            iteratedProp = RW_PopulationTools_generateCrAndPenalty( iteratedProp, finalPenalty );
        }
//        SendMessageToPC( GetFirstPC(), "RW_PopulationTools_calculateNumAreasAndCrOfTheFirst: cr="+IntToString(iteratedProp.cr)+", penalty="+FloatToString(iteratedProp.penalty) );
        if( iteratedProp.cr < finalCr ) {
            result.firstCr += 1;
            return result;
        }
        else if( iteratedProp.cr == finalCr && iteratedProp.penalty == finalPenalty )
            return result;
        else if( iteratedProp.cr == finalCr && iteratedProp.penalty > finalPenalty )
            result.numAreas += 1;
        else
            result.firstCr -= 1;
    }
//    SendMessageToPC( GetFirstPC(), "RW_PopulationTools_calculateNumAreasAndCrOfTheFirst: end - firstCr="+IntToString(result.firstCr) + ", numAreas="+IntToString(result.numAreas) );
    return result;
}


// sets the CR and the safety penalty for all the areas of the received shortcut
// For every area whose RS_sge_PN property is not specified, the received 'defaultSge' is used.
int RW_PopulationTools_populateShortcut( struct Address shortcut, object secondaryEntranceBody, string defaultSge );
int RW_PopulationTools_populateShortcut( struct Address shortcut, object secondaryEntranceBody, string defaultSge ) {

    object baseArea = GetArea(shortcut.nbh);
    int baseCr = GetLocalInt( baseArea, RS_crArea_PN );
    float basePenalty = -0.01 * GetLocalInt( baseArea, RS_factorTransitoArea_PN );
    int minNumAreas = GetLocalInt( shortcut.nbh, RW_Initiator_numberOfTripAreas_PN );
    object destinationArea = GetArea(secondaryEntranceBody);
    int destinationCr = GetLocalInt( destinationArea, RS_crArea_PN );
    float destinationPenalty = -0.01 * GetLocalInt( destinationArea, RS_factorTransitoArea_PN );

    if( destinationPenalty > 0.0 ) {
        struct NumAreasAndFirstCr result = RW_PopulationTools_calculateNumAreasAndCrOfTheFirst( baseCr, basePenalty, minNumAreas, destinationCr, destinationPenalty );
        RW_PopulationTools_populate( shortcut, result.firstCr, defaultSge, destinationPenalty );
        return TRUE;
    }
    else
        return destinationCr == 0;
    return FALSE;
}
