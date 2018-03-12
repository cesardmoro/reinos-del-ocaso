const int MK_CREATURE_PART_NEXT = 1;
const int MK_CREATURE_PART_PREV = 2;

// ----------------------------------------------------------------------------
// Sets the body part model to be used on the creature specified to the
// next or previous part model.
// Returns the new part model.
// - nPart (CREATURE_PART_*)
//      CREATURE_PART_RIGHT_FOOT
//      CREATURE_PART_LEFT_FOOT
//      CREATURE_PART_RIGHT_SHIN
//      CREATURE_PART_LEFT_SHIN
//      CREATURE_PART_RIGHT_THIGH
//      CREATURE_PART_LEFT_THIGH
//      CREATURE_PART_PELVIS
//      CREATURE_PART_TORSO
//      CREATURE_PART_BELT
//      CREATURE_PART_NECK
//      CREATURE_PART_RIGHT_FOREARM
//      CREATURE_PART_LEFT_FOREARM
//      CREATURE_PART_RIGHT_BICEP
//      CREATURE_PART_LEFT_BICEP
//      CREATURE_PART_RIGHT_SHOULDER
//      CREATURE_PART_LEFT_SHOULDER
//      CREATURE_PART_RIGHT_HAND
//      CREATURE_PART_LEFT_HAND
//      CREATURE_PART_HEAD
// - nMode
//      MK_CREATURE_PART_NEXT: next model part
//      MK_CREATURE_PART_PREV: previous model part
// - oCreature
//      Creature whose body is to changed.
// ----------------------------------------------------------------------------
int MK_SetCreatureBodyPart(int nPart, int nMode, object oCreature=OBJECT_SELF);

// ----------------------------------------------------------------------------
// Sets the body part to be modified.
// ----------------------------------------------------------------------------
void MK_SetCurrentBodyPart(object oCreature, int nPart);

// ----------------------------------------------------------------------------
// Gets the body part to be modified.
// ----------------------------------------------------------------------------
int MK_GetCurrentBodyPart(object oCreature);

// ----------------------------------------------------------------------------
// Saves the current head of oCreature as a integer on oCreature.
// ----------------------------------------------------------------------------
void MK_SaveHead(object oCreature);

// ----------------------------------------------------------------------------
// Restores a previously saved head.
// ----------------------------------------------------------------------------
void MK_RestoreHead(object oCreature);

// ----------------------------------------------------------------------------
// Saves the current phenotype of oCreature as a integer on oCreature.
// ----------------------------------------------------------------------------
void MK_SavePhenoType(object oCreature);

// ----------------------------------------------------------------------------
// Restores a previously saved phenotype.
// ----------------------------------------------------------------------------
void MK_RestorePhenoType(object oCreature);

// ----------------------------------------------------------------------------
// Sets the phenotype of creature to the next phenotype (if possible).
// The next phenotype is the next phenotype in PhenoType.2da
// ----------------------------------------------------------------------------
void MK_NextPhenoType(object oCreature);

// ----------------------------------------------------------------------------
// Sets the phenotype of creature to the previous phenotype (if possible).
// The previous phenotype is the previous phenotype in PhenoType.2da
// ----------------------------------------------------------------------------
void MK_PrevPhenoType(object oCreature);

// ----------------------------------------------------------------------------
// Saves the current tail of oCreature as a integer on oCreature.
// ----------------------------------------------------------------------------
void MK_SaveTail(object oCreature);

// ----------------------------------------------------------------------------
// Restores a previously saved tail.
// ----------------------------------------------------------------------------
void MK_RestoreTail(object oCreature);

// ----------------------------------------------------------------------------
// Sets the tail of creature to the next tail(if possible).
// The next tail is the next tail in TailModel.2da
// ----------------------------------------------------------------------------
void MK_NextTail(object oCreature);

// ----------------------------------------------------------------------------
// Sets the tail of creature to the previous tail (if possible).
// The previous tail is the previous tail in TailModel.2da
// ----------------------------------------------------------------------------
void MK_PrevTail(object oCreature);

// ----------------------------------------------------------------------------
// Saves the current wings of oCreature as a integer on oCreature.
// ----------------------------------------------------------------------------
void MK_SaveWings(object oCreature);

// ----------------------------------------------------------------------------
// Restores a previously saved wings.
// ----------------------------------------------------------------------------
void MK_RestoreWings(object oCreature);

// ----------------------------------------------------------------------------
// Sets the wings of creature to the next wings(if possible).
// The next wings are the next wings in WingModel.2da
// ----------------------------------------------------------------------------
void MK_NextWings(object oCreature);

// ----------------------------------------------------------------------------
// Sets the wings of creature to the previous wings (if possible).
// The previous wings are the previous wings in TailModel.2da
// ----------------------------------------------------------------------------
void MK_PrevWings(object oCreature);


// ----------------------------------------------------------------------------
// Toggles the tattoo of the selected body part.
// ----------------------------------------------------------------------------
void MK_ToggleTattoo(object oCreature, int nPart);

// ----------------------------------------------------------------------------
// Saves the tattoos of oCreature as a string on oCreature.
// ----------------------------------------------------------------------------
void MK_SaveTattoos(object oCreature);

// ----------------------------------------------------------------------------
// Restores previously saved tattoos.
// ----------------------------------------------------------------------------
void MK_RestoreTattoos(object oCreature);


int MK_SetCreatureBodyPart(int nPart, int nMode, object oCreature)
{
    int nModelNumber = GetCreatureBodyPart(nPart, oCreature);

    switch (nMode)
    {
    case MK_CREATURE_PART_NEXT:
        nModelNumber++;
        break;
    case MK_CREATURE_PART_PREV:
        nModelNumber--;
        break;
    }

    SetCreatureBodyPart(nPart, nModelNumber, oCreature);

    return GetCreatureBodyPart(nPart, oCreature);
}

void MK_SetCurrentBodyPart(object oCreature, int nPart)
{
    SetLocalInt(oCreature, "MK_MODIFY_CURRENT_BODYPART", nPart);
}

int MK_GetCurrentBodyPart(object oCreature)
{
    return GetLocalInt(oCreature, "MK_MODIFY_CURRENT_BODYPART");
}

void MK_ToggleTattoo(object oCreature, int nPart)
{
    int nTattoo = GetCreatureBodyPart(nPart, oCreature);

    switch (nTattoo)
    {
    case CREATURE_MODEL_TYPE_SKIN:
        nTattoo = CREATURE_MODEL_TYPE_TATTOO;
        break;
    case CREATURE_MODEL_TYPE_TATTOO:
        nTattoo = CREATURE_MODEL_TYPE_SKIN;
        break;
    }

    SetCreatureBodyPart(nPart, nTattoo, oCreature);
}

int MK_GetTattooBodyPart(int iTattoo)
{
    int nPart=0;
    switch (iTattoo)
    {
    case 0:
        nPart = CREATURE_PART_TORSO;
        break;
    case 1:
        nPart = CREATURE_PART_LEFT_BICEP;
        break;
    case 2:
        nPart = CREATURE_PART_RIGHT_BICEP;
        break;
    case 3:
        nPart = CREATURE_PART_LEFT_FOREARM;
        break;
    case 4:
        nPart = CREATURE_PART_RIGHT_FOREARM;
        break;
    case 5:
        nPart = CREATURE_PART_LEFT_THIGH;
        break;
    case 6:
        nPart = CREATURE_PART_RIGHT_THIGH;
        break;
    case 7:
        nPart = CREATURE_PART_LEFT_SHIN;
        break;
    case 8:
        nPart = CREATURE_PART_RIGHT_SHIN;
        break;
    }
    return nPart;
}

void MK_SaveTattoos(object oCreature)
{
    int nPart, i;
    string sTattoos = "";
    for (i=0; i<=8; i++)
    {
        nPart = MK_GetTattooBodyPart(i);
        sTattoos+=IntToString(GetCreatureBodyPart(nPart,oCreature));
    }
    SetLocalString(oCreature,"MK_CURRENT_TATTOOS", sTattoos);
//    SendMessageToPC(oCreature, "Aktuelle Tattoos: " + sTattoos);
}

void MK_RestoreTattoos(object oCreature)
{
    int i, nPart, nTattoo;
    string sTattoos = GetLocalString(oCreature, "MK_CURRENT_TATTOOS");

    for (i=0; i<=8; i++)
    {
        nPart = MK_GetTattooBodyPart(i);
        nTattoo = StringToInt(GetSubString(sTattoos,i,1));
        SetCreatureBodyPart(nPart,nTattoo,oCreature);
    }
    DeleteLocalString(oCreature, "MK_CURRENT_TATTOOS");
}

void MK_DoneTattoo(object oCreature)
{
    DeleteLocalString(oCreature, "MK_CURRENT_TATTOOS");
}

void MK_SaveHead(object oCreature)
{
    int nCurrentHead = GetCreatureBodyPart(CREATURE_PART_HEAD, oCreature);
    SetLocalInt(oCreature,"MK_CURRENT_HEAD",nCurrentHead);
}

void MK_RestoreHead(object oCreature)
{
    int nOldHead = GetLocalInt(oCreature,"MK_CURRENT_HEAD");
    SetCreatureBodyPart(CREATURE_PART_HEAD, nOldHead, oCreature);
    DeleteLocalInt(oCreature,"MK_CURRENT_HEAD");
    DeleteLocalInt(oCreature,"MK_MODIFY_CURRENT_BODYPART");
}

void MK_DoneHead(object oCreature)
{
    DeleteLocalInt(oCreature,"MK_CURRENT_HEAD");
    DeleteLocalInt(oCreature,"MK_MODIFY_CURRENT_BODYPART");
}

void MK_SavePhenoType(object oCreature)
{
    int nPhenoType = GetPhenoType(oCreature);
    SetLocalInt(oCreature, "MK_CURRENT_PHENOTYPE", nPhenoType);
}

void MK_DonePhenoType(object oCreature)
{
    DeleteLocalInt(oCreature, "MK_CURRENT_PHENOTYPE");
}

void MK_RestorePhenoType(object oCreature)
{
    int nPhenoType = GetLocalInt(oCreature, "MK_CURRENT_PHENOTYPE");
    SetPhenoType(nPhenoType, oCreature);
    DeleteLocalInt(oCreature, "MK_CURRENT_PHENOTYPE");
}

void MK_SetPhenoType(object oCreature, int nPhenoType)
{
    string sPhenoType = Get2DAString("PhenoType", "Label", nPhenoType);
    if (sPhenoType=="") return;

    SetPhenoType(nPhenoType, oCreature);
}

void MK_NextPhenoType(object oCreature)
{
    int nPhenoType = GetPhenoType(oCreature);
    MK_SetPhenoType(oCreature, nPhenoType+1);
}

void MK_PrevPhenoType(object oCreature)
{
    int nPhenoType = GetPhenoType(oCreature);
    MK_SetPhenoType(oCreature, nPhenoType-1);
}

void MK_SaveTail(object oCreature)
{
    int nTail = GetCreatureTailType(oCreature);
    SetLocalInt(oCreature, "MK_CURRENT_TAIL", nTail);
}

void MK_RestoreTail(object oCreature)
{
    int nTail = GetLocalInt(oCreature, "MK_CURRENT_TAIL");
    SetCreatureTailType(nTail, oCreature);
    DeleteLocalInt(oCreature, "MK_CURRENT_TAIL");
}

void MK_DoneTail(object oCreature)
{
    DeleteLocalInt(oCreature, "MK_CURRENT_TAIL");
}

// Nota por Dragoncin:
// Funcion modificada para que al llegar al final, vuelva al principio y viceversa

void MK_SetTail(object oCreature, int nTail, int nDirection)
{
    string sTail;
    do {
        if (nDirection == MK_CREATURE_PART_NEXT) {
            nTail++;
            if (nTail>255)
                nTail = 1;
        }
        if (nDirection == MK_CREATURE_PART_PREV) {
            nTail--;
            if (nTail<0)
                nTail = 255;
        }
        sTail = Get2DAString("TailModel", "Label", nTail);
    } while (sTail=="");

    SetCreatureTailType(nTail, oCreature);
}

void MK_NextTail(object oCreature)
{
    int nTail = GetCreatureTailType(oCreature);
    MK_SetTail(oCreature, nTail, MK_CREATURE_PART_NEXT);
}

void MK_PrevTail(object oCreature)
{
    int nTail = GetCreatureTailType(oCreature);
    MK_SetTail(oCreature, nTail, MK_CREATURE_PART_PREV);
}

void MK_SaveWings(object oCreature)
{
    int nWings = GetCreatureWingType(oCreature);
    SetLocalInt(oCreature, "MK_CURRENT_WINGS", nWings);
}

void MK_RestoreWings(object oCreature)
{
    int nWings = GetLocalInt(oCreature, "MK_CURRENT_WINGS");
    SetCreatureWingType(nWings, oCreature);
    DeleteLocalInt(oCreature, "MK_CURRENT_WINGS");
}

void MK_DoneWings(object oCreature)
{
    DeleteLocalInt(oCreature, "MK_CURRENT_WINGS");
}

// Nota por Dragoncin:
// Funcion modificada para que al llegar al final, vuelva al principio y viceversa

void MK_SetWings(object oCreature, int nWings, int nDirection)
{
    string sWings;
    do {
        if (nDirection == MK_CREATURE_PART_NEXT) {
            nWings++;
            if (nWings>255)
                nWings = 1;
        }
        if (nDirection == MK_CREATURE_PART_PREV) {
            nWings--;
            if (nWings<0)
                nWings = 255;
        }
        sWings = Get2DAString("WingModel", "Label", nWings);
    } while (sWings=="");

    SetCreatureWingType(nWings, oCreature);
}

void MK_NextWings(object oCreature)
{
    int nWings = GetCreatureWingType(oCreature);
    MK_SetWings(oCreature, nWings, MK_CREATURE_PART_NEXT);
}

void MK_PrevWings(object oCreature)
{
    int nWings = GetCreatureWingType(oCreature);
    MK_SetWings(oCreature, nWings, MK_CREATURE_PART_PREV);
}

/*
void MK_TogglePhenoType(object oCreature)
{
    int nPhenoType = GetPhenoType(oCreature);
    switch (nPhenoType)
    {
    case PHENOTYPE_NORMAL:
        nPhenoType = PHENOTYPE_BIG;
        break;
    case PHENOTYPE_BIG:
        nPhenoType = PHENOTYPE_NORMAL;
        break;
    }
    SetPhenoType(nPhenoType, oCreature);
}
*/
/*
void main()
{

}
/**/
