/******************* Item Properties System - Random Properties Generator ********
package: Item Properties System - Random Properties Generator - include
Autor: Inquisidor
Descripcion: funciones que generan propiedades para items.
*******************************************************************************/
#include "IPS_Features_inc"
#include "IPS_inc"
#include "inc_item_props"


////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Item generators //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

struct Properties IPS_Item_generateRandomProperties( float desiredQuality, struct WeightedSelector featureDie, int baseItemType, int armor2daIndex=-1 );
struct Properties IPS_Item_generateRandomProperties( float desiredQuality, struct WeightedSelector featureDie, int baseItemType, int armor2daIndex=-1 ) {
    struct Properties properties;
//    SendMessageToPC( GetFirstPC(), "desiredQuality="+FloatToString(desiredQuality)+", baseItemType="+IntToString(baseItemType) );
    float remainingFeaturePoints = desiredQuality;
    float curseQualityBonus = 0.0;
    int numberOfPropertiesApplied = 0;
//    int borrame = 0;
    while( remainingFeaturePoints > 0.0 && featureDie.totalWeight > 0 && numberOfPropertiesApplied < IPS_ItemProperty_MAX_NUMBER_OF_PROPERTIES ) {
        int entry = WeightedDie_throw( featureDie );
//        SendMessageToPC( GetFirstPC(), "entry="+IntToString(entry) ); //+", featureDie="+featureDie.array );

        // le agrega la abilidad correspondiente
        if( IPS_FEATURE_ID_ABILITY_BEGIN <= entry && entry <= IPS_FEATURE_ID_ABILITY_END ) {
            struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_AbilityBonus_getCostParams( baseItemType ) );
            if( stlc.intensity > 0 ) {
                remainingFeaturePoints -= stlc.cost;
                properties.onEquipDescriptors += IPS_ItemProperty_AbilityBonus_buildDescriptor( entry - IPS_FEATURE_ID_ABILITY_BEGIN, stlc.intensity );
            }

        }
        // le agrega la salvacion correspondiente
        else if( IPS_FEATURE_ID_BONUS_SAVES_BEGIN <= entry && entry <= IPS_FEATURE_ID_BONUS_SAVES_END ) {
            struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_BonusSavingThrow_getCostParams( baseItemType, entry - IPS_FEATURE_ID_BONUS_SAVES_BEGIN ) );
            if( stlc.intensity > 0 ) {
                remainingFeaturePoints -= stlc.cost;
                properties.onEquipDescriptors += IPS_ItemProperty_BonusSavingThrow_buildDescriptor( entry - IPS_FEATURE_ID_BONUS_SAVES_BEGIN, stlc.intensity );
                if( entry == IPS_FEATURE_ID_BONUS_SAVES_UNIVERSAL )
                    featureDie = WeightedDie_removeFace( WeightedDie_removeFace( WeightedDie_removeFace( featureDie, IPS_FEATURE_ID_BONUS_SAVES_FORTITUDE ), IPS_FEATURE_ID_BONUS_SAVES_WILL ), IPS_FEATURE_ID_BONUS_SAVES_REFLEX );  // excluyente con las salvaciones simples: BONUS_SAVES_FORTITUDE, BONUS_SAVES_REFLEX, y BONUS_SAVES_WILL
                else
                    featureDie = WeightedDie_removeFace( featureDie, IPS_FEATURE_ID_BONUS_SAVES_UNIVERSAL ); // excluyente con BONUS_SAVES_UNIVERSAL
            }
        }
        // le agrega inmunidad porcentual al daño fisico correspondiente
        else if( IPS_FEATURE_ID_DAMAGE_INMUNITY_BEGIN_FISICAL <= entry && entry <= IPS_FEATURE_ID_DAMAGE_INMUNITY_END_FISICAL ) {
            struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_DamageImmunityFisical_getCostParams( baseItemType, armor2daIndex ) );
            if( stlc.intensity > 0 ) {
                remainingFeaturePoints -= stlc.cost;
                properties.onEquipDescriptors += IPS_ItemProperty_DamageImmunityFisical_buildDescriptor( entry - IPS_FEATURE_ID_DAMAGE_INMUNITY_BEGIN_FISICAL, stlc.intensity );
            }

        }
        // le agrega inmunidad porcentual a el daño elemental correspondiente
        else if( IPS_FEATURE_ID_DAMAGE_INMUNITY_BEGIN_ELEMENTAL <= entry && entry <= IPS_FEATURE_ID_DAMAGE_INMUNITY_END_ELEMENTAL ) {
            struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_DamageImmunityElemental_getCostParams( baseItemType, armor2daIndex ) );
            if( stlc.intensity > 0 ) {
                remainingFeaturePoints -= stlc.cost;
                properties.onEquipDescriptors += IPS_ItemProperty_DamageImmunityElemental_buildDescriptor( entry - IPS_FEATURE_ID_DAMAGE_INMUNITY_BEGIN_ELEMENTAL, stlc.intensity );
            }

        }
        // le agrega el skill parry
        else if( entry == IPS_FEATURE_ID_SKILL_PARRY ) {
            if( numberOfPropertiesApplied == 0 ) { // solo agregar si hasta el momento no se aplicó ninguna propiead
                struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_SkillBonus_getCostParams( baseItemType ) );
                if( stlc.intensity > 0 ) {
                    remainingFeaturePoints -= stlc.cost;
                    properties.onEquipDescriptors += IPS_ItemProperty_SkillBonus_buildDescriptor( entry - IPS_FEATURE_ID_SKILL_BEGIN, stlc.intensity );
                }
            }
        }
        // le agrega el skill correspondiente
        else if( IPS_FEATURE_ID_SKILL_BEGIN <= entry && entry <= IPS_FEATURE_ID_SKILL_END ) {
            struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_SkillBonus_getCostParams( baseItemType ) );
            if( stlc.intensity > 0 ) {
                remainingFeaturePoints -= stlc.cost;
                properties.onEquipDescriptors += IPS_ItemProperty_SkillBonus_buildDescriptor( entry - IPS_FEATURE_ID_SKILL_BEGIN, stlc.intensity );
            }
        } else switch( entry ) {

            case IPS_FEATURE_ID_AC_BONUS: { // le agrega defleccion
                struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_ACBonus_getCostParams( baseItemType, armor2daIndex ) );
                if( stlc.intensity > 0 ) {
                    remainingFeaturePoints -= stlc.cost;
                    properties.onEquipDescriptors += IPS_ItemProperty_ACBonus_buildDescriptor( stlc.intensity );
                }
            } break;

            case IPS_FEATURE_ID_ATTACK_BONUS: { // agrega precicion (attack bonus)
                struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_AttackBonus_getCostParams( baseItemType ) );
                if( stlc.intensity > 0 ) {
                    remainingFeaturePoints -= stlc.cost;
                    properties.onEquipDescriptors += IPS_ItemProperty_AttackBonus_buildDescriptor( stlc.intensity );
                    featureDie = WeightedDie_removeFace( featureDie, IPS_FEATURE_ID_ENHANCEMENT_BONUS ); // esta propiedad excluye a enhancement bonus
                }
            } break;

            case IPS_FEATURE_ID_DAMAGE_BONUS_PHYSICAL: { // agregan daño fisico (damage bonus: BLUDGEONING, PIERCING, o SLASHING ).
                struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_FisicalDamageBonus_getCostParams( baseItemType ) );
                if( stlc.intensity > 0 ) {
                    remainingFeaturePoints -= stlc.cost;
                    int damageType; //El tipo de daño elegido es el mismo que agrega el hechizo "enchant weapon", cosa de que al aplicarse el hechizo sobre un ítem con esta propiedad, no se sumen los bonos.
                    switch( StringToInt( Get2DAStringAdapted( "baseItems", "WeaponType", baseItemType ) ) ) {
                        case 1:     damageType = IP_CONST_DAMAGETYPE_PIERCING;      break;
                        case 2:     damageType = IP_CONST_DAMAGETYPE_BLUDGEONING;   break;
                        case 3:     damageType = IP_CONST_DAMAGETYPE_SLASHING;      break;
                        case 4:     damageType = IP_CONST_DAMAGETYPE_SLASHING;      break;
                        case 5:     damageType = IP_CONST_DAMAGETYPE_PIERCING;      break;
                        default:    WriteTimestampedLogEntry("IPS_Item_generateRandomProperties: Error, unreachable in case 02, baseItemType="+IntToString(baseItemType) ); break;
                    }
                    properties.onEquipDescriptors += IPS_ItemProperty_DamageBonus_buildDescriptor( damageType, stlc.intensity );
                    featureDie = WeightedDie_removeFace( featureDie, IPS_FEATURE_ID_ENHANCEMENT_BONUS );  // esta propiedad excluye a enhancement bonus
                }
            } break;

            case IPS_FEATURE_ID_DAMAGE_BONUS_ELEMENTAL: { // agrega daño elemental ( damage bonus: ACID, ELECTRICAL, COLD, o FIRE ).
                struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_ElementalDamageBonus_getCostParams( baseItemType ) );
                if( stlc.intensity > 1 ) { // se compara con 1 y no con 0 porque no hay daño 1d2 en la tabla del 2DA
                    remainingFeaturePoints -= stlc.cost*IntToFloat(2*stlc.intensity+1)/IntToFloat(2*stlc.intensity); // el factor compenza el estra danio por usar dado.  Por ejemplo, si en lugar de hacer 3 fijo se usa un 1d6, el dano esperado sería 3,5. El factor agrega el costo correspondiente al ese 16.6% de incremento al daño que da subir de 3 a 3,5.
                    int elemDamageType;
                    switch( Random(4) ) {
                        case 0: elemDamageType = IP_CONST_DAMAGETYPE_ACID;      break;
                        case 1: elemDamageType = IP_CONST_DAMAGETYPE_COLD;      break;
                        case 2: elemDamageType = IP_CONST_DAMAGETYPE_ELECTRICAL;break;
                        case 3: elemDamageType = IP_CONST_DAMAGETYPE_FIRE;      break;
                    }
                    properties.onEquipDescriptors += IPS_ItemProperty_DamageBonus_buildDescriptor( elemDamageType, stlc.intensity + DAMAGE_BONUS_1d4 - 2 ); // intensity -> damage: 2->1d4, 3->1d6, 4->1d8, 5->1d10
                }
            } break;

            case IPS_FEATURE_ID_ENHANCEMENT_BONUS: { // encanta el arma (enhancement bonus)
                struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_EnhancementBonus_getCostParams( baseItemType ) );
                if( stlc.intensity > 0 ) {
                    remainingFeaturePoints -= stlc.cost;
                    properties.onEquipDescriptors += IPS_ItemProperty_EnhancementBonus_buildDescriptor( stlc.intensity );
                    featureDie = WeightedDie_removeFace( WeightedDie_removeFace( featureDie, IPS_FEATURE_ID_ATTACK_BONUS ), IPS_FEATURE_ID_DAMAGE_BONUS_PHYSICAL ); // esta propiedad excluye a attack bonus y fisical damage bonus
                }
            } break;

            case IPS_FEATURE_ID_MAX_RANGE_STRENGHT_MOD: { // aumenta el limitador de daño por modificador de fuerza (mighty)
                struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_MaxRangeStrengthMod_getCostParams( baseItemType )  );
                if( stlc.intensity > 0 ) {
                    remainingFeaturePoints -= stlc.cost;
                    properties.onEquipDescriptors += IPS_ItemProperty_MaxRangeStrengthMod_buildDescriptor( stlc.intensity );
                }
            } break;

            case IPS_FEATURE_ID_VAMPIRIC_REGENERATION: { // da regeneracion vampirica
                if( numberOfPropertiesApplied <= 1 ) { // solo agregar si hasta el momento se aplicó a lo sumo una propiead
                    struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_VampiricRegeneration_getCostParams( baseItemType )  );
                    if( stlc.intensity > 0 ) {
                        remainingFeaturePoints -= stlc.cost;
                        properties.onEquipDescriptors += IPS_ItemProperty_VampiricRegeneration_buildDescriptor( stlc.intensity );
                    }
                }
            } break;

            case IPS_FEATURE_ID_UNLIMITED_AMMO: { // da municiones ilimitadas
                struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_UnlimitedAmmo_getCostParams( baseItemType )  );
                if( stlc.intensity > 0 ) {
                    remainingFeaturePoints -= stlc.cost;
                    properties.onEquipDescriptors += IPS_ItemProperty_UnlimitedAmmo_buildDescriptor( stlc.intensity );
                }
            } break;

            case IPS_FEATURE_ID_KEEN: { // afila el arma. Solo válido para armas de hoja.
                float cost = IPS_Feature_Keen_getCost( baseItemType );
                if( remainingFeaturePoints >= cost ) {
                    remainingFeaturePoints -= cost;
                    properties.onEquipDescriptors += IPS_ItemProperty_Keen_buildDescriptor();
                }
            } break;

            case IPS_FEATURE_ID_WEIGHT_REDUCTION: { // le reduce el peso
                struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_ACBonus_getCostParams( baseItemType, armor2daIndex ) );
                if( stlc.intensity > 0 ) {
                    remainingFeaturePoints -= stlc.cost;
                    properties.onCreationDescriptors += IPS_ItemProperty_WeightReduction_buildDescriptor( stlc.intensity );
                }
            } break;

            case IPS_FEATURE_ID_CAST_SPELL_CONTINGENCY: { // le agrega contingencia de spells (spell sequencer)
                struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_SpellSequencer_getCostParams( baseItemType, armor2daIndex ) );
                if( stlc.intensity > 0 ) {
                    remainingFeaturePoints -= stlc.cost;
                    properties.onEquipDescriptors += IPS_ItemProperty_CastSpell_buildDescriptor( 520+stlc.intensity, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE); // capacity: 521 -> 1 spell, 522 -> 2 spells, 523 -> 3 spells
                    properties.onEquipDescriptors += IPS_ItemProperty_CastSpell_buildDescriptor( 524, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE); // 524 spells reset
                }
            } break;

            case IPS_FEATURE_ID_ARMOR_FORTIFICATION: { // le agrega fortificacion (inmunidad a criticos): 1->10%, 2->20%, ..., 9->90%
                if( numberOfPropertiesApplied ==0  ) { // solo agregar si hasta el momento no se aplicó ninguna propiead
                    struct IPS_FeatureIntensityAndCost stlc = IPS_generateRandomIntensity( remainingFeaturePoints, IPS_Feature_Fortification_getCostParams( baseItemType, armor2daIndex ) );
                    if( stlc.intensity > 0 ) {
                        remainingFeaturePoints -= stlc.cost;
                        properties.onEquipDescriptors += IPS_ItemProperty_Fortification_buildDescriptor( stlc.intensity );
                    }
                }
            } break;

            case IPS_FEATURE_ID_CONFUSION_ON_DAMAGE: { // agrega la maldicion confusion al recibir daño
                if( numberOfPropertiesApplied == 0 ) { // solo agregar si hasta el momento no se aplicó ninguna propiead
                    desiredQuality += IPS_Feature_ConfusionCurse_QUALITY_BONUS;
                    remainingFeaturePoints += IPS_Feature_ConfusionCurse_QUALITY_BONUS;
                    curseQualityBonus += IPS_Feature_ConfusionCurse_QUALITY_BONUS;
                    properties.onEquipDescriptors += IPS_ItemProperty_ConfusionCurse_buildDescriptor();
                    properties.flags |= IPS_ITEM_FLAG_IS_CURSED;
                }
            } break;

            case IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS: { // agrega la maldicion hostilidad por parte de los compañeros de equipo
                if( numberOfPropertiesApplied == 0 ) { // solo agregar si hasta el momento no se aplicó ninguna propiead
                    desiredQuality += IPS_Feature_HostilityCurse_QUALITY_BONUS;
                    remainingFeaturePoints += IPS_Feature_HostilityCurse_QUALITY_BONUS;
                    curseQualityBonus += IPS_Feature_HostilityCurse_QUALITY_BONUS;
                    properties.onEquipDescriptors += IPS_ItemProperty_HostilityCurse_buildDescriptor();
                    properties.flags |= IPS_ITEM_FLAG_IS_CURSED;
                }
            } break;

            case IPS_FEATURE_ID_BONUS_FEAT_GREATER_CLEAVE: { // agrega clava superior
                if( numberOfPropertiesApplied == 0 ) { // solo agregar si hasta el momento no se aplicó ninguna propiead
                    float cost = IPS_Feature_Feat_getCost( baseItemType, 260  ); //IP_CONST_FEAT_GREATER_CLEAVE
                    if( remainingFeaturePoints >= cost ) {
                        remainingFeaturePoints -= cost;
                        properties.onCreationDescriptors += IPS_ItemProperty_BonusFeat_buildDescriptor( IP_CONST_FEAT_CLEAVE );
                        properties.onCreationDescriptors += IPS_ItemProperty_BonusFeat_buildDescriptor( 260 ); // 260 = IP_CONST_FEAT_GREATER_CLEAVE
                    }
                }
            } break;

            case IPS_FEATURE_ID_ON_HIT_ARMOR_CAST_SPELL: { // le agrega el "on hit cast spell" correspondiente
                if( numberOfPropertiesApplied <= 1 ) { // solo agregar si hasta el momento se aplicó a lo sumo una propiead
                    struct IPS_SpecialPropertyParamsAndCost sppac = IPS_Feature_OnHitArmorCastSpell_getCostParams( baseItemType, remainingFeaturePoints );
                    if( sppac.intensity > 0 ) {
                        remainingFeaturePoints -= sppac.cost;
                        properties.onEquipDescriptors += IPS_ItemProperty_OnHitCastSpell_buildDescriptor( sppac.subtype, sppac.intensity );
                    }
                }
            } break;

            case IPS_FEATURE_ID_ON_HIT_WEAPON_PROPS: { // le agrega el "on hit properties" correspondiente
                struct IPS_SpecialPropertyParamsAndCost sppac = IPS_Feature_OnHitWeaponProps_generateRandom( baseItemType, remainingFeaturePoints );
                if( sppac.intensity > 0 ) {
                    remainingFeaturePoints -= sppac.cost;
                    properties.onEquipDescriptors += IPS_ItemProperty_OnHitProps_buildDescriptor( sppac.subtype, sppac.intensity-1, sppac.specialParam );
                }
            } break;

            default:
                WriteTimestampedLogEntry( "IPS_Item_generateRandomProperties: error, invalid die face:"+IntToString( entry ) );

        }
        featureDie = WeightedDie_removeFace( featureDie, entry );
        numberOfPropertiesApplied = ( GetStringLength(properties.onEquipDescriptors)+GetStringLength(properties.onCreationDescriptors) )/IPS_ItemProperty_TOTAL_WIDTH;
//        if( numberOfPropertiesApplied == borrame )
//            SendMessageToPC( GetFirstPC(), "IPS_Item_generateRandomProperties: itemType="+IntToString(baseItemType)+", entry="+IntToString(entry)+", descriptors="+properties.onEquipDescriptors );
//        borrame = numberOfPropertiesApplied;
    }
    properties.quality = desiredQuality - remainingFeaturePoints - curseQualityBonus;
    return properties;
}


