/*****************************************************************************
Script By Zero - Retocado por Dragoncin
Abre la puerta mas cercana con el tag "puertaciudad_###" al oir la frase "abran la puerta".
Donde se aplica: trigger al lado de una puerta.
Nota: el trigger debe tener el tag "triggerpuerta_###"
*****************************************************************************/

void main()
{
  // Nota por dragoncin: las siguientes lineas fueron agregadas para no hacer un script por puerta
  // sino uno general.

  string sNum4 = GetTag(OBJECT_SELF);

    string sNum32 = "";
    int iLar2 = GetStringLength(sNum4);
    while((sNum4 != "") && !(GetStringRight(sNum4, 1) == "_") )
    {
        string sNum22 = GetStringRight(sNum4, 1);
        sNum32 = sNum22 + sNum32;
        iLar2 = iLar2 - 1;
        sNum4 = GetStringLeft(sNum4, iLar2);
    }
    string sNumero2 = sNum32;
    int nNumero2 = StringToInt(sNum32);




 // string sTagSelf = GetTag(OBJECT_SELF);
 // int charPos = FindSubString(sTagSelf, "_");
 // charPos = GetStringLength(sTagSelf) - charPos;
  string sTagPuerta = "puertaciudad_" + sNumero2;
  object riddledoor = GetObjectByTag(sTagPuerta);
  // ... end Nota

  object oPC = GetEnteringObject();
  if (!GetIsOpen(riddledoor) && GetCampaignInt("PVP", "Assasin", oPC) == 0)
  {
     location loc = GetLocation(OBJECT_SELF);
     vector temp = GetPositionFromLocation(loc);
     vector zIndexCorrection = Vector(temp.x,temp.y,GetPositionFromLocation(GetLocation(riddledoor)).z);
     location correctedloc = Location(GetAreaFromLocation(loc),zIndexCorrection,90.0);

     object listener = CreateObject(OBJECT_TYPE_PLACEABLE,"listener",correctedloc); // remember, blueprint not tag.

     SetListenPattern(listener,"ABRAN LA PUERTA",1000); // whatever you want for a password,
     SetListening(listener,TRUE);
     int seconds;
     for (seconds = 1; seconds < 7; seconds++)
        DelayCommand(IntToFloat(seconds),SignalEvent(listener,EventUserDefined(1300)));
  }
}
