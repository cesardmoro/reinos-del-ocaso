//::///////////////////////////////////////////////
//:: Name: Include de MonturasDeeme
//:: FileName: eid_gsc_include
//:: Copyright (c) 2005 ES] EIDOLOM
//:://////////////////////////////////////////////
/*
    Traduccion, ordenacion y adaptacion del original.
    Se anulan la convocacion original (linea 254 y siguientes).
    Aplicados DelayCommand a lineas 194, 195 y 196.
*/
//::
//:: Ñ ñ Ú É í Ó Á ¿ ¡ ú é í ó á
//::
//:://////////////////////////////////////////////
//:: Modified By: Deeme
//:: Modified On: 02/07/2005
//:://////////////////////////////////////////////


//::///////////////////////////////////////////////
//:: Name Gilean Sistema Cavalli
//:: FileName  gsc_include
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*     Sistema persistente di cavalli
       Creato per il pw Ardemor
*/
//:://////////////////////////////////////////////
//:: Created By:   Gilean
//:: Created On:   04.03.05
//:://////////////////////////////////////////////


const int SKILL_CAVALCARE = 27;
const int CD_CAVALCARE=24; //Tiro da effettuare per superare il disarcionamento
int nRiga2daCavalloUmano=5;//Fenotipo umano magro cavallo 1
int nRiga2daCavalloElfo=6;//Fenotipo umano magro cavallo 2
int nRiga2daCavalloNano=7;//Fenotipo umano grasso cavallo 1
int nRiga2daCavalloGnomo=8;//Fenotipo umano grasso cavallo 2
/*int nRiga2daCavalloKender=2184;//Riga del 2da corrispondente al cavaliere gnomo
int nRiga2daCavalloOrco=2185;//Riga del 2da corrispondente al cavaliere mezz'orco
*/
//Questa funzione ritorna il numero di 2da correlato alla razza che cavalca
int GSC_AssegnaCavalloARazza(object oPC);
//Questa funzione fa montare (o smontare) a cavallo oPC umano;
void GSC_SellaPG(object oPC,object oCavallo);
//Questa funzione controlla che oPCnon abbia gia' un cavallo
//evocato
void GSC_CreaCavallooPonyInStalla(object oPC,string sTagCavallo);
//Da porre nell'evento on activated item del modulo
void GSC_AttivaSella();
//Questa funzione risetta l'apparenza normale del cavallo e del pg
//la puoi porre in on client enter per far ritornare
//Cavallo e cavaliere separati
int GSC_SmontaDaCavallo(object oPC);
//Da porre in on client enter del modulo, fa tornare il PG
//con le fattezze normali
void GSC_OnClientEnter(object oPC);
//Ritorna TRUE se oCavallo e' il cavallo di oPC
int GSC_GetMasterOfHorse(object oPC,object oCavallo);
// Questa funzione posta in onCombatRoundEnd del mob
//Fa il check su disarcionare
void GSC_CheckDisarcionare(object oMob);
//La funzione da porre in on death del modulo
//Fa smontare il pg dalla sella e distrugge cavallo e cintura
void GSC_OnPGDeath(object oPC);
//LA funzione ritorna TRUE se oPC sta cavalcando una cavalcatura.
int GSC_IsPGRidingHorse(object oPC);
//Questa funzione posta nell'evento OnEquipItem del modulo
//fa si che oPC non equipaggi oggetti proibiti mentre cavalce
void GSC_OnEquipItem(object oPC,object ItemEquipped);



///////////////////////////////////////////////
int GSC_IsPGRidingHorse(object oPC)
///////////////////////////////////////////////
{
    if(GetPhenoType(oPC) != PHENOTYPE_NORMAL && GetPhenoType(oPC) != PHENOTYPE_BIG)
        return TRUE;

    else
        return FALSE;
}



///////////////////////////////////////////////
int GSC_AssegnaCavalloARazza(object oPC)
///////////////////////////////////////////////
{
int nRace=GetRacialType(oPC);
switch(nRace)
{
case(RACIAL_TYPE_HUMAN):
return  nRiga2daCavalloUmano;
break;
case(RACIAL_TYPE_HALFELF):
return  nRiga2daCavalloUmano;
break;
case(RACIAL_TYPE_ELF):
return  nRiga2daCavalloElfo;
break;
case(RACIAL_TYPE_DWARF):
return  nRiga2daCavalloNano;
break;
case(RACIAL_TYPE_GNOME):
return  nRiga2daCavalloGnomo;
break;
default:
{
//FloatingTextStringOnCreature("La tua razza non e' in grado di cavalcare",oPC,FALSE);
FloatingTextStringOnCreature("// Tu raza no está entrenada para cabalgar.", oPC, FALSE);
return 0;
}
}
return 0;
}



///////////////////////////////////////////////
int GSC_SmontaDaCavallo(object oPC)
///////////////////////////////////////////////
{
    if(GSC_IsPGRidingHorse(oPC)){
        int nCavallo = GetPhenoType(oPC);

        SetPhenoType(PHENOTYPE_NORMAL, oPC);

        effect First = GetFirstEffect(oPC);

        while(GetIsEffectValid(First)){
            if(GetEffectType(First) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE){
                RemoveEffect(oPC, First);
                break;
            }

            else First = GetNextEffect(oPC);
        }

        object oCavallo;

        if(GetRacialType(oPC) == RACIAL_TYPE_HUMAN){
            oCavallo = CreateObject(OBJECT_TYPE_CREATURE, "gsc_cavallo" + IntToString(nCavallo), GetLocation(oPC), TRUE);
        }
        if(GetRacialType(oPC) == RACIAL_TYPE_ELF){
            oCavallo = CreateObject(OBJECT_TYPE_CREATURE, "gsc_cavallo" + IntToString(nCavallo), GetLocation(oPC), TRUE);
        }
        if(GetRacialType(oPC) == RACIAL_TYPE_HALFELF){
            oCavallo = CreateObject(OBJECT_TYPE_CREATURE, "gsc_cavallo" + IntToString(nCavallo), GetLocation(oPC), TRUE);
        }
        if(GetRacialType(oPC) == RACIAL_TYPE_HALFORC){
            oCavallo = CreateObject(OBJECT_TYPE_CREATURE, "gsc_cavallo" + IntToString(nCavallo), GetLocation(oPC), TRUE);
        }

        else if(GetRacialType(oPC) == RACIAL_TYPE_DWARF){
            oCavallo = CreateObject(OBJECT_TYPE_CREATURE, "gsc_pony" + IntToString(nCavallo), GetLocation(oPC), TRUE);
        }
            if(GetRacialType(oPC) == RACIAL_TYPE_GNOME){
            oCavallo = CreateObject(OBJECT_TYPE_CREATURE, "gsc_pony" + IntToString(nCavallo), GetLocation(oPC), TRUE);
        }
            if(GetRacialType(oPC) == RACIAL_TYPE_HALFLING){
            oCavallo = CreateObject(OBJECT_TYPE_CREATURE, "gsc_pony" + IntToString(nCavallo), GetLocation(oPC), TRUE);
        }

        //SetLocalObject(oCavallo, "gsc_padrone", oPC);
        AddHenchman(oPC, oCavallo);
        return TRUE;
    }

    else{
        //FloatingTextStringOnCreature("Per montare a cavallo parlaci",oPC,FALSE);
        FloatingTextStringOnCreature("// Para montar, habla con la montura.", oPC, FALSE);
        return FALSE;
    }
}

///////////////////////////////////////////////
void GSC_SellaPG(object oPC,object oCavallo)
///////////////////////////////////////////////
{
    int nRace = GetRacialType(oPC);
    string nResCavallo = GetTag(oCavallo);
    int nPhenotype = StringToInt(GetStringRight(nResCavallo, 2));
    //FloatingTextStringOnCreature("// Fenotipo "+IntToString(nPhenotype),oPC,FALSE);
    int Continua = FALSE;

    //Parte per smontare da cavallo
    //GSC_SmontaDaCavallo(oPC);
    //Parte per montare a cavall0
    if(GetDistanceBetween(oPC, oCavallo) < 30.0){
        AssignCommand(oCavallo, SetIsDestroyable(TRUE, FALSE, FALSE));
        DestroyObject(oCavallo);
        SetPhenoType(nPhenotype, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedIncrease(50)), oPC);
    }

/*else
if(GetHenchman(oPC)!=oCavallo)
{
//FloatingTextStringOnCreature("Non puoi cavalcare questo cavallo poiche' non ti appartiene",oPC,FALSE);
FloatingTextStringOnCreature("// No puedes cabalgar en esta montura porque no te pertenece.", oPC, FALSE);
}
else
if(GetStringLowerCase(GetSubRace(oPC))=="minotauro")
{
//FloatingTextStringOnCreature("I minotauri non possono cavalcare",oPC,FALSE);
FloatingTextStringOnCreature("// El minotauro no puede cabalgar.", oPC, FALSE);
}
else
{
//FloatingTextStringOnCreature("Devi essere piu' vicino per montare la sella",oPC,FALSE);
FloatingTextStringOnCreature("// Debes acercarte más para colocar la silla de montar.", oPC, FALSE);
}
*/
}

///////////////////////////////////////////////
void GSC_CreaCavallooPonyInStalla(object oPC,string sTagCavallo)
///////////////////////////////////////////////
{
//FloatingTextStringOnCreature("Creato animale con tag "+sTagCavallo,oPC,FALSE);
FloatingTextStringOnCreature("// Creando animal con la etiqueta: " + sTagCavallo, oPC, FALSE);
int nMaxCavalli=GetMaxHenchmen();
int i;
for(i==1;i<=nMaxCavalli;i++)
{
if(FindSubString(GetTag(GetHenchman(oPC,i)),"gsc_cavallo")!=-1 || FindSubString(GetTag(GetHenchman(oPC,i)),"gsc_pony")!=-1)
{
////FloatingTextStringOnCreature("Hai gia' un cavallo",oPC,FALSE);
//FloatingTextStringOnCreature("// Olé, una montura.", oPC, FALSE);
return;
}
}
object oCavallo=CreateObject(OBJECT_TYPE_CREATURE,sTagCavallo,GetLocation(oPC),TRUE);
SetLocalObject(oCavallo,"gsc_padrone",oPC);
AddHenchman(oPC,oCavallo);
}

///////////////////////////////////////////////
void GSC_AttivaSella()
///////////////////////////////////////////////
{
    object oPC = GetItemActivator();
    //object oSella = GetItemActivated();
    //string sResSella = GetTag(oSella);

    if(GSC_IsPGRidingHorse(oPC)){
        GSC_SmontaDaCavallo(oPC);
        return;
    }

    // La siguiente parte es anulada para que no tenga efecto la convocacion:
    /*
    int nPhenotype = StringToInt(GetStringRight(sResSella, 2));

    FloatingTextStringOnCreature("// Fenotipo " + IntToString(nPhenotype), oPC, FALSE);

    if(FindSubString(sResSella, "gsc_sella") != -1){
        if(GetLocalInt(GetArea(oPC), "stalla_var") == 1){
            ////FloatingTextStringOnCreature("sei in stalla", oPC, FALSE);
            //FloatingTextStringOnCreature("// Estás en el establo.", oPC, FALSE);

            object oCavallo = GetItemActivatedTarget();

            if(GetRacialType(oPC) == RACIAL_TYPE_HUMAN ||
            GetRacialType(oPC) == RACIAL_TYPE_HALFELF ||
            GetRacialType(oPC) == RACIAL_TYPE_ELF ||
            GetRacialType(oPC) == RACIAL_TYPE_HALFORC &&
            GetStringLowerCase(GetSubRace(oPC)) != "minotauro"){
                GSC_CreaCavallooPonyInStalla(oPC, "gsc_cavallo"+IntToString(nPhenotype));
            }

            else if(GetRacialType(oPC) == RACIAL_TYPE_DWARF ||
            GetRacialType(oPC) == RACIAL_TYPE_GNOME ||
            GetRacialType(oPC) == RACIAL_TYPE_HALFLING){
                GSC_CreaCavallooPonyInStalla(oPC, "gsc_pony"+IntToString(nPhenotype));
            }

            //else FloatingTextStringOnCreature("La tua razza non e' in grado di cavalcare", oPC, FALSE);
            else FloatingTextStringOnCreature("// Tu raza no está entrenada para cabalgar.", oPC, FALSE);
        }
    }

    else GSC_SmontaDaCavallo(oPC);
    */
    // Fin de la parte anulada.
/*
    if(GSC_SmontaDaCavallo(oPC) == FALSE && GetTag(GetItemActivatedTarget()) == "gsc_cavallo" || GetTag(GetItemActivatedTarget()) == "gsc_pony")
        //FloatingTextStringOnCreature("Per montare a cavallo parlaci", oPC, FALSE);
        FloatingTextStringOnCreature("// Para montar, habla con la montura.", oPC, FALSE);

    //else FloatingTextStringOnCreature("Puoi evocare il tuo cavallo solo in una stalla", oPC, FALSE);
    else FloatingTextStringOnCreature("// Puedes convocar a tu montura sólo en un establo.", oPC, FALSE);
*/
} //Fine if(GetTag(oSella) == "gsc_sella")



///////////////////////////////////////////////
void GSC_OnClientEnter(object oPC)
///////////////////////////////////////////////
{
    if(GSC_IsPGRidingHorse(oPC))
        SetPhenoType(PHENOTYPE_NORMAL, oPC);
}

    int GSC_GetMasterOfHorse(object oPC, object oCavallo){
        int nMaxCavalli = GetMaxHenchmen();
        int i;

        for(i == 1; i <= nMaxCavalli; i++){
            if(GetHenchman(oPC, i) == oCavallo)
                return TRUE;
        }

    return FALSE;
}


///////////////////////////////////////////////
void GSC_CheckDisarcionare(object oMob)
///////////////////////////////////////////////
{
object oPC=GetAttackTarget(oMob);
if(GetLastDamager(oPC)==oMob)
{
int PXScorsi=GetLocalInt(oPC,"gsc_px");
int nPXAttualiPC=GetCurrentHitPoints(oPC);
//SendMessageToPC(oPC,"Nome delPX attuali pari a "+IntToString(nPXAttualiPC)+" , PX storati="+IntToString(PXScorsi));
if(GSC_IsPGRidingHorse(oPC))
{
//Se sbaglia il tiro il pg cade da cavallo
if(nPXAttualiPC!=PXScorsi && PXScorsi!=0 && !GetIsSkillSuccessful(oPC,SKILL_CAVALCARE,CD_CAVALCARE))
{
SendMessageToPC(oPC,"Tiro su Cavalcare fallito,cadi da cavallo");
GSC_SmontaDaCavallo(oPC);
AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,1.0,5.0));
ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(10),oPC);
SetLocalInt(oPC,"gsc_px",nPXAttualiPC);
}
//Nel caso di primo attacco limitiamoci ad aggiornare la soglia
else
if(PXScorsi==0)
SetLocalInt(oPC,"gsc_px",nPXAttualiPC);
//Il pg non e' stato danneggiato quindi non facciamo check
//ma aggiorniamo la soglia
else
SetLocalInt(oPC,"gsc_px",nPXAttualiPC);
}
}
}


///////////////////////////////////////////////
void GSC_OnPGDeath(object oPC)
///////////////////////////////////////////////
{

if(GSC_IsPGRidingHorse(oPC))
{
int nPhenotype=GetPhenoType(oPC);
DestroyObject(GetItemPossessedBy(oPC,"gsc_sella"+IntToString(nPhenotype)));
SetPhenoType(1,oPC);
}

else return;
}

///////////////////////////////////////////////
void GSC_OnEquipItem(object oPC,object ItemEquipped)
///////////////////////////////////////////////
{
if(GSC_IsPGRidingHorse(oPC))
{
switch(GetBaseItemType(ItemEquipped))
{
case(BASE_ITEM_TOWERSHIELD):
DelayCommand(1.0,AssignCommand(oPC,ActionUnequipItem(ItemEquipped)));
//FloatingTextStringOnCreature("Non puoi equipaggiare questo oggetto quando cavalchi",oPC,FALSE);
FloatingTextStringOnCreature("// No puedes equiparte con este objeto cuando cabalgas", oPC, FALSE);
break;
//Continua qua con la lista oggetti non consentita
default:
return;
}//fine switch
}

}


//void main(){}

