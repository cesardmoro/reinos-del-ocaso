////////////////
// Script By Dragoncin
//
// Arregla la locacion de respawn del personaje.
// En el futuro hay que incluirlo en muerte_inc para controlar todas las facciones
///////////////

void main() {
    object oPC = GetPCSpeaker();
    string sID = GetStringLeft( GetName(oPC), 25 );

    if( GetLevelByClass(CLASS_TYPE_DRUID, oPC ) > 0)
        SetCampaignLocation( "respawn", "lugar"+sID, GetLocation(GetWaypointByTag("DruidaSpawn")) );
    else
        SetCampaignLocation( "respawn", "lugar"+sID, GetLocation(GetWaypointByTag("inicio2")) );
}
