void main()
{
    object oUser = GetLastUsedBy();
    if (GetLevelByClass(CLASS_TYPE_DRUID, oUser) > 0) {
        FloatingTextStringOnCreature("*Al ver este viejo roble recuerdas las palabras del Gran Druida: '... y asi, nacieron un par de arboles hermanos, uno en las cercanias de Benzor y el otro en el corazon del bosque, uniendo por los siglos a ambos. Dales nueva piel y te llevaran entre ellos.'*", oUser);
    }
}
