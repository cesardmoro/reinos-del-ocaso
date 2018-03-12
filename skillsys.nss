/********************************* class SkillSys ******************************
Package: SkillSys - front end interface
Author: Inquisidor
Version: 0.1
Descripcon: Sistema de skills modificado.
Este sistema de skill es totalmente distinto al de D&D.
El proposito de este sistema es minimizar las diferencias de poder debidas al nivel.

Nota por Dragoncin: mas allá de que esto realmente es DUDOSO con todas las mayúsculas
(y que espero que solo lo apliques en circunstancias muy concretas y no en todos lados),
la esperanza matemática en inglés se escribe "expectance". :P
*******************************************************************************/

////////////////////////// class operations ///////////////////////////////////

// Mide el valor de un skill (modificado por el bono) del sujeto dado.
float SkillSys_measure( object subject, int skillId, int bonus = 0 );
float SkillSys_measure( object subject, int skillId, int bonus = 0 ) {
    //float subjectBaseSkillRank = IntToFloat( GetSkillRank( skillA, subjectA, TRUE ) );
    float subjectFinalSkillRank = IntToFloat( GetSkillRank( skillId, subject, FALSE ) + bonus + 5); // el '5' compensa los cinco puntos correspondientes al modificador por habilidad que son quitados por D&D para que de cero cuando se tiene diez puntos en la habilidad.
    if( subjectFinalSkillRank <= 1.0 )
        return 1.0;
    int subjectLevel = GetHitDice( subject );
    float measure = subjectFinalSkillRank * pow( subjectFinalSkillRank / IntToFloat( subjectLevel + 8 ), 0.25 );  // "subjectLevel + 8" es el valor final del skill cuando se pone la maxima cantidad posible de skill points, en un PJ con 10 puntos en la habilidad que modifica al skill y ningun otro bonus.
//    SendMessageToPC( GetFirstPC(), "subjectName="+GetName(subject)+", subjectFinalSkillRank="+FloatToString(subjectFinalSkillRank)+", subjectLevel="+IntToString(subjectLevel)+", measure="+FloatToString(measure) );
    if( measure < 1.0 )
        measure = 1.0;
    return measure;
}


// Da la esperanza de la relacion entre exitos y fallas del skill A con medida
// 'skillAMeasure' respecto al skill opueso B con medida 'skillBMeasure'.
float SkillSys_opositesCheckSuccessesPerFailsEsperance( float skillAMeasure, float skillBMeasure );
float SkillSys_opositesCheckSuccessesPerFailsEsperance( float skillAMeasure, float skillBMeasure ) {
    return 0.904762 * pow( 1.21, skillAMeasure - skillBMeasure );  // 0.904762 = 19/21
    //float skillsRelation = skillAMeasure/skillBMeasure;
    //return skillsRelation*skillsRelation; // successPerFails = skillsRelation^2;
}


// Da la probabilidad de que el skill A con medida 'skillAMeasure' le gane al skill
// opueso B con medida 'skillBMeasure'.
float SkillSys_opositesCheckSuccessProbability( float skillAMeasure, float skillBMeasure );
float SkillSys_opositesCheckSuccessProbability( float skillAMeasure, float skillBMeasure ) {
    float successesPerFails = SkillSys_opositesCheckSuccessesPerFailsEsperance( skillAMeasure, skillBMeasure );
    return successesPerFails / ( successesPerFails + 1.0 );
}

