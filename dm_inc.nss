// Devuelve si un PJ tiene su CD Key habilitada para ser DM
int GetIsAllowedDM( object oPC );
int GetIsAllowedDM( object oPC )
{
    string sCd = GetPCPublicCDKey( oPC );
    SendMessageToAllDMs("Ingreso como dm"+sCd);
    /*//Lista de cdkeys:
    if( sCd != "UCPVMDD7"    // Hildor
        && sCd != "USN56ADB" // Athanasius - DM
        //&& sCd != "8AYCHKX1" // Bando-DM
        //&& sCd != "4YN3DHH9" // BlackMage - DM  (esteban)
        && sCd != "ZU5JVF6I" // Darkraven - DM (mrpipa = Megrin = Damino)
        && sCd != "7DE6L4Q6" // DarkStar - DM (ale)
        && sCd != "MLQCEL4J" // Dragoncin - DM
        && sCd != "TG43XJ79" // Dumork - DM
        && sCd != "3KDDNZ4N" // Frostfire - DM (Lantus Malagar = Kard Lionheart)
        && sCd != "ACXKGVUH" // Guilgard DM
        && sCd != "RFJKFCQW" // Inquisidor - DM
        && sCd != "F2UGXAJQ" // Marduk - DM (- illithid -)
        && sCd != "J2OIVC6J" // Pet-DM
        //&& sCd != "NINBGHGB" // Sardaukar - DM (MuaDib)
        //&& sCd != "0BY7HXZ9" // Shadowlord DM
        //&& sCd != "DJY966IP" // SwordLegend DM - angrium
        //&& sCd != "FVBG9OFD" // Tasslehoff DM - lopeloco
        //&& sCd != "XOIPHKUO" // Wolf - DM (Lobofiel)
        //&& sCd != "RNRDTER3" // Aegis - DM
        //&& sCd != "YR3973EL" // Lady Gunatar - DM
        //&& sCd != "V9PMPUVE" // Siberys - DM
        && sCd != "VD7ULCVC" // Leandro INXS - Desarrollo
        //&& sCd != "DQBPU57M" // Alliance - DM
        //&& sCd != "TV6DXAC9" // black_dragon (rod)
        //&& sCd != "QG6X6C7Y" // DM-Injusto[El Iluminador] (Zoraga: Deltrix, Uber Nul)
        //&& sCd != "NRZKYO60" // Nikkey - DM (davidfiorito1@hotmail.com)
        //&& sCd != "CINY8ZJB" // Obsidian - DM
        //&& sCd != "YYRNT7CG" // Silverscale - DM
        //&& sCd != "FQCAQ49E" // Zeratul - DM
        && sCd != "TGBZA76G" // Just-K
    && sCd != "CDEZKN63" // Garuda
    && sCd != "GX1WBS13" // Lopeloco
    && sCd != "PNQ7PFQJ" // Vermis Luctus
    ) {
        return FALSE;
    }        */
    return TRUE;
}
