/****************************** TREE STRIDE ************************************
01/02/07 - Script by Dragoncin

Al lanzar un conjuro de piel robiza sobre el arbol, el lanzador es enviado al
otro arbol.
******************************************************************************/
void main()
{
    int nSpell = GetLastSpell();
    if (nSpell==SPELL_BARKSKIN) {
        object oViajero = GetLastSpellCaster();
        location lArbol = GetLocation(OBJECT_SELF);
        string sTag = GetTag(OBJECT_SELF);
        if (GetStringRight(sTag, 6)=="benzor")
            sTag = "wp_treestride_bosque";
        else
            sTag = "wp_treestride_benzor";
        location lWPDestino = GetLocation(GetWaypointByTag(sTag));
        effect eCirculoVerde = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eCirculoVerde, lArbol);
        DelayCommand(3.0, AssignCommand(oViajero, JumpToLocation(lWPDestino)));
    }
}
