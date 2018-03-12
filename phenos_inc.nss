/////////////////////////////////////
// 01/06/07 Script By Dragoncin
//
// Control de Fenotipos y Colas
//////////////////////////

const int PHENOTYPE_FLY_CEP         = 16;
const int PHENOTYPE_FLY_RDO         = 15;
const int PHENOTPYE_FLY_CEP_FAT     = 26;
const int PHENOTYPE_FLY_RDO_FAT     = 25;

const string PhenoTypes_DATABASE                = "pheno";
const string PhenoTypes_DB_PHENOTYPE_IS_SAVED   = "PhenoTypes_IS_SAVED";
const string PhenoTypes_DB_NATURAL_PHENOTYPE    = "PhenoTypes_NATURAL_PHENOTYPE";

// Devuelve el fenotipo original del PJ
int GetNaturalPhenoType( object oPC );
int GetNaturalPhenoType( object oPC )
{
    return GetCampaignInt(PhenoTypes_DATABASE, PhenoTypes_DB_NATURAL_PHENOTYPE, oPC );
}

// Devuelve el PJ a su fenotipo natural
void ReturnToNaturalPhenoType( object oPC );
void ReturnToNaturalPhenoType( object oPC )
{
    // Funcion hecha principalmente para facilitar la lectura de los scripts
    SetPhenoType(GetNaturalPhenoType(oPC), oPC);
}

// setea el fenotipo de oPC y lo guarda en la base de datos
void SetNaturalPhenoType( int nPhenoType, object oPC = OBJECT_SELF );
void SetNaturalPhenoType( int nPhenoType, object oPC = OBJECT_SELF )
{
    SetPhenoType(nPhenoType, oPC);
    SetCampaignInt(PhenoTypes_DATABASE, PhenoTypes_DB_NATURAL_PHENOTYPE, nPhenoType, oPC);
}

// Control de fenotipos
void PhenoTypes_onEnter( object oPC );
void PhenoTypes_onEnter( object oPC )
{
    int hasSavedPhenoType = GetCampaignInt(PhenoTypes_DATABASE, PhenoTypes_DB_PHENOTYPE_IS_SAVED);
    if (!hasSavedPhenoType) {

        SetCampaignInt(PhenoTypes_DATABASE, PhenoTypes_DB_NATURAL_PHENOTYPE, GetPhenoType(oPC));
        SetCampaignInt(PhenoTypes_DATABASE, PhenoTypes_DB_PHENOTYPE_IS_SAVED, TRUE);

    }
}



const string Tails_DATABASE           = "tails";
const string Tails_DB_TAIL_IS_SAVED   = "Tails_IS_SAVED";
const string Tails_DB_NATURAL_TAIL    = "Tails_NATURAL_PHENOTYPE";

// Devuelve el fenotipo original del PJ
int GetNaturalTail( object oPC );
int GetNaturalTail( object oPC )
{
    return GetCampaignInt(Tails_DATABASE, Tails_DB_NATURAL_TAIL, oPC );
}

void ReturnToNaturalTail( object oPC );
void ReturnToNaturalTail( object oPC )
{
    // Funcion hecha principalmente para facilitar la lectura de los scripts
    SetCreatureTailType(GetNaturalTail(oPC), oPC);
}

// setea la cola de oPC y la guarda en la base de datos
void SetNaturalTail( int nTailType, object oPC = OBJECT_SELF );
void SetNaturalTail( int nTailType, object oPC = OBJECT_SELF )
{
    SetCreatureTailType(nTailType, oPC);
    SetCampaignInt(Tails_DATABASE, Tails_DB_NATURAL_TAIL, nTailType, oPC);
}

// Control de fenotipos
void Tails_onEnter( object oPC );
void Tails_onEnter( object oPC )
{
    int hasSavedTail = GetCampaignInt(Tails_DATABASE, Tails_DB_TAIL_IS_SAVED);
    if (!hasSavedTail) {

        SetCampaignInt(Tails_DATABASE, Tails_DB_NATURAL_TAIL, GetCreatureTailType(oPC));
        SetCampaignInt(Tails_DATABASE, Tails_DB_TAIL_IS_SAVED, TRUE);

    }
}


const string Wings_DATABASE           = "pheno"; //para no crear oootra base de datos
const string Wings_DB_WINGS_ARE_SAVED = "Wings_ARE_SAVED";
const string Wings_DB_NATURAL_WINGS   = "Wings_NATURAL_WINGS";

// Devuelve el fenotipo original del PJ
int GetNaturalWings( object oPC );
int GetNaturalWings( object oPC )
{
    return GetCampaignInt(Wings_DATABASE, Wings_DB_NATURAL_WINGS, oPC );
}

void ReturnToNaturalWings( object oPC );
void ReturnToNaturalWings( object oPC )
{
    // Funcion hecha principalmente para facilitar la lectura de los scripts
    SetCreatureWingType(GetNaturalTail(oPC), oPC);
}

// setea la cola de oPC y la guarda en la base de datos
void SetNaturalWings( int nWingType, object oPC = OBJECT_SELF );
void SetNaturalWings( int nWingType, object oPC = OBJECT_SELF )
{
    SetCreatureWingType(nWingType, oPC);
    SetCampaignInt(Wings_DATABASE, Wings_DB_NATURAL_WINGS, nWingType, oPC);
}

// Control de fenotipos
void Wings_onEnter( object oPC );
void Wings_onEnter( object oPC )
{
    int hasSavedWing = GetCampaignInt(Wings_DATABASE, Wings_DB_WINGS_ARE_SAVED);
    if (!hasSavedWing) {

        SetCampaignInt(Wings_DATABASE, Wings_DB_NATURAL_WINGS, GetCreatureWingType(oPC));
        SetCampaignInt(Wings_DATABASE, Wings_DB_WINGS_ARE_SAVED, TRUE);

    }
}
