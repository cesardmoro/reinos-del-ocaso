//::///////////////////////////////////////////////
//:: Name: Ajustando la silla de montar.
//:: FileName: eid_gsc_ensillar
//:: Copyright (c) 2005 ES] EIDOLOM
//:://////////////////////////////////////////////
/*
    Si se cumplen las condiciones, salta la frase del dialogo a la que este
    script este asignada.
*/
//::
//:: Ñ ñ Ú É í Ó Á ¿ ¡ ú é í ó á
//::
//:://////////////////////////////////////////////
//:: Created By: Deeme
//:: Created On: 26/06/2005
//:: Modified On: 02/07/2005
//:://////////////////////////////////////////////

string sTagMontura = GetTag(OBJECT_SELF);

int StartingConditional()
{
    if(GetStringLeft(sTagMontura, 11) == "gsc_cavallo"){
        if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_HUMAN){
            return TRUE;
        }
        if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_ELF){
            return TRUE;
        }
        if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_HALFELF){
            return TRUE;
        }
        if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_HALFORC){
            return TRUE;
        }
    }

    if(GetStringLeft(sTagMontura, 8) == "gsc_pony"){
        if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_DWARF){
            return TRUE;
        }
        if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_GNOME){
            return TRUE;
        }
        if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_HALFLING){
            return TRUE;
        }
    }

    return FALSE;
}

