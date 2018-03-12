///////////////////////////////////////////////////////////////////////////////
// deity_onload.nss
//
// Created by: The Krit
// Date: 11/06/06
///////////////////////////////////////////////////////////////////////////////
//
// This file defines core deities.
//
// These deities are based on those I found on wikipedia
// (http://en.wikipedia.org/wiki/List_of_deities_of_Dungeons_&_Dragons).
//
// My intent is that this file defines a relatively small pantheon for those
// who want some degree of simplicity. I included greater, intermediate, and
// lesser deities, but only the core ones, not the exclusively demihuman ones.
// To balance this, I listed each deity as accepting all races, unless there
// was a reason to do otherwise. (Being a patron deity counts as a reason to
// do otherwise. To balance things a little, I declared Pelor to be the patron
// of humans.)
//
///////////////////////////////////////////////////////////////////////////////
//
// This is the file you most likely need to change to adapt to your world.
// The provided deities are examples for how to set up your own pantheon.
//
// You may want to change deity_include to allow additional information to be
// stored for each deity.
//
// For the core info concerning allowed alignments, races, and domains, keep
// in mind that the default is to accept all. If you specify certain races,
// then those races are the only ones that will be able to level as clerics
// of that deity (and similarly for alignments and domains).
//
///////////////////////////////////////////////////////////////////////////////
//
// To use this pantheon system, InitializePantheon() needs to be called in
// the module's OnLoad event.
//
// Alternatively, you could rename the function to main() and make this file
// your module's OnLoad event handler.
//
///////////////////////////////////////////////////////////////////////////////
//
// The following comments are intended to give guidance for defining your
// pantheon. This is not the only way to do things, but following these
// examples should keep your code clean and not scare away the non-scripters.
//
// A minimal deity definition would look something like:
//
//    // Name
//    nDeity = AddDeity("Name");
//
//        // Allow all alignments.
//        // AddClericAlignment(nDeity, ALIGNMENT_,  ALIGNMENT_);
//
//        // Allow all races.
//        // AddClericRace(nDeity, RACIAL_TYPE_);
//
//        // Allow all domains,
//        // AddClericDomain(nDeity, DOMAIN_);
//
// A full (but not maximal, especially if you add fields in deity_include)
// deity definition would look something like:
//
//    // Name
//    nDeity = AddDeity("Name");
//        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
//        SetDeityAvatar(nDeity, "AvatarTag");
//        SetDeityGender(nDeity, GENDER_MALE);
//        SetDeityHolySymbol(nDeity, "HolySymbolTag");
//        SetDeityPortfolio(nDeity, "Ice");
//        SetDeitySpawnLoc(nDeity, "StartLocationTag");
//        SetDeityBook(nDeity, "ResRef");
//        SetDeityTitle(nDeity, "Super Cool One");
//        SetDeityTitleAlternates(nDeity, "Frosty the Snowman and Jack Frost");
//        SetDeityWeapon(nDeity, BASE_ITEM_WHIP);
//
//        // Allowed alignments.
//        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL,  ALIGNMENT_GOOD);
//        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
//        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL,  ALIGNMENT_NEUTRAL);
//
//        // Allowed races.
//        AddClericRace(nDeity, RACIAL_TYPE_HALFELF);
//        AddClericRace(nDeity, RACIAL_TYPE_HALFORC);
//        AddClericRace(nDeity, RACIAL_TYPE_HUMAN);
//
//        // Domain choices.
//        AddClericDomain(nDeity, DOMAIN_GOOD);
//        AddClericDomain(nDeity, DOMAIN_HEALING);
//        AddClericDomain(nDeity, DOMAIN_PROTECTION);
//        AddClericDomain(nDeity, DOMAIN_WATER);
//
//
//
///////////////////////////////////////////////////////////////////////////////


#include "deity_include"


///////////////////////////////////////////////////////////////////////////////
// InitializePantheon()
//
// Sets some module variables to represent the supported pantheon.
//
// Customize to suit your world. No string has special meaning to this system,
// so feel free to change them, as well as the alignment, racial, domain, and
// gender constants, and add and delete deities as needed.
//
// These deities are alphabetical by first name, where "Saint" counts as a
// title, not a name. The first name is also used in the associated tags, so
// it should be easy to spot name conflicts before they are a problem.
//
// Nota por Dragoncin: de modificarse esta funcion, debe compilarse el script
// del evento OnModuleLoad
void InitializePantheon()
{
    int nDeity; // Index for the deity being added.

    /* Nota por Dragoncin: dado que todos empezamos en el mismo lugar, esto no va
    // SetDeitySpawnLoc(-1, "Default_Start");  // (See GetPlayerSpawnLocation() in deity_example.)

    /* Nota por Dragoncin: quite todo este sistema de grititos tontos...*/
    // SetDeitySwear(-1, "By the gods!");      // (See Swear() in deity_example.)


    // The pantheon:

    /* IMPORTANTE!
    NOTA POD DRAGONCIN:
    Si se va a agregar o modificar un dios debe mantenerse SI O SI el orden en los panteones.
    Es decir, si se va a agregar un dios elfico, DEBE hacerse debajo de la linea que indica el panteon elfico,
    preferentemente manteniendo el orden alfabetico.
    Luego, deben modificarse estas variables que indican cuantos dioses tiene cada panteon: */

    object oModule = GetModule();

    SetLocalInt(oModule, "NroDiosesPanteonGeneral", 35);
    SetLocalInt(oModule, "NroDiosesPanteonElfico", 11);
    SetLocalInt(oModule, "NroDiosesPanteonEnano", 11);
    SetLocalInt(oModule, "NroDiosesPanteonGnomo", 7);
    SetLocalInt(oModule, "NroDiosesPanteonMediano", 5);


    // PANTEON GENERAL
    // Akadia (Deidad mayor)
    nDeity = AddDeity("Akadia");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "el aire, los elementales de aire, la velocidad, el movimiento, los viajes y las criaturas voladoras");
        SetDeityTitleAlternates(nDeity, "Reina del Aire, Señora del Aire, Señora de los Vientos");
        SetDeityWeapon(nDeity, BASE_ITEM_HEAVYFLAIL);
        SetDeityBook(nDeity, "dogmas_akadia");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL,  ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);

        // Allow all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_AIR);
        AddClericDomain(nDeity, DOMAIN_ILLUSION);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);
        AddClericDomain(nDeity, DOMAIN_TRICKERY);


    // Auril (Deidad menor)
    nDeity = AddDeity("Auril");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "el frio, el hielo y el invierno");
        SetDeityTitleAlternates(nDeity, "la Doncella de Hielo, el Amanecer de Hielo, la Diosa del Frío");
        SetDeityWeapon(nDeity, BASE_ITEM_BATTLEAXE);
        SetDeityBook(nDeity, "dogmas_auril");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_EVIL);

        // Allow all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_AIR);
        AddClericDomain(nDeity, DOMAIN_EVIL);
        AddClericDomain(nDeity, DOMAIN_STORM);
        AddClericDomain(nDeity, DOMAIN_WATER);


    // Azuth (Deidad menor)
    nDeity = AddDeity("Azuth");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "los magos, los lanzadores de conjuros en general y algunos monjes (la Mano Brillante)");
        SetDeityTitleAlternates(nDeity, "el Supremo, Señor de los mágicos, Señor de los conjuros");
        SetDeityBook(nDeity, "dogmas_azut");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_EVIL);

        // Allow all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ILLUSION);
        AddClericDomain(nDeity, DOMAIN_MAGIC);
        AddClericDomain(nDeity, DOMAIN_KNOWLEDGE);
        AddClericDomain(nDeity, DOMAIN_SPELLS);
        AddClericDomain(nDeity, DOMAIN_SPELLS);


    // Cyric (Deidad mayor)
    nDeity = AddDeity("Cyric");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "los asesinatos, la intriga, las mentiras, el engaño y la ilusión");
        SetDeityTitleAlternates(nDeity, "el Príncipe de las mentiras, el Sol Oscuro, el Sol Negro");
        SetDeityWeapon(nDeity, BASE_ITEM_LONGSWORD);
        SetDeityBook(nDeity, "dogmas_cyric");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);

        // Allow all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_EVIL);
        AddClericDomain(nDeity, DOMAIN_DESTRUCTION);
        AddClericDomain(nDeity, DOMAIN_ILLUSION);
        AddClericDomain(nDeity, DOMAIN_TRICKERY);


    // Gond (Deidad intermedia)
    nDeity = AddDeity("Gond");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "el artificio, el arte, la construcción y el trabajo de forja");
        SetDeityTitleAlternates(nDeity, "el Hacedor de Prodigios, Señor de Todos los Herreros");
        SetDeityWeapon(nDeity, BASE_ITEM_WARHAMMER);
        SetDeityBook(nDeity, "dogmas_gond");

        // Allow all alignments.
        // AddClericAlignment(nDeity, ALIGNMENT_,  ALIGNMENT_);

        // Allow all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_EARTH);
        AddClericDomain(nDeity, DOMAIN_FIRE);
        AddClericDomain(nDeity, DOMAIN_KNOWLEDGE);
        AddClericDomain(nDeity, DOMAIN_METAL);


    // Grumbar (Deidad mayor)
    // Nota por Dragoncin: deidad no disponible hasta nuevo parche de Zero
    nDeity = AddDeity("Grumbar");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la tierra elemental, la solidez, la inmutabilidad y los juramentos");
        SetDeityTitleAlternates(nDeity, "el Señor de la tierra, Rey de la tierra bajo las raíces");
        SetDeityWeapon(nDeity, BASE_ITEM_WARHAMMER);
        SetDeityBook(nDeity, "dogmas_grumbar");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL,  ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Allowed races.
        AddClericRace(nDeity, RACIAL_TYPE_GNOME);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_EARTH);
        AddClericDomain(nDeity, DOMAIN_METAL);
        AddClericDomain(nDeity, DOMAIN_TIME);


    // Ilmater (Deidad intermedia)
    nDeity = AddDeity("Ilmater");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la resistencia, el sufrimiento, el martirio y la perseverancia");
        SetDeityTitleAlternates(nDeity, "el Dios del Lamento, el Dios Quebrado");
        SetDeityBook(nDeity, "dogmas_ilmater");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);

        // Todas las razas
        // AddClericRace(nDeity, RACIAL_TYPE);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_HEALING);
        AddClericDomain(nDeity, DOMAIN_STRENGTH);


    // Istishia (Deidad mayor)
    nDeity = AddDeity("Istishia");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "el agua elemental y la purificación");
        SetDeityTitleAlternates(nDeity, "el Señor de las Aguas, el Señor de los Elementales del Agua");
        SetDeityWeapon(nDeity, BASE_ITEM_WARHAMMER);
        SetDeityBook(nDeity, "dogmas_istishia");


        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL,  ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Allow all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DESTRUCTION);
        AddClericDomain(nDeity, DOMAIN_OCEAN);
        AddClericDomain(nDeity, DOMAIN_STORM);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);
        AddClericDomain(nDeity, DOMAIN_WATER);


    // Kelemvor (Deidad mayor)
    nDeity = AddDeity("Kelemvor");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la muerte y los muertos");
        SetDeityTitleAlternates(nDeity, "el Señor de los Muertos, Juez de los Condenados");
        SetDeityWeapon(nDeity, BASE_ITEM_LONGSWORD);
        SetDeityBook(nDeity, "dogmas_kelemvor");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL,  ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL,  ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_EVIL);

        // Allow all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DEATH);
        AddClericDomain(nDeity, DOMAIN_FATE);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);


    // Khauntea (Deidad mayor)
    nDeity = AddDeity("Khauntea");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la agricultura, las plantas cultivadas por los hombres, los granjeros, los jardineros y el verano");
        SetDeityTitleAlternates(nDeity, "la Gran Madre, la Diosa del Cereal, la Madre Tierra");
        SetDeityWeapon(nDeity, BASE_ITEM_SCYTHE);
        SetDeityBook(nDeity, "dogmas_khauntea");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);

        // Allow all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ANIMAL);
        AddClericDomain(nDeity, DOMAIN_EARTH);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PLANT);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_RENEWAL);


    // Kossuth (Deidad mayor)
    nDeity = AddDeity("Kossuth");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "el fuego elemental y la purificación por medio del fuego");
        SetDeityTitleAlternates(nDeity, "el Señor de las Llamas, el Señor del Fuego");
        SetDeityBook(nDeity, "dogmas_kossut");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL,  ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_EVIL);

        // Todas las razas
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DESTRUCTION);
        AddClericDomain(nDeity, DOMAIN_FIRE);
        AddClericDomain(nDeity, DOMAIN_RENEWAL);


    // Laira (Deidad menor)
    nDeity = AddDeity("Laira");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la alegría, la felicidad, el baile, las fiestas, la espontaneidad y la libertad");
        SetDeityTitleAlternates(nDeity, "Nuestra Dama de la Alegría, Portadora de la Alegría, Ama de las Fiestas");
        SetDeityWeapon(nDeity, BASE_ITEM_SHURIKEN);
        SetDeityBook(nDeity, "dogmas_laira");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC,  ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Allowed all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_CHARM);
        AddClericDomain(nDeity, DOMAIN_FAMILY);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);


    // Lathander (Deidad mayor)
    nDeity = AddDeity("Lathander");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la creativdad, la juventud, el nacimiento, la renovacion, el perfeccionamiento personal y el atletismo");
        SetDeityTitleAlternates(nDeity, "el Señor de la Mañana");
        SetDeityBook(nDeity, "dogmas_lathander");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL,  ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);

        // Allow all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_NOBILITY);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_RENEWAL);
        AddClericDomain(nDeity, DOMAIN_STRENGTH);
        AddClericDomain(nDeity, DOMAIN_SUN);


    // Loviatar (Deidad menor)
    nDeity = AddDeity("Loviatar");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_EVIL);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "el dolor, el daño, la agonía, el tormento, el sufrimiento y la tortura");
        SetDeityTitleAlternates(nDeity, " la Doncella del Dolor, el Látigo Servicial");
        SetDeityBook(nDeity, "dogmas_loviatar");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);

        // Allow all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_EVIL);
        AddClericDomain(nDeity, DOMAIN_STRENGTH);


    // Malar (Deidad menor)
    nDeity = AddDeity("Malar");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la sed de sangre, los licántropos malignos, los cazadores, las bestias y monstruos merodeadores, y el acecho");
        SetDeityTitleAlternates(nDeity, "la Bestia, La Pantera de Dientes Negros");
        SetDeityBook(nDeity, "dogmas_malar");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ANIMAL);
        AddClericDomain(nDeity, DOMAIN_EVIL);
        AddClericDomain(nDeity, DOMAIN_STRENGTH);


    // Mascara (Deidad menor)
    nDeity = AddDeity("Mascara");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "las sombras, el latrocinio y los ladrones");
        SetDeityTitleAlternates(nDeity, "Maestro de Todos los Ladrones, Señor de las Sombras");
        SetDeityWeapon(nDeity, BASE_ITEM_LONGSWORD);
        SetDeityBook(nDeity, "dogmas_mascara");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);

        // Allow all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DARKNESS);
        AddClericDomain(nDeity, DOMAIN_EVIL);
        AddClericDomain(nDeity, DOMAIN_LUCK);
        AddClericDomain(nDeity, DOMAIN_TRICKERY);


    // Mielikki (Deidad intermedia)
    nDeity = AddDeity("Mielikki");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "los bosques, las criaturas de los bosques, los exploradores, las driadas y el otoño");
        SetDeityTitleAlternates(nDeity, "Nuestra Señora del Bosque, la Reina del Bosque");
        SetDeityWeapon(nDeity, BASE_ITEM_SCIMITAR);
        SetDeityBook(nDeity, "dogmas_mielikki");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL,  ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);

        // Allow all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ANIMAL);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PLANT);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);


    // Mystra (Deidad mayor)
    nDeity = AddDeity("Mystra");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "la magia, los conjuros y la Urdimbre");
        SetDeityTitleAlternates(nDeity, "la Dama de los Misterios, la Madre de toda la Magia");
        SetDeityWeapon(nDeity, BASE_ITEM_SHURIKEN);
        SetDeityBook(nDeity, "dogmas_mystra");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);

        // Allow all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_KNOWLEDGE);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_ILLUSION);
        AddClericDomain(nDeity, DOMAIN_MAGIC);
        AddClericDomain(nDeity, DOMAIN_RUNE);
        AddClericDomain(nDeity, DOMAIN_SPELLS);


    // Oghma (Deidad mayor)
    nDeity = AddDeity("Oghma");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "los bardos, la inspiración, la invención y el saber");
        SetDeityTitleAlternates(nDeity, "el Señor del Saber, el que Ata Todo lo Conocido");
        SetDeityWeapon(nDeity, BASE_ITEM_LONGSWORD);
        SetDeityBook(nDeity, "dogmas_oghma");

        // Todos los alineamientos.

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_KNOWLEDGE);
        AddClericDomain(nDeity, DOMAIN_SPELLS);
        AddClericDomain(nDeity, DOMAIN_TRICKERY);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);


    // Perdicion (Deidad mayor)
    nDeity = AddDeity("Perdicion");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_EVIL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "los conflictos, el odio, la tiranía y el miedo");
        SetDeityTitleAlternates(nDeity, "el Señor Negro, la Mano Negra, el Señor de la Oscuridad");
        SetDeityBook(nDeity, "dogmas_perdicion");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);

        // Allow all races.
        // AddClericRace(nDeity, RACIAL_TYPE_);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DESTRUCTION);
        AddClericDomain(nDeity, DOMAIN_EVIL);
        AddClericDomain(nDeity, DOMAIN_TYRANNY);
        AddClericDomain(nDeity, DOMAIN_HATRED);


    // Selune (Deidad intermedia)
    nDeity = AddDeity("Selune");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "la luna, las estrellas, la navegación, los navegantes, los trotamundos, las profecías, la gente en misión divina y los licántropos buenos y neutrales");
        SetDeityTitleAlternates(nDeity, "Nuestra Señora de Plata, la Doncella Luna");
        SetDeityBook(nDeity, "dogmas_selune");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);


    // Shar (Deidad mayor)
    nDeity = AddDeity("Shar");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "la oscuridad, la noche, la perdida, el olvido, los secretos, las cavernas, los calabozos y la Infraoscuridad");
        SetDeityTitleAlternates(nDeity, "la Dueña de la Noche, Señora de la Perdida, Diosa Oscura");
        SetDeityBook(nDeity, "dogmas_shar");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_EVIL);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_EVIL);
        AddClericDomain(nDeity, DOMAIN_DARKNESS);
        AddClericDomain(nDeity, DOMAIN_KNOWLEDGE);


    // Shondakul (Deidad menor)
    nDeity = AddDeity("Shondakul");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "el viaje, la exploración, los portales, los mineros y caravanas");
        SetDeityTitleAlternates(nDeity, "el Jinete de los Vientos, la Mano que Ayuda");
        SetDeityWeapon(nDeity, BASE_ITEM_GREATSWORD);
        SetDeityBook(nDeity, "dogmas_shondakul");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_AIR);
        AddClericDomain(nDeity, DOMAIN_PORTAL);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);


    // Silvanus (Deidad mayor)
    nDeity = AddDeity("Silvanus");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la naturaleza salvaje y druidas");
        SetDeityTitleAlternates(nDeity, "el Padre Roble, Padre del Bosque, Padre árbol");
        SetDeityBook(nDeity, "dogmas_silvanus");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ANIMAL);
        AddClericDomain(nDeity, DOMAIN_PORTAL);
        AddClericDomain(nDeity, DOMAIN_PLANT);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_RENEWAL);


    // Sune (Deidad mayor)
    nDeity = AddDeity("Sune");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "la belleza, el amor y la pasión");
        SetDeityTitleAlternates(nDeity, "Cabello de Fuego, Dama del Cabello de Fuego");
        SetDeityWeapon(nDeity, BASE_ITEM_WHIP);
        SetDeityBook(nDeity, "dogmas_sune");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_CHARM);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);


    // Talona (Deidad menor)
    nDeity = AddDeity("Talona");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "la enfermedad y el veneno");
        SetDeityTitleAlternates(nDeity, "la Dama del Veneno, el Ama de la Enfermedad, la Madre de Todas las Plagas");
        SetDeityBook(nDeity, "dogmas_talona");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DESTRUCTION);
        AddClericDomain(nDeity, DOMAIN_EVIL);


    // Talos (Deidad mayor)
    nDeity = AddDeity("Talos");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "las tormentas, la destrucción, la rebelión, las conflagraciones, los terremotos y los remolinos");
        SetDeityTitleAlternates(nDeity, "el Destructor, el Señor de la Tormenta");
        SetDeityWeapon(nDeity, BASE_ITEM_SHORTSPEAR);
        SetDeityBook(nDeity, "dogmas_talos");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DESTRUCTION);
        AddClericDomain(nDeity, DOMAIN_EVIL);
        AddClericDomain(nDeity, DOMAIN_FIRE);
        AddClericDomain(nDeity, DOMAIN_STORM);


    // Tempus (Deidad mayor)
    nDeity = AddDeity("Tempus");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la guerra, la batalla y los combatientes");
        SetDeityTitleAlternates(nDeity, "el Señor de la Batalla, Martillo de Enemigos");
        SetDeityWeapon(nDeity, BASE_ITEM_BATTLEAXE);
        SetDeityBook(nDeity, "dogmas_tempus");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_STRENGTH);
        AddClericDomain(nDeity, DOMAIN_WAR);


    // Torm (Deidad menor)
    nDeity = AddDeity("Torm");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "el deber, la lealtad, la obediencia y los paladines");
        SetDeityTitleAlternates(nDeity, "el Leal, la Deidad Leal, la Furia Leal");
        SetDeityWeapon(nDeity, BASE_ITEM_GREATSWORD);
        SetDeityBook(nDeity, "dogmas_torm");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_HEALING);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_STRENGTH);


    // Tymora (Deidad intermedia)
    nDeity = AddDeity("Tymora");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "la buena fortuna, la habilidad, la victoria y los aventureros");
        SetDeityTitleAlternates(nDeity, "la Dama de la Fortuna, la Dama Sonriente, Nuestra Dama Sonriente");
        SetDeityWeapon(nDeity, BASE_ITEM_SHURIKEN);
        SetDeityBook(nDeity, "dogmas_tymora");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);


    // Tyr (Deidad mayor)
    nDeity = AddDeity("Tyr");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la justicia");
        SetDeityTitleAlternates(nDeity, "el Dios Justo, el Dios Manco, el Equilibrado");
        SetDeityWeapon(nDeity, BASE_ITEM_LONGSWORD);
        SetDeityBook(nDeity, "dogmas_tyr");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_KNOWLEDGE);
        AddClericDomain(nDeity, DOMAIN_RETRIBUTION);
        AddClericDomain(nDeity, DOMAIN_WAR);


    // Umberlee (Deidad intermedia)
    nDeity = AddDeity("Umberlee");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "los oceanos, las corrientes, las olas y los vientos marinos");
        SetDeityTitleAlternates(nDeity, "la Reina Perra, Reina de las Profundidades");
        SetDeityBook(nDeity, "dogmas_umberli");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DESTRUCTION);
        AddClericDomain(nDeity, DOMAIN_EVIL);
        AddClericDomain(nDeity, DOMAIN_OCEAN);
        AddClericDomain(nDeity, DOMAIN_STORM);
        AddClericDomain(nDeity, DOMAIN_WATER);

    // Waukeen (Deidad menor)
    nDeity = AddDeity("Waukeen");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "el comercio, la moneda y las riquezas");
        SetDeityTitleAlternates(nDeity, "la Amiga del Mercader");
        SetDeityBook(nDeity, "dogmas_mystra");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_KNOWLEDGE);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);


    // Wee Jas (Semidiosa)
    nDeity = AddDeity("Wee Jas");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "la muerte y la magia de muerte");
        SetDeityTitleAlternates(nDeity, "la Reina Bruja, la Hechicera Rubi, Guardiana de la Muerte");
        SetDeityWeapon(nDeity, BASE_ITEM_DAGGER);
        SetDeityBook(nDeity, "dogmas_weejas");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_EVIL);
	  AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);

        // Todas las razas

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DEATH);
        AddClericDomain(nDeity, DOMAIN_MAGIC);
        AddClericDomain(nDeity, DOMAIN_EVIL);
        AddClericDomain(nDeity, DOMAIN_UNDEATH);


    // Yelmo (Deidad intermedia)
    nDeity = AddDeity("Yelmo");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "los guardianes y los protectores");
        SetDeityTitleAlternates(nDeity, "el Observador, el Uno Vigilante");
        SetDeityBook(nDeity, "dogmas_yelmo");

        // Allowed alignments.
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_EVIL);
        SetDeityWeapon(nDeity, BASE_ITEM_BASTARDSWORD);

        // Todas las razas
        // AddClericRace(nDeity, RACIAL_TYPE);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_STRENGTH);



    // PANTEON ELFICO

    // Anghárradh (Deidad mayor)
    nDeity = AddDeity("Angharradh");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "la primavera, la fertilidad, la siembra, el nacimiento, la defensa y la sabiduría");
        SetDeityTitleAlternates(nDeity, "la Diosa Trina. Reina de Arvandor");
        SetDeityWeapon(nDeity, BASE_ITEM_SHORTSPEAR);
        SetDeityBook(nDeity, "dogmas_angharrad");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_ELF);
        AddClericRace(nDeity, RACIAL_TYPE_HALFELF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ELF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_KNOWLEDGE);
        AddClericDomain(nDeity, DOMAIN_PLANT);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_RENEWAL);


    // Corellon Larethian (Deidad mayor)
    nDeity = AddDeity("Corellon Larethian");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, " los elfos, la magia, la música, el arte, la guerra, las poesías, los bardos y los combatientes");
        SetDeityTitleAlternates(nDeity, "el Creador de los Elfos, Rey de Arvandor");
        SetDeityWeapon(nDeity, BASE_ITEM_LONGSWORD);
        SetDeityBook(nDeity, "dogmas_corellon");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_ELF);
        AddClericRace(nDeity, RACIAL_TYPE_HALFELF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ELF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_MAGIC);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_WAR);


    // Erdrie Fenya (Deidad intermedia)
    nDeity = AddDeity("Erdrie Fenya");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "el aire, el clima, las criaturas aladas, la lluvia, la fertilidad y los avariel");
        SetDeityTitleAlternates(nDeity, "la Madre Alada, Reina de los Avariel");
        SetDeityWeapon(nDeity, BASE_ITEM_QUARTERSTAFF);
        SetDeityBook(nDeity, "dogmas_erdrie");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_ELF);
        AddClericRace(nDeity, RACIAL_TYPE_HALFELF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_AIR);
        AddClericDomain(nDeity, DOMAIN_ANIMAL);
        AddClericDomain(nDeity, DOMAIN_ELF);
        AddClericDomain(nDeity, DOMAIN_GOOD);


    // Erevan Ilesere (Deidad intermedia)
    nDeity = AddDeity("Erevan Ilesere");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "las travesura, el cambio y los picaros");
        SetDeityTitleAlternates(nDeity, "el Camaleón, el Bromista Feerico");
        SetDeityWeapon(nDeity, BASE_ITEM_SHORTSWORD);
        SetDeityBook(nDeity, "dogmas_erevan");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_ELF);
        AddClericRace(nDeity, RACIAL_TYPE_HALFELF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ELF);
        AddClericDomain(nDeity, DOMAIN_TRICKERY);


    // Fenmarel Mestarine (Deidad menor)
    nDeity = AddDeity("Fenmarel Mestarine");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "los elfos agrestes, los proscriptos, los chivos expiatorios y el aislamiento");
        SetDeityTitleAlternates(nDeity, "el Lobo Solitario");
        SetDeityWeapon(nDeity, BASE_ITEM_DAGGER);
        SetDeityBook(nDeity, "dogmas_fenmarel");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_ELF);
        AddClericRace(nDeity, RACIAL_TYPE_HALFELF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ANIMAL);
        AddClericDomain(nDeity, DOMAIN_ELF);
        AddClericDomain(nDeity, DOMAIN_PLANT);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);


    // Hanali Celanil (Deidad intermedia)
    nDeity = AddDeity("Hanali Celanil");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "el amor, el romance, la belleza, los encantamientos, el arte y la maestría con objetos mágicos");
        SetDeityTitleAlternates(nDeity, "la Dama del Corazón de Oro, la Rosa Encantadora");
        SetDeityWeapon(nDeity, BASE_ITEM_DAGGER);
        SetDeityBook(nDeity, "dogmas_hanali");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_ELF);
        AddClericRace(nDeity, RACIAL_TYPE_HALFELF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_CHARM);
        AddClericDomain(nDeity, DOMAIN_ELF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_MAGIC);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);


    // Labelas Enoret (Deidad intermedia)
    nDeity = AddDeity("Labelas Enoret");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la longevidad, el tiempo, la historia y los momentos decisivos");
        SetDeityTitleAlternates(nDeity, "el Dador de Vida, el Sabio a la Puesta del Sol");
        SetDeityWeapon(nDeity, BASE_ITEM_QUARTERSTAFF);
        SetDeityBook(nDeity, "dogmas_labelas");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_ELF);
        AddClericRace(nDeity, RACIAL_TYPE_HALFELF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ELF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_KNOWLEDGE);
        AddClericDomain(nDeity, DOMAIN_TIME);


    // Rílifein Ralazhil (Deidad intermedia)
    nDeity = AddDeity("Rílifein Ralazhil");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "los elfos salvajes, el bosque, la naturaleza y los druidas");
        SetDeityTitleAlternates(nDeity, "el Señor de la Hoja");
        SetDeityWeapon(nDeity, BASE_ITEM_QUARTERSTAFF);
        SetDeityBook(nDeity, "dogmas_rillifein");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_ELF);
        AddClericRace(nDeity, RACIAL_TYPE_HALFELF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ELF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PLANT);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);


    // Sashelas (Deidad intermedia)
    nDeity = AddDeity("Sashelas");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "los océanos, los elfos marinos, la creación y el saber");
        SetDeityTitleAlternates(nDeity, "el Señor de las Profundidades");
        SetDeityBook(nDeity, "dogmas_sashelas");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_ELF);
        AddClericRace(nDeity, RACIAL_TYPE_HALFELF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ELF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_KNOWLEDGE);
        AddClericDomain(nDeity, DOMAIN_OCEAN);
        AddClericDomain(nDeity, DOMAIN_WATER);


    // Sehanine Lunarco (Deidad intermedia)
    nDeity = AddDeity("Sehanine Lunarco");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "el misticismo, los sueños, la muerte, los viajes, la trascendencia, la luna, las estrellas y los elfos lunares");
        SetDeityTitleAlternates(nDeity, "la Hija de la Noche, la Señora de los Sueños");
        SetDeityWeapon(nDeity, BASE_ITEM_QUARTERSTAFF);
        SetDeityBook(nDeity, "dogmas_sehanine");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_ELF);
        AddClericRace(nDeity, RACIAL_TYPE_HALFELF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ELF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_ILLUSION);
        AddClericDomain(nDeity, DOMAIN_KNOWLEDGE);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);


    // Solonor Zhelandira (Deidad intermedia)
    nDeity = AddDeity("Solonor Zhelandira");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "el tiro con arco, la caza y la supervivencia");
        SetDeityTitleAlternates(nDeity, "el Ojo Agudo, el Gran Arquero");
        SetDeityWeapon(nDeity, BASE_ITEM_LONGBOW);
        SetDeityBook(nDeity, "dogmas_solonor");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_ELF);
        AddClericRace(nDeity, RACIAL_TYPE_HALFELF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ELF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PLANT);
        AddClericDomain(nDeity, DOMAIN_WAR);


    // PANTEON ENANO

    // Abbathor (Deidad intermedia)
    nDeity = AddDeity("Abbathor");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la codicia");
        SetDeityTitleAlternates(nDeity, "el Gran Maestro de la Codicia, Señor de la Trova, el Avaro, Gusano de la Avaricia");
        SetDeityWeapon(nDeity, BASE_ITEM_DAGGER);
        SetDeityBook(nDeity, "dogmas_abbathor");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_EVIL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_DWARF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ELF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PLANT);
        AddClericDomain(nDeity, DOMAIN_WAR);


    // Berronar Argentica (Deidad intermedia)
    nDeity = AddDeity("Berronar Argentica");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "la seguridad, la honestidad, el hogar, la curacion, la familia enana, la constancia escrita, el matrimonio, la fidelidad, la lealtad y los juramentos");
        SetDeityTitleAlternates(nDeity, "la Reverenda Madre, la Madre de la Seguridad");
        SetDeityWeapon(nDeity, BASE_ITEM_DIREMACE);
        SetDeityBook(nDeity, "dogmas_berronar");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_DWARF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DWARF);
        AddClericDomain(nDeity, DOMAIN_FAMILY);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_HEALING);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);


    // Clangeddni Bargenta (Deidad intermedia)
    nDeity = AddDeity("Clangeddin Bargenta");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la batalla, la guerra, el valor, la valentia y el honor en la batalla");
        SetDeityTitleAlternates(nDeity, "el Padre de la Batalla, el Señor de las Hachas Gemelas, la Roca de la Batalla");
        SetDeityWeapon(nDeity, BASE_ITEM_BATTLEAXE);
        SetDeityBook(nDeity, "dogmas_clangeddi");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_DWARF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DWARF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_STRENGTH);
        AddClericDomain(nDeity, DOMAIN_WAR);


    // Dugmaren del Manto Brillante (Deidad intermedia)
    nDeity = AddDeity("Dugmaren del Manto Brillante");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la erudicion, la invencion y el descrubrimiento");
        SetDeityTitleAlternates(nDeity, "el Brillo en el Ojo, el Descubridor Errante");
        SetDeityWeapon(nDeity, BASE_ITEM_SHORTSWORD);
        SetDeityBook(nDeity, "dogmas_dugmaren");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_DWARF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DWARF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_KNOWLEDGE);
        AddClericDomain(nDeity, DOMAIN_RUNE);


    // Dumathoin (Deidad intermedia)
    nDeity = AddDeity("Dumathoin");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la riqueza enterrada, las menas, las gemas, la mineria, la exploraciion, los enanos escudo y el guardian de los muertos");
        SetDeityTitleAlternates(nDeity, "el Guardian de los Secretos bajo la Montaña, el Guardian Silencioso");
        SetDeityBook(nDeity, "dogmas_dumathoin");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_DWARF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DWARF);
        AddClericDomain(nDeity, DOMAIN_EARTH);
        AddClericDomain(nDeity, DOMAIN_KNOWLEDGE);
        AddClericDomain(nDeity, DOMAIN_METAL);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);


    // Gorm Gultun (Deidad intermedia)
    nDeity = AddDeity("Gorm Gultun");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la defensa, guardian de todos los enanos y la vigilancia");
        SetDeityTitleAlternates(nDeity, "Ojos de Fuego, Señor de la Mascara de Bronce, el Eternamente Vigilante");
        SetDeityWeapon(nDeity, BASE_ITEM_BATTLEAXE);
        SetDeityBook(nDeity, "dogmas_gorm");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_DWARF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DWARF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_WAR);


    // Marthammor Duin (Deidad menor)
    nDeity = AddDeity("Marthammor Duin");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "los guias, los exploradores, los expatriados, los viajeros y el relampago");
        SetDeityTitleAlternates(nDeity, "el Descubridor de Caminos, el Vigilante de los Trotamundos, el Ojo Vigilante");
        SetDeityWeapon(nDeity, BASE_ITEM_DIREMACE);
        SetDeityBook(nDeity, "dogmas_marthammo");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_DWARF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DWARF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);


    // Moradin (Deidad mayor)
    nDeity = AddDeity("Moradin");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "los enanos, la creacion, la herreria, la proteccion, la metalisteria y la canteria");
        SetDeityTitleAlternates(nDeity, "el Forjador de Almas, el Padre de los Enanos, el Padre de Todos");
        SetDeityWeapon(nDeity, BASE_ITEM_WARHAMMER);
        SetDeityBook(nDeity, "dogmas_moradin");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_DWARF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DWARF);
        AddClericDomain(nDeity, DOMAIN_EARTH);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);


    // Sharindlar (Deidad intermedia)
    nDeity = AddDeity("Sharindlar");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "la curacion, la misericordia, el amor romantico, la felicidad, el baile, el noviazgo y la luna");
        SetDeityTitleAlternates(nDeity, "la Dama de la Vida y la Clemencia, la Bailarina Reluciente");
        SetDeityWeapon(nDeity, BASE_ITEM_WHIP);
        SetDeityBook(nDeity, "dogmas_sharindla");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_DWARF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_CHARM);
        AddClericDomain(nDeity, DOMAIN_DWARF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_HEALING);


    // Vergadain (Deidad intermedia)
    nDeity = AddDeity("Vergadain");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la riqueza, la suerte, el azar, los ladrones no malignos, la suspicacia, la supercheria, la negociacion y el ingenio ladino");
        SetDeityTitleAlternates(nDeity, "el Rey Mercader, el Padre Costo, el Enano que Rie");
        SetDeityWeapon(nDeity, BASE_ITEM_LONGSWORD);
        SetDeityBook(nDeity, "dogmas_vergadain");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_DWARF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_DWARF);
        AddClericDomain(nDeity, DOMAIN_LUCK);
        AddClericDomain(nDeity, DOMAIN_TRICKERY);


    // Thard Harr (Deidad menor)
    nDeity = AddDeity("Thard Harr");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "los druidas, los habitantes de las junglas, los exploradores, los enanos y los salvajes");
        SetDeityTitleAlternates(nDeity, "el Senor de las Profundidades de la Jungla");
        SetDeityBook(nDeity, "dogmas_thard");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_DWARF);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ANIMAL);
        AddClericDomain(nDeity, DOMAIN_DWARF);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PLANT);


    // PANTEON GNOMO

    // Baravar capa de sombra (Deidad menor)
    nDeity = AddDeity("Baravar capa de sombra");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "las ilusiones, los enganos, la trampa y las custodias");
        SetDeityTitleAlternates(nDeity, "el Astuto, el Amo de la Ilusion, el Senor Disfrazado");
        SetDeityWeapon(nDeity, BASE_ITEM_DAGGER);
        SetDeityBook(nDeity, "dogmas_baravar");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_GNOME);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_GNOME);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_ILLUSION);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_TRICKERY);


    // Bervan el viajero indomito (Deidad menor)
    nDeity = AddDeity("Bervan");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "el viaje, la naturaleza y los gnomos del bosque");
        SetDeityTitleAlternates(nDeity, "el Viajero Indomito, la Hoja Enmascarada");
        SetDeityWeapon(nDeity, BASE_ITEM_SHORTSPEAR);
        SetDeityBook(nDeity, "dogmas_bervan");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_GNOME);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_ANIMAL);
        AddClericDomain(nDeity, DOMAIN_GNOME);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PLANT);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);


    // Flandal de la piel de acero (Deidad intermedia)
    nDeity = AddDeity("Flandal de la Piel de Acero");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la mineria, la buena forma fisica, la herreria y la metalisteria");
        SetDeityTitleAlternates(nDeity, "el Amo del Metal, el Gran Forjador de Acero");
        SetDeityWeapon(nDeity, BASE_ITEM_WARHAMMER);
        SetDeityBook(nDeity, "dogmas_flandal");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_GNOME);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_GNOME);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_METAL);


    // Garl del Oro Luminoso (deidad mayor)
    nDeity = AddDeity("Garl del Oro Luminoso");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la proteccion, el humor, la supercheria, la talla de gemas y los gnomos");
        SetDeityTitleAlternates(nDeity, "el Bromista, el Protector Vigilante, el Ingenio Chispeante");
        SetDeityWeapon(nDeity, BASE_ITEM_BATTLEAXE);
        SetDeityBook(nDeity, "dogmas_garl");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_GNOME);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_GNOME);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_TRICKERY);


    // Guerdal Mano de Hierro (deidad menor)
    nDeity = AddDeity("Guerdal Mano de Hierro");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la vigilancia, el combate y la defensa marcial");
        SetDeityTitleAlternates(nDeity, "el Severo, el Escudo de las Colinas Doradas");
        SetDeityWeapon(nDeity, BASE_ITEM_WARHAMMER);
        SetDeityBook(nDeity, "dogmas_guerdal");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_GNOME);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_GNOME);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_WAR);


    // Segoyan Clamaterra (deidad menor)
    nDeity = AddDeity("Segoyan Clamaterra");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la tierra, la naturaleza y los muertos");
        SetDeityTitleAlternates(nDeity, "el Amigo de la Tierra, el Senor de las Madrigueras");
        SetDeityWeapon(nDeity, BASE_ITEM_DIREMACE);
        SetDeityBook(nDeity, "dogmas_segoyan");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_GNOME);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_EARTH);
        AddClericDomain(nDeity, DOMAIN_GNOME);
        AddClericDomain(nDeity, DOMAIN_GOOD);


    // Urdlen (deidad intermedia)
    nDeity = AddDeity("Urdlen");
        SetDeityAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la codicia, la sed de sangre, el mal, el odio, el impulso incontrolado y los spriggan");
        SetDeityTitleAlternates(nDeity, "el Reptador Bajo el Mundo");
        SetDeityBook(nDeity, "dogmas_urdlen");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_GNOME);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_EARTH);
        AddClericDomain(nDeity, DOMAIN_EVIL);
        AddClericDomain(nDeity, DOMAIN_GNOME);
        AddClericDomain(nDeity, DOMAIN_HATRED);


    // PANTEON MEDIANO

    // Arvoreen (deidad intermedia)
    nDeity = AddDeity("Arvoreen");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la defensa, la guerra, la vigilancia, los medianos, los combatientes y el deber");
        SetDeityTitleAlternates(nDeity, "el Defensor, la Espada Precavida");
        SetDeityWeapon(nDeity, BASE_ITEM_SHORTSWORD);
        SetDeityBook(nDeity, "dogmas_arvorin");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_HALFLING);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_HALFLING);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);
        AddClericDomain(nDeity, DOMAIN_WAR);


    // Brandobaris (deidad menor)
    nDeity = AddDeity("Brandovaris");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "el sigilo, el latrocinio, la aventura, los picaros y los medianos");
        SetDeityTitleAlternates(nDeity, "el Maestro del Sigilo, el Granuja Indomable");
        SetDeityBook(nDeity, "dogmas_brandobar");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_HALFLING);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_HALFLING);
        AddClericDomain(nDeity, DOMAIN_LUCK);
        AddClericDomain(nDeity, DOMAIN_TRAVEL);
        AddClericDomain(nDeity, DOMAIN_TRICKERY);


    // Cyrrolali (deidad intermedia)
    nDeity = AddDeity("Cyrrolali");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "la amistad, la confianza, la chimenea, la hospitalidad y las artesanias");
        SetDeityTitleAlternates(nDeity, "la Mano de la Compania, la Guardiana del Corazon");
        SetDeityBook(nDeity, "dogmas_cyrrollal");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_HALFLING);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_FAMILY);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_HALFLING);


    // Shila Peryroyl (deidad intermedia)
    nDeity = AddDeity("Shila Peryroyl");
        SetDeityAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        SetDeityGender(nDeity, GENDER_MALE);
        SetDeityPortfolio(nDeity, "la naturaleza, la agricultura, el clima, la cancion, el baile, la belleza y el amor romantico");
        SetDeityTitleAlternates(nDeity, "la Hermana Verde, la Madre Vigilante");
        SetDeityBook(nDeity, "dogmas_shila");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_HALFLING);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_AIR);
        AddClericDomain(nDeity, DOMAIN_CHARM);
        AddClericDomain(nDeity, DOMAIN_HALFLING);
        AddClericDomain(nDeity, DOMAIN_PLANT);


    // Yondala (deidad intermedia)
    nDeity = AddDeity("Yondala");
        SetDeityAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);
        SetDeityGender(nDeity, GENDER_FEMALE);
        SetDeityPortfolio(nDeity, "la proteccion, la generosidad, los medianos, los ninos, la seguridad, el liderazgo, la sabiduria, la creacion, la familia y la tradicion");
        SetDeityTitleAlternates(nDeity, "la Protectora y Benefactora, la Matriarca Dedicada, la Bendita");
        SetDeityBook(nDeity, "dogmas_yondala");

        // Alineamientos
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
        AddClericAlignment(nDeity, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
        AddClericAlignment(nDeity, ALIGNMENT_LAWFUL, ALIGNMENT_GOOD);

        // Razas
        AddClericRace(nDeity, RACIAL_TYPE_HALFLING);

        // Domain choices.
        AddClericDomain(nDeity, DOMAIN_FAMILY);
        AddClericDomain(nDeity, DOMAIN_GOOD);
        AddClericDomain(nDeity, DOMAIN_HALFLING);
        AddClericDomain(nDeity, DOMAIN_PROTECTION);

}

