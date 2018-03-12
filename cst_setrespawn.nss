/*****************************************************************************
20/02/07 - Script By Dragoncin modificado por Inquisidor
Guarda en la DB la ubicaciion del clerigo para revivir alli
*****************************************************************************/

void main()
{
    location lClerigo = GetLocation(OBJECT_SELF);
    object oPC = GetPCSpeaker();
    string sID = GetStringLeft( GetName(oPC), 25 );
    SetCampaignLocation( "respawn", "lugar"+sID, lClerigo);
    SendMessageToPC( oPC, "Desde ahora será aqui en '"+GetName(GetArea(OBJECT_SELF))+"' donde revivirías de llegar a morir y ser perdonado." );
}
