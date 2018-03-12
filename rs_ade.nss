/**************** Arreglos descriptores de encuentro **************************
Package: RandoSpawn - Arreglos descriptores de encuentro
Autor: Inquisidor y Lobofiel
Descripcion: Estas funciones son llamadas desde los SGEs (script descript de encuentro).
El objetivo de reunirlas aqui, es centralizar el manejo de los CRs de las criaturas.
Hay dos tipos de funciones:
1) Sin sufijo 'Variado': dan un arreglo que puede ser usado tanto por 'RS_generarGrupo(..) como
por 'RS_generarMezclado(..)'.
2) Con sufijo 'Variado': dan un arreglo que solo puede ser usado por 'RS_generarMezclado(..)'

******************************************************************************/


/////////////////////// CATEGORIZADO POR RAZA //////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// ABERRATIONS ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//__________________________ Aberrations / Azotamentes _____________________________________
//CRs: 7,17
string ADE_Aberrations_Azotamentes_get();
string ADE_Aberrations_Azotamentes_get() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "007,M,023,110,????????,mindflayer002    "; // Azotamentes cr8
    arregloDMDs +=  "017,M,023,110,????????,mindflayer004    "; // Azotamentes cr17
    return arregloDMDs;
}


//__________________________ Aberrations / Beholder _____________________________________
// CRs: 1,13                        Faction: Hostil
string ADE_Aberrations_Beholder_getVariado();
string ADE_Aberrations_Beholder_getVariado() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "001,M,023,110,????????,beholder         "; // Beholder Eyeball Aberration 1
    arregloDMDs +=  "013,M,023,110,????????,beholder002      "; // Beholder D&D Aberration 11
    return arregloDMDs;
}


//__________________________ Aberrations / Draña _____________________________________
// CRs: 7
string ADE_Aberrations_Drana_get();
string ADE_Aberrations_Drana_get() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "007,M,023,110,????????,drider003        "; // Draña Cleriga D&D cr7
    arregloDMDs +=  "007,M,023,110,????????,drider002        "; // Draña Hechicero D&D cr7
    return arregloDMDs;
}


//____________________________Aberrations / Underground_______________________________
// CRs: 3,4,5,8,10,14
string ADE_Aberrations_Underground_getVariado();
string ADE_Aberrations_Underground_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
//  arregloDVDs +=  "003,M,023,110,????????,pm002a           ";  // vermin 4         "Insects / Spiders / Arania Gigante D&D"  { 3 x Web [Caster Level:4] }
//  arregloDVDs +=  "003,L,050,110,????????,pm002            "; // aberration 5     "Tracnido D&D" seguidor=pm002a (QUITADOS X FORMAR PARTE DE OTRO ARREGLO UNDER, INSECTCS-SPIDERS)
//  arregloDVDs +=  "004,M,030,110,????????,mcorrosivo001    "; // Rust Monster cr3 (mariconeadas, hay que corregir los efectos del bicho)
    arregloDVDs +=  "005,S,045,110,????????,umberhulk001     "; // Umber Hulk CR7
    arregloDVDs +=  "008,M,030,108,????????,pm006a           "; // aberration 9     "Fuego Fatuo D&D"
    arregloDVDs +=  "010,S,045,110,????????,hookhorror1      "; // Hook Horror D&D cr10
    arregloDVDs +=  "014,S,045,110,????????,umberhulk002     "; // Truly Horrid Umber Hulk CR14
    return arregloDVDs;
}

////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// ANIMALES /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//____________________________Animales / Alimañas _______________________________
// CRs: 3,4,5,7       Factions: Alimañas     Notas: Nocturnos
string ADE_Animales_Alimanias_getVariado();
string ADE_Animales_Alimanias_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "003,M,018,055,????????,rat002           "; // animal 5 (3hp x hd) "Animals / Other / Rata D&D" 2.79 Alimañas                   Visto paso
    arregloDVDs +=  "004,M,030,150,????????,am001            "; // animal 6 (3hp x hd) "Animals / Other / Murciélago D&D" 3.68 Alimañas             Visto paso
    arregloDVDs +=  "005,M,023,110,????????,rata003          "; // animal 5 (6hp x hd) "Animals / Other / Rata Terrible D&D" 4.77 Alimañas          Visto paso
    arregloDVDs +=  "007,M,023,110,????????,am001a           "; // animal 10(6hp x hd) "Animals / Other / Murciélago Terrible D&D" 7.45 Alimañas    Visto mod
    return arregloDVDs;
}


//____________________________Animales / Alimañas / Ratas _______________________________
// CRs: 3,5       Factions: Alimañas     Notas: Nocturnos
// Solo se usa en miniquest Perro Salado
string ADE_Animales_Ratas_getVariado();
string ADE_Animales_Ratas_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "003,M,018,055,????????,rat002           "; // animal 5 (3hp x hd) Rata D&D
    arregloDVDs +=  "005,M,023,110,????????,rata003          "; // animal 6 (6hp x hd) Rata Terrible D&D cr2
    return arregloDVDs;
}


//____________________________Animales / Ave Diurna_______________________________
// CRs: 3-12     Factions: Animales
string ADE_Animales_AveDiurna_getVariado();
string ADE_Animales_AveDiurna_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "003,M,023,110,????????,aguila           "; // animal 3     "Animal / Birds / Aguila D&D" Animales
    arregloDVDs +=  "004,M,023,110,????????,halcon           "; // animal 5 (6hp x HD) "Animals / Birds / Halcon D&D"
    arregloDVDs +=  "007,M,023,110,????????,aguila001        "; // animal 8     "Animal / Birds / Aguila D&D" Animales
    arregloDVDs +=  "008,M,023,110,????????,vr_eag_cr08      "; //
    arregloDVDs +=  "009,M,023,110,????????,vr_eag_cr09      "; //
    arregloDVDs +=  "010,M,023,110,????????,vr_eag_cr10      "; //
    arregloDVDs +=  "012,M,030,110,????????,aguila2          "; // animal 12    "Animal / Birds / Aguila LegendariaD&D" Animales
    arregloDVDs +=  "013,M,030,110,????????,vr_lgeag_cr13    "; //
    arregloDVDs +=  "014,M,030,110,????????,vr_lgeag_cr14    "; // animal 17
    arregloDVDs +=  "016,M,030,110,????????,vr_lgeag_cr16    "; // animal 22
    arregloDVDs +=  "018,M,030,110,????????,vr_lgeag_cr18    "; // animal 27
return arregloDVDs;
}

//____________________________Animales / Aves Nocturna_______________________________
// CRs: 3,4     Factions: Animales
string ADE_Animales_AveNocturna_getVariado();
string ADE_Animales_AveNocturna_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "003,M,023,110,????????,am002            "; // animal 5 (3hp x HD) "Animals / Birds / Cuervo D&D"  Nocturno
    arregloDVDs +=  "004,M,023,110,????????,halcon           "; // animal 5 (6hp x HD) "Animals / Birds / Halcon D&D"
    arregloDVDs +=  "005,M,023,110,????????,vr_rav_cr05      "; //
    arregloDVDs +=  "006,M,023,110,????????,vr_rav_cr06      "; //
    arregloDVDs +=  "006,M,023,110,????????,vr_haw_cr06      "; //
    arregloDVDs +=  "007,M,023,110,????????,vr_haw_cr07      "; //
return arregloDVDs;
}

//____________________________Animales / Campo _______________________________
// CRs: 3-11     Factions: Animales     Notas: Diurno
string ADE_Animales_Campo_getVariado();
string ADE_Animales_Campo_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
//    arregloDVDs +=  "003,M,030,110,????????,zep_weasel003  "; // animal 3        "Animals / Other / Comadreja Terrible D&D" 2.82 Animals
    arregloDVDs +=  "003,M,045,110,????????,as008            "; // animal 3        "Animals / Other / Gloton D&D" 2.91
    arregloDVDs +=  "004,M,045,110,????????,as009            "; // animal 4        "Animals / Other / Jabalí D&D"
//    arregloDVDs +=  "003,S,045,110,????????,as002          "; // animal 3        "Animals / Other / Huron Terrible D&D"
//    arregloDVDs +=  "003,S,045,110,????????,as0010         "; // animal 3        "Animals / Other / Tejón terrible  D&D"
    arregloDVDs +=  "006,M,045,110,????????,as0017           "; // animal 6        "Animals / Other / Gloton Terrible D&D"
    arregloDVDs +=  "007,M,030,110,????????,zep_bison001     "; // animal 9        "Animals / Other / Bisonte D&D"
    arregloDVDs +=  "008,S,045,110,????????,as0016           "; // animal 10       "Animals / Ohter / Jabalí terrible D&D" 8.93 Animales        visto mod
    arregloDVDs +=  "009,S,045,110,????????,vr_trjab_cr09    "; //
    arregloDVDs +=  "011,S,045,110,????????,as017            "; // animal 15       "Animals / Ohter / Jabalí terrible D&D" 13.13                visto mod
    arregloDVDs +=  "013,S,045,110,????????,bisonlegend      "; // animal 24       "Animals / Ohter / Bisonte Legendario D&D" 15.9                 visto mod (marcos)
    arregloDVDs +=  "013,S,045,110,????????,vr_trjab_cr13    "; //
    arregloDVDs +=  "015,S,045,110,????????,vr_trjab_cr15    "; //
    arregloDVDs +=  "015,S,045,110,????????,jabalilegend     "; // animal 25       "Animals / Ohter / Jabalí Legendario D&D" 21.3                  visto mod (marcos)
    arregloDVDs +=  "016,S,045,110,????????,vr_lgjab_cr16    "; //
    arregloDVDs +=  "016,S,045,110,????????,vr_lgbis_cr16    "; //

return arregloDVDs;
}

//____________________________Animales / Caninos_______________________________
// CRs: 4,7,13      Faction: Animales
string ADE_Animales_Lobos_getVariado();
string ADE_Animales_Lobos_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "004,M,023,110,????????,am003            "; // animal 3        "Animals / Canine / Lobo D&D" 3.47 Animales                  visto mod
    arregloDVDs +=  "005,M,023,110,????????,vr_wlf_cr05      "; //
    arregloDVDs +=  "006,M,023,110,????????,vr_wlf_cr06      "; //
    arregloDVDs +=  "007,M,023,110,????????,am003a           "; // animal 8        "Animals / Canine / Lobo Terrible D&D" 6.97 Animales         visto paso
    arregloDVDs +=  "010,M,023,110,????????,am003a001        "; // animal 13       "Animals / Canine / Lobo Terrible D&D" 11.8 Animales         visto mod
    arregloDVDs +=  "011,M,023,110,????????,vr_trwlf_cr11    "; //
    arregloDVDs +=  "012,M,023,110,????????,vr_trwlf_cr12    "; //
    arregloDVDs +=  "013,M,023,110,????????,vr_trwlf_cr13    "; //
    arregloDVDs +=  "013,M,050,110,????????,lobo3            "; // animal 17       "Animals / Canine / Lobo Legendario D&D" 15.9 Animales       visto mod
    arregloDVDs +=  "015,M,023,110,????????,vr_trwlf_cr15    "; //
    arregloDVDs +=  "015,M,050,110,????????,lobo004          "; // animal 21       "Animals / Canine / Lobo Legendario D&D" 18.82 Animales      visto mod
    arregloDVDs +=  "017,M,050,110,????????,vr_lgwlf_cr17    "; //
    arregloDVDs +=  "019,M,050,110,????????,vr_lgwlf_cr19    "; //
    arregloDVDs +=  "021,M,050,110,????????,vr_lgwlf_cr21    "; //
    arregloDVDs +=  "023,M,050,110,????????,vr_lgwlf_cr23    "; //
    arregloDVDs +=  "025,M,050,110,????????,vr_lgwlf_cr25    "; //
    return arregloDVDs;
}

// CRs: 4-10        Faction: Animales
string ADE_Animales_Hiena_getVariado();
string ADE_Animales_Hiena_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "004,M,030,110,????????,hiena1           "; // animals 4        "Animals / Canine / Hiena D&D" 3.6   Animales               visto paso
    arregloDVDs +=  "007,M,030,110,????????,hiena002         "; // animals 8        "Animals / Canine / Hiena D&D" 7.07  Animales               visto paso
    arregloDVDs +=  "010,M,030,110,????????,hiena003         "; // animals 11       "Animals / Canine / Hiena D&D" 10.99 Animales               visto mod
//    arregloDVDs +=  "001,M,030,110,????????,hiena            "; // Hiena D&D cr3
    return arregloDVDs;
}


// LOBO, los felinos diurnos y nocturnos los volvi a poner porque se usaban en varios sitios. Fijate como arreglarlo para que no esten repetidos algunos elementos.
// No hay problema.. (marcos)
//____________________________Animales / Felino Diurno_______________________________
// deprecated CRs: 3-20
string ADE_Animales_FelinoDiurno_getVariado();
string ADE_Animales_FelinoDiurno_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "003,S,045,120,????????,as011            "; // animal 2        "Animals / Feline / Puma moribundo D&D" 2.05
    arregloDVDs +=  "005,M,023,110,????????,leonmoribundo    "; // animal 5        "Animals / Feline / León moribundo D&D" 5.25
    arregloDVDs +=  "006,S,045,120,????????,as007            "; // animal 7        "Animals / Feline / Puma D&D"
    arregloDVDs +=  "007,S,045,110,????????,tigremoribundo   "; // animal 8        "Animals / Feline / Tigre moribundo D&D" 7.49
    arregloDVDs +=  "008,M,023,110,????????,am005            "; // animal 11       "Animals / Feline / León D&D" 9.26
    arregloDVDs +=  "009,S,045,110,????????,as0015           "; // animal 12       "Animals / Feline / Tigre D&D" 10.46
    arregloDVDs +=  "010,S,045,120,????????,as004            "; // animal 15       "Animals / Feline / Cheetah D&D" 11.46
    arregloDVDs +=  "011,S,023,110,????????,leonfornido      "; // animal 15       "Animals / Feline / León fornido D&D" 13:31
    arregloDVDs +=  "014,S,023,110,????????,am005a           "; // animal 20       "Animals / Feline / León terrible D&D" 17.15
    arregloDVDs +=  "014,S,045,110,????????,as0019           "; // animal 20       "Animals / Feline / Tigre terrible D&D"
    arregloDVDs +=  "020,S,050,110,????????,tigrelegend1     "; // animal 26       "Animals / Feline / Tigre Legendario D&D"
    return arregloDVDs;
}

//____________________________Animales / Felino Nocturno_______________________________
// deprecated CRs: 3-20
string ADE_Animales_FelinoNocturno_getVariado();
string ADE_Animales_FelinoNocturno_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "003,S,045,120,????????,leopardomoribund "; // animal 3        "Animals / Feline / Leopardo moribundo D&D" 2.48
    arregloDVDs +=  "004,S,045,120,????????,as005            "; // animal 5        "Animals / Feline / Leopardo D&D" 4.09
    arregloDVDs +=  "005,S,045,120,????????,as011            "; // animal 6        "Animals / Feline / Puma moribundo D&D" 5.29
    arregloDVDs +=  "007,S,045,110,????????,tigremoribundo   "; // animal 8        "Animals / Feline / Tigre moribundo D&D" 7.49
    arregloDVDs +=  "009,S,045,120,????????,as013            "; // animal 12       "Animals / Feline / Puma D&D"
    arregloDVDs +=  "010,S,045,110,????????,as0015           "; // animal 14       "Animals / Feline / Tigre D&D" 11.48
    arregloDVDs +=  "014,S,045,110,????????,as0019           "; // animal 20       "Animals / Feline / Tigre terrible D&D"
    arregloDVDs +=  "020,S,050,110,????????,tigrelegend1     "; // animal 26       "Animals / Feline / Tigre Legendario D&D"
//    arregloDVDs +=  "004,S,045,110,????????,as0012           "; // animal 5        "Animals / Feline / Yaguar D&D"  Nocturno
    return arregloDVDs;
}

//____________________________Animales / Felino Calido_______________________________
// CRs: 3-20
string ADE_Animales_FelinoCalido_getVariado();
string ADE_Animales_FelinoCalido_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "003,S,045,120,????????,leopardomoribund "; // animal 3        "Animals / Feline / Leopardo moribundo D&D" 2.48
    arregloDVDs +=  "004,S,045,120,????????,as005            "; // animal 5        "Animals / Feline / Leopardo D&D" 4.09
    arregloDVDs +=  "005,S,045,120,????????,as011            "; // animal 6        "Animals / Feline / Puma moribundo D&D" 5.29
    arregloDVDs +=  "006,S,045,120,????????,vr_puma_cr06     "; //
    arregloDVDs +=  "007,S,045,120,????????,vr_puma_cr07     "; //
    arregloDVDs +=  "007,S,045,110,????????,tigremoribundo   "; // animal 8        "Animals / Feline / Tigre moribundo D&D" 7.49
    arregloDVDs +=  "008,S,045,120,????????,vr_puma_cr08     "; //
    arregloDVDs +=  "009,S,045,120,????????,as013            "; // animal 12       "Animals / Feline / Puma D&D" 10.62                          visto mod
    arregloDVDs +=  "010,S,045,110,????????,as0015           "; // animal 14       "Animals / Feline / Tigre D&D" 11.72                         visto mod
    arregloDVDs +=  "011,S,045,110,????????,vr_tig_cr11      "; //
    arregloDVDs +=  "012,S,045,110,????????,vr_tig_cr12      "; //
    arregloDVDs +=  "013,S,045,110,????????,vr_trtig_cr13    "; //
    arregloDVDs +=  "014,S,045,110,????????,as0019           "; // animal 20       "Animals / Feline / Tigre terrible D&D" 17.52                visto paso
    arregloDVDs +=  "015,S,045,110,????????,vr_trtig_cr15    "; //
    arregloDVDs +=  "016,S,045,110,????????,vr_trtig_cr16    "; //
    arregloDVDs +=  "020,S,050,110,????????,tigrelegend1     "; // animal 29       "Animals / Feline / Tigre Legendario D&D" 25.81 felinos      visto mod
    arregloDVDs +=  "022,S,050,110,????????,vr_tiglg_cr22    "; // animal 29       "Animals / Feline / Tigre Legendario D&D" 25.81 felinos      visto mod
    arregloDVDs +=  "024,S,050,110,????????,vr_tiglg_cr24    "; //
    arregloDVDs +=  "025,S,050,110,????????,vr_tiglg_cr25    "; //
    return arregloDVDs;
}

//____________________________Animales / Felino Templado_______________________________
// CRs: 3-20
string ADE_Animales_FelinoTemplado_getVariado();
string ADE_Animales_FelinoTemplado_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "003,S,045,120,????????,pumamoribundo    "; // animal 2        "Animals / Feline / Puma moribundo D&D"
    arregloDVDs +=  "005,M,023,110,????????,leonmoribundo    "; // animal 5        "Animals / Feline / León moribundo D&D"
    arregloDVDs +=  "006,S,045,120,????????,as007            "; // animal 7        "Animals / Feline / Puma D&D"
    arregloDVDs +=  "007,M,023,110,????????,vr_leo_cr07      "; //
    arregloDVDs +=  "008,M,023,110,????????,am005            "; // animal 11       "Animals / Feline / León D&D" 9.26
    arregloDVDs +=  "010,S,045,120,????????,as004            "; // animal 15       "Animals / Feline / Cheetah D&D" 11.46
    arregloDVDs +=  "010,M,023,110,????????,vr_leo_cr10      "; //
    arregloDVDs +=  "011,S,023,110,????????,leonfornido      "; // animal 15       "Animals / Feline / León fornido D&D" 13:31
    arregloDVDs +=  "012,S,045,120,????????,vr_chee_cr12     "; //
    arregloDVDs +=  "012,S,023,110,????????,vr_liontr_cr12   "; //
    arregloDVDs +=  "014,S,023,110,????????,vr_liontr_cr14   "; // animal 20       "Animals / Feline / León terrible D&D" 17.15
    arregloDVDs +=  "016,S,023,110,????????,vr_liontr_cr16   "; //
    arregloDVDs +=  "018,S,023,110,????????,vr_liontr_cr18   "; //
    return arregloDVDs;
}

//____________________________Animales / Felino Invernal_______________________________
// CRs: 3,7,11
string ADE_Animales_FelinosInvernal_getVariado();
string ADE_Animales_FelinosInvernal_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "003,S,045,120,????????,as016            "; // animal 7        "Animals / Feline / Leopardo de las Nieves D&D"
    arregloDVDs +=  "007,S,045,120,????????,as018            "; // animal 12       "Animals / Feline / Leopardo de las Nieves D&D"
    arregloDVDs +=  "011,S,045,120,????????,as020            "; // animal 18       "Animals / Feline / Tigre de Bengala D&D"
    return arregloDVDs;
}

// CRs: 11
string ADE_Animales_Malar_get();
string ADE_Animales_Malar_get() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "011,M,023,110,????????,beastmalar002    "; // Pantera de Malar D&D cr11
    return arregloDMDs;
}


//____________________________Animales / Osos _______________________________
// CRs: 4,7,9,11,14,17    Faction: Osos
string ADE_Animales_Osos_getVariado();
string ADE_Animales_Osos_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "004,S,045,130,????????,as003            "; // animal 6       "Animals / Bear / Oso negro D&D"
    arregloDVDs +=  "007,S,050,120,????????,as0014           "; // animal 10      "Animals / Bear / Oso pardo D&D"
//    arregloDVDs +=  "005,S,050,120,????????,bearbrwn002      "; // animal 6         "Animals / Bear / Oso panda D&D" 5.39 Es igual al pardo excepto por el skin
    arregloDVDs +=  "005,S,045,130,????????,vr_osob_cr05     "; //
    arregloDVDs +=  "009,S,050,120,????????,as015            "; // animal 12      "Animals / Bear / Oso pardo D&D" 10.58
//    arregloDVDs +=  "010,S,050,107,????????,vr_osotr_cr10    "; // QUITADO porque no existe
    arregloDVDs +=  "011,S,050,120,????????,vr_oso_cr11      "; //
    arregloDVDs +=  "011,S,050,107,????????,as0018           "; // animal 15      "Animals / Bear / Oso terrible D&D" 13.82
    arregloDVDs +=  "012,S,050,107,????????,vr_osotr_cr12    "; //
    arregloDVDs +=  "014,S,050,107,????????,as019            "; // animal 20      "Animals / Bear / Oso terrible D&D" 17.3 Osos
    arregloDVDs +=  "016,S,050,107,????????,vr_osotr_cr16    "; //
    arregloDVDs +=  "017,S,030,110,????????,osolegendario1   "; // animal 26      "Animals / Bear / Oso Legendario D&D" 21.6 Osos
    arregloDVDs +=  "018,S,050,107,????????,vr_osotr_cr18    "; //
    arregloDVDs +=  "023,S,030,110,????????,vr_osolg_cr23    "; //
    arregloDVDs +=  "025,S,030,110,????????,vr_osolg_cr25    "; //
    return arregloDVDs;
}

// CRs: 7,12
string ADE_Animales_OsosW_getVariado();
string ADE_Animales_OsosW_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "007,S,050,120,????????,as021            "; // animal 10      "Animals / Bear / Oso Polar D&D"
    arregloDVDs +=  "012,S,050,120,????????,as022            "; // animal 15      "Animals / Bear / Oso Polar D&D"
    return arregloDVDs;
}


//____________________________Animales / Serpents _______________________________
// CRs: 3,8,11,16      Faction: serpientes
string ADE_Animales_SerpentDesert_getVariado();
string ADE_Animales_SerpentDesert_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "003,S,045,110,????????,as115            "; // animal 8     "Animals / Snakes / Serpiente del desierto D&D" Serpientes
    arregloDVDs +=  "008,S,045,110,????????,diresnake004     "; // animal 15    "Animals / Snakes / Serpiente del desierto grande D&D" Serpientes
    arregloDVDs +=  "009,S,045,110,????????,vr_serds_cr09    "; //
    arregloDVDs +=  "010,S,045,110,????????,vr_serds_cr10    "; //
    arregloDVDs +=  "011,S,045,110,????????,vr_serds_cr11    "; //
    arregloDVDs +=  "011,S,045,110,????????,diresnake003     "; // animal 17    "Animals / Snakes / Serpiente del desierto Terrible D&D" Serpientes
    arregloDVDs +=  "013,S,045,110,????????,vr_serdstr_cr13  "; //
    arregloDVDs +=  "015,S,045,110,????????,vr_serdstr_cr15  "; //
    arregloDVDs +=  "016,S,045,110,????????,legendsnake002   "; // animal 24    "Animals / Snakes / Serpiente del desierto Legendaria D&D" Serpientes
    arregloDVDs +=  "017,S,045,110,????????,vr_serdstr_cr17  "; //
    arregloDVDs +=  "023,S,045,110,????????,vr_serdslg_cr23  "; //
    arregloDVDs +=  "024,S,045,110,????????,vr_serdslg_cr24  "; //
    arregloDVDs +=  "025,S,045,110,????????,vr_serdslg_cr25  "; //
    return arregloDVDs;
}

// CRs: 3,6,10,14    Faction: serpientes
string ADE_Animales_SerpentJungle_getVariado();
string ADE_Animales_SerpentJungle_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "003,S,045,110,????????,as0011           "; // animal 8     "Animals / Snakes / Serpiente venenosa del Bosque D&D" Serpientes
    arregloDVDs +=  "006,S,045,110,????????,diresnake1       "; // animal 11     "Animals / Snakes / Serpiente Venenosa Terrible del bosque  D&D" Serpientes
    arregloDVDs +=  "006,S,045,110,????????,vr_srb_cr06      "; //
    arregloDVDs +=  "009,S,045,110,????????,vr_srb_cr09      "; //
    arregloDVDs +=  "010,S,045,110,????????,diresnake002     "; // animal 16     "Animals / Snakes / Serpiente Venenosa Terrible del bosque  D&D" 12.04     Serpientes
    arregloDVDs +=  "011,S,045,110,????????,vr_srbtr_cr11    "; //
    arregloDVDs +=  "012,S,045,110,????????,vr_srbtr_cr12    "; //
    arregloDVDs +=  "013,S,045,110,????????,vr_srbtr_cr13    "; //
    arregloDVDs +=  "014,S,045,110,????????,legendsnake1     "; // animal 22    "Animals / Snakes / Serpiente Venenosa Legendaria del bosque  D&D" 17.3     Serpientes
    arregloDVDs +=  "016,S,045,110,????????,vr_srblg_cr16    "; //
    arregloDVDs +=  "018,S,045,110,????????,vr_srblg_cr18    "; //
    arregloDVDs +=  "020,S,045,110,????????,vr_srblg_cr20    "; //
    arregloDVDs +=  "022,S,045,110,????????,vr_srblg_cr22    "; //
    arregloDVDs +=  "024,S,045,110,????????,vr_srblg_cr24    "; //
    arregloDVDs +=  "025,S,045,110,????????,vr_srblg_cr25    "; //
    return arregloDVDs;
}


// CRs: 8,12,16      Faction: serpientes
string ADE_Animales_SerpentSwamp_getVariado();
string ADE_Animales_SerpentSwamp_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "008,S,045,110,????????,ps002            "; // animal 15    "Animals / Snakes / Serpiente Constrictora D&D" Serpientes
    arregloDVDs +=  "011,S,045,110,????????,vr_cn_cr11       "; //
    arregloDVDs +=  "012,S,045,110,????????,ps015            "; // animal 17    "Animals / Snakes / Serpiente Constrictora D&D" Serpientes
    arregloDVDs +=  "013,S,045,110,????????,vr_cn_cr13       "; //
    arregloDVDs +=  "015,S,045,110,????????,vr_cn_cr15       "; //
    arregloDVDs +=  "016,S,045,110,????????,ps016            "; // animal 19    "Animals / Snakes / Serpiente Constrictora Legendaria D&D" Serpientes
    arregloDVDs +=  "018,S,045,110,????????,vr_cnlg_cr18     "; //
    arregloDVDs +=  "020,S,045,110,????????,vr_cnlg_cr20     "; //
    arregloDVDs +=  "022,S,045,110,????????,vr_cnlg_cr22     "; //

    return arregloDVDs;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// BESTIAS /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//____________________________Bestias / Dry _______________________________
// CRs: 7,8,9,10,15,18            Faction: Hostil
string ADE_Bestias_Dry_getVariado();
string ADE_Bestias_Dry_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "007,M,030,110,????????,basilisk001      "; // Magical Beast 8 (F: Hostil) Basilisco D&D
//    arregloDVDs +=  "006,S,045,109,????????,ps005            "; // magical beast 6  "Magical Beasts / Manticora D&D" 6.94 Hostile [5 x Manticore Spikes] NO PERTENECE AL AMBIENTE
    arregloDVDs +=  "008,S,050,109,????????,ps006            "; // magical beast 9 (F: Hostil) "Magical Beasts / Quimera D&D" [15 x Cone of Fire]
    arregloDVDs +=  "009,M,022,110,????????,gorgon002        "; // Magical Beast 9 (F:Hostil)  Gorgon D&D
    arregloDVDs +=  "010,S,050,107,????????,ps007            "; // Magical Beast 12(F: Hostil) "Magical Beasts / Terraron D&D" [nada]
//    arregloDVDs +=  "008,S,045,110,????????,sphinx001        "; // Androesfinge cr9
//    arregloDVDs +=  "008,S,045,110,????????,gynosphinx001    "; // Gynoesfinge cr8
    arregloDVDs +=  "015,S,050,109,????????,ps011            "; // magical beast 18 (F: Hostil)"Magical Beasts / Quimera D&D" [15 x Cone of Fire] //
    arregloDVDs +=  "018,S,050,107,????????,ps012            "; // Magical Beast 21(F: Hostil) "Magical Beasts / Terraron D&D" [nada]
    return arregloDVDs;
}


//____________________________Bestias / Forest Summer _______________________________
// CRs: 3-14            Factions: Animal, Hostil, Goblins, Osos
string ADE_Bestias_ForestS_getVariado();
string ADE_Bestias_ForestS_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "003,M,023,110,????????,am004            "; // Magical Beast 4 (F: Animal)  "Magical Beasts / Perro Intermitente D&D"
    arregloDVDs +=  "004,M,070,130,????????,as001            "; // Magical Beast 4 (F: Hostil)  "Magical Beast / Krenshar D&D"
    arregloDVDs +=  "005,M,023,110,????????,vr_dint_cr05     "; //
    arregloDVDs +=  "006,M,030,110,????????,pm004            "; // magical beast 6 (F: Hostil)  "Magical Beast / Bestia Tremula D&D"
    arregloDVDs +=  "006,M,070,130,????????,vr_kr_cr06       "; //
    arregloDVDs +=  "007,M,022,110,????????,huargo001        "; // Magical Beast 8 (F: Goblins) "Huargo D&D"
    arregloDVDs +=  "007,M,023,110,????????,vr_dint_cr07     "; //
    arregloDVDs +=  "008,S,045,110,????????,as0013           "; // Magical Beast 10 (F: Osos)   "Magical Beast / Oso Lechuza D&D" 8.97          Visto Mod
    arregloDVDs +=  "008,M,070,130,????????,vr_kr_cr08       "; //
    arregloDVDs +=  "011,M,022,110,????????,huargo002        "; // Magical Beast 16 (F: Animales)"Magical Beast / Huargo D&D" 12.7              Visto Mod
    arregloDVDs +=  "012,M,022,110,????????,vr_huarg_cr12    "; //
    arregloDVDs +=  "012,M,030,110,????????,pm006            "; // magical beast 15 (F: Hostil) "Magical Beast / Bestia Tremula D&D" 14.55      Visto Mod
    arregloDVDs +=  "013,M,022,110,????????,vr_huarg_cr13    "; //
    arregloDVDs +=  "014,S,045,110,????????,as014            "; // Magical Beast 19 (F: Osos)   "Magical Beasts / Oso Lechuza D&D" 17.34
    arregloDVDs +=  "014,M,022,110,????????,vr_huarg_cr14    "; //
    arregloDVDs +=  "016,M,022,110,????????,vr_huarg_cr16    "; //
    arregloDVDs +=  "016,S,045,110,????????,vr_oslech_cr16   "; //
    arregloDVDs +=  "018,S,045,110,????????,vr_oslech_cr18   "; //
    arregloDVDs +=  "018,M,022,110,????????,vr_huarg_cr18    "; //
    arregloDVDs +=  "020,S,045,110,????????,vr_oslech_cr20   "; //
    arregloDVDs +=  "022,S,045,110,????????,vr_oslech_cr22   "; //
    arregloDVDs +=  "024,S,045,110,????????,vr_oslech_cr24   "; //
    return arregloDVDs;
}


//____________________________Bestias / Forest Winter _______________________________
// CRs: 5-14            Factions: Goblins, Osos, Hostil
string ADE_Bestias_ForestW_getVariado();
string ADE_Bestias_ForestW_getVariado() {
    string arregloDVDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "005,M,030,110,????????,creature012      "; // Magical Beast 6 (F: Hostil)  Lobo Invernal D&D
    arregloDVDs +=  "007,M,022,110,????????,huargo001        "; // Magical Beast 8 (F: Goblins) "Huargo D&D"
    arregloDVDs +=  "008,S,045,110,????????,as0013           "; // Magical Beast 8 (F: Osos)    "Beasts / Oso Lechuza D&D"
    arregloDVDs +=  "011,M,022,110,????????,huargo002        "; // Magical Beast 13 (F: Goblins)"Huargo D&D"
    arregloDVDs +=  "014,S,045,110,????????,as014            "; // Magical Beast 15 (F: Osos)   "Beasts / Oso Lechuza D&D"
    return arregloDVDs;
}


//____________________________Bestias / Hills _______________________________
// CRs: 3-18        Factions: Goblins, Animal, Hostil
string ADE_Bestias_Hills_getVariado();
string ADE_Bestias_Hills_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "003,M,023,110,????????,am004            "; // Magical Beast 4 (F: Animal) "Magical Beasts / Perro Intermitente D&D"
//    arregloDVDs +=  "005,S,070,109,????????,ps005            "; // magical beast 6  "Magical Beasts / Manticora D&D" [5 x Manticore Spikes] NO PERTENECE AL AMBIENTE
    arregloDVDs +=  "005,M,023,110,????????,vr_dint_cr05     "; //
    arregloDVDs +=  "006,M,030,110,????????,pm004            "; // magical beast 6 (F: Hostil) "Magical Beast / Bestia Tremula D&D"
    arregloDVDs +=  "007,M,022,110,????????,huargo001        "; // Magical Beast 8 (F: Goblins)"Huargo D&D"
    arregloDVDs +=  "007,M,023,110,????????,vr_dint_cr07     "; //
    arregloDVDs +=  "008,S,050,109,????????,ps006            "; // magical beast 9 (F: Hostil) "Magical Beasts / Quimera D&D" [15 x Cone of Fire] //
//    arregloDVDs +=  "008,S,033,106,????????,ps008            "; // beast 10         "Magical Beasts / Desgarrador Gris D&D" NO PERTENECE AL AMBIENTE
    arregloDVDs +=  "010,S,050,107,????????,ps007            "; // Magical Beast 12(F: Hostil) "Magical Beasts / Terraron D&D" [nada]
    arregloDVDs +=  "011,M,022,110,????????,huargo002        "; // Magical Beast 13 (F: Goblins)    "Huargo D&D"
    arregloDVDs +=  "012,M,022,110,????????,vr_huarg_cr12    "; //
    arregloDVDs +=  "012,S,050,107,????????,vr_terra_cr12    "; //
    arregloDVDs +=  "012,M,030,110,????????,pm006            "; // magical beast 12 (F: Hostil) "Magical Beast / Bestia Tremula D&D"
    arregloDVDs +=  "013,S,050,109,????????,vr_qui_cr13      "; //
    arregloDVDs +=  "013,M,022,110,????????,vr_huarg_cr13    "; //
    arregloDVDs +=  "014,S,050,107,????????,vr_terra_cr14    "; //
    arregloDVDs +=  "014,M,022,110,????????,vr_huarg_cr14    "; //
    arregloDVDs +=  "015,S,050,109,????????,ps011            "; // magical beast 18 (F: Hostil) "Magical Beasts / Quimera D&D" [15 x Cone of Fire] //
    arregloDVDs +=  "016,M,022,110,????????,vr_huarg_cr16    "; //
    arregloDVDs +=  "016,S,050,107,????????,vr_terra_cr16    "; //
    arregloDVDs +=  "017,S,050,109,????????,vr_qui_cr17      "; //
    arregloDVDs +=  "018,S,050,107,????????,ps012            "; // Magical Beast 21(F: Hostil) "Magical Beasts / Terraron D&D" [nada]
    arregloDVDs +=  "018,M,022,110,????????,vr_huarg_cr18    "; //
    arregloDVDs +=  "019,S,050,109,????????,vr_qui_cr19      "; //

    return arregloDVDs;
}


//____________________________Bestias / Swamp _______________________________
// CRs: 7-17            Faction: Hostil
string ADE_Bestias_Swamp_getVariado();
string ADE_Bestias_Swamp_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs += "007,S,070,109,????????,ps005            "; // Magical Beast 6  "Magical Beasts / Manticora D&D" [5 x Manticore Spikes]
    arregloDVDs += "008,S,033,106,????????,ps008            "; // MAgical Beast 10 "Magical Beasts / Desgarrador Gris D&D"
    arregloDVDs += "012,S,033,106,????????,ps013            "; // MAgical Beast 15 "Magical Beasts / Desgarrador Gris D&D"
    arregloDVDs += "015,S,070,109,????????,ps010            "; // Magical Beast 16 "Magical Beasts / Manticora D&D" [5 x Manticore Spikes]
    arregloDVDs += "015,S,070,109,????????,vr_mant_cr10     "; //
    arregloDVDs += "017,S,033,106,????????,ps014            "; // MAgical Beast 21 "Magical Beasts / Desgarrador Gris D&D"
    arregloDVDs += "017,S,070,109,????????,vr_mant_cr17     "; //
    arregloDVDs += "019,S,033,106,????????,vr_des_cr19      "; //
    arregloDVDs += "019,S,070,109,????????,vr_mant_cr19     "; //

    return arregloDVDs;
}


//____________________________Bestias / Underground _______________________________
// CRs: 6-15            Factions: Hostil
string ADE_Bestias_Under_getVariado();
string ADE_Bestias_Under_getVariado() {
    string arregloDVDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "006,M,030,110,????????,pm004            "; // magical beast 6 (F: Hostil) "Magical Beast / Bestia Tremula D&D"
    arregloDVDs +=  "007,M,030,110,????????,basilisk001      "; // Magical Beast 8 (F: Hostil) Basilisco D&D
    arregloDVDs +=  "012,M,030,110,????????,pm006            "; // magical beast 12(F: Hostil) "Magical Beast / Bestia Tremula D&D"
    arregloDVDs +=  "014,S,033,105,????????,ps0010           "; // magical beast 16(F: Hostil) "Magical Beasts / Gusano Purpura D&D" [no se mueve]
    arregloDVDs +=  "015,M,030,110,????????,basilisk002      "; // Magical Beast 18(F: Hostil) Gran Basilisco Abysal D&D
    return arregloDVDs;
}

////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// CAMBIAFORMAS ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//__________________________Cambiaformas / Aranea _____________________________________
// CRs: 3
string ADE_Cambiaformas_Aranea_get();
string ADE_Cambiaformas_Aranea_get() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,aranea001        "; // Aranea D&D cr4
    return arregloDMDs;
}


//__________________________Cambiaformas / Barghest _____________________________________
// CRs: 3,5
string ADE_Cambiaformas_Barg_get();
string ADE_Cambiaformas_Barg_get() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,zep_barghest001  "; // Barghest D&D cr4
    arregloDMDs += "005,M,023,110,????????,zep_barghest002  "; // Large Barghest D&D cr5
    return arregloDMDs;
}

////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// CIENOS /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//_____________________________ Cienos _____________________________________________________
// CRs: 4,5,6
string ADE_Cienos_getVariado();
string ADE_Cienos_getVariado() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="004,S,030,110,????????,cubo             "; // ooze 5  "Oozes / Cubo Gelatinoso"      3.40
    arregloDVDs +="004,M,030,110,????????,vr_cie_cr04      "; //
    arregloDVDs +="005,M,030,110,????????,cieno001         "; // ooze 4  "Oozes / Cieno"                4.35 Hostil { 10 x Bolt, Acid }
    arregloDVDs +="005,M,023,110,????????,vr_cie_cr05      ";
    arregloDVDs +="006,M,023,110,????????,pm005            "; // ooze 6  "Oozes / Gelatina Ocre D&D"    4.43 Hostil { 5 x Bolt Acid }
//    arregloDVDs +="005,M,023,110,????????,pm005b            "; // ooze 6  "Oozes / Gelatina Ocre D&D" 4.43 Hostil { 5 x Bolt Acid }  QUITADA porque es igual a la pm005
//    arregloDVDs +="006,S,030,110,????????,vr_cubo_cr06     "; // QUITADO porque no existe
    arregloDVDs +="006,M,030,110,????????,vr_cie_cr06      "; //
    arregloDVDs +="006,M,023,110,????????,vr_jelly_cr06    "; //
    return arregloDVDs;
}

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// CONSTRUCTOS ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//__________________________Construct / Animated Mixed1 _____________________________________
// CRs: 1,2,3
string ADE_Animated_Mixed1_getVariado();
string ADE_Animated_Mixed1_getVariado() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "001,M,022,110,????????,zep_animtome002  "; // Libros animados D&D
    arregloDMDs += "002,M,022,110,????????,zep_animtome003  "; // Libros animados D&D
    arregloDMDs += "002,M,022,110,????????,zep_mechspide001 "; // Araña Mecanica D&D CR2
    arregloDMDs += "002,M,022,110,????????,zep_animchest001 "; // Baul Animado D&DCR2
    arregloDMDs += "002,M,022,110,????????,zep_animcutte001 "; // Cortadora Animada D&D CR2
    arregloDMDs += "002,M,022,110,????????,zep_animtable001 "; // Animated Table D&D CR2
    arregloDMDs += "002,M,022,110,????????,zep_mechspide001 "; // Araña Mecanica D&D CR2
    arregloDMDs += "002,M,022,110,????????,zep_animchest001 "; // Baul Animado D&DCR2
    arregloDMDs += "002,M,022,110,????????,zep_animcutte001 "; // Cortadora Animada D&D CR2
    arregloDMDs += "002,M,022,110,????????,zep_animtable001 "; // Animated Table D&D CR2
    arregloDMDs += "003,M,022,110,????????,zep_animtome004  "; // Libros animados D&D
    arregloDMDs += "003,M,022,110,????????,zep_spiker001    "; // Spiker D&D CR3
    arregloDMDs += "003,M,022,110,????????,zep_spiker001    "; // Spiker D&D CR3
    return arregloDMDs;
}


//__________________________ Construct / Espantapajaros _____________________________________
// CRs: 1
string ADE_Scare_Crow_get();
string ADE_Scare_Crow_get() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "001,M,023,110,????????,zep_scarecr001   "; // Espantapajaros Animado D&D CR2
    return arregloDMDs;
}


//__________________________ Construct / Golems Arcilla _____________________________________
// CRs: 10
string ADE_Golem_Arcilla_getVariado();
string ADE_Golem_Arcilla_getVariado() {
    string arregloDMDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "010,M,022,110,????????,golclay001       "; // GOlem de Arcilla D&D CR10
    return arregloDMDs;
}


//__________________________ Construct / Golems Emerald _____________________________________
// CRs: 12
string ADE_Golem_Emeral_getVariado();
string ADE_Golem_Emeral_getVariado() {
    string arregloDMDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "012,M,022,110,????????,golemesmeralda1  "; // GOlem de Esmeralda D&D CR12
    return arregloDMDs;
}


//__________________________ Construct / Golems Flesh _____________________________________
// CRs: 7
string ADE_Golem_Flesh_getVariado();
string ADE_Golem_Flesh_getVariado() {
    string arregloDMDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "007,M,022,110,????????,golflesh001      "; // GOlem de Carne CR7
    return arregloDMDs;
}


//__________________________ Construct / Golems Iron _____________________________________
// CRs: 13
string ADE_Golem_Iron_getVariado();
string ADE_Golem_Iron_getVariado() {
    string arregloDMDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "013,M,022,110,????????,goliron001       "; // GOlem de Hierro CR13
    return arregloDMDs;
}


//__________________________ Construct / Golems Piedra _____________________________________
// CRs: 11,16
string ADE_Golem_Stone_getVariado();
string ADE_Golem_Stone_getVariado() {
    string arregloDMDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "011,M,022,110,????????,golstone001      "; // GOlem de Piedra CR11
    arregloDMDs +=  "016,M,022,110,????????,golstone002      "; // GOlem de Piedra CR16
    return arregloDMDs;
}


//__________________________ Construct / Golems Ruby _____________________________________
// CRs: 11
string ADE_Golem_Ruby_getVariado();
string ADE_Golem_Ruby_getVariado() {
    string arregloDMDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "011,M,022,110,????????,golemderuby      "; // GOlem de Rubi CR11
    return arregloDMDs;
}


//__________________________ Construct / Guardianes _____________________________________
// CRs: 8,10
string ADE_Golem_Guard_getVariado();
string ADE_Golem_Guard_getVariado() {
    string arregloDMDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "008,M,022,110,????????,shguard001       "; // Guardian Escudo CR8
    arregloDMDs +=  "010,M,022,110,????????,helmedhorror1    "; // Guardian Escudo CR10
    return arregloDMDs;
}

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// ELEMENTALES ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//__________________________ Elementals / Air _____________________________________
// CRs: 2,3,5
string ADE_Elemental_Air_getVariado();
string ADE_Elemental_Air_getVariado() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "002,M,022,110,????????,zep_elemairs001  "; // Elemental de Aire CR1
    arregloDMDs += "003,M,022,110,????????,zep_elemairs002  "; // Elemental de Aire CR3
    arregloDMDs += "005,M,022,110,????????,zep_elemairs004  "; // Elemental de Aire CR5
    return arregloDMDs;
}


//__________________________ Elementals / Other _____________________________________
// CRs: 5,7
string ADE_Elemental_Other_getVariado();
string ADE_Elemental_Other_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "005,M,022,110,????????,zep_belker001    "; // Belker D&D CR6
    arregloDVDs +=  "007,M,022,110,????????,invstalk001      "; // Acechador Invisible CR7
    return arregloDVDs;
}


//__________________________ Elementals / Earth _____________________________________
// CRs: 2,3,5,7,9,11
string ADE_Elemental_Earth_getVariado();
string ADE_Elemental_Earth_getVariado() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "002,M,022,110,????????,zep_elemearth002 "; // Elemental de Tierra CR1
    arregloDMDs += "003,M,022,110,????????,zep_elemearth003 "; // Elemental de Tierra CR3
    arregloDMDs += "005,M,022,110,????????,zep_elemearth004 "; // Elemental de Tierra CR5
    arregloDMDs += "007,M,022,110,????????,zep_elemearth005 "; // Elemental de Tierra CR7
    arregloDMDs += "009,M,022,110,????????,zep_elemearth006 "; // Elemental de Tierra CR9
    arregloDMDs += "011,M,022,110,????????,zep_elemearth007 "; // Elemental de Tierra CR11
    return arregloDMDs;
}


//__________________________ Elementals / Fire _____________________________________
// CRs: 2,3,5,7,9,11
string ADE_Elemental_Fire_getVariado();
string ADE_Elemental_Fire_getVariado() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "002,M,022,110,????????,zep_elemfires001 "; // Elemental de Fuego CR1
    arregloDMDs += "003,M,022,110,????????,zep_elemfirem001 "; // Elemental de Fuego CR3
    arregloDMDs += "005,M,022,110,????????,zep_elemfirel001 "; // Elemental de Fuego CR5
    arregloDMDs += "007,M,022,110,????????,zep_elemfirel002 "; // Elemental de Fuego CR8
    arregloDMDs += "009,M,022,110,????????,zep_elemfirel003 "; // Elemental de Fuego CR9
    arregloDMDs += "011,M,022,110,????????,zep_elemfirel004 "; // Elemental de Fuego CR11
    return arregloDMDs;
}


//__________________________ Elementals / Water _____________________________________
// CRs: 2,3,5,7,9,11
string ADE_Elemental_Water_getVariado();
string ADE_Elemental_Water_getVariado() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "002,M,022,110,????????,zep_elemwater001 "; // Elemental de Agua CR1
    arregloDMDs += "003,M,022,110,????????,zep_elemwater010 "; // Elemental de Agua CR3
    arregloDMDs += "005,M,022,110,????????,zep_elemwater003 "; // Elemental de Agua CR5
    arregloDMDs += "007,M,022,110,????????,zep_elemwater008 "; // Elemental de Agua CR7
    arregloDMDs += "009,M,022,110,????????,zep_elemwater011 "; // Elemental de Agua CR9
    arregloDMDs += "011,M,022,110,????????,zep_elemwater006 "; // Elemental de Agua CR11
    return arregloDMDs;
}

//__________________________ Elementals / Cyclone Ravager _____________________________________
// CRs: 20,22,23,24,25
string ADE_Elemental_Cyclone_getVariado();
string ADE_Elemental_Cyclone_getVariado() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "020,M,022,110,????????,md_cyclonic01 "; // Elemental de Aire 20 (Cr 20)
    arregloDMDs += "022,M,022,110,????????,md_cyclonic02 "; // Elemental de Aire 22 (Cr 22)
    arregloDMDs += "023,M,022,110,????????,md_cyclonic03 "; // Elemental de Aire 25 (Cr 23)
    arregloDMDs += "024,M,022,110,????????,md_cyclonic04 "; // Elemental de Aire 26 (Cr 24)
    arregloDMDs += "025,M,022,110,????????,md_cyclonic05 "; // Elemental de Aire 28 (Cr 25)
    return arregloDMDs;
}


//__________________________ Paraelemental / Cieno _____________________________________
// CRs: 1,5,7,9,11      Factions: ?
string ADE_Paraelemental_Cieno_getVariado();
string ADE_Paraelemental_Cieno_getVariado() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "001,M,022,110,????????,cieno            "; // Paraelemental de Cieno Pequeño D&D CR1
    arregloDMDs += "005,M,022,110,????????,cieno002         "; // Paraelemental de Cieno Grande D&D CR5
    arregloDMDs += "007,M,022,110,????????,cieno003         "; // Paraelemental de Cieno Enorme D&D CR7
    arregloDMDs += "009,M,022,110,????????,cieno004         "; // Paraelemental de Cieno Mayor D&D CR9
    arregloDMDs += "011,M,022,110,????????,cieno005         "; // Paraelemental de Cieno Anciano D&D CR11
    return arregloDMDs;
}


//__________________________ Paraelemental / Hielo _____________________________________
// CRs: 1,3,5,7,11      Factions: ?
string ADE_Paraelemental_Hielo_getVariado();
string ADE_Paraelemental_Hielo_getVariado() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "001,M,022,110,????????,hielo            "; // Paraelemental de Hielo Pequeño D&D CR1
    arregloDMDs += "003,M,022,110,????????,hielo001         "; // Paraelemental de Hielo Mediano D&D CR3
    arregloDMDs += "005,M,022,110,????????,hielo002         "; // Paraelemental de Hielo Grande D&D CR5
    arregloDMDs += "007,M,022,110,????????,hielo003         "; // Paraelemental de Hielo Enorme D&D CR7
    arregloDMDs += "009,M,022,110,????????,hielo004         "; // Paraelemental de Hielo Mayor D&D CR9
    arregloDMDs += "011,M,022,110,????????,hielo005         "; // Paraelemental de Hielo Anciano D&D CR11
    return arregloDMDs;
}


//__________________________ Paraelemental / Humo _____________________________________
// CRs: 1,3,5,7,9,11      Factions: ?
string ADE_Paraelemental_Humo_getVariado();
string ADE_Paraelemental_Humo_getVariado() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "001,M,022,110,????????,humo             "; // Paraelemental de Humo Pequeño D&D CR1
    arregloDMDs += "003,M,022,110,????????,humo001          "; // Paraelemental de Humo Mediano D&D CR3
    arregloDMDs += "005,M,022,110,????????,humo002          "; // Paraelemental de Humo Grande D&D CR5
    arregloDMDs += "007,M,022,110,????????,humo003          "; // Paraelemental de Humo Enorme D&D CR7
    arregloDMDs += "009,M,022,110,????????,humo004          "; // Paraelemental de Humo Mayor D&D CR9
    arregloDMDs += "011,M,022,110,????????,humo005          "; // Paraelemental de Humo Anciano D&D CR11
    return arregloDMDs;
}



//__________________________ Paraelemental / Magma _____________________________________
// CRs: 1,3,5,7,9,11      Factions: ?
string ADE_Paraelemental_Magma_getVariado();
string ADE_Paraelemental_Magma_getVariado() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "001,M,022,110,????????,magma            "; // Paraelemental de Magma Pequeño D&D CR1
    arregloDMDs += "003,M,022,110,????????,magma001         "; // Paraelemental de Magma Mediano D&D CR3
    arregloDMDs += "005,M,022,110,????????,magma002         "; // Paraelemental de Magma Grande D&D CR5
    arregloDMDs += "007,M,022,110,????????,magma003         "; // Paraelemental de Magma Enorme D&D CR7
    arregloDMDs += "009,M,022,110,????????,magma004         "; // Paraelemental de Magma Mayor D&D CR9
    arregloDMDs += "011,M,022,110,????????,magma005         "; // Paraelemental de Magma Anciano D&D CR11
    return arregloDMDs;
}



////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// GIGANTES /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/*FUERA DE USO
//____________________________Giant / Ettin ________________________________
// CRs: 7      Factions: ?
string ADE_Giant_Ettin_get();
string ADE_Giant_Ettin_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "007,M,030,110,????????,ettin003         "; // Giant 10        "Giant / Common / Ettin D&D"
    return arregloDMDs;
}
*/

//____________________________Giant / Ettin ________________________________
// CRs: 6-10      Factions: Ogros, Orcos
string ADE_Giant_Ettin_getVariado();
string ADE_Giant_Ettin_getVariado() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "006,M,022,110,????????,mettin           "; // Giant  6 -  6.1 Ogros     "Giant / Common / Ettin flaco"
    arregloDMDs += "006,L,040,110,????????,mettino          "; // Giant  6 -  6.0 Hostile   "Giant / Common / Ettin D&D", Seguidor: orco009, Salvaje Orco D&D Barbarian 6, Cr 5
    arregloDMDs += "007,M,022,110,????????,mettin001        "; // Giant  8 -  7.4 Ogros     "Giant / Common / Ettin D&D"
    arregloDMDs += "007,L,050,110,????????,mettin001b       "; // Giant  8 -  7.4 Hostile   "Giant / Common / Ettin D&D", Seguidor: orco009, Salvaje Orco D&D Barbarian 6, Cr 5
    arregloDMDs += "008,M,022,110,????????,mettin002        "; // Giant  9 -  8.8 Ogros     "Giant / Common / Ettin D&D"
    arregloDMDs += "008,L,033,110,????????,mettin002o       "; // Giant  9 -  8.8 Hostile   "Giant / Common / Ettin D&D", Seguidor: orcog002, Salvaje Orco D&D Barbarian 8, Cr 7
    arregloDMDs += "009,M,022,110,????????,mettin003        "; // Giant 10 - 10.3 Ogros     "Giant / Common / Ettin D&D"
    arregloDMDs += "010,M,022,110,????????,mettin004        "; // Giant 12 - 11.7 Ogros     "Giant / Common / Ettin D&D"
    arregloDMDs += "010,L,033,110,????????,mettin004o       "; // Giant 12 - 11.7 Hostile   "Giant / Common / Ettin D&D", Seguidor; orco010, Barbaro Orco D&D Barbarian 11, Cr 9
    arregloDMDs += "011,L,033,110,????????,vr_ett_cr11      "; //
    arregloDMDs += "012,M,022,110,????????,vr_ett_cr12      "; //
    arregloDMDs += "013,M,022,110,????????,vr_ett_cr13      "; //
    arregloDMDs += "014,M,022,110,????????,vr_ett_cr14      "; //
    arregloDMDs += "016,M,022,110,????????,vr_ett_cr16      "; //
    arregloDMDs += "018,M,022,110,????????,vr_ett_cr18      "; //
    return arregloDMDs;
}

//____________________________Giant / Frost ________________________________
// CRs: 9,11,20      Factions: ?
string ADE_Giant_Frost_get();
string ADE_Giant_Frost_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "009,M,023,110,????????,gntfrost001      "; // Frost Giant CR9
    arregloDMDs += "011,M,023,110,????????,gntfrost003      "; // Frost Giant CR11
    arregloDMDs += "020,M,023,110,????????,gntfrost002      "; // Frost Giant CR20
    return arregloDMDs;
}


//____________________________Giant / Fire ________________________________
// CRs: 10      Factions: ?
string ADE_Giant_Fire_get();
string ADE_Giant_Fire_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "010,M,023,110,????????,gntfire001       "; // Fire Giant CR10
    arregloDMDs += "010,M,023,110,????????,gntfire002       "; // Fire Giant CR10
    return arregloDMDs;
}


//____________________________Giant / Hill ________________________________
// CRs: 7-12      Factions: Hostil
string ADE_Giant_Hill_get();
string ADE_Giant_Hill_get() {
    string arregloDVDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs += "007,M,023,110,????????,hgiant1          "; //  "Giant / Gigante de las Colinas D&D" hostil
    arregloDVDs += "008,M,023,110,????????,hgiant2          "; //  "Giant / Gigante de las Colinas D&D" hostil
    arregloDVDs += "009,M,023,110,????????,hgiant3          "; //  "Giant / Gigante de las Colinas D&D" hostil
    arregloDVDs += "010,M,023,110,????????,hgiant4          "; //  "Giant / Gigante de las Colinas D&D" hostil
    arregloDVDs += "011,M,023,110,????????,hgiant5          "; //  "Giant / Gigante de las Colinas D&D" hostil
    arregloDVDs += "012,M,023,110,????????,hgiant6          "; //  "Giant / Gigante de las Colinas D&D" hostil
    return arregloDVDs;
}


//__________________________Giants / Ogros _____________________________________
// CRs: 5      Factions: ?
string ADE_Giant_Ogro_getCaster();
string ADE_Giant_Ogro_getCaster() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "008,L,023,110,????????,ogremage003       "; // giant 5                "Ogro Hechicero D&D"
    return arregloDMDs;
}

// CRs: 4,8      Factions: ?
string ADE_Giant_Ogro_getMelee();
string ADE_Giant_Ogro_getMelee() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "003,M,023,110,????????,ogre002          "; // giant 4               "Giant / Ogres / Ogro D&D"
    arregloDMDs +=  "007,M,023,110,????????,ogre003          "; // giant 4 barbarian 4   "Giant / Ogres / Ogro Barbaro D&D"
    return arregloDMDs;
}


//____________________________Giant / Troll ________________________________
// CRs: 4,9      Factions: ?
string ADE_Giant_Troll_getVariado();
string ADE_Giant_Troll_getVariado() {
    string arregloDVDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs += "004,S,045,110,????????,ps003            "; // giant 6          "Giant / Trolls / Troll D&D"
    arregloDVDs += "009,S,045,110,????????,ps009            "; // giant 6 ranger 6 "Giant / Trolls / Troll Hunter D&D"
    return arregloDVDs;
}

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// HUMANOIDES  ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//__________________________ Humanoids / Arpias _____________________________________
// CRs: 4     Factions: ?
string ADE_Humanoid_Arpias_getVariado();
string ADE_Humanoid_Arpias_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "004,S,030,110,????????,harpy002         "; // Arpia D&D CR4
    arregloDVDs +=  "004,M,030,110,????????,pm003            "; // monstrous 7      "Humanoid / Other / Arpia D&D" [1 x Captivating Song]
    arregloDVDs +=  "004,S,030,110,????????,pm003a           "; // Arpia D&D CR4
    arregloDVDs +=  "004,S,030,110,????????,pm003b           "; // Arpia D&D CR4
    return arregloDVDs;
}


//__________________________ Humanoids / Fatas _____________________________________
// CRs: 2,4      Factions: ?
string ADE_Humanoid_Fatas_getVariado();
string ADE_Humanoid_Fatas_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "002,M,030,110,????????,dryad001         "; // Driada D&D CR2
    arregloDVDs +=  "004,M,030,110,????????,pixie001         "; // Pixie D&D CR4
    return arregloDVDs;
}


//____________________________Humanoids / Gnolls _______________________________
// CRs: 4,5      Factions: Gnoll
string ADE_Humanoid_Gnoll_getCaster();
string ADE_Humanoid_Gnoll_getCaster() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "004,M,023,110,????????,gn003            "; // cleric 5       "Humanoid / Other / Gnoll Clerigo D&D" 4.59 Gnoll
    arregloDMDs +=  "005,M,023,110,????????,gn004            "; // druid 5        "Humanoid / Other / Gnoll Druid D&D" 4.38 Gnoll
    return arregloDMDs;
}

// CRs: 2-16      Factions: Gnoll
string ADE_Humanoid_Gnoll_getMelee();
string ADE_Humanoid_Gnoll_getMelee() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "002,M,023,110,????????,mGnoll           "; // Gnoll D&D, Humanoid 2
    arregloDMDs +=  "003,M,023,110,????????,mGnollBarb02     "; // Salvaje Gnoll D&D, Humanoid 2 Barbarian 2
    arregloDMDs +=  "003,M,023,110,????????,mGnollBarb02b    "; // Salvaje Gnoll D&D, Humanoid 2 Barbarian 2
    arregloDMDs +=  "005,M,023,110,????????,mGnollBarb04     "; // Salvaje Gnoll D&D, Humanoid 2 Barbarian 4
    arregloDMDs +=  "005,M,023,110,????????,mGnollBarb04b    "; // Salvaje Gnoll D&D, Humanoid 2 Barbarian 4
    arregloDMDs +=  "007,M,023,110,????????,mGnollBarb06     "; // Salvaje Gnoll D&D, Humanoid 2 Barbarian 6
    arregloDMDs +=  "007,M,023,110,????????,mGnollBarb06b    "; // Salvaje Gnoll D&D, Humanoid 2 Barbarian 6
    arregloDMDs +=  "009,M,023,110,????????,mGnollBarb09     "; // Salvaje Gnoll D&D, Humanoid 2 Barbarian 9
    arregloDMDs +=  "009,M,023,110,????????,mGnollBarb09b    "; // Salvaje Gnoll D&D, Humanoid 2 Barbarian 9
    arregloDMDs +=  "012,M,023,110,????????,mGnollBarb12     "; // Salvaje Gnoll D&D, Humanoid 2 Barbarian 12
    arregloDMDs +=  "012,M,023,110,????????,mGnollBarb12b    "; // Salvaje Gnoll D&D, Humanoid 2 Barbarian 12
    arregloDMDs +=  "014,M,023,110,????????,mGnollBarb15     "; // Salvaje Gnoll D&D, Humanoid 2 Barbarian 15
    arregloDMDs +=  "014,M,023,110,????????,mGnollBarb15b    "; // Salvaje Gnoll D&D, Humanoid 2 Barbarian 15
    arregloDMDs +=  "016,M,023,110,????????,mGnollBarb18     "; // Salvaje Gnoll D&D, Humanoid 2 Barbarian 18
    arregloDMDs +=  "016,M,023,110,????????,mGnollBarb18b    "; // Salvaje Gnoll D&D, Humanoid 2 Barbarian 18
    return arregloDMDs;
}


/*
//_____________________________Humanoids / Gran Trasgo _____________________________
// CRs: 4      Factions: ?
string ADE_Humanoid_Hobgoblin_getCaster();
string ADE_Humanoid_Hobgoblin_getCaster() {
    string arregloDMDs;
                 //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=   "004,M,023,110,????????,trasgo010        "; // Chaman Gran Trasgo
    return arregloDMDs;
}

// CRs: 5      Factions: ?
string ADE_Humanoid_Hobgoblin_getMelee();
string ADE_Humanoid_Hobgoblin_getMelee() {
    string arregloDMDs;
                   //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=     "005,M,023,110,????????,trasgo012        "; // Gran Trasgo
    return arregloDMDs;
}
*/


//____________________________Humanoids / Kobolds _______________________________
// CRs: 6      Factions: ?
string ADE_Humanoid_Kobold_getCaster();
string ADE_Humanoid_Kobold_getCaster() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "006,M,023,110,????????,kb006            "; // humanoid 4 cleric 7            "Humanoid / Lizardfolk / Kobold Curandero D&D"
    arregloDMDs +=  "006,M,023,110,????????,kb005            "; // humanoid 4 sorcerer 7          "Humanoid / Lizardfolk / Kobold Shaman D&D"
    return arregloDMDs;
}

// CRs: 3,4,5,6      Factions: ?
string ADE_Humanoid_Kobold_getMelee();
string ADE_Humanoid_Kobold_getMelee() {
    string arregloDMDs;
                   //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=     "003,M,023,110,????????,kb001            "; // humanoid 4                     "Humanoid / Lizardfolk / Kobold Combatiente D&D"
    arregloDMDs +=     "004,M,023,110,????????,kb003            "; // humanoid 4 rogue 2             "Humanoid / Lizardfolk / Kobold Sargento D&D"
    arregloDMDs +=     "005,M,023,110,????????,kb002            "; // humanoid 4 rogue 4             "Humanoid / Lizardfolk / Kobold Teniente D&D"
    arregloDMDs +=     "006,M,023,110,????????,kb004            "; // humanoid 4 rogue 5 assasin 1   "Humanoid / Lizardfolk / Kobold Capitan D&D"
    return arregloDMDs;
}


//____________________________Humanoids / Hag_____(se acompaña de gigantes y ogros)____
// CRs: 4      Factions: ?
string ADE_Humanoid_Hag_get();
string ADE_Humanoid_Hag_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "004,S,045,110,????????,ps004            "; // monstrous 3      "Humanoid / Other / Saga Marina D&D" { 3 x Fear [Caster Level:15], 3 x Phantasmal Killer [Caster Level:3], 1 x Horrific Appearance }
    return arregloDMDs;
}

/*FUERA DE USO
//____________________________Humanoids / Lizardmen _______________________________
// CRs: 6,7,8,9      Factions: ?
string ADE_Humanoid_Lizardmen_getCaster();
string ADE_Humanoid_Lizardmen_getCaster() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "006,M,023,110,????????,hombrelagarto007 "; //humanoid 2 clerig 6 "Humanoid / Lizardfolk / Hombre Lagarto Chaman"                7.61 Hostile
    arregloDMDs += "007,M,023,110,????????,hombrelagarto008 "; //humanoid 2 clerig 7 "Humanoid / Lizardfolk / Hombre Lagarto Gran Chaman"           8.57 Hostile
    arregloDMDs += "008,M,023,110,????????,hombrelagarto009 "; //humanoid 2 clerig 8 "Humanoid / Lizardfolk / Hombre Lagarto Señor de los Chamanes" 9.4  Hostile
    arregloDMDs += "009,M,023,110,????????,hombrelagarto006 "; //humanoid 2 druid 9  "Humanoid / Lizardfolk / Hombre Lagarto Gran Druida"           10.14 Hostile
    return arregloDMDs;
}

// CRs: 5,6,7,8      Factions: ?
string ADE_Humanoid_Lizardmen_getMelee();
string ADE_Humanoid_Lizardmen_getMelee() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "006,M,023,110,????????,hombrelagarto001 "; //humanoid 3 barbarian 4 "Humanoid / Lizardfolk / Hombre Lagarto Barbaro"            6.32 Hostile
    arregloDMDs += "006,M,023,110,????????,hombrelagarto002 "; //humanoid 2 barbarian 5 "Humanoid / Lizardfolk / Hombre Lagarto Veterano"           6.34 Hostile
    arregloDMDs += "007,M,023,110,????????,hombrelagarto003 "; //humanoid 2 barbarian 6 "Humanoid / Lizardfolk / Hombre Lagarto Lider"              7.13 Hostile
    arregloDMDs += "008,M,023,110,????????,hombrelagarto004 "; //humanoid 2 barbarian 7 "Humanoid / Lizardfolk / Hombre Lagarto Berserker"          8.13 Hostile
    arregloDMDs += "009,M,023,110,????????,hombrelagarto005 "; //humanoid 2 barbarian 8 "Humanoid / Lizardfolk / Hombre Lagarto Campeon"            8.81 Hostile
    return arregloDMDs;
}
*/

//____________________________Humanoids / Lizardmen _______________________________
// CRs: 4-16      Factions: Dragones
string ADE_Humanoid_Lizardmen_getCaster();
string ADE_Humanoid_Lizardmen_getCaster() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "004,M,023,110,????????,mlizardshaman    "; //Shaman Hombre Lagarto D&D Humanoid 2 Druid 3
    arregloDMDs += "005,M,023,110,????????,mlizardbruja     "; //Bruja Hombre Lagarto D&D Humanoid 2 Sorcecer 4
    arregloDMDs += "007,M,023,110,????????,mlizardshaman001 "; //Shaman Hombre Lagarto D&D Humanoid 2 Druid 6
    arregloDMDs += "008,M,023,110,????????,mlizardbruja001  "; //Bruja Hombre Lagarto D&D Humanoid 2 Sorcecer 8
    arregloDMDs += "009,M,023,110,????????,mlizardshaman002 "; //Shaman Hombre Lagarto D&D Humanoid 2 Druid 9 (club) 9.68
    arregloDMDs += "011,M,023,110,????????,mlizardbruja002  "; //Gran Bruja Hombre Lagarto D&D Humanoid 4 Sorcecer 12 (staff) 13.1
    arregloDMDs += "012,M,023,110,????????,mlizardshaman003 "; //Gran Shaman Hombre Lagarto D&D Humanoid 4 Druid 13 (club) 14.5
    arregloDMDs += "013,M,023,110,????????,mlizardbruja003  "; //Gran Bruja Hombre Lagarto D&D Humanoid 4 Sorcecer 15 (staff) 15.9
    arregloDMDs += "014,M,023,110,????????,mlizardshaman004 "; //Gran Shaman Hombre Lagarto D&D Humanoid 4 Druid 15 (club) 17.3
    arregloDMDs += "015,M,023,110,????????,mlizardbruja004  "; //Gran Bruja Hombre Lagarto D&D Humanoid 6 Sorcecer 16 (staff) 18.8
    arregloDMDs += "016,M,023,110,????????,mlizardshaman005 "; //Gran Shaman Hombre Lagarto D&D Humanoid 6 Druid 18 (club) 20.2
    return arregloDMDs;
}

// CRs: 2-16      Factions: Dragones
string ADE_Humanoid_Lizardmen_getMelee();
string ADE_Humanoid_Lizardmen_getMelee() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,mlizardman       "; //"Hombre Lagarto D&D"         Humanoid 2 (garras 1d2) 1.7             Inqui: subi el CR desde 2, le bajé el daño
    arregloDMDs += "003,M,023,110,????????,mlizardman001    "; //"Hombre Lagarto Hembra D&D"  Humanoid 2 (garras 1d2) 1.7             Inqui: subi el CR desde 2, le bajé el daño
    arregloDMDs += "004,M,023,110,????????,mlizardbarb      "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 2 (axe) 3.6        Inqui: subi el CR desde 3
    arregloDMDs += "004,M,023,110,????????,mlizardbarbs     "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 2 (spear) 3.6      Inqui: subi el CR desde 3
    arregloDMDs += "005,M,023,110,????????,mlizardbarb001   "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 3 (axe) 4.49       Inqui: subi el CR desde 4
    arregloDMDs += "005,M,023,110,????????,mlizardbarb001g  "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 3 (spear) 4.48     Inqui: subi el CR desde 4
    arregloDMDs += "006,M,023,110,????????,mlizardbarb002   "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 4 (axe) 6.0        Inqui: subi el CR desde 5
    arregloDMDs += "006,M,023,110,????????,mlizardbarb003   "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 5
    arregloDMDs += "006,M,023,110,????????,mlizardbarb003s  "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 5 (spear)
    arregloDMDs += "007,M,023,110,????????,mlizardbarb004   "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 6
    arregloDMDs += "007,M,023,110,????????,mlizardsarge     "; //"Sargento Hombre Lagarto D&D" Humanoid 2 Barbarian 2 Fighter 4
    arregloDMDs += "008,M,023,110,????????,mlizardbarb005   "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 7
    arregloDMDs += "008,M,023,110,????????,mlizardbarb005s  "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 7 (Greataxe)
    arregloDMDs += "009,M,023,110,????????,mlizardbarb006   "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 8
    arregloDMDs += "009,M,023,110,????????,mlizardbarb006s  "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 8 (spear)
    arregloDMDs += "010,M,023,110,????????,mlizardbarb007   "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 9
    arregloDMDs += "010,M,023,110,????????,mlizardlieut     "; //"Teniente Hombre Lagarto D&D" Humanoid 2 Barbarian 5 Fighter 4
    arregloDMDs += "011,M,023,110,????????,mlizardbarb008   "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 11
    arregloDMDs += "012,M,023,110,????????,mlizardbarb009   "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 12
    arregloDMDs += "012,M,023,110,????????,mlizardbarb009s  "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 12 (spear)
    arregloDMDs += "012,M,023,110,????????,mlizardbarb009g  "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 12 (Greataxe)
    arregloDMDs += "012,M,023,110,????????,mlizardcapitan   "; //"Capitan Hombre Lagarto D&D" Humanoid 2 Barbarian 8 Fighter 4
    arregloDMDs += "013,M,023,110,????????,mlizardbarb010   "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 13
    arregloDMDs += "013,M,023,110,????????,mlizardbarb011   "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 14 (dwaraxe) 13.84             Inqui: Baje el CR desde 14
    arregloDMDs += "014,M,023,110,????????,mlizardbarb012   "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 15 (dwaraxe) 14.64             Inqui: Baje el CR desde 15
    arregloDMDs += "014,M,023,110,????????,mlizardbarb012s  "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 15 (spear) 14.64               Inqui: Baje el CR desde 15
    arregloDMDs += "014,M,023,110,????????,mlizardgral      "; //"General Hombre Lagarto D&D" Humanoid 2 Barbarian 11 Fighter 4 (GreatAxe) 15.0   Inqui: Baje el CR desde 15
    arregloDMDs += "015,M,023,110,????????,mlizardbarb013   "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 16 (Greataxe) 15.51            Inqui: Baje el CR desde 16
    arregloDMDs += "015,M,023,110,????????,mlizardbarb013s  "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 16 (Spear)15.61                Inqui: copia de mlizardbarb013 pero con spear
    arregloDMDs += "015,M,023,110,????????,mlizardbarb013w  "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 16 (Warhammer)15.51            Inqui: copia de mlizardbarb013 pero con warhamer
    arregloDMDs += "015,M,023,110,????????,mlizardbarb013g  "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 16 (Greataxe) 15.48            Inqui: Baje el CR desde 16
    arregloDMDs += "016,M,023,110,????????,mlizardbarb014   "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 18 (Battleaxe) 17.73           Inqui: Baje el CR de 17
    arregloDMDs += "016,M,023,110,????????,mlizardbarb014s  "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 18 (Spear) 17.73               Inqui: copia de mlizardbarb014 pero con spear
    arregloDMDs += "016,M,023,110,????????,mlizardbarb014w  "; //"Barbaro Hombre Lagarto D&D" Humanoid 2 Barbarian 18 (Warhammer) 17.73           Inqui: copia de mlizardbarb014 pero con warhammer
    arregloDMDs += "016,M,023,110,????????,mlizardchief     "; //"Cacique Hombre Lagarto D&D" Humanoid 2 Barbarian14 Fighter 4 (Battleaxe) 17.84  Inqui: Baje el CR desde 18
    return arregloDMDs;
}

//____________________________Humanoids / Medusa________________________________
// CRs: 7      Factions: ?
string ADE_Humanoid_Medusa_get();
string ADE_Humanoid_Medusa_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "007,M,023,110,????????,medusa001        "; // Monstrous 11
    return arregloDMDs;
}





//____________________________Humanoids / Minotauros________________________________
// CRs: 4,7,8,9      Factions: ?
string ADE_Humanoid_Minotauro_get();
string ADE_Humanoid_Minotauro_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "004,M,023,110,????????,minotaur001      "; // Minotauro cr4 Monstrous 11
    arregloDMDs += "007,M,023,110,????????,minotauro001     "; // Monstrous 11
    arregloDMDs += "008,M,023,110,????????,minotauro002     "; // Barbarian 6
    arregloDMDs += "009,M,023,110,????????,minotauro003     "; // Barbarian 7
    return arregloDMDs;
}



/* QUEDA FUERA DE USO
//____________________________Humanoids / Orcos ________________________________
// CRs: 3,4,5,6,7,8     Factions: Orco
string ADE_Humanoid_Orco_get();
string ADE_Humanoid_Orco_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,orco001          "; // humanoid 4
    arregloDMDs += "003,M,023,110,????????,orco002          "; // humanoid 4
    arregloDMDs += "004,M,023,110,????????,orco003          "; // numanoid 4, barbarian 1
    arregloDMDs += "005,M,023,110,????????,orco004          "; // humanoid 4, barbarian 2
    arregloDMDs += "005,M,023,110,????????,orco005          "; // humanoid 4, barbarian 2  "Humanoid / Orcs / Orco Teniente D&D"
    arregloDMDs += "006,M,023,110,????????,orco008          "; // humanoid 4, cleric    3
    arregloDMDs += "006,M,023,110,????????,orco006          "; // humanoid 4, barbarian 3  "Humanoid / Orcs / Orco Capitan D&D"
    arregloDMDs += "007,M,023,110,????????,orco007          "; // humanoid 4, barbarian 4
    arregloDMDs += "007,M,023,110,????????,orco009          "; // humanoid 4, barbarian 5
    arregloDMDs += "008,M,023,110,????????,orco010          "; // humanoid 4, barbarian 6
    return arregloDMDs;
}


//____________________________Humanoids / Orcos ________________________________
// CRs: 3,4,5,6,7,9,15      Factions: ?
string ADE_Humanoid_Orcob_get();
string ADE_Humanoid_Orcob_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,orca003          "; // Orco CR2
    arregloDMDs += "003,M,023,110,????????,orca005          "; // Orco CR3
    arregloDMDs += "004,M,023,110,????????,orca006          "; // Orco CR4
    arregloDMDs += "005,M,023,110,????????,orca007          "; // Orco CR4
    arregloDMDs += "005,M,023,110,????????,orca008          "; // Orco CR5
    arregloDMDs += "006,M,023,110,????????,orca012          "; // Orco CR5
    arregloDMDs += "006,M,023,110,????????,orca009          "; // Orco CR6
    arregloDMDs += "007,M,023,110,????????,orca010          "; // Orco CR7
    arregloDMDs += "009,M,023,110,????????,orca011          "; // Orco CR9
    arregloDMDs += "015,M,023,110,????????,orca013          "; // Orco CR15
    arregloDMDs += "015,M,023,110,????????,orca014          "; // Orco CR15
    arregloDMDs += "015,M,023,110,????????,orca015          "; // Orco CR15
    return arregloDMDs;
}
*/

//____________________________Humanoids / Orcos ________________________________
// CRs: 5-19     Factions: ORCOS
string ADE_Humanoid_Orco_getCaster();
string ADE_Humanoid_Orco_getCaster() {
    string arregloDMDs;
                 //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=   "005,L,023,110,????????,morcadept04      "; // Hechicero Orco D&D Sorcerer 6
    arregloDMDs +=   "005,L,023,110,????????,orco003          "; // Sargento Orco D&D Barbarian 3 Warchief 3
    arregloDMDs +=   "007,L,023,110,????????,morcgrunmsh04    "; // Ojo de Grummsh D&D Cleric 7 Eye of Grummsh 1
    arregloDMDs +=   "009,L,023,110,????????,morcadept10      "; // Brujo Orco D&D Sorcerer 11
    arregloDMDs +=   "009,L,023,110,????????,orclieut10       "; // Teniente Orco D&D Barbarian 3 Warchief 7
    arregloDMDs +=   "011,L,023,110,????????,morcgrunmsh12    "; // Ojo de Grummsh D&D Cleric 7 Eye of Grummsh 5
    arregloDMDs +=   "013,L,023,110,????????,morcadept13      "; // Brujo Orco D&D Sorcerer 16
    arregloDMDs +=   "014,L,023,110,????????,orccapt15        "; // Capitan Orco D&D Barbarian 5 Warchief 10
    arregloDMDs +=   "015,L,023,110,????????,morcgrunmsh17    "; // "Ojo de Grummsh D&D" Cleric 7 Eye of Grummsh 10 Humanoid 6; cr=18.8; spear
    arregloDMDs +=   "017,L,023,110,????????,morcadept17      "; // "Orco Gran Brujo D&D" Sorcerer 17 Humanoid 13; cr=21.6; staff
    arregloDMDs +=   "019,L,023,110,????????,morcgrunmsh20    "; // "Orco Ojo de Grummsh D&D" Cleric 10 Eye of Grummsh 5 Humanoid 15; cr=24.4; spear
    return arregloDMDs;
}

// CRs: 3-19     Factions: ORCOS
string ADE_Humanoid_Orco_getMelee();
string ADE_Humanoid_Orco_getMelee() {
    string arregloDMDs;
                   //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=     "003,M,023,110,????????,orca014          "; // Salvaje Orco D&D Barbarian 3
    arregloDMDs +=     "003,M,023,110,????????,morcscout04      "; // Acechador Orco D&D Barbarian 2 Rogue 2
    arregloDMDs +=     "004,M,023,110,????????,morcfight04      "; // Combatiente Orco D&D Fighter 4
    arregloDMDs +=     "005,M,023,110,????????,orco009          "; // Salvaje Orco D&D Barbarian 6
    arregloDMDs +=     "006,M,023,110,????????,orca003          "; // Combatiente Orco D&D Fighter 7
    arregloDMDs +=     "007,M,023,110,????????,orcog002         "; // Salvaje Orco D&D Barbarian 8
    arregloDMDs +=     "007,M,023,110,????????,morcscout06      "; // Acechador Orco D&D Barbarian 4 Rogue 4
    arregloDMDs +=     "008,M,023,110,????????,orca011          "; // Guerrero Orco D&D Fighter 9
    arregloDMDs +=     "009,M,023,110,????????,orco010          "; // Barbaro Orco D&D Barbarian 11
    arregloDMDs +=     "010,M,023,110,????????,orco0010         "; // Guerrero Orco D&D Fighter 11
    arregloDMDs +=     "010,M,023,110,????????,morcscout08      "; // Batidor Orco D&D Barbarian 6 Rogue 6
    arregloDMDs +=     "011,M,023,110,????????,orca002          "; // Barbaro Orco D&D Barbarian 13

    arregloDMDs +=     "012,M,023,110,????????,orco004          "; // "Orco Gran Guerrero D&D" Fighter 17; 14.5; Warhammer      Modificaco por Inquisidor basamdose en tabla- begin
    arregloDMDs +=     "013,M,023,110,????????,orca008          "; // "Orco Barbaro D&D" Barbarian 19; cr=15.9; Great axe
    arregloDMDs +=     "013,M,023,110,????????,morcscout15      "; // "Orco Batidor D&D" Barbarian 15 Rogue 4; cr=15.9; Spear
    arregloDMDs +=     "014,M,023,110,????????,orca006          "; // "Orco Gran Guerrero D&D" Fighter 21; cr=17.3; Warhammer
    arregloDMDs +=     "015,M,023,110,????????,orca010          "; // "Orco Berserker D&D" Barbarian 23; cr=18.8; Halbert
    arregloDMDs +=     "016,M,023,110,????????,orca007          "; // "Orco Teniente D&D" Fighter 25; cr=20.2;  Battleaxe
    arregloDMDs +=     "017,M,023,110,????????,orca013          "; // "Orco Guardia Elite D&D" Barbarian 27; cr=21.6;  Heavy flail
    arregloDMDs +=     "017,M,023,110,????????,morcscout11      "; // "Orco Cazador D&D" Barbarian 20 Rogue 10; cr=21.6;  Spear
    arregloDMDs +=     "018,S,023,110,????????,orcchief20       "; // "Orco Cacique D&D" Barbarian 10 Warchief 10; cr=23.0; light flail
    arregloDMDs +=     "018,M,023,110,????????,orca005          "; // "Orco Guerrero de Elite D&D" Fighter 32; cr=23.0; Hand axe
    arregloDMDs +=     "019,M,023,110,????????,orca016          "; // "Orco Guardia Elite D&D" Barbarian 34; warhammer          Modificaco por Inquisidor - end
    return arregloDMDs;
}


/*
//____________________________Humanoids / Ozgos ________________________________
// CRs: 4,5     Factions: ?
string ADE_Humanoid_Ozgo_getCaster();
string ADE_Humanoid_Ozgo_getCaster() {
    string arregloDMDs;
                 //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=   "004,M,023,110,????????,osgo004          "; // humanoid 3 cleric 3    "Humanoid / Bugbears / Osgo Clerigo D&D"
    arregloDMDs +=   "004,M,023,110,????????,osgo006          "; // humanoid 3 sorcerer 4  "Humanoid / Bugbears / Osgo Shaman D&D"
    arregloDMDs +=   "005,M,023,110,????????,osgo005          "; // humanoid 3 duid 4      "Humanoid / Bugbears / Osgo Druida D&D"
    return arregloDMDs;
}

// CRs: 2,3,4     Factions: ?
string ADE_Humanoid_Ozgo_getMelee();
string ADE_Humanoid_Ozgo_getMelee() {
    string arregloDMDs;
                   //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=     "002,M,023,110,????????,osgo001          "; // humanoid 4            "Humanoid / Bugbears / Osgo Combatiente D&D"
    arregloDMDs +=     "003,M,023,110,????????,osgo002          "; // humanoid 3 fighter 1  "Humanoid / Bugbears / Osgo Sargento D&D"
    arregloDMDs +=     "004,M,023,110,????????,osgo003          "; // humanoid 3 fighter 2  "Humanoid / Bugbears / Osgo Lider D&D"
    return arregloDMDs;
}
*/


/*
//____________________________Humanoids / Ozgos Snow ________________________________
// CRs: 7       Factions: ?
string ADE_Humanoid_OzgoSnow_getCaster();
string ADE_Humanoid_OzgoSnow_getCaster() {
    string arregloDMDs;
                 //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=   "007,M,023,110,????????,bugbeara016      "; // Osgo de las Nieves D&D cr7
    return arregloDMDs;
}

// CRs: 5,6       Factions: ?
string ADE_Humanoid_OzgoSnow_getMelee();
string ADE_Humanoid_OzgoSnow_getMelee() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "005,M,023,110,????????,bugbeara012      "; // Osgo de las Nieves D&D cr5
    arregloDMDs += "006,M,023,110,????????,bugbeara015      "; // Osgo de las Nieves D&D cr6
    return arregloDMDs;
}
*/


//____________________________Humanoids / Stingers _______________________________
// CRs: 4-18       Factions: Aracnidos
string ADE_Humanoid_Stinger_getCaster();
string ADE_Humanoid_Stinger_getCaster() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "007,M,023,110,????????,mstingercleri001 "; // Aguijoneador D&D Mountruoso 4 Cleric 4
    arregloDMDs += "009,M,023,110,????????,mstingersorc001  "; // "Hechicero Aguijoneador" Monstruoso 4 Hechicero 8, 10.3             Inqui: creador
    arregloDMDs += "011,M,023,110,????????,mstingercleri002 "; // Aguijoneador D&D Mountruoso 4 Cleric 8
    arregloDMDs += "014,M,023,110,????????,mstingercleri003 "; // "Sacerdote Aguijoneador D&D" Mountruoso 4 Cleric 12
    arregloDMDs += "016,M,023,110,????????,mstingercleri005 "; // "Sacerdote Aguijoneador D&D" Mountruoso 8 Cleric 16, 20.2           Inqui: creador
    arregloDMDs += "017,M,023,110,????????,mstingersorc002  "; // "Hehicero Aguijoneador" Monstruoso 14 Hechicero 15, 21.6"           Inqui: creado
    arregloDMDs += "018,M,023,110,????????,mstingercleri004 "; // "Gran Sacerdote Aguijoneador D&D" Mountruoso 9 Cleric 18, 23.0      Inqui: mejoré la criatura
    arregloDMDs += "019,M,023,110,????????,mstingersorc003  "; // "Hehicero Aguijoneador" Monstruoso 16 Hechicero 17, 24.4

    return arregloDMDs;
}

// CRs: 4-18       Factions: Aracnidos
string ADE_Humanoid_Stinger_getMelee();
string ADE_Humanoid_Stinger_getMelee() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "004,M,023,110,????????,mstinger         "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4                  Inqui: modifiqué la criatura
    arregloDMDs += "005,M,023,110,????????,mstingerfight001 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 1        Inqui: modifiqué la criatura
    arregloDMDs += "006,M,023,110,????????,mstingerfight002 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 2        Inqui: modifiqué la criatura
    arregloDMDs += "007,M,023,110,????????,mstingerfight003 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 4,  7.4          Inqui: modifiqué la criatura
    arregloDMDs += "008,M,023,110,????????,mstingerfight004 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 6,  8.8          Inqui: modifiqué la criatura
    arregloDMDs += "009,M,023,110,????????,mstingerfight005 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 8,  10.3         Inqui: mejoré la criatura
    arregloDMDs += "010,M,023,110,????????,mstingerfight006 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 10, 11.7         Inqui: mejoré la criatura
    arregloDMDs += "011,M,023,110,????????,mstingerfight007 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 12, 13.1         Inqui: mejoré la criatura
    arregloDMDs += "012,M,023,110,????????,mstingerfight008 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 14, 14.5         Inqui: mejoré la criatura
    arregloDMDs += "013,M,023,110,????????,mstingerfight009 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 16, 15.9         Inqui: mejoré la criatura
    arregloDMDs += "014,M,023,110,????????,mstingerfight010 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 18, 17.3         Inqui: mejoré la criatura
    arregloDMDs += "015,M,023,110,????????,mstingerfight011 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 20, 18.8         Inqui: mejoré la criatura
    arregloDMDs += "016,M,023,110,????????,mstingerfight012 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 22, 20.2       Inqui: mejoré la criatura
    arregloDMDs += "017,M,023,110,????????,mstingerfight013 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 24, 21.6       Inqui: mejoré la criatura
    arregloDMDs += "018,M,023,110,????????,mstingerfight014 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 26, 23.0        Inqui: mejoré la criatura
    arregloDMDs += "019,M,023,110,????????,mstingerfight015 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 28, 24.4        Inqui: creador
    arregloDMDs += "020,M,023,110,????????,mstingerfight015 "; // "Humanoid / Other / Guerrero Aguijoneador D&D" Mountruoso 4 Fighter 30, 25.8        Inqui: creador
    return arregloDMDs;
}


//_____________________________Humanoids / Trasgoides _____________________________
// CRs: 4-18       Factions: ?
string ADE_Humanoid_Trasgo_getCaster();
string ADE_Humanoid_Trasgo_getCaster() {
    string arregloDMDs;
                 //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
/*  arregloDMDs +=   "005,M,023,110,????????,trasgo010        "; // humanoid 2 sorcerer 6  6.72 "Humanoid / Goblins / Gran Trasgo Shaman D&D"
    arregloDMDs +=   "005,M,023,110,????????,trasgo007        "; // humanoid 3 sorcerer 6  7.7  "Humanoid / Goblins / Trasgo Shaman D&D"
    arregloDMDs +=   "006,M,023,110,????????,trasgo006        "; // humanoid 4 cleric 6    8.34 "Humanoid / Goblins / Trasgo Clerigo D&D"
    arregloDMDs +=   "006,M,023,110,????????,trasgo005        "; // humanoid 4 druid 6     8.42 "Humanoid / Goblins / Trasgo Druida D&D"
*/

    arregloDMDs +=   "004,S,023,110,????????,mGoblinShaman04  "; // humanoid 1 Cleri 4  - Cr4    - Shaman Trasgo D&D
    arregloDMDs +=   "004,S,023,110,????????,mGoblinwitch04   "; // humanoid 1 Sorce 4  - Cr4    - Brujo Trasgo D&D
    arregloDMDs +=   "006,S,023,110,????????,mGoblinwitch07   "; // humanoid 1 Sorce 7  - Cr6    - Brujo Trasgo D&D
    arregloDMDs +=   "006,S,023,110,????????,mGoblinShaman06  "; // humanoid 1 Cleri 6  - Cr6    - Shaman Trasgo D&D
    arregloDMDs +=   "007,S,023,110,????????,mHobGobSham07    "; // humanoid 1 Cleri 7  - Cr7    - Shaman Gran Trasgo D&D
    arregloDMDs +=   "008,S,023,110,????????,mGoblinShaman08  "; // humanoid 1 Cleri 8  - Cr8    - Shaman Trasgo D&D
    arregloDMDs +=   "009,S,023,110,????????,mGoblinwitch10   "; // humanoid 1 Sorce 10 - Cr9    - Brujo Trasgo D&D
    arregloDMDs +=   "010,S,023,110,????????,mGoblinShaman11  "; // humanoid 1 Cleri 11 - Cr10   - Shaman Trasgo D&D
    arregloDMDs +=   "011,S,023,110,????????,mOsgoWitch09     "; // humanoid 3 Sorce 9  - Cr11   - Brujo Osgo D&D
    arregloDMDs +=   "011,S,023,110,????????,mOsgoSham09      "; // humanoid 3 Cleri 9  - Cr11   - Shaman Osgo D&D
    arregloDMDs +=   "013,S,023,110,????????,mHobGobSham13    "; // humanoid 1 Cleri 13 - Cr13   - Shaman Gran Trasgo D&D
    arregloDMDs +=   "014,S,023,110,????????,mOsgoWitch13     "; // humanoid 3 Sorce 13 - Cr14   - Brujo Osgo D&D
    arregloDMDs +=   "015,S,023,110,????????,mOsgoSham13      "; // humanoid 3 Cleri 13 - Cr15   - Shaman Osgo D&D
    arregloDMDs +=   "017,S,023,110,????????,mOsgoWitch17     "; // humanoid 3 Sorce 17 - Cr17   - Brujo Osgo D&D
    arregloDMDs +=   "018,S,023,110,????????,mHobGobSham19    "; // humanoid 1 Cleri 19 - Cr18   - Shaman Gran Trasgo D&D
    arregloDMDs +=   "018,S,023,110,????????,mOsgoSham17      "; // humanoid 3 Cleri 17 - Cr18   - Shaman Osgo D&D
    return arregloDMDs;
}

// CRs: 1-18      Factions: Goblins
string ADE_Humanoid_Trasgo_getMelee();
string ADE_Humanoid_Trasgo_getMelee() {
    string arregloDMDs;
                   //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
/*  arregloDMDs +=     "004,M,023,110,????????,trasgo001        "; // humanoid 4           - 3.2  "Humanoid / Goblins / Trasgo Combatiente D&D"
    arregloDMDs +=     "005,M,023,110,????????,trasgo002        "; // humanoid 4 rogue 2   - 4.8  "Humanoid / Goblins / Trasgo Sargento D&D"
    arregloDMDs +=     "005,M,023,110,????????,trasgo009        "; // magical beast 4      - 3.29 "Humanoid / Goblins / Huargo con Jinete Trasgo D&D"
    arregloDMDs +=     "006,M,023,110,????????,trasgo003        "; // humanoid 3 fighter 4 - 6.16 "Humanoid / Goblins / Trasgo Teniente D&D"
    arregloDMDs +=     "007,M,023,110,????????,trasgo004        "; // humanoid 4 figther 5 - 7.52 "Humanoid / Goblins / Trasgo Capitan D&D"
    arregloDMDs +=     "007,M,023,110,????????,trasgo012        "; // humanoid 2 fighter 6 - 7.42 "Humanoid / Goblins / Gran Trasgo Guerrero D&D"
    arregloDMDs +=     "008,M,023,110,????????,trasgo008        "; // humanoid 4 ranger 7  - 8.8  "Humanoid / Goblins / Jinete Trasgo D&D"
*/

    arregloDMDs +=     "001,M,023,110,????????,mGoblin01        "; // humanoid 1          - Cr1/4  - Trasgo D&D
    arregloDMDs +=     "001,M,023,110,????????,mhobgoblin01     "; // humanoid 1          - Cr1/2  - Gran Trasgo D&D
    arregloDMDs +=     "002,M,023,110,????????,mGoblinThug02    "; // humanoid 1 Rogue 2  - Cr2    - Maton Trasgo D&D
    arregloDMDs +=     "002,M,023,110,????????,mGoblinFighter02 "; // humanoid 1 Fight 2  - Cr2    - Combatiente Trasgo D&D
    arregloDMDs +=     "003,M,023,110,????????,mOsgo03          "; // humanoid 3          - Cr3    - Osgo D&D
    arregloDMDs +=     "003,M,023,110,????????,mGoblinRogue03   "; // humanoid 1 Rogue 3  - Cr3    - Acechador Trasgo D&D
    arregloDMDs +=     "004,M,023,110,????????,mGoblinThug04    "; // humanoid 1 Rogue 4  - Cr4    - Maton Trasgo D&D
    arregloDMDs +=     "004,M,023,110,????????,mGoblinFighter04 "; // humanoid 1 Fight 4  - Cr4    - Combatiente Trasgo D&D
    arregloDMDs +=     "005,M,023,110,????????,mGoblinRogue05   "; // humanoid 1 Rogue 5  - Cr5    - Acechador Trasgo D&D
    arregloDMDs +=     "006,M,023,110,????????,mGoblinThug07    "; // humanoid 1 Rogue 7  - Cr6    - Maton Trasgo D&D
    arregloDMDs +=     "006,M,023,110,????????,mGoblinFighter06 "; // humanoid 1 Fight 6  - Cr6    - Combatiente Trasgo D&D
    arregloDMDs +=     "007,M,023,110,????????,mGoblinRogue08   "; // humanoid 1 Rogue 8  - Cr7    - Acechador Trasgo D&D
    arregloDMDs +=     "007,M,023,110,????????,mhobgoblinFight07"; // humanoid 1 Fight 7  - Cr7    - Guerrero Gran Trasgo D&D
    arregloDMDs +=     "008,M,023,110,????????,mGoblinThug09    "; // humanoid 1 Rogue 9  - Cr8    - Maton Trasgo D&D
    arregloDMDs +=     "008,M,023,110,????????,mGoblinFighter08 "; // humanoid 1 Fight 8  - Cr8    - Combatiente Trasgo D&D
    arregloDMDs +=     "009,M,023,110,????????,mGoblinRogue11   "; // humanoid 1 Rogue 11 - Cr9    - Acechador Trasgo D&D
    arregloDMDs +=     "009,M,023,110,????????,mOsgoRogue08     "; // humanoid 3 Rogue 8  - Cr9    - Acechador Osgo D&D
    arregloDMDs +=     "010,M,023,110,????????,mGoblinThug11    "; // humanoid 1 Rogue 11 - Cr10   - Maton Trasgo D&D
    arregloDMDs +=     "010,M,023,110,????????,mGoblinFighter10 "; // humanoid 1 Fight 10 - Cr10   - Combatiente Trasgo D&D
    arregloDMDs +=     "010,M,023,110,????????,mhobgoblinFight10"; // humanoid 1 Fight 10 - Cr10   - Guerrero Gran Trasgo D&D
    arregloDMDs +=     "010,M,023,110,????????,mOsgoFigh08      "; // humanoid 3 Fight 8  - Cr10   - Guerrero Osgo D&D
    arregloDMDs +=     "010,M,023,110,????????,mOsgoBarb08      "; // humanoid 3 Barba 8  - Cr10   - Barbaro Osgo D&D
    arregloDMDs +=     "012,M,023,110,????????,mOsgoRogue11     "; // humanoid 3 Rogue 11 - Cr12   - Acechador Osgo D&D
    arregloDMDs +=     "012,M,023,110,????????,mOsgoBarb11      "; // humanoid 3 Barba 11 - Cr12   - Barbaro Osgo D&D
    arregloDMDs +=     "013,M,023,110,????????,mOsgoFigh11      "; // humanoid 3 Fight 11 - Cr13   - Guerrero Osgo D&D
    arregloDMDs +=     "013,M,023,110,????????,mhobgoblinFight13"; // humanoid 1 Fight 13 - Cr13   - Guerrero Gran Trasgo D&D
    arregloDMDs +=     "014,M,023,110,????????,mOsgoRogue14     "; // humanoid 3 Rogue 14 - Cr14   - Acechador Osgo D&D
    arregloDMDs +=     "015,M,023,110,????????,mOsgoBarb14      "; // humanoid 3 Barba 14 - Cr15   - Barbaro Osgo D&D
    arregloDMDs +=     "015,M,023,110,????????,mOsgoFigh14      "; // humanoid 3 Fight 14 - Cr15   - Guerrero Osgo D&D
    arregloDMDs +=     "015,M,023,110,????????,mhobgoblinFight16"; // humanoid 1 Fight 16 - Cr15   - Guerrero Gran Trasgo D&D
    arregloDMDs +=     "017,M,023,110,????????,mOsgoRogue17     "; // humanoid 3 Rogue 17 - Cr17   - Acechador Osgo D&D
    arregloDMDs +=     "017,M,023,110,????????,mOsgoBarb17      "; // humanoid 3 Barba 17 - Cr17   - Barbaro Osgo D&D
    arregloDMDs +=     "018,M,023,110,????????,mOsgoFigh17      "; // humanoid 3 Fight 17 - Cr18   - Guerrero Osgo D&D
    arregloDMDs +=     "018,M,023,110,????????,mhobgoblinFight20"; // humanoid 1 Fight 20 - Cr18   - Guerrero Gran Trasgo D&D
    return arregloDMDs;
}


//__________________________Humanoids / Trasgos de Caverna _____________________
// CRs: 6,7       Factions: ?
string ADE_Humanoid_TrasgoCaverna_getCaster();
string ADE_Humanoid_TrasgoCaverna_getCaster() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "006,M,023,110,????????,goblina007       "; // humanoid 4 sorcerer 7  "Humanoid / Goblin / Trasgo Brujo D&D"
    arregloDMDs += "007,M,023,110,????????,goblina011       "; // humanoid 4 sorcerer 8  "Humanoid / Goblin / Trasgo Gran Brujo D&D"
    return arregloDMDs;
}

// CRs: 6,7,8       Factions: ?
string ADE_Humanoid_TrasgoCaverna_getMelee();
string ADE_Humanoid_TrasgoCaverna_getMelee() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "006,M,023,110,????????,goblina010       "; // humanoid 4 rogue 5    "Humanoid / Goblin / Trasgo de las cavernas Acechador D&D"
    arregloDMDs += "007,M,023,110,????????,goblina013       "; // humanoid 4 fighter 6  "Humanoid / Goblin / Trasgo de las Cavernas Guerrero D&D"
    arregloDMDs += "008,M,023,110,????????,goblina014       "; // humanoid 4 fighter 7  "Humanoid / Goblin / Trasgo de las Cavernas Campeon D&D"
    return arregloDMDs;
}


//_____________________________Humanoids / Saurion _____________________________
// CRs: 5,7       Factions: ?
string ADE_Humanoid_Saurion_getCaster();
string ADE_Humanoid_Saurion_getCaster() {
    string arregloDMDs;
                 //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=   "005,M,023,110,????????,troglodita003    "; // humanoide 1 clerigo 5       "Humanoid / Lizardfolk / Troglodita Shaman D&D"
    arregloDMDs +=   "007,M,023,110,????????,troglodita005    "; // humanoide 1 clerigo 7       "Humanoid / Lizardfolk / Troglodita Gran Shaman D&D"
    return arregloDMDs;
}

// CRs: 5,6,7       Factions: ?
string ADE_Humanoid_Saurion_getMelee();
string ADE_Humanoid_Saurion_getMelee() {
    string arregloDMDs;
                   //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=     "005,M,023,110,????????,troglodita001    "; // Humanoide 3/Guerrero 3       "Humanoid / Lizardfolk / Troglodita Combatiente D&D"
    arregloDMDs +=     "006,M,023,110,????????,troglodita002    "; // Humanoide 2/Guerrero 5       "Humanoid / Lizardfolk / Troglodita Sargento D&D"
    arregloDMDs +=     "007,M,023,110,????????,troglodita004    "; // Humanoide 2/Guerrero 6       "Humanoid / Lizardfolk / Troglodita Teniente D&D"
    return arregloDMDs;
}

/*
//_____________________________Humanoids / Wemics _____________________________
// CRs: 5,7       Factions: Felinos
string ADE_Humanoid_Wemic_getCaster();
string ADE_Humanoid_Wemic_getCaster() {
    string arregloDMDs;
                 //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=   "005,M,023,110,????????,troglodita003    "; // humanoide 1 clerigo 5       "Humanoid / Lizardfolk / Troglodita Shaman D&D"
    arregloDMDs +=   "007,M,023,110,????????,troglodita005    "; // humanoide 1 clerigo 7       "Humanoid / Lizardfolk / Troglodita Gran Shaman D&D"
    return arregloDMDs;
}
*/
// CRs: 4-17       Factions: Felinos
string ADE_Humanoid_Wemic_getMelee();
string ADE_Humanoid_Wemic_getMelee() {
    string arregloDMDs;
                   //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=     "004,M,023,110,????????,mwemic           "; // Lenauro D&D Humanoid 5
    arregloDMDs +=     "004,M,023,110,????????,mwemic001        "; // Lenauro Hembra D&D Humanoid 5
    arregloDMDs +=     "005,M,023,110,????????,mwemicbarb       "; // Lenauro D&D Humanoid 5 Barbarian 1
    arregloDMDs +=     "006,M,023,110,????????,mwemicbarb001    "; // Lenauro D&D Humanoid 5 Barbarian 2
    arregloDMDs +=     "007,M,023,110,????????,mwemicbarb002    "; // Lenauro D&D Humanoid 5 Barbarian 3
    arregloDMDs +=     "008,M,023,110,????????,mwemicbarb003    "; // Lenauro D&D Humanoid 5 Barbarian 4
    arregloDMDs +=     "009,M,023,110,????????,mwemicbarb004    "; // Lenauro D&D Humanoid 5 Barbarian 5
    arregloDMDs +=     "010,M,023,110,????????,mwemicbarb005    "; // Lenauro D&D Humanoid 5 Barbarian 7
    arregloDMDs +=     "011,M,023,110,????????,mwemicbarb006    "; // Lenauro D&D Humanoid 5 Barbarian 8
    arregloDMDs +=     "012,M,023,110,????????,mwemicbarb007    "; // Lenauro D&D Humanoid 5 Barbarian 9
    arregloDMDs +=     "013,M,023,110,????????,mwemicbarb008    "; // Lenauro D&D Humanoid 5 Barbarian 10
    arregloDMDs +=     "014,M,023,110,????????,mwemicbarb009    "; // Lenauro D&D Humanoid 5 Barbarian 11
    arregloDMDs +=     "015,M,023,110,????????,mwemicbarb010    "; // Lenauro D&D Humanoid 5 Barbarian 13
    arregloDMDs +=     "016,M,023,110,????????,mwemicbarb011    "; // Lenauro D&D Humanoid 5 Barbarian 14
    arregloDMDs +=     "017,M,023,110,????????,mwemicbarb012    "; // Lenauro D&D Humanoid 5 Barbarian 15
    return arregloDMDs;
}


//_____________________________Humanoids / Yuanti ___________________________
// CRs: 7,8,9       Factions: ?
string ADE_Humanoid_Yuanti_get();
string ADE_Humanoid_Yuanti_get() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="007,M,030,110,????????,yuantipuracasta1 "; //Yuanti Puracasta cr8
    arregloDVDs +="008,M,030,110,????????,yuantipuracasta2 "; //Yuanti Puracasta cr9
    arregloDVDs +="009,M,030,110,????????,yuantipuracas001 "; //Yuanti Puracasta cr10
    return arregloDVDs;
}

//_____________________________Humanoids / Yuanti / Nigromante & Sacerdote ___________________________
// CRs: 17, 18, 19, 20, 21, 22, 23, 24, 25   Factions: hostil
string ADE_Humanoid_YuanTis_getCaster();
string ADE_Humanoid_YuanTis_getCaster() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="017,M,020,110,????????,vr_yuantin01     "; //Yuanti Puracasta Nigromante cr 17
    arregloDVDs +="017,M,020,110,????????,vr_yuantis01     "; //Yuan-ti Puracasta Sacerdote cr 17
    arregloDVDs +="018,M,020,110,????????,vr_yuantin02     "; //Yuanti Puracasta Nigromante cr 18
    arregloDVDs +="018,M,020,110,????????,vr_yuantis02     "; //Yuan-ti Puracasta Sacerdote cr 18
    arregloDVDs +="019,M,020,110,????????,vr_yuantin03     "; //Yuanti Puracasta Nigromante cr 19
    arregloDVDs +="019,M,020,110,????????,vr_yuantis03     "; //Yuan-ti Puracasta Sacerdote cr 19
    arregloDVDs +="020,M,020,110,????????,vr_yuantin04     "; //Yuanti Puracasta Nigromante cr 20
    arregloDVDs +="020,M,020,110,????????,vr_yuantis04     "; //Yuan-ti Puracasta Sacerdote cr 20
    arregloDVDs +="021,M,020,110,????????,vr_yuantin05     "; //Yuanti Puracasta Nigromante cr 21
    arregloDVDs +="021,M,020,110,????????,vr_yuantis05     "; //Yuan-ti Puracasta Sacerdote cr 21
    arregloDVDs +="022,M,020,110,????????,vr_yuantin06     "; //Yuanti Puracasta Nigromante cr 22
    arregloDVDs +="022,M,020,110,????????,vr_yuantis06     "; //Yuan-ti Puracasta Sacerdote cr 22
    arregloDVDs +="023,M,020,110,????????,vr_yuantin07     "; //Yuanti Puracasta Nigromante cr 23
    arregloDVDs +="023,M,020,110,????????,vr_yuantis07     "; //Yuan-ti Puracasta Sacerdote cr 23
    arregloDVDs +="024,M,020,110,????????,vr_yuantin08     "; //Yuanti Puracasta Nigromante cr 24
    arregloDVDs +="024,M,020,110,????????,vr_yuantis08     "; //Yuan-ti Puracasta Sacerdote cr 24
    arregloDVDs +="025,M,020,110,????????,vr_yuantin09     "; //Yuanti Puracasta Nigromante cr 25
    arregloDVDs +="025,M,020,110,????????,vr_yuantis09     "; //Yuan-ti Puracasta Sacerdote cr 25
    return arregloDVDs;
}



//_____________________________Humanoids / Yuanti / Guerrero, Rogue & Explorador ___________________________
// CRs: 17, 18, 19, 20, 21, 22, 23, 24, 25       Factions: Hostil
string ADE_Humanoid_YuanTis_getMelee();
string ADE_Humanoid_YuanTis_getMelee() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="017,M,030,110,????????,vr_yuantif01     "; //Yuan-ti Abominacion Guerrero Cr 17
    arregloDVDs +="017,M,030,110,????????,vr_yuantie01     "; //Yuan-ti Hibrido Explorador Cr 17
    arregloDVDs +="017,M,030,110,????????,vr_yuantir01     "; //Yuan ti Puracasta Rogue Cr 17
    arregloDVDs +="018,M,030,110,????????,vr_yuantif02     "; //Yuan-ti Abominacion Guerrero Cr 18
    arregloDVDs +="018,M,030,110,????????,vr_yuantie02     "; //Yuan-ti Hibrido Explorador Cr 18
    arregloDVDs +="018,M,030,110,????????,vr_yuantir02     "; //Yuan ti Puracasta Rogue Cr 18
    arregloDVDs +="019,M,030,110,????????,vr_yuantif03     "; //Yuan-ti Abominacion Guerrero Cr 19
    arregloDVDs +="019,M,030,110,????????,vr_yuantie03     "; //Yuan-ti Hibrido Explorador Cr 19
    arregloDVDs +="019,M,030,110,????????,vr_yuantir03     "; //Yuan ti Puracasta Rogue Cr 19
    arregloDVDs +="020,M,030,110,????????,vr_yuantif04     "; //Yuan-ti Abominacion Guerrero Cr 20
    arregloDVDs +="020,M,030,110,????????,vr_yuantie04     "; //Yuan-ti Hibrido Explorador Cr 20
    arregloDVDs +="020,M,030,110,????????,vr_yuantir04     "; //Yuan ti Puracasta Rogue Cr 20
    arregloDVDs +="021,M,030,110,????????,vr_yuantif05     "; //Yuan-ti Abominacion Guerrero Cr 21
    arregloDVDs +="021,M,030,110,????????,vr_yuantie05     "; //Yuan-ti Hibrido Explorador Cr 21
    arregloDVDs +="021,M,030,110,????????,vr_yuantir05     "; //Yuan ti Puracasta Rogue Cr 21
    arregloDVDs +="022,M,030,110,????????,vr_yuantif06     "; //Yuan-ti Abominacion Guerrero Cr 22
    arregloDVDs +="022,M,030,110,????????,vr_yuantie06     "; //Yuan-ti Hibrido Explorador Cr 22
    arregloDVDs +="022,M,030,110,????????,vr_yuantir06     "; //Yuan ti Puracasta Rogue Cr 22
    arregloDVDs +="023,M,030,110,????????,vr_yuantif07     "; //Yuan-ti Abominacion Guerrero Cr 23
    arregloDVDs +="023,M,030,110,????????,vr_yuantie07     "; //Yuan-ti Hibrido Explorador Cr 23
    arregloDVDs +="023,M,030,110,????????,vr_yuantir07     "; //Yuan ti Puracasta Rogue Cr 23
    arregloDVDs +="024,M,030,110,????????,vr_yuantif08     "; //Yuan-ti Abominacion Guerrero Cr 24
    arregloDVDs +="024,M,030,110,????????,vr_yuantie08     "; //Yuan-ti Hibrido Explorador Cr 24
    arregloDVDs +="024,M,030,110,????????,vr_yuantir08     "; //Yuan ti Puracasta Rogue Cr 24
    arregloDVDs +="025,M,030,110,????????,vr_yuantif09     "; //Yuan-ti Abominacion Guerrero Cr 25
    arregloDVDs +="025,M,030,110,????????,vr_yuantie09     "; //Yuan-ti Hibrido Explorador Cr 25
    arregloDVDs +="025,M,030,110,????????,vr_yuantir09     "; //Yuan ti Puracasta Rogue Cr 25
    return arregloDVDs;
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// INSECT //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//____________________________ Insect / Ants ________________________________
// CRs: 3,5,7,9       Factions: Insectos
string ADE_Insects_Ants_get();
string ADE_Insects_Ants_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,in001            "; // vermin 3        "Insects / Ants / Hormiga Trabajadora Gigante D&D"
    arregloDMDs += "005,M,023,110,????????,in005            "; // vermin 6        "Insects / Ants / Hormiga Soldado Gigante D&D"
    arregloDMDs += "007,M,023,110,????????,in013            "; // vermin 8        "Insects / Ants / Hormiga Soldado Guardian D&D"
    arregloDMDs += "008,M,023,110,????????,vr_antsld_cr08   "; //
    arregloDMDs += "009,L,030,110,????????,in007            "; // vermin 10       "Insects / Ants / Hormiga Reina D&D" (seguidor: in013)
    arregloDMDs += "009,M,023,110,????????,vr_antgua_cr09   "; //
    arregloDMDs += "011,M,023,110,????????,vr_antgua_cr11   "; //
    arregloDMDs += "011,L,030,110,????????,vr_antqu_cr11    "; //

    return arregloDMDs;
}


//____________________________ Insect / Avispa ________________________________
// CRs: 5-7       Factions: Insectos
string ADE_Insects_Avispa_getVariado();
string ADE_Insects_Avispa_getVariado() {
    string arregloDVDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs += "005,M,023,110,????????,in008            "; // vermin 5        "Insects / Other / Avispa Gigante D&D" 4.67 Insectos          visto paso
    arregloDVDs += "007,M,023,110,????????,in011            "; // vermin 8        "Insects / Other / Avispa Gigante D&D" 7.5  Insectos          visto mod
    arregloDVDs += "009,M,023,110,????????,vr_avg_cr09      "; //
    arregloDVDs += "012,L,045,110,????????,in012            "; // vermin 19       "Insects / Other / Avispa Reina Gigante D&D" 14.8 Insectos     visto mod
    return arregloDVDs;
}


//____________________________ Insect / Beetle ________________________________
// CRs: 3,4,6,9,11,15       Factions: ?
string ADE_Insects_Beetle_getVariado();
string ADE_Insects_Beetle_getVariado() {
    string arregloDVDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs += "003,M,023,110,????????,in017            "; // vermin 3        "Insects / Beetles / Escarabajo de Fuego Gigante D&D" (3hd x 5 hp) {Cono de fuego 1 x dia}
    arregloDVDs += "004,M,023,110,????????,in006            "; // vermin 4        "Insects / Beetles / Escarabajo Bombardero D&D" (4hd x 6 hp) {cono de acido x 4}
    arregloDVDs += "006,M,023,110,????????,in010            "; // vermin 5        "Insects / Beetles / Escarabajo Astado D&D" 6.04 Insectos                                         Visto mod
    arregloDVDs += "009,S,023,110,????????,in018            "; // vermin 9        "Insects / Beetles / Escarabajo de Fuego Enorme D&D" 10.3 Insectos {Cono de fuego 3 x dia}        Visto mod
    arregloDVDs += "010,S,023,110,????????,vr_btfe_cr10     "; //
    arregloDVDs += "011,S,023,110,????????,in019            "; // vermin 14       "Insects / Beetles / Escarabajo Bombardero Enorme D&D" 13.10 (4hd x 6 hp) {cono de acido x 4}     Visto mod
    arregloDVDs += "011,S,023,110,????????,vr_btfe_cr11     ";
    arregloDVDs += "012,S,023,110,????????,vr_btfe_cr12     ";
    arregloDVDs += "012,S,023,110,????????,vr_btaste_cr12   ";
    arregloDVDs += "013,S,023,110,????????,vr_btaste_cr13   ";
    arregloDVDs += "013,M,023,110,????????,vr_btlbomb_cr13  ";
    arregloDVDs += "015,M,023,110,????????,vr_btlbomb_cr15  ";
    arregloDVDs += "015,S,023,110,????????,in020            "; // vermin 20       "Insects / Beetles / Escarabajo Astado D&D" 18.12 Insectos                                        Visto mod
    arregloDVDs += "017,S,023,110,????????,vr_btaste_cr17   ";
    arregloDVDs += "017,M,023,110,????????,vr_btlbomb_cr17  ";
    arregloDVDs += "019,S,023,110,????????,vr_btaste_cr19   ";
    arregloDVDs += "019,M,023,110,????????,vr_btlbomb_cr19  ";
    return arregloDVDs;
}


//____________________________ Insect / Scorpion Green________________________________
// CRs: 3,6,9       Factions: Insect
string ADE_Insects_ScorpionGreen_getVariado();
string ADE_Insects_ScorpionGreen_getVariado() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,030,110,????????,in003            "; // vermin 5  "Insects / Scorpions / Escorpion Verde Gigante D&D"
    arregloDMDs += "006,M,030,110,????????,in004            "; // vermin 10 "Insects / Scorpions / Escorpion Verde Gigante D&D"
    arregloDMDs += "009,S,030,117,????????,in009            "; // vermin 15 "Insects / Scorpions / Escorpion Verde Enorme D&D" 11.0
    arregloDMDs += "011,M,030,110,????????,vr_scge_cr11     "; //
    arregloDMDs += "013,M,030,110,????????,vr_scge_cr13     "; //
    arregloDMDs += "015,M,030,110,????????,vr_scge_cr15     "; //
    arregloDMDs += "017,M,030,110,????????,vr_scge_cr17     "; //
    arregloDMDs += "019,S,030,117,????????,vr_scgg_cr19     "; //
    arregloDMDs += "021,S,030,117,????????,vr_scgg_cr21     "; //
    arregloDMDs += "023,S,030,117,????????,vr_scgg_cr23     "; //
    arregloDMDs += "025,S,030,117,????????,vr_scgg_cr25     "; //
    return arregloDMDs;
}


//____________________________ Insect / Scorpion Black________________________________
// CRs: 2,3       Factions: ?
string ADE_Insects_ScorpionBlack_getVariado();
string ADE_Insects_ScorpionBlack_getVariado() {
    string arregloDMDs;
                // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,030,110,????????,in022            "; // vermin 5  "Insects / Scorpions / Escorpion Negro Gigante D&D"
    arregloDMDs += "006,M,030,110,????????,in023            "; // vermin 10 "Insects / Scorpions / Escorpion Negro Gigante D&D"
    arregloDMDs += "007,M,030,110,????????,vr_scblg_cr07    "; //
    arregloDMDs += "008,M,030,110,????????,vr_scblg_cr08    "; //
    arregloDMDs += "009,M,030,110,????????,vr_scblg_cr09    "; //
    arregloDMDs += "009,S,030,117,????????,in021            "; // vermin 15 "Insects / Scorpions / Escorpion Negro Enorme D&D"
    arregloDMDs += "013,S,030,117,????????,vr_scblh_cr13    "; //
    arregloDMDs += "016,S,030,117,????????,vr_scblh_cr16    "; //
    arregloDMDs += "018,S,030,117,????????,vr_scblh_cr18    "; //
    return arregloDMDs;
}


//__________________________ Insect / Spider _____________________________________
// CRs: 3,5,6,7,8,9,12       Factions: Aracnidos
string ADE_Insect_Spider_getVariado();
string ADE_Insect_Spider_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
//    arregloDVDs +=  "004,M,030,110,????????,spidgiant001     "; // Araña Gigante D&D CR4
//    arregloDVDs +=  "009,M,030,110,????????,pseudospiddire   "; // Araña Terrible CR9
    arregloDVDs +=  "003,M,030,110,????????,spid001          "; // Araña D&D (Vermin 3)
    arregloDVDs +=  "005,M,030,110,????????,pm002b           "; // Araña Gigante D&D (Vermin 6)
    arregloDVDs +=  "005,M,030,110,????????,vr_sp_cr05       "; //
    arregloDVDs +=  "006,M,030,110,????????,espada1          "; // Araña Espada D&D (Vermin 6)
    arregloDVDs +=  "007,L,023,110,????????,pm002            "; // aberration 5         "Tracnido D&D" seguidor=pm002a
    arregloDVDs +=  "007,M,030,110,????????,vr_sp_cr07       "; //
    arregloDVDs +=  "008,M,030,110,????????,spidphase001     "; // Magical Beast 11     "Insects / Spieders / Araña de Fase D&D" 9.39 Insectos          Visto mod
    arregloDVDs +=  "008,M,030,110,????????,vr_spe_cr08      "; //
    arregloDVDs +=  "009,L,023,110,????????,vr_trac_cr09     "; //
    arregloDVDs +=  "009,M,030,110,????????,vr_spg_cr09      "; //
    arregloDVDs +=  "010,M,030,110,????????,vr_spf_cr10      "; //
    arregloDVDs +=  "011,M,030,110,????????,vr_spe_cr11      "; //
    arregloDVDs +=  "012,L,023,110,????????,vr_trac_cr12     "; //
    arregloDVDs +=  "012,M,030,110,????????,spidphase003     "; // Magical Beast 18     "Insects / Spieders / Araña de Fase D&D" 14.37 Insectos         Visto mod
    arregloDVDs +=  "013,M,030,110,????????,vr_spg_cr13      "; //
    return arregloDVDs;
}

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// NPCs //////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


//__________________________ NPCs / Human&HalfOrc / Bandits ____________________
// CRs: 1,2,3,4,7,10                        Faction: Hostil
string ADE_NPC_Bandits_get();
string ADE_NPC_Bandits_get() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "001,M,023,110,????????,nw_bandit001     "; // NPC / Human  0.5
    arregloDMDs +=  "001,M,023,110,????????,nw_bandit002     "; // NPC / Human  0.5
    arregloDMDs +=  "002,M,023,110,????????,nw_bandit003     "; // NPC / Human  1
    arregloDMDs +=  "003,M,023,110,????????,nw_bandit004     "; // NPC / Human  3
    arregloDMDs +=  "004,M,023,110,????????,nw_bandit005     "; // NPC / Human  4
    arregloDMDs +=  "007,M,023,110,????????,nw_bandit006     "; // NPC / Human  7
    arregloDMDs +=  "010,M,023,110,????????,nw_bandit007     "; // NPC / Human  11
    return arregloDMDs;
}


//__________________________ NPCs / Human / Gypsy ______________________________
// CRs: 1,4,8,9,10                    Faction: Hostil
string ADE_NPC_Gypsy_get();
string ADE_NPC_Gypsy_get() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "001,M,023,110,????????,nw_gypfemale     "; // NPC / Human  0.25
    arregloDMDs +=  "001,M,023,110,????????,nw_gypmale       "; // NPC / Human  0.25
    arregloDMDs +=  "001,M,023,110,????????,nw_gypsy001      "; // NPC / Human  0.5
    arregloDMDs +=  "001,M,023,110,????????,nw_gypsy002      "; // NPC / Human  0.5
    arregloDMDs +=  "004,M,023,110,????????,nw_gypsy003      "; // NPC / Human  4
    arregloDMDs +=  "004,M,023,110,????????,nw_gypsy004      "; // NPC / Human  4
    arregloDMDs +=  "008,M,023,110,????????,nw_gypsy005      "; // NPC / Human  8
    arregloDMDs +=  "009,M,023,110,????????,nw_gypsy007      "; // NPC / Human  10
    arregloDMDs +=  "010,M,023,110,????????,nw_gypsy006      "; // NPC / Human  11
    return arregloDMDs;
}


//__________________________ NPCs / Human / Mercenary __________________________
// CRs: 1,3,4,6,9,11,13                    Faction: Hostil
string ADE_NPC_HumanMercenary_get();
string ADE_NPC_HumanMercenary_get() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "003,M,023,110,????????,nw_humanmerc001  "; // NPC / Human  2
    arregloDMDs +=  "004,M,023,110,????????,nw_humanmerc002  "; // NPC / Human  3
    arregloDMDs +=  "006,M,023,110,????????,nw_humanmerc003  "; // NPC / Human  6
    arregloDMDs +=  "009,M,023,110,????????,nw_humanmerc004  "; // NPC / Human  9
    arregloDMDs +=  "011,M,023,110,????????,nw_humanmerc005  "; // NPC / Human  12
    arregloDMDs +=  "012,M,023,110,????????,nw_humanmerc006  "; // NPC / Human  15
    return arregloDMDs;
}

//__________________________ NPCs / Halfling / Mercenary _______________________
// CRs: 2,4,5,7,9,11               Faction: Hostil
string ADE_NPC_HalflingMercenary_get();
string ADE_NPC_HalflingMercenary_get() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "002,M,023,110,????????,nw_halfmerc001   "; // NPC / Halfling  1
    arregloDMDs +=  "004,M,023,110,????????,nw_halfmerc002   "; // NPC / Halfling  3
    arregloDMDs +=  "005,M,023,110,????????,nw_halfmerc003   "; // NPC / Halfling  5
    arregloDMDs +=  "007,M,023,110,????????,nw_halfmerc004   "; // NPC / Halfling  7
    arregloDMDs +=  "009,M,023,110,????????,nw_halfmerc005   "; // NPC / Halfling  10
    arregloDMDs +=  "009,M,023,110,????????,nw_halfling015   "; // NPC / Halfling  10
    arregloDMDs +=  "011,M,023,110,????????,nw_halfmerc006   "; // NPC / Halfling  13
    return arregloDMDs;
}


//__________________________ NPCs / Elf / Mercenary _______________________
// CRs: 3,5,6,8,10,12              Faction: Hostil
string ADE_NPC_ElfMercenary_get();
string ADE_NPC_ElfMercenary_get() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "003,M,023,110,????????,nw_elfmerc001    "; // NPC / Elf  2
    arregloDMDs +=  "005,M,023,110,????????,nw_elfmerc002    "; // NPC / Elf  4
    arregloDMDs +=  "006,M,023,110,????????,nw_elfmerc003    "; // NPC / Elf  6
    arregloDMDs +=  "008,M,023,110,????????,nw_elfmerc004    "; // NPC / Elf  9
    arregloDMDs +=  "010,M,023,110,????????,nw_elfmerc005    "; // NPC / Elf  11
    arregloDMDs +=  "012,M,023,110,????????,nw_elfmerc006    "; // NPC / Elf  14
    return arregloDMDs;
}

//__________________________ NPCs / Dwarf / Mercenary _______________________
// CRs: 3,5,6,8,10,12              Faction: Hostil
string ADE_NPC_DwarfMercenary_get();
string ADE_NPC_DwarfMercenary_get() {
    string arregloDMDs;
                //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=  "001,M,023,110,????????,nw_dwarfmerc001  "; // NPC / Dwarf  0.5
    arregloDMDs +=  "003,M,023,110,????????,nw_dwarfmerc002  "; // NPC / Dwarf  2
    arregloDMDs +=  "005,M,023,110,????????,nw_dwarfmerc003  "; // NPC / Dwarf  4
    arregloDMDs +=  "007,M,023,110,????????,nw_dwarfmerc004  "; // NPC / Dwarf  7
    arregloDMDs +=  "008,M,023,110,????????,nw_dwarfmerc005  "; // NPC / Dwarf  9
    arregloDMDs +=  "011,M,023,110,????????,nw_dwarfmerc006  "; // NPC / Dwarf  13
    return arregloDMDs;
}



////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// UNDEAD ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


//_________________________ Undeads / Esqueletos Enano_______________________________
// CRs: 3       Factions: Undead
string ADE_Undead_EsqueletoE_getMelee();
string ADE_Undead_EsqueletoE_getMelee() {
    string arregloDVDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs += "003,M,023,110,????????,skele004         "; // undead 5  "Undead / Skeleton / Esqueleto de enano (Combatiente)"
    arregloDVDs += "003,M,023,110,????????,skele005         "; // undead 5  "Undead / Skeleton / Esqueleto de enano (Combatiente)"
    arregloDVDs += "003,M,023,110,????????,skele006         "; // undead 5  "Undead / Skeleton / Esqueleto de enano (Combatiente)"
    return arregloDVDs;
}


//_________________________ Undeads / Esqueletos Human_______________________________
// CRs: 2,4,5,7       Factions: Undead
string ADE_Undead_EsqueletoH_getMelee();
string ADE_Undead_EsqueletoH_getMelee() {
    string arregloDVDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs += "002,M,023,110,????????,skele001         "; // undead 3  "Undead / Skeleton / Esqueleto (Combatiente)"
    arregloDVDs += "002,M,023,110,????????,skele002         "; // undead 3  "Undead / Skeleton / Esqueleto (Combatiente)"
    arregloDVDs += "002,M,023,110,????????,skele003         "; // undead 3  "Undead / Skeleton / Esqueleto (Combatiente)"
    arregloDVDs += "004,M,023,110,????????,skele007         "; // undead 7  "Undead / Skeleton / Esqueleto (Guerrero)"
    arregloDVDs += "004,M,023,110,????????,skele008         "; // undead 7  "Undead / Skeleton / Esqueleto (Guerrero)"
    arregloDVDs += "005,M,023,110,????????,skele0010        "; // undead 9  "Undead / Skeleton / Esqueleto (Gran Guerrero)"
    arregloDVDs += "007,L,023,110,????????,skele0011        "; // undead 11 "Undead / Skeleton / Esqueleto (Jefe)" Seguidor skele0010
    return arregloDVDs;
}


//_________________________ Undeads / Esqueletos Ogro_______________________________
// CRs: 5       Factions: Undead
string ADE_Undead_EsqueletoO_getMelee();
string ADE_Undead_EsqueletoO_getMelee() {
    string arregloDVDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs += "005,S,023,110,????????,skele009         "; // undead 8  "Undead / Skeleton / Esqueleto de Ogro"
    return arregloDVDs;
}


//_________________________ Undeads / Fantasmas ________________________________
// CRs: 4,5,6,7,8        Factions: Undead
string ADE_Undead_Fantasma_getCaster();
string ADE_Undead_Fantasma_getCaster() {
    string arregloDVDs;
                 //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=   "004,L,023,110,????????,bs005b           "; // undead 1 sorcerer 4    "Undead / Wraith / Fantasma Hechicero D&D"
    arregloDVDs +=   "005,L,023,110,????????,bs005            "; // undead 1 sorcerer 5    "Undead / Wraith / Fantasma Hechicero D&D"
    arregloDVDs +=   "006,L,023,110,????????,bs006            "; // undead 3 sorcerer 5    "Undead / Wraith / Fantasma Hechicero D&D"
    arregloDVDs +=   "006,M,023,110,????????,bs001            "; // undead 4               "Undead / Wraith / Allip D&D"               { 5 x Hold Monster [Caster Level:4], 10 x Bolt Drain Wisdom, 10 x Pulse Drain Wisdom }
    arregloDVDs +=   "007,L,023,110,????????,bs006b           "; // undead 3 sorcerer 7    "Undead / Wraith / Fantasma Hechicero D&D"
    arregloDVDs +=   "008,L,023,110,????????,bs007            "; // undead 3 mague 8       "Undead / Wraith / Espectro Mago D&D"
    return arregloDVDs;
}

// CRs: 4,5,6,10        Factions: Undead
string ADE_Undead_Fantasma_getMelee();
string ADE_Undead_Fantasma_getMelee() {
    string arregloDVDs;
                   //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=     "004,M,023,110,????????,shadow           "; // Undead 3              "Sombra D&D"
    arregloDVDs +=     "005,M,023,110,????????,bs002            "; // undead 7              "Undead / Wraith / Espectro D&D"            { 1 x Aura of Unnatural, garra: level drain on hit[dc=14] }
    arregloDVDs +=     "006,M,023,110,????????,bs003            "; // undead 1 fighter 5    "Undead / Wraith / Fantasma Guerrero D&D"
    arregloDVDs +=     "007,M,023,110,????????,bs004            "; // undead 1 fighter 6    "Undead / Wraith / Fantasma Guerrero D&D"
    arregloDVDs +=     "008,M,023,110,????????,shadow1          "; // undead 9              "Undead / Shadow / Sombra Mayor D&D"        { garra: strenght damage on hit }
    arregloDVDs +=     "009,S,023,110,????????,bs008            "; // undead 1 fighter 8    "Undead / Wratih / Visage D&D"
    return arregloDVDs;
}



//_________________________ Undeads / Guerrero Maldito __________________________________
// CRs: 9       Factions: ?
string ADE_Undead_Damned_getMelee();
string ADE_Undead_Damned_getMelee() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "009,M,023,110,????????,maldito4         "; // Guerrera Veterana Maldita  D&D
    arregloDMDs += "009,M,023,110,????????,maldito3         "; // Guerrero Veterano Maldito  D&D
    return arregloDMDs;
}


//_________________________ Undeads / Revenant ________________________________
// CRs: 8       Factions: ?
string ADE_Undead_Revenant_getCaster();
string ADE_Undead_Revenant_getCaster() {
    string arregloDMDs;
                 //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=   "008,M,023,110,????????,revenant1        "; // Sorceror Revenant D&D
    arregloDMDs +=   "008,M,023,110,????????,revenant2        "; // Sorceror Revenant D&D
    return arregloDMDs;
}

// CRs: 8       Factions: ?
string ADE_Undead_Revenant_getMelee();
string ADE_Undead_Revenant_getMelee() {
    string arregloDMDs;
                   //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs +=     "008,M,023,110,????????,revenant3        "; // Revenant Barbarian D&D
    return arregloDMDs;
}


//_________________________ Undeads / Bodak __________________________________
// CRs: 7        Factions: ?
string ADE_Undead_Bodak_getVariado();
string ADE_Undead_Bodak_getVariado() {
    string arregloDVDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs += "010,S,023,110,????????,bodak001         "; // Bodak D&D
    return arregloDVDs;
}


//_________________________ Undeads / Tumulario __________________________________
// CRs: 3        Factions: ?
string ADE_Undead_Tumulo_getMelee();
string ADE_Undead_Tumulo_getMelee() {
    string arregloDVDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs += "003,M,023,110,????????,zombi006         "; // Undead 4 Tumulario D&D
    return arregloDVDs;
}


//_________________________ Undeads / Vampire __________________________________
// CRs: 7,14        Factions: ?
string ADE_Undead_Vampire_getMelee();
string ADE_Undead_Vampire_getMelee() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "007,M,023,110,????????,vampiro          "; // Vampiro D&D
    arregloDMDs += "007,M,023,110,????????,vampiro1         "; // Vampiro D&D
    arregloDMDs += "014,M,023,110,????????,vampiroelite     "; // Vampiro Elite D&D
    arregloDMDs += "014,M,023,110,????????,vampiroelite001  "; // Vampiro Elite D&D
    return arregloDMDs;
}


//_________________________ Undeads / Zombies __________________________________
// CRs: 3-16        Factions: ?
string ADE_Undead_Zombi_getMelee();
string ADE_Undead_Zombi_getMelee() {
    string arregloDVDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "  HP= 10 * cr^1.2;  ab y ac segun tabla progresion cr
    arregloDVDs += "003,M,023,110,????????,zombie002        "; // undead  2  "Undead / Zombies / Zombi D&D"
    arregloDVDs += "004,M,023,110,????????,zombie003        "; // undead  4  "Undead / Zombies / Zombi D&D"
    arregloDVDs += "005,M,023,110,????????,zombie004        "; // undead  4 Fighter  4 "Undead / Zombies / Zombi de Aventurero D&D"
    arregloDVDs += "006,M,023,110,????????,zombie005        "; // undead  6 Fighter  5 "Undead / Zombies / Zombi de Aventurero D&D"
    arregloDVDs += "007,M,023,110,????????,zombie006        "; // undead  6 Fighter  8 "Undead / Zombies / Zombi de Aventurero D&D"
    arregloDVDs += "008,M,023,110,????????,zombie007        "; // undead  8 Fighter  8 "Undead / Zombies / Zombi Guerrero D&D"
    arregloDVDs += "009,M,023,110,????????,zombie008        "; // undead  8 Fighter 11 "Undead / Zombies / Zombi Combatiente D&D"
    arregloDVDs += "010,L,023,110,????????,zombie009        "; // undead 10 Fighter 12 "Undead / Zombies / Zombi Lider D&D"
    arregloDVDs += "011,M,023,110,????????,zombi010         "; // undead 10 Fighter 14 "Undead / Zombies / Zombi Guerrero D&D"
    arregloDVDs += "012,M,023,110,????????,zombi0010        "; // undead 12 Fighter 15 "Undead / Zombies / Zombi Guerrero D&D"
    arregloDVDs += "013,L,023,110,????????,zombi011         "; // undead 12 Fighter 17 "Undead / Zombies / Zombi Lider D&D"
    arregloDVDs += "014,L,023,110,????????,zombi0011        "; // undead 14 Fighter 17 "Undead / Zombies / Zombi Lider D&D"
    arregloDVDs += "015,L,023,110,????????,zombi011b        "; // undead 14 Fighter 19 "Undead / Zombies / Zombi Lider D&D"
    arregloDVDs += "016,L,023,110,????????,zombi0011b       "; // undead 16 Fighter 19 "Undead / Zombies / Zombi Lider D&D"
    return arregloDVDs;
}


//_________________________ Undeads / Momias __________________________________
// CRs: 5,8,12,16        Factions: ?
string ADE_Undead_Momias_get();
string ADE_Undead_Momias_get() {
    string arregloDVDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs += "007,M,023,110,????????,mummy001         "; // undead 2 Fighter 7             "Undead / Mummy / Momia"
    arregloDVDs += "010,M,023,110,????????,mummy002         "; // undead 2 Fighter 12            "Undead / Mummy / Momia - Guerrero"
    arregloDVDs += "012,S,023,110,????????,mummy003         "; // undead 2 Clerigo 10 Fighter 4  "Undead / Mummy / Momia - Señor de las"
    arregloDVDs += "013,S,023,110,????????,nw_it_crewpb008  "; // undead 25                      "Undead / Mummy / Warrior/Greater Mummy Slam"
    arregloDVDs += "016,L,023,110,????????,mummy004         "; // fighter 10 Clerigo 15          "Undead / Mummy / Momia - Gran Señor"
    return arregloDVDs;
}


//_________________________ Undeads / Banshees_______________________________
// CRs: 20,22,23,24,25       Factions: Undead
string ADE_Undead_Banshees_get();
string ADE_Undead_Banshees_get() {
    string arregloDVDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "020,M,030,110,????????,md_bansh01       "; // Banshee Cr 20
    arregloDVDs +=  "022,M,030,110,????????,md_bansh02       "; // Banshee Cr 22
    arregloDVDs +=  "023,M,030,110,????????,md_bansh03       "; // Banshee Cr 23
    arregloDVDs +=  "024,M,030,110,????????,md_bansh04       "; // Banshee Cr 24
    arregloDVDs +=  "025,M,030,110,????????,md_bansh05       "; // Banshee Cr 25
    return arregloDVDs;
}


////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// PLANARIOS /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//____________________________ Planars / Azer _______________________________
// CRs: 2,3,5        Factions: ?
string ADE_Planar_Azer_get();
string ADE_Planar_Azer_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "002,M,023,110,????????,zep_azermale001  "; // Azer Male Sergeant D&D cr2
    arregloDMDs += "002,M,023,110,????????,zep_azerfemal001 "; // Azer female soldier D&D cr2
    arregloDMDs += "003,M,023,110,????????,azer003          "; // Azer Lieutenant D&D cr3
    arregloDMDs += "005,M,023,110,????????,azer002          "; // Azer Male Captain D&D cr5
    return arregloDMDs;
}


//____________________________ Planars / Bladelings _______________________________
// CRs: 10        Factions: ?
string ADE_Planar_Bladelings_get();
string ADE_Planar_Bladelings_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "010,M,023,110,????????,bladeling1       "; // Bladeling D&D cr10
    arregloDMDs += "010,M,023,110,????????,bladeling2       "; // Bladeling Clerigo D&D cr10
    return arregloDMDs;
}


//____________________________ Planars / Celestial Arcontes _______________________________
// CRs: 4,6,18        Factions: ?
string ADE_Celestial_Archon_get();
string ADE_Celestial_Archon_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "004,M,023,110,????????,chound002        "; // Canarconte D&D cr4
    arregloDMDs += "016,M,023,110,????????,chound003        "; // Canarconte Heroe D&D cr16
    arregloDMDs += "018,M,023,110,????????,clantern001      "; // Lamparconte D&D cr22
    return arregloDMDs;
}


//____________________________ Planars / Celestial Deva _______________________________
// CRs: 14        Factions: ?
string ADE_Celestial_Deva_get();
string ADE_Celestial_Deva_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "014,M,023,110,????????,creature         "; // Astral Deva D&D cr14
    return arregloDMDs;
}


//______________________Planar / Celestial Eladrin ___________________________________________
// CRs: 7,10,14        Factions: ?
string ADE_Celestial_Eladrin_getVariado();
string ADE_Celestial_Eladrin_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "007,M,030,110,????????,bralani          "; // Bralani D&D cr7
    arregloDVDs +=  "007,M,030,110,????????,bralani001       "; // Bralani D&D cr7
    arregloDVDs +=  "010,M,030,110,????????,firre            "; // Firre D&D cr10
    arregloDVDs +=  "010,M,030,110,????????,firre001         "; // Firre D&D cr10
    arregloDVDs +=  "014,M,030,110,????????,creature009      "; // Ghaele D&D cr14
    arregloDVDs +=  "014,M,030,110,????????,creature004      "; // Ghaele D&D cr14
    return arregloDVDs;
}



//____________________________ Planars / Celestial Guardinals _______________________________
// CRs: 4,5,6,7,12        Factions: ?
string ADE_Celestial_Guard_get();
string ADE_Celestial_Guard_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "004,M,023,110,????????,lupinal002       "; // Lupinal D&D cr5
    arregloDMDs += "004,M,023,110,????????,lupinal2         "; // Lupinal D&D cr5
    arregloDMDs += "005,M,023,110,????????,lupinal3         "; // Lupinal Combatiente D&D cr6
    arregloDMDs += "005,M,023,110,????????,lupinal4         "; // Lupinal Combatiente D&D cr6
    arregloDMDs += "006,M,023,110,????????,lupinal5         "; // Lupinal Veterano D&D cr7
    arregloDMDs += "006,M,023,110,????????,lupinal6         "; // Lupinal Veterano D&D cr7
    arregloDMDs += "007,M,023,110,????????,lupinal7         "; // Lupinal Lider D&D cr8
    arregloDMDs += "007,M,023,110,????????,lupinal8         "; // Lupinal Lider D&D cr8
    arregloDMDs += "012,M,023,110,????????,leonal           "; // Leonal D&D cr12
    return arregloDMDs;
}


//____________________________ Planars / Celestial Semicelestial _______________________________
// CRs: 11        Factions: ?
string ADE_Celestial_Half_get();
string ADE_Celestial_Half_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "011,M,023,110,????????,semicelestial1   "; // Semicelestial D&D cr11
    arregloDMDs += "011,M,023,110,????????,semicelestial2   "; // Semicelestial D&D cr11
    return arregloDMDs;
}


//____________________________ Planars / Demonios Abishai _______________________________
// CRs: 5,6,7,8,9,10        Factions: Hostile
string ADE_Demon_Abisai_get();
string ADE_Demon_Abisai_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "005,M,016,110,????????,abishai1         "; // "Abishai (Baatezu)"; outsider  5, ab= 5,ac=15,hp=22; {5 x Animate Dead [cl=4], 2 x Dominate Person [cl=4], 5 x Scare [cl=4], 1 x Summon Baatezu }
    arregloDMDs += "006,M,016,110,????????,abishai2         "; // "Abishai (Baatezu)"; outsider  7, ab= 7,ac=17,hp=29; {5 x animate dead [cl=5], 2 x Dominate Person [cl=5], 5 x Scare [cl=5], 1 x Summon Baetezu }
    arregloDMDs += "007,M,016,110,????????,abishai3         "; // "Abishai (Baatezu)"; outsider  9, ab=10,ac=19,hp=37; {5 x Animate Dead [cl=6], 2 x Dominate Person [cl=6], 5 x Scare [cl=6], 1 x Summon Baatezu }
    arregloDMDs += "008,M,016,110,????????,abishai4         "; // "Abishai (Baatezu)"; outsider 11, ab=12,ac=21,hp=45; {5 x Animate Dead [cl=7], 2 x Dominate Person [cl=7], 5 x Scare [cl=7], 1 x Summon Baatezu }
    arregloDMDs += "009,M,016,110,????????,abishai5         "; // "Abishai (Baatezu)"; outsider 13, ab=15,ac=23,hp=54; {5 x Animate Dead [cl=8], 2 x Dominate Person [cl=8], 5 x Scare [cl=8], 2 x Summon Baatezu }
    arregloDMDs += "010,M,016,110,????????,abishai6         "; // "Abishai (Baatezu)"; outsider 15, ab=17,ac=25,hp=63; {5 x Animate Dead [cl=9], 2 x Dominate Person [cl=9], 5 x Scare [cl=9], 2 x Summon Baatezu }

    return arregloDMDs;
}


//______________________ Planar / Demonios ___________________________________________
// CRs: 2,3,7,8,9,10,11,12,13,17,18,20        Factions: ?
string ADE_Planar_Demon_get();
string ADE_Planar_Demon_get() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="002,M,030,110,????????,dmquasit001      "; // Quasit D&D cr2
    arregloDVDs +="005,M,030,110,????????,shmastif002      "; // "Mastin Sombrio D&D" outsider 8; ab=8,ac=11,hp=20 {1x howl fear}
    arregloDVDs +="006,M,030,110,????????,durzagon1        "; // "Half-Fiend Durzagon" outsider 10, ab=10,ac=14,hp=20; {3x darkness, 1x invisibility}
    arregloDVDs +="006,S,030,110,????????,zep_succubus     "; // "Succubus" outsider 6; ab=7,ac=20,hp=27 {3x charm monster, ...; cl=12; 1x summon Tanarri}
    arregloDVDs +="007,S,030,110,????????,zep_nighthag     "; // "Night Hag" outsider 8; ab=12,ac=20,hp=36; {6 x magic Missile, 6 x ray of enfeeblement, 6 x sleep; cl=8}
    arregloDVDs +="008,M,030,110,????????,zep_vrock        "; // "Vroc" ousider  8; ab=12,ac=25,hp=60; {?}
    arregloDVDs +="009,M,030,110,????????,shmastif001      "; // Perro de Guerra Nessiano D&D cr10
    arregloDVDs +="010,S,030,110,????????,spiderdemo002    "; // Bebilith D&D cr10
    arregloDVDs +="013,S,030,110,????????,zep_glabrezu001  "; // Glabrezu D&D cr13
    arregloDVDs +="017,S,030,110,????????,zep_merilith003  "; // Marilith D&D cr17
    arregloDVDs +="018,S,030,110,????????,demon001         "; // Balor D&D cr20
    arregloDVDs +="020,S,030,110,????????,halfdragonfiend  "; // Balor D&D cr22
    return arregloDVDs;
}


//______________________ Planar / Diablos ___________________________________________
// CRs: 2,3,4,8,9,10,12,15,18        Factions: ?
string ADE_Planar_Devil_get();
string ADE_Planar_Devil_get() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="002,M,030,110,????????,imp001           "; // Diablillo D&D cr2
    arregloDVDs +="003,M,030,110,????????,hellhound001     "; // Can del Infierno D&D cr3
    arregloDVDs +="007,S,030,110,????????,dmsucubus001     "; // Sucubo D&D cr7
    arregloDVDs +="009,M,030,110,????????,zep_osyluth002   "; // "Osyluth" outsider 11; ab=18,ac=17,hp=69; {10 x invisibility; 4 x aura of fear}
    arregloDVDs +="010,M,030,110,????????,zep_hamatula001  "; // "Hamatula" outsider 11; ab=20,ac=19,hp=
    arregloDVDs +="011,M,030,110,????????,semiinfernal1    "; // "Semi-infernal" cleric 13; ab=13,ac=26,hp=109
    arregloDVDs +="012,M,030,110,????????,semiinfernal2    "; // "Semi-infernal" cleric 15; ab=15,ac=26,hp=122
    arregloDVDs +="013,M,030,110,????????,zep_gelugon      "; // "Gelugon" outsider 12; ab=18,ac=28,hp=52
    arregloDVDs +="015,M,030,110,????????,zep_cornugong001 "; // "Cornugon (Diablo Astado Baatezu)" ousider 22; ab=27,ac=29,hp=84;  {3 x Fireball [cl=15]; 3 x Lighting bolt [cl=15]; 2 x Aura of fear, 1 x Summon Baetezu}
    arregloDVDs +="016,M,030,110,????????,zep_cornugong002 "; // "Cornugon (Diablo Astado Baatezu)" ousider 24; ab=28,ac=31,hp=148; {3 x Fireball [cl=15]; 3 x Lighting bolt [cl=15]; 3 x Aura of fear, 1 x Summon Baetezu}
    arregloDVDs +="018,S,030,110,????????,zep_pitfiend001  "; // Diablo de la cima D&D cr20
    return arregloDVDs;
}


//______________________ Planar / Djinn ___________________________________________
// CRs: 3,5,8        Factions: ?
string ADE_Planar_Djinn_getVariado();
string ADE_Planar_Djinn_getVariado() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="003,M,030,110,????????,djinni002        "; // Janni D&D cr4
    arregloDVDs +="003,M,030,110,????????,djinni003        "; // Janni D&D cr4
    arregloDVDs +="005,M,030,110,????????,djinni           "; // Djinni D&D cr5
    arregloDVDs +="008,M,030,110,????????,djinni001        "; // Ifriti D&D cr8
    return arregloDVDs;
}

/*
//____________________________ Planars / Formicida _______________________________
// CRs: 1,3,7,10,15        Factions: ?
string ADE_Planar_Formicida_get();
string ADE_Planar_Formicida_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "001,M,023,110,????????,form_worker001   "; // Formicida Obrera CR1
    arregloDMDs += "003,M,023,110,????????,form_warrior001  "; // Formicida Soldado     CR3
    arregloDMDs += "007,M,023,110,????????,form_taskmast001 "; // Formicida Capataz     CR7
    arregloDMDs += "010,M,023,110,????????,form_myrmarch001 "; // Formicida Myrmarca    CR10
    arregloDMDs += "015,M,023,110,????????,form_queen001    "; // FOrmicida Reina   CR17
    return arregloDMDs;
}
*/

//____________________________ Planars / Formicidas _______________________________
// CRs: 1-17        Factions: Hostil
string ADE_Planar_Formicida_getMelee();
string ADE_Planar_Formicida_getMelee() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "001,M,023,110,????????,form_worker001   "; // Formicida Obrera D&D   CR1  (Ajeno 1)
    arregloDMDs += "002,M,023,110,????????,form_worker002   "; // Formicida Obrera D&D   CR3  (Ajeno 3)
    arregloDMDs += "003,M,023,110,????????,form_warrior001  "; // Formicida Soldado D&D  CR3  (Ajeno 4)
    arregloDMDs += "005,M,023,110,????????,form_warrior002  "; // Formicida Soldado D&D  CR5  (Ajeno 6)
    arregloDMDs += "007,M,023,110,????????,form_warrior003  "; // Formicida Soldado D&D  CR7  (Ajeno 8)
    arregloDMDs += "009,M,023,110,????????,form_warrior004  "; // Formicida Soldado D&D  CR9  (Ajeno 10)
    arregloDMDs += "010,M,023,110,????????,form_myrmarch001 "; // Formicida Myrmarca D&D CR10 (Ajeno 12)
    arregloDMDs += "012,M,023,110,????????,form_myrmarch002 "; // Formicida Myrmarca D&D CR12 (Ajeno 14)
    arregloDMDs += "014,M,023,110,????????,form_myrmarch003 "; // Formicida Myrmarca D&D CR14 (Ajeno 16)
    arregloDMDs += "015,M,023,110,????????,form_myrmarch004 "; // Formicida Myrmarca D&D CR15 (Ajeno 18)
    arregloDMDs += "017,M,023,110,????????,form_myrmarch005 "; // Formicida Myrmarca D&D CR17 (Ajeno 20)
    return arregloDMDs;
}

// CRs: 7-15        Factions: Hostil
string ADE_Planar_Formicida_getCaster();
string ADE_Planar_Formicida_getCaster() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "007,S,023,110,????????,form_taskmast001 "; // Formicida Capataz D&D  CR7  (Ajeno 6)
    arregloDMDs += "009,S,023,110,????????,form_taskmast002 "; // Formicida Capataz D&D  CR9  (Ajeno 9)
    arregloDMDs += "011,S,023,110,????????,form_taskmast003 "; // Formicida Capataz D&D  CR12 (Ajeno 12)
    arregloDMDs += "015,S,023,110,????????,form_queen001    "; // FOrmicida Reina   D&D  CR17 (Ajeno 3, Sorc 17)
    return arregloDMDs;
}


//______________________ Planar / Mephits Air ___________________________________________
// CRs: 3        Factions: ?
string ADE_Planar_MefitA_getVariado();
string ADE_Planar_MefitA_getVariado() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="003,M,030,110,????????,mepair001        "; // Mephit de Air cr3
    arregloDVDs +="003,M,030,110,????????,mepair002        "; // Mephit de Air cr3
    arregloDVDs +="003,M,030,110,????????,mepice002        "; // Mephit de Hielo cr3
    return arregloDVDs;
}


//______________________ Planar / Mephits Earth ___________________________________________
// CRs: 3        Factions: ?
string ADE_Planar_MefitE_getVariado();
string ADE_Planar_MefitE_getVariado() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="003,M,030,110,????????,mepsalt001       "; // Mephit de Sal cr3
    arregloDVDs +="003,M,030,110,????????,mepsalt002       "; // Mephit de Sal cr3
    return arregloDVDs;
}


//______________________ Planar / Mephits Fire ___________________________________________
// CRs: 3        Factions: ?
string ADE_Planar_MefitF_getVariado();
string ADE_Planar_MefitF_getVariado() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="003,M,030,110,????????,mepfire001       "; // Mephit de Fire cr3
    arregloDVDs +="003,M,030,110,????????,mepfire002       "; // Mephit de Fire cr3
    arregloDVDs +="003,M,030,110,????????,mepfire003       "; // Mephit de Fire cr3
    return arregloDVDs;
}


//______________________ Planar / Mephits Water ___________________________________________
// CRs: 3        Factions: ?
string ADE_Planar_MefitW_getVariado();
string ADE_Planar_MefitW_getVariado() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="003,M,030,110,????????,mepwater001      "; // Mephit de Agua cr3
    arregloDVDs +="003,M,030,110,????????,mepooze001       "; // Mephit de Cieno cr3
    return arregloDVDs;
}


//______________________ Planar / Rakshasa ___________________________________________
// CRs: 9        Factions: ?
string ADE_Planar_Rak_getVariado();
string ADE_Planar_Rak_getVariado() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="009,M,030,110,????????,rakshasa         "; // Rakshasa D&D cr9
    arregloDVDs +="009,M,030,110,????????,rakshasa1        "; // Rakshasa D&D cr9
    return arregloDVDs;
}


//____________________________ Planars / Slaadi _______________________________
// CRs: 7,8,9,10,13        Factions: ?
string ADE_Planar_Slaad_get();
string ADE_Planar_Slaad_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "007,M,023,110,????????,slaadred001      "; // Slaad Rojo CR7
    arregloDMDs += "008,M,023,110,????????,slaadbl001       "; // Slaad Azul CR8
    arregloDMDs += "009,M,023,110,????????,slaadgrn001      "; // Slaad Verde CR9
    arregloDMDs += "010,M,023,110,????????,slaadgray001     "; // Slaad Gris CR10
    arregloDMDs += "013,M,023,110,????????,slaaddeth001     "; // Slaad de la Muerte CR13
    return arregloDMDs;
}


//______________________ Planar / Xorn ___________________________________________
// CRs: 8        Factions: ?
string ADE_Planar_Xorn_getVariado();
string ADE_Planar_Xorn_getVariado() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="008,M,030,110,????????,xorn01           "; // Xorn Anciano D&D cr8
    return arregloDVDs;
}


//______________________ Plantas / Variado ___________________________________________
// CRs: 3,5,8        Factions: Hostil , Animal
string ADE_Plantas_getVariado();
string ADE_Plantas_getVariado() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="003,M,030,110,????????,zep_vines003     "; // Enredadera Asesina D&D (Mounstruos 4) F:Hostil
    arregloDVDs +="005,M,030,110,????????,zep_vines004     "; // Enredadera Asesina D&D (Mounstruos 7) F:Hostil
    arregloDVDs +="008,S,030,110,????????,vr_ent_cr08      "; //
    arregloDVDs +="011,S,030,110,????????,vr_ent_cr11      "; //
    arregloDVDs +="013,S,030,110,????????,vr_ent_cr13      "; //
    arregloDVDs +="016,S,030,110,????????,vr_ent_cr16      "; //
    arregloDVDs +="018,S,030,110,????????,vr_ent_cr18      "; //
    arregloDVDs +="020,S,030,110,????????,vr_ent_cr20      "; //
    arregloDVDs +="022,S,030,110,????????,vr_ent_cr22      "; //
    arregloDVDs +="024,S,030,110,????????,vr_ent_cr24      "; //
    return arregloDVDs;
}


//____________________________ Plantas / Vegepygmy _______________________________
// CRs: 5,7        Factions: Hostile
string ADE_Pantas_VPygmy_get();
string ADE_Pantas_VPygmy_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "005,M,023,110,????????,giant001         "; // Giant 6 "Plants / Vegepygmy D&D" 4.87
    arregloDMDs += "007,M,023,110,????????,giant002         "; // Giant 8 "Plants / Thorny D&D" 7.40
    arregloDMDs += "007,M,023,110,????????,giant003         "; // Giant 8 "Plants / Thorny Rider D&D" 7.40
    return arregloDMDs;
}


////////////////////////////////////////////////////////////////////////////////
/////////////////////// CATEGORIZADO MISCELANEO ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Mover las criaturas de estos arreglos a donde corresponda

//______________________Aberraciones ___________________________________________
// deprecated  (no usar)
string ADE_Miscelaneo1_getVariado();
string ADE_Miscelaneo1_getVariado() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="003,L,023,110,????????,pm002            "; // aberration 5     "Tracnido D&D" seguidor=pm002a
//    seguidor:   "003,   ,   , ,pm002a           "  // vermin 4         "Insects / Spiders / Arania Gigante D&D"  { 3 x Web [Caster Level:4] }
    arregloDVDs +="003,L,030,110,????????,pm001            "; // vermin 5         "Insects / Scorpions / Escorpion Negro Enorme D&D"
//    seguidor:   "001,   ,   , ,pm001a           "  // vermin 2         "Insects / Scorpions / Escorpion Negro Enorme D&D"
    arregloDVDs +="004,M,030,110,????????,pm003            "; // monstrous 7      "Humanoid / Other / Arpia D&D" [1 x Captivating Song]
    arregloDVDs +="004,S,070,110,????????,ps004            "; // monstrous 3      "Humanoid / Other / Saga Marina D&D" { 3 x Fear [Caster Level:15], 3 x Phantasmal Killer [Caster Level:3], 1 x Horrific Appearance }
    arregloDVDs +="005,M,030,110,????????,pm004            "; // magical beast 6  "Magical Beast / Bestia Tremula D&D"  Hostil
    arregloDVDs +="005,S,070,109,????????,ps005            "; // magical beast 6  "Magical Beasts / Manticora D&D" [5 x Manticore Spikes]
    arregloDVDs +="006,S,050,109,????????,ps006            "; // magical beast 9  "Magical Beasts / Quimera D&D" [15 x Cone of Fire] //
    arregloDVDs +="007,S,050,107,????????,ps007            "; // beast 9          "Magical Beasts / Terraron D&D" [nada]
    arregloDVDs +="008,M,030,108,????????,pm006a           "; // aberration 9     "Fuego Fatuo D&D"
    arregloDVDs +="008,S,033,106,????????,ps008            "; // beast 10         "Magical Beasts / Desgarrador Gris D&D"
    return arregloDVDs;
}


////////////////////////////////////////////////////////////////////////////////
/////////////////////// CATEGORIZADO POR AREA //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// No hay que categorizar por area. Los arreglos que ya estan aqui deben ser recategorizados.


//______________________Esteros Centrales - Camino ___________________________
// predecated (no usar)
string ADE_EsterosCentrales_Camino_getVariado();
string ADE_EsterosCentrales_Camino_getVariado() {
    string arregloDVDs;
               // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +="002,S,070,110,????????,ps001            "; // animal 2         "animal / snakes / Serpiente Venenosa del pantano D&D" 1.74 Serpientes
    arregloDVDs +="004,S,070,110,????????,ps003            "; // giant 6          "Giant / Trolls / Troll D&D"
    arregloDVDs +="006,S,070,110,????????,ps002            "; // animal 11        "animal / other / Serpiente constrictora gigante D&D"
    arregloDVDs +="009,S,033,106,????????,ps009            "; // giant 6 ranger 6 "Giant / Trolls / Troll Hunter D&D"
    return arregloDVDs + ADE_Miscelaneo1_getVariado();
}


//____________________________Bosque de Trommel _______________________________
// predecated  (no usar)
string ADE_Benzor_Trommel_getVariado();
string ADE_Benzor_Trommel_getVariado() {
    string arregloDVDs;
                 // "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDVDs +=  "007,M,030,110,????????,willowisp001     "; // Aberration 9    "Aberrations / Fuego Fatuo D&D"
    arregloDVDs +=  "007,M,030,110,????????,ettin003         "; // Giant 10        "Giant / Common / Ettin D&D"
    arregloDVDs +=  "008,S,033,106,????????,ps008            "; // beast 10        "Magical Beasts / Desgarrador Gris D&D"
    arregloDVDs +=  "008,M,030,110,????????,grayrend001      "; // Beast 10        "Magical Beasts / Desgarrador Gris D&D"
    arregloDVDs +=  "009,M,030,110,????????,gnthill001       "; // Giant 12        "Giant / Common / Gigante de las Colinas D&D"
    arregloDVDs +=  "015,S,030,120,????????,osolegendario1   "; // animal 20       "Animals / Bear / Oso Legandario D&D"

    return arregloDVDs;
}

////////////////////////////////////////////////////////////////////////////////
///////////////////////////// RAzAS JUGABLES ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//____________________________ HUMANOS / BARBAROS _______________________________
// CRs: 3-17        Factions: Plebeyo
string ADE_Merc_HuBarb_get();
string ADE_Merc_HuBarb_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,partya008        "; // Barbara Humana, Barbarian 4 (fem)
    arregloDMDs += "003,M,023,110,????????,partya003        "; // Barbaro Humano, Barbarian 4 (mas)
    arregloDMDs += "005,M,023,110,????????,partya0028       "; // Barbara Humana, Barbarian 6 (fem)
    arregloDMDs += "005,M,023,110,????????,partya0027       "; // Barbaro Humano, Barbarian 6 (mas)
    arregloDMDs += "007,M,023,110,????????,partya0046       "; // Barbara Humana, Barbarian 8 (fem)
    arregloDMDs += "007,M,023,110,????????,partya0045       "; // Barbaro Humano, Barbarian 8 (mas)
    arregloDMDs += "009,M,023,110,????????,partya0066       "; // Barbara Humana, Barbarian 11 (fem)
    arregloDMDs += "009,M,023,110,????????,partya0065       "; // Barbaro Humano, Barbarian 11 (mas)
    arregloDMDs += "012,M,023,110,????????,partya0086       "; // Barbara Humana, Barbarian 14 (fem)
    arregloDMDs += "012,M,023,110,????????,partya0085       "; // Barbaro Humano, Barbarian 14 (mas)
    arregloDMDs += "014,M,023,110,????????,mBarbarian17f    "; // Barbara Humana, Barbarian 17 (fem)
    arregloDMDs += "014,M,023,110,????????,mBarbarian17m    "; // Barbaro Humano, Barbarian 17 (mas)
    arregloDMDs += "017,M,023,110,????????,mBarbarian20f    "; // Barbara Humana, Barbarian 20 (fem)
    arregloDMDs += "017,M,023,110,????????,mBarbarian20m    "; // Barbaro Humano, Barbarian 20 (mas)
    return arregloDMDs;
}

//____________________________ HUMANOS / GUERREROS _______________________________
// CRs: 3-12        Factions: Plebeyo
string ADE_Merc_HuFight_get();
string ADE_Merc_HuFight_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,partya0013       "; // Guerrera D&D, Fighter 4 (bastard sword)
    arregloDMDs += "003,M,023,110,????????,partya0012       "; // Guerrero D&D, Fighter 4 (bastard sword)
    arregloDMDs += "005,M,023,110,????????,partya0036       "; // Guerrera D&D, Fighter 6 (bastard sword)
    arregloDMDs += "005,M,023,110,????????,partya0035       "; // Guerrero D&D, Fighter 6 (bastard sword)
    arregloDMDs += "007,M,023,110,????????,partya0058       "; // Guerrera D&D, Fighter 8 (bastard sword)
    arregloDMDs += "007,M,023,110,????????,partya0057       "; // Guerrero D&D, Fighter 8 (bastard sword)
    arregloDMDs += "010,M,023,110,????????,partya0078       "; // Guerrera D&D, Fighter 11 (bastard sword)
    arregloDMDs += "010,M,023,110,????????,partya0077       "; // Guerrero D&D, Fighter 11 (bastard sword)
    arregloDMDs += "012,M,023,110,????????,partya0098       "; // Guerrera D&D, Fighter 14 (bastard sword)
    arregloDMDs += "012,M,023,110,????????,partya0097       "; // Guerrero D&D, Fighter 14 (bastard sword)
    arregloDMDs += "015,M,023,110,????????,mFighter17f      "; // Guerrera D&D, Fighter 17 (bastard sword)
    arregloDMDs += "015,M,023,110,????????,mFighter17m      "; // Guerrero D&D, Fighter 17 (bastard sword)
    arregloDMDs += "018,M,023,110,????????,mFighter20f      "; // Guerrera D&D, Fighter 20 (bastard sword)
    arregloDMDs += "018,M,023,110,????????,mFighter20m      "; // Guerrero D&D, Fighter 20 (bastard sword)
    return arregloDMDs;
}

//____________________________ HUMANOS / HECHICEROS _______________________________
// CRs: 3-16        Factions: Plebeyo
string ADE_Merc_HuSorc_get();
string ADE_Merc_HuSorc_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,partye001        "; // Hechicero Humano, Sorcerer 4 (mas)
    arregloDMDs += "003,M,023,110,????????,partye002        "; // Hechicero Humano, Sorcerer 4 (fem)
    arregloDMDs += "005,M,023,110,????????,partye0013       "; // Hechicero Humano, Sorcerer 6 (mas)
    arregloDMDs += "005,M,023,110,????????,partye0014       "; // Hechicero Humano, Sorcerer 6 (fem)
    arregloDMDs += "007,M,023,110,????????,partye0027       "; // Hechicero Humano, Sorcerer 8 (mas)
    arregloDMDs += "007,M,023,110,????????,partye0028       "; // Hechicero Humano, Sorcerer 8 (fem)
    arregloDMDs += "009,M,023,110,????????,partye0039       "; // Hechicero Humano, Sorcerer 11(mas)
    arregloDMDs += "009,M,023,110,????????,partye0040       "; // Hechicero Humano, Sorcerer 11(fem)
    arregloDMDs += "012,M,023,110,????????,partye0051       "; // Hechicero Humano, Sorcerer 14(mas)
    arregloDMDs += "012,M,023,110,????????,partye0052       "; // Hechicero Humano, Sorcerer 14(fem)
    arregloDMDs += "014,M,023,110,????????,msorc17m         "; // Hechicero Humano, Sorcerer 17(mas)
    arregloDMDs += "014,M,023,110,????????,msorc17f         "; // Hechicero Humano, Sorcerer 17(fem)
    arregloDMDs += "016,M,023,110,????????,msorc20m         "; // Hechicero Humano, Sorcerer 20(mas)
    arregloDMDs += "016,M,023,110,????????,msorc20f         "; // Hechicero Humano, Sorcerer 20(fem)
    return arregloDMDs;
}

//____________________________ HUMANOS / PICAROS _______________________________
// CRs: 3-16        Factions: Plebeyo
string ADE_Merc_HuRogue_get();
string ADE_Merc_HuRogue_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,partyc004        "; // Picaro Humano, Picaro 4 (fem), ranged
    arregloDMDs += "003,M,023,110,????????,partyc003        "; // Picaro Humano, Picaro 4 (mas), ranged
    arregloDMDs += "003,M,023,110,????????,mrogue04fb       "; // Picaro Humano, Picaro 4 (fem), melee
    arregloDMDs += "003,M,023,110,????????,mrogue04mb       "; // Picaro Humano, Picaro 4 (mas), melee
    arregloDMDs += "005,M,023,110,????????,partyc0022       "; // Picaro Humano, Picaro 6 (fem), ranged
    arregloDMDs += "005,M,023,110,????????,partyc0021       "; // Picaro Humano, Picaro 6 (mas), ranged
    arregloDMDs += "005,M,023,110,????????,mrogue06fb       "; // Picaro Humano, Picaro 6 (fem), melee
    arregloDMDs += "005,M,023,110,????????,mrogue06mb       "; // Picaro Humano, Picaro 6 (mas), melee
    arregloDMDs += "007,M,023,110,????????,partyc0048       "; // Picaro Humano, Picaro 8 (fem), ranged
    arregloDMDs += "007,M,023,110,????????,partyc0047       "; // Picaro Humano, Picaro 8 (mas), ranged
    arregloDMDs += "007,M,023,110,????????,mrogue08fb       "; // Picaro Humano, Picaro 8 (fem), melee
    arregloDMDs += "007,M,023,110,????????,mrogue08mb       "; // Picaro Humano, Picaro 8 (mas), melee
    arregloDMDs += "009,M,023,110,????????,partyc0062       "; // Picaro Humano, Picaro 11(fem), ranged
    arregloDMDs += "009,M,023,110,????????,partyc0061       "; // Picaro Humano, Picaro 11(mas), ranged
    arregloDMDs += "009,M,023,110,????????,mrogue11fb       "; // Picaro Humano, Picaro 11(fem), melee
    arregloDMDs += "009,M,023,110,????????,mrogue11mb       "; // Picaro Humano, Picaro 11(mas), melee
    arregloDMDs += "011,M,023,110,????????,partyc0080       "; // Picaro Humano, Picaro 14(fem), ranged
    arregloDMDs += "011,M,023,110,????????,partyc0079       "; // Picaro Humano, Picaro 14(mas), ranged
    arregloDMDs += "011,M,023,110,????????,mrogue14fb       "; // Picaro Humano, Picaro 14(fem), melee
    arregloDMDs += "011,M,023,110,????????,mrogue14mb       "; // Picaro Humano, Picaro 14(mas), melee
    arregloDMDs += "013,M,023,110,????????,mrogue17f        "; // Picaro Humano, Picaro 17(fem), ranged
    arregloDMDs += "013,M,023,110,????????,mrogue17m        "; // Picaro Humano, Picaro 17(mas), ranged
    arregloDMDs += "013,M,023,110,????????,mrogue17fb       "; // Picaro Humano, Picaro 17(fem), melee
    arregloDMDs += "013,M,023,110,????????,mrogue17mb       "; // Picaro Humano, Picaro 17(mas), melee
    arregloDMDs += "016,M,023,110,????????,mrogue20f        "; // Picaro Humano, Picaro 20(fem), ranged
    arregloDMDs += "016,M,023,110,????????,mrogue20m        "; // Picaro Humano, Picaro 20(mas), ranged
    arregloDMDs += "016,M,023,110,????????,mrogue20fb       "; // Picaro Humano, Picaro 20(fem), melee
    arregloDMDs += "016,M,023,110,????????,mrogue20mb       "; // Picaro Humano, Picaro 20(mas), melee
    return arregloDMDs;
}

//____________________________ MEDIANOS / Guerreros _______________________________
// CRs: 3-18        Factions: Plebeyo
string ADE_Halflings_Fighter_getMelee();
string ADE_Halflings_Fighter_getMelee() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,mhobbfight04     "; // Guerrero Mediano D&D (Fighter 4)
    arregloDMDs += "003,M,023,110,????????,mhobbfight04f    "; // Guerrera Mediana D&D (Fighter 4)
    arregloDMDs += "005,M,023,110,????????,mHobbFight06     "; // Guerrero Mediano D&D (Fighter 6)
    arregloDMDs += "005,M,023,110,????????,mHobbFight06f    "; // Guerrera Mediana D&D (Fighter 6)
    arregloDMDs += "007,M,023,110,????????,mHobbFight08     "; // Guerrero Mediano D&D (Fighter 8)
    arregloDMDs += "007,M,023,110,????????,mHobbFight08f    "; // Guerrera Mediana D&D (Fighter 8)
    arregloDMDs += "010,M,023,110,????????,mHobbFight11     "; // Guerrero Mediano D&D (Fighter 11)
    arregloDMDs += "010,M,023,110,????????,mHobbFight11f    "; // Guerrera Mediana D&D (Fighter 11)
    arregloDMDs += "012,M,023,110,????????,mHobbFight14     "; // Guerrero Mediano D&D (Fighter 14)
    arregloDMDs += "012,M,023,110,????????,mHobbFight14f    "; // Guerrera Mediana D&D (Fighter 14)
    arregloDMDs += "015,M,023,110,????????,mHobbFight17     "; // Guerrero Mediano D&D (Fighter 17)
    arregloDMDs += "015,M,023,110,????????,mHobbFight17f    "; // Guerrera Mediana D&D (Fighter 17)
    arregloDMDs += "018,M,023,110,????????,mHobbFight20     "; // Guerrero Mediano D&D (Fighter 20)
    arregloDMDs += "018,M,023,110,????????,mHobbFight20f    "; // Guerrera Mediana D&D (Fighter 20)
    return arregloDMDs;
}

//____________________________ SEMIORCOS / BARBAROS _______________________________
// CRs: 4-18        Factions: Plebeyo
string ADE_Merc_HOrcBarbarians_get();
string ADE_Merc_HOrcBarbarians_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "004,M,023,110,????????,partya002        "; // Barbaro Semiorco, Barbarian 4
    arregloDMDs += "004,M,023,110,????????,partya006        "; // Barbaro Semiorco, Barbarian 4
    arregloDMDs += "004,M,023,110,????????,partya0011       "; // Barbaro Semiorco, Barbarian 4
    arregloDMDs += "004,M,023,110,????????,partya0016       "; // Barbaro Semiorco, Barbarian 4
    arregloDMDs += "006,M,023,110,????????,partya0021       "; // Barbaro Semiorco, Barbarian 6
    arregloDMDs += "006,M,023,110,????????,partya0022       "; // Barbaro Semiorco, Barbarian 6
    arregloDMDs += "006,M,023,110,????????,partya0023       "; // Barbaro Semiorco, Barbarian 6
    arregloDMDs += "006,M,023,110,????????,partya0024       "; // Barbaro Semiorco, Barbarian 6
    arregloDMDs += "008,M,023,110,????????,partya0048       "; // Barbaro Semiorco, Barbarian 8
    arregloDMDs += "008,M,023,110,????????,partya0047       "; // Barbaro Semiorco, Barbarian 8
    arregloDMDs += "008,M,023,110,????????,partya0050       "; // Barbaro Semiorco, Barbarian 8
    arregloDMDs += "008,M,023,110,????????,partya0049       "; // Barbaro Semiorco, Barbarian 8
    arregloDMDs += "010,M,023,110,????????,partya0069       "; // Barbaro Semiorco, Barbarian 11
    arregloDMDs += "010,M,023,110,????????,partya0070       "; // Barbaro Semiorco, Barbarian 11
    arregloDMDs += "010,M,023,110,????????,partya0067       "; // Barbaro Semiorco, Barbarian 11
    arregloDMDs += "010,M,023,110,????????,partya0068       "; // Barbaro Semiorco, Barbarian 11
    arregloDMDs += "013,M,023,110,????????,partya0089       "; // Barbaro Semiorco, Barbarian 14
    arregloDMDs += "013,M,023,110,????????,partya0090       "; // Barbaro Semiorco, Barbarian 14
    arregloDMDs += "013,M,023,110,????????,partya0087       "; // Barbaro Semiorco, Barbarian 14
    arregloDMDs += "013,M,023,110,????????,partya0088       "; // Barbaro Semiorco, Barbarian 14
    arregloDMDs += "016,M,023,110,????????,partya090        "; // Barbaro Semiorco, Barbarian 17
    arregloDMDs += "016,M,023,110,????????,partya091        "; // Barbaro Semiorco, Barbarian 17
    arregloDMDs += "016,M,023,110,????????,partya088        "; // Barbaro Semiorco, Barbarian 17
    arregloDMDs += "016,M,023,110,????????,partya089        "; // Barbaro Semiorco, Barbarian 17
    arregloDMDs += "018,M,023,110,????????,partya092        "; // Barbaro Semiorco, Barbarian 20
    arregloDMDs += "018,M,023,110,????????,partya093        "; // Barbaro Semiorco, Barbarian 20
    arregloDMDs += "018,M,023,110,????????,partya094        "; // Barbaro Semiorco, Barbarian 20
    arregloDMDs += "018,M,023,110,????????,partya095        "; // Barbaro Semiorco, Barbarian 20
    return arregloDMDs;
}

//____________________________ SEMIORCOS / HECHICEROS _______________________________
// CRs: 4-18        Factions: Plebeyo
string ADE_Merc_HOrcSorcerer_get();
string ADE_Merc_HOrcSorcerer_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "004,M,023,110,????????,mhosorcerer04m   "; // Hechicero Semiorco, Sorcerer 4
    arregloDMDs += "004,M,023,110,????????,mhosorcerer04f   "; // Hechicero Semiorco, Sorcerer 4
    arregloDMDs += "006,M,023,110,????????,mhosorcerer06m   "; // Hechicero Semiorco, Sorcerer 6
    arregloDMDs += "006,M,023,110,????????,mhosorcerer06f   "; // Hechicero Semiorco, Sorcerer 6
    arregloDMDs += "008,M,023,110,????????,mhosorcerer08m   "; // Hechicero Semiorco, Sorcerer 8
    arregloDMDs += "008,M,023,110,????????,mhosorcerer08f   "; // Hechicero Semiorco, Sorcerer 8
    arregloDMDs += "010,M,023,110,????????,mhosorcerer11m   "; // Hechicero Semiorco, Sorcerer 11
    arregloDMDs += "010,M,023,110,????????,mhosorcerer11f   "; // Hechicero Semiorco, Sorcerer 11
    arregloDMDs += "013,M,023,110,????????,mhosorcerer14m   "; // Hechicero Semiorco, Sorcerer 14
    arregloDMDs += "013,M,023,110,????????,mhosorcerer14f   "; // Hechicero Semiorco, Sorcerer 14
    arregloDMDs += "016,M,023,110,????????,mhosorcerer17m   "; // Hechicero Semiorco, Sorcerer 17
    arregloDMDs += "016,M,023,110,????????,mhosorcerer17f   "; // Hechicero Semiorco, Sorcerer 17
    arregloDMDs += "018,M,023,110,????????,mhosorcerer20m   "; // Hechicero Semiorco, Sorcerer 20
    arregloDMDs += "018,M,023,110,????????,mhosorcerer20f   "; // Hechicero Semiorco, Sorcerer 20
    return arregloDMDs;
}

//____________________________ Wild Elves / Barbarians _______________________________
// CRs: 3-16        Factions: Plebeyo
string ADE_WildElves_Barbarian_getMelee();
string ADE_WildElves_Barbarian_getMelee() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,partya001        "; // Barbaro Elfo Salvaje D&D (Barbarian 4)
    arregloDMDs += "003,M,023,110,????????,partya007        "; // Barbara Elfa Salvaje D&D (Barbarian 4)
    arregloDMDs += "005,M,023,110,????????,partya0025       "; // Barbaro Elfo Salvaje D&D (Barbarian 6)
    arregloDMDs += "005,M,023,110,????????,partya0026       "; // Barbara Elfa Salvaje D&D (Barbarian 6)
    arregloDMDs += "007,M,023,110,????????,partya0041       "; // Barbaro Elfo Salvaje D&D (Barbarian 8)
    arregloDMDs += "007,M,023,110,????????,partya0042       "; // Barbara Elfa Salvaje D&D (Barbarian 8)
    arregloDMDs += "009,M,023,110,????????,partya0061       "; // Barbaro Elfo Salvaje D&D (Barbarian 11)
    arregloDMDs += "009,M,023,110,????????,partya0062       "; // Barbara Elfa Salvaje D&D (Barbarian 11)
    arregloDMDs += "012,M,023,110,????????,partya0081       "; // Barbaro Elfo Salvaje D&D (Barbarian 14)
    arregloDMDs += "012,M,023,110,????????,partya0082       "; // Barbara Elfa Salvaje D&D (Barbarian 14)
    arregloDMDs += "014,M,023,110,????????,mWElfBarb17m     "; // Barbaro Elfo Salvaje D&D (Barbarian 17)
    arregloDMDs += "014,M,023,110,????????,mWElfBarb17f     "; // Barbara Elfa Salvaje D&D (Barbarian 17)
    arregloDMDs += "016,M,023,110,????????,mWElfBarb20m     "; // Barbaro Elfo Salvaje D&D (Barbarian 20)
    arregloDMDs += "016,M,023,110,????????,mWElfBarb20f     "; // Barbara Elfa Salvaje D&D (Barbarian 20)
    return arregloDMDs;
}

//____________________________ Wild Elves / Sorcerers _______________________________
// CRs: 3-16        Factions: Plebeyo
string ADE_WildElves_Sorcerer_getCaster();
string ADE_WildElves_Sorcerer_getCaster() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,partye003        "; // Hechicero Elfo Salvaje D&D (Sorcerer 4)
    arregloDMDs += "003,M,023,110,????????,partye004        "; // Hechicera Elfa Salvaje D&D (Sorcerer 4)
    arregloDMDs += "005,M,023,110,????????,partye0016       "; // Hechicero Elfo Salvaje D&D (Sorcerer 6)
    arregloDMDs += "005,M,023,110,????????,partye0015       "; // Hechicera Elfa Salvaje D&D (Sorcerer 6)
    arregloDMDs += "007,M,023,110,????????,partye0025       "; // Hechicero Elfo Salvaje D&D (Sorcerer 8)
    arregloDMDs += "007,M,023,110,????????,partye0026       "; // Hechicera Elfa Salvaje D&D (Sorcerer 8)
    arregloDMDs += "009,M,023,110,????????,partye0037       "; // Hechicero Elfo Salvaje D&D (Sorcerer 11)
    arregloDMDs += "009,M,023,110,????????,partye0038       "; // Hechicera Elfa Salvaje D&D (Sorcerer 11)
    arregloDMDs += "011,M,023,110,????????,partye0049       "; // Hechicero Elfo Salvaje D&D (Sorcerer 14)
    arregloDMDs += "011,M,023,110,????????,partye0050       "; // Hechicera Elfa Salvaje D&D (Sorcerer 14)
    arregloDMDs += "014,M,023,110,????????,mWElfSorc17m     "; // Hechicero Elfo Salvaje D&D (Sorcerer 17)
    arregloDMDs += "014,M,023,110,????????,mWElfSorc17f     "; // Hechicera Elfa Salvaje D&D (Sorcerer 17)
    arregloDMDs += "016,M,023,110,????????,mWElfSorc20m     "; // Hechicero Elfo Salvaje D&D (Sorcerer 20)
    arregloDMDs += "016,M,023,110,????????,mWElfSorc20f     "; // Hechicera Elfa Salvaje D&D (Sorcerer 20)
    return arregloDMDs;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// GUARDIAS ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//____________________________ Guardia / Benzor _______________________________
// CRs: 4-18        Factions: Defensor
string ADE_Guardia_Benzor_get();
string ADE_Guardia_Benzor_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "004,M,023,110,????????,mbenguard04lsm   "; // Guardia de Benzor, Fighter 4, Longsword+Shield
    arregloDMDs += "004,M,023,110,????????,mbenguard04lsf   "; // Guardia de Benzor, Fighter 4, Longsword+Shield
    arregloDMDs += "004,M,023,110,????????,mbenguard04ssm   "; // Guardia de Benzor, Fighter 4, Shortspear+Shield
    arregloDMDs += "004,M,023,110,????????,mbenguard04ssf   "; // Guardia de Benzor, Fighter 4, Shortspear+Shield
    arregloDMDs += "006,M,023,110,????????,mbenguard06lsm   "; // Guardia de Benzor, Fighter 6, Longsword+Shield
    arregloDMDs += "006,M,023,110,????????,mbenguard06lsf   "; // Guardia de Benzor, Fighter 6, Longsword+Shield
    arregloDMDs += "006,M,023,110,????????,mbenguard06ssm   "; // Guardia de Benzor, Fighter 6, Shortspear+Shield
    arregloDMDs += "006,M,023,110,????????,mbenguard06ssf   "; // Guardia de Benzor, Fighter 6, Shortspear+Shield
    arregloDMDs += "008,M,023,110,????????,mbenguard09lsm   "; // Guardia de Benzor, Fighter 8, Longsword+Shield
    arregloDMDs += "008,M,023,110,????????,mbenguard09lsf   "; // Guardia de Benzor, Fighter 8, Longsword+Shield
    arregloDMDs += "008,M,023,110,????????,mbenguard09ssm   "; // Guardia de Benzor, Fighter 8, Shortspear+Shield
    arregloDMDs += "008,M,023,110,????????,mbenguard09ssf   "; // Guardia de Benzor, Fighter 8, Shortspear+Shield
    arregloDMDs += "010,M,023,110,????????,mbenguard12lsm   "; // Guardia de Benzor, Fighter 11, Longsword+Shield
    arregloDMDs += "010,M,023,110,????????,mbenguard12lsf   "; // Guardia de Benzor, Fighter 11, Longsword+Shield
    arregloDMDs += "010,M,023,110,????????,mbenguard12ssm   "; // Guardia de Benzor, Fighter 11, Shortspear+Shield
    arregloDMDs += "010,M,023,110,????????,mbenguard12ssf   "; // Guardia de Benzor, Fighter 11, Shortspear+Shield
    arregloDMDs += "013,M,023,110,????????,mbenguard14lsm   "; // Guardia de Benzor, Fighter 14, Longsword+Shield
    arregloDMDs += "013,M,023,110,????????,mbenguard14lsf   "; // Guardia de Benzor, Fighter 14, Longsword+Shield
    arregloDMDs += "013,M,023,110,????????,mbenguard14ssm   "; // Guardia de Benzor, Fighter 14, Shortspear+Shield
    arregloDMDs += "013,M,023,110,????????,mbenguard14ssf   "; // Guardia de Benzor, Fighter 14, Shortspear+Shield
    arregloDMDs += "016,M,023,110,????????,mbenguard17lsm   "; // Guardia de Benzor, Fighter 17, Longsword+Shield
    arregloDMDs += "016,M,023,110,????????,mbenguard17lsf   "; // Guardia de Benzor, Fighter 17, Longsword+Shield
    arregloDMDs += "016,M,023,110,????????,mbenguard17ssm   "; // Guardia de Benzor, Fighter 17, Shortspear+Shield
    arregloDMDs += "016,M,023,110,????????,mbenguard17ssf   "; // Guardia de Benzor, Fighter 17, Shortspear+Shield
    arregloDMDs += "018,M,023,110,????????,mbenguard20lsm   "; // Guardia de Benzor, Fighter 20, Longsword+Shield
    arregloDMDs += "018,M,023,110,????????,mbenguard20lsf   "; // Guardia de Benzor, Fighter 20, Longsword+Shield
    arregloDMDs += "018,M,023,110,????????,mbenguard20ssm   "; // Guardia de Benzor, Fighter 20, Shortspear+Shield
    arregloDMDs += "018,M,023,110,????????,mbenguard20ssf   "; // Guardia de Benzor, Fighter 20, Shortspear+Shield
    return arregloDMDs;
}

//____________________________ Guardia / Mror _______________________________
// CRs: 4,6,8,11,14        Factions: Defensor
string ADE_Guardia_Mror_get();
string ADE_Guardia_Mror_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "004,M,023,110,????????,mmrorguard04b    "; // Guardia de Mror, Fighter 4, 2 Cimitars
    arregloDMDs += "004,M,023,110,????????,mmrorguard04bf   "; // Guardia de Mror, Fighter 4, 2 Cimitars
    arregloDMDs += "006,M,023,110,????????,mmrorguard06b    "; // Guardia de Mror, Fighter 6, 2 Cimitars
    arregloDMDs += "006,M,023,110,????????,mmrorguard06bf   "; // Guardia de Mror, Fighter 6, 2 Cimitars
    arregloDMDs += "008,M,023,110,????????,mmrorguard09b    "; // Guardia de Mror, Fighter 9, 2 Cimitars
    arregloDMDs += "008,M,023,110,????????,mmrorguard09bf   "; // Guardia de Mror, Fighter 9, 2 Cimitars
    arregloDMDs += "011,M,023,110,????????,mmrorguard12b    "; // Guardia de Mror, Fighter 12, 2 Cimitars
    arregloDMDs += "011,M,023,110,????????,mmrorguard12bf   "; // Guardia de Mror, Fighter 12, 2 Cimitars
    arregloDMDs += "014,M,023,110,????????,mmrorguard15b    "; // Guardia de Mror, Fighter 15, 2 Cimitars
    arregloDMDs += "014,M,023,110,????????,mmrorguard15bf   "; // Guardia de Mror, Fighter 15, 2 Cimitars
    return arregloDMDs;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// IGLESIAS ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//____________________________ Iglesia / Bane _______________________________
// CRs: 4-18        Factions: ?
string ADE_Iglesia_Bane_get();
string ADE_Iglesia_Bane_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "004,M,023,110,????????,mbanecleric04    "; // Sacerdote de Perdicion, Cleric 4
    arregloDMDs += "004,M,023,110,????????,mbanecleric04f   "; // Sacerdotisa de Perdicion, Cleric 4
    arregloDMDs += "006,M,023,110,????????,mbanecleric06    "; // Sacerdote de Perdicion, Cleric 6
    arregloDMDs += "006,M,023,110,????????,mbanecleric06f   "; // Sacerdotisa de Perdicion, Cleric 6
    arregloDMDs += "007,M,023,110,????????,mbanecleric08    "; // Sacerdote de Perdicion, Cleric 8
    arregloDMDs += "007,M,023,110,????????,mbanecleric08f   "; // Sacerdotisa de Perdicion, Cleric 8
    arregloDMDs += "010,M,023,110,????????,mbanecleric11    "; // Sacerdote de Perdicion, Cleric 11
    arregloDMDs += "010,M,023,110,????????,mbanecleric11f   "; // Sacerdotisa de Perdicion, Cleric 11
    arregloDMDs += "010,M,023,110,????????,mbaneblkguard11m "; // Guardia Negro de Perdicion, Cleric 8 Blackguard 3
    arregloDMDs += "010,M,023,110,????????,mbaneblkguard11f "; // Guardia Negro de Perdicion, Cleric 8 Blackguard 3
    arregloDMDs += "012,M,023,110,????????,mbaneblkguard14m "; // Guardia Negro de Perdicion, Cleric 8 Blackguard 6
    arregloDMDs += "012,M,023,110,????????,mbaneblkguard14f "; // Guardia Negro de Perdicion, Cleric 8 Blackguard 6
    arregloDMDs += "013,M,023,110,????????,mbanecleric14    "; // Sacerdote de Perdicion, Cleric 14
    arregloDMDs += "013,M,023,110,????????,mbanecleric14f   "; // Sacerdotisa de Perdicion, Cleric 14
    arregloDMDs += "014,M,023,110,????????,mbaneblkguard17m "; // Guardia Negro de Perdicion, Cleric 10 Blackguard 7
    arregloDMDs += "014,M,023,110,????????,mbaneblkguard17f "; // Guardia Negro de Perdicion, Cleric 10 Blackguard 7
    arregloDMDs += "015,M,023,110,????????,mbanecleric17    "; // Sacerdote de Perdicion, Cleric 17
    arregloDMDs += "015,M,023,110,????????,mbanecleric17f   "; // Sacerdotisa de Perdicion, Cleric 17
    arregloDMDs += "017,M,023,110,????????,mbaneblkguard20m "; // Guardia Negro de Perdicion, Cleric 10 Blackguard 10
    arregloDMDs += "017,M,023,110,????????,mbaneblkguard20f "; // Guardia Negro de Perdicion, Cleric 10 Blackguard 10
    arregloDMDs += "018,M,023,110,????????,mbanecleric20    "; // Sacerdote de Perdicion, Cleric 20
    arregloDMDs += "018,M,023,110,????????,mbanecleric20f   "; // Sacerdotisa de Perdicion, Cleric 20
    return arregloDMDs;
}

//____________________________ Iglesia / Corelion _______________________________
// CRs: 4-18        Factions: ?
string ADE_Iglesia_Corelion_get();
string ADE_Iglesia_Corelion_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "004,M,023,110,????????,partyb002        "; // Sacerdote de Corelion Larethian, cleric 4
    arregloDMDs += "004,M,023,110,????????,partyb008        "; // Sacerdotisa de Corelion Larethian, cleric 4
    arregloDMDs += "006,M,023,110,????????,partyb0023       "; // Sacerdote de Corelion Larethian, cleric 6
    arregloDMDs += "006,M,023,110,????????,partyb0024       "; // Sacerdotisa de Corelion Larethian, cleric 6
    arregloDMDs += "007,M,023,110,????????,partyb0033       "; // Sacerdote de Corelion Larethian, cleric 8
    arregloDMDs += "007,M,023,110,????????,partyb0034       "; // Sacerdotisa de Corelion Larethian, cleric 8
    arregloDMDs += "010,M,023,110,????????,partyb0049       "; // Sacerdote de Corelion Larethian, cleric 11
    arregloDMDs += "010,M,023,110,????????,partyb0050       "; // Sacerdotisa de Corelion Larethian, cleric 11
    arregloDMDs += "013,M,023,110,????????,partyb0065       "; // Sacerdote de Corelion Larethian, cleric 14
    arregloDMDs += "013,M,023,110,????????,partyb0066       "; // Sacerdotisa de Corelion Larethian, cleric 14
    arregloDMDs += "016,M,023,110,????????,mcorelcler17m    "; // Sacerdote de Corelion Larethian, cleric 17
    arregloDMDs += "016,M,023,110,????????,mcorelcler17f    "; // Sacerdotisa de Corelion Larethian, cleric 17
    arregloDMDs += "018,M,023,110,????????,mcorelcler20m    "; // Sacerdote de Corelion Larethian, cleric 20
    arregloDMDs += "018,M,023,110,????????,mcorelcler20f    "; // Sacerdotisa de Corelion Larethian, cleric 20
    return arregloDMDs;
}

//____________________________ Iglesia / Ilmater _______________________________
// CRs: 3-18         Factions: ?
string ADE_Iglesia_Ilmater_get();
string ADE_Iglesia_Ilmater_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,milmatermonk04m  "; // Disc.de S.Morgan, Monk 4, Guantelete+Shield
    arregloDMDs += "003,M,023,110,????????,milmatermonk04f  "; // Herm.de S.Yasper, Monk 4, Guantelete+Shield
    arregloDMDs += "004,M,023,110,????????,milmatercler04m  "; // Clerigo de Ilmater, Cleric 4, Guantelete+Shield
    arregloDMDs += "004,M,023,110,????????,milmatercler04f  "; // Cleriga de Ilmater, Cleric 4, Guantelete+Shield
    arregloDMDs += "004,M,023,110,????????,milmaterpala04m  "; // Paladin de Ilmater, Paladin 4, Guantelete+Shield
    arregloDMDs += "004,M,023,110,????????,milmaterpala04f  "; // Paladina de Ilmater, Paladin 4, Guantelete+Shield
    arregloDMDs += "005,M,023,110,????????,milmatermonk06m  "; // Disc.de S.Morgan, Monk 6, Guantelete+Shield
    arregloDMDs += "005,M,023,110,????????,milmatermonk06f  "; // Herm.de S.Yasper, Monk 6, Guantelete+Shield
    arregloDMDs += "005,M,023,110,????????,milmaterpala06m  "; // Paladin de Ilmater, Paladin 6, Guantelete+Shield
    arregloDMDs += "005,M,023,110,????????,milmaterpala06f  "; // Paladina de Ilmater, Paladin 6, Guantelete+Shield
    arregloDMDs += "006,M,023,110,????????,milmatercler06m  "; // Clerigo de Ilmater, Cleric 6, Guantelete+Shield
    arregloDMDs += "006,M,023,110,????????,milmatercler06f  "; // Cleriga de Ilmater, Cleric 6, Guantelete+Shield
    arregloDMDs += "007,M,023,110,????????,milmatermonk08m  "; // Disc.de S.Morgan, Monk 8, Guantelete+Shield
    arregloDMDs += "007,M,023,110,????????,milmatermonk08f  "; // Herm.de S.Yasper, Monk 8, Guantelete+Shield
    arregloDMDs += "007,M,023,110,????????,milmaterpala08m  "; // Paladin de Ilmater, Paladin 8, Guantelete+Shield
    arregloDMDs += "007,M,023,110,????????,milmaterpala08f  "; // Paladina de Ilmater, Paladin 8, Guantelete+Shield
    arregloDMDs += "008,M,023,110,????????,milmatercler08m  "; // Clerigo de Ilmater, Cleric 8, Guantelete+Shield
    arregloDMDs += "008,M,023,110,????????,milmatercler08f  "; // Cleriga de Ilmater, Cleric 8, Guantelete+Shield
    arregloDMDs += "010,M,023,110,????????,milmatermonk11m  "; // Disc.de S.Morgan, Monk 11, Guantelete+Shield
    arregloDMDs += "010,M,023,110,????????,milmatermonk11f  "; // Herm.de S.Yasper, Monk 11, Guantelete+Shield
    arregloDMDs += "010,M,023,110,????????,milmaterpala11m  "; // Paladin de Ilmater, Paladin 11, Guantelete+Shield
    arregloDMDs += "010,M,023,110,????????,milmaterpala11f  "; // Paladina de Ilmater, Paladin 11, Guantelete+Shield
    arregloDMDs += "010,M,023,110,????????,milmatercler11m  "; // Clerigo de Ilmater, Cleric 11, Guantelete+Shield
    arregloDMDs += "010,M,023,110,????????,milmatercler11f  "; // Cleriga de Ilmater, Cleric 11, Guantelete+Shield
    arregloDMDs += "012,M,023,110,????????,milmatermonk14m  "; // Disc.de S.Morgan, Monk 14, Guantelete+Shield
    arregloDMDs += "012,M,023,110,????????,milmatermonk14f  "; // Herm.de S.Yasper, Monk 14, Guantelete+Shield
    arregloDMDs += "012,M,023,110,????????,milmaterpala14m  "; // Paladin de Ilmater, Paladin 14, Guantelete+Shield
    arregloDMDs += "012,M,023,110,????????,milmaterpala14f  "; // Paladina de Ilmater, Paladin 14, Guantelete+Shield
    arregloDMDs += "013,M,023,110,????????,milmatercler14m  "; // Clerigo de Ilmater, Cleric 14, Guantelete+Shield
    arregloDMDs += "013,M,023,110,????????,milmatercler14f  "; // Cleriga de Ilmater, Cleric 14, Guantelete+Shield
    arregloDMDs += "014,M,023,110,????????,milmatermonk17m  "; // Disc.de S.Morgan, Monk 17, Guantelete+Shield
    arregloDMDs += "014,M,023,110,????????,milmatermonk17f  "; // Herm.de S.Yasper, Monk 17, Guantelete+Shield
    arregloDMDs += "015,M,023,110,????????,milmaterpala17m  "; // Paladin de Ilmater, Paladin 17, Guantelete+Shield
    arregloDMDs += "015,M,023,110,????????,milmaterpala17f  "; // Paladina de Ilmater, Paladin 17, Guantelete+Shield
    arregloDMDs += "016,M,023,110,????????,milmatercler17m  "; // Clerigo de Ilmater, Cleric 17, Guantelete+Shield
    arregloDMDs += "016,M,023,110,????????,milmatercler17f  "; // Cleriga de Ilmater, Cleric 17, Guantelete+Shield
    arregloDMDs += "017,M,023,110,????????,milmatermonk20m  "; // Disc.de S.Morgan, Monk 20, Guantelete+Shield
    arregloDMDs += "017,M,023,110,????????,milmatermonk20f  "; // Herm.de S.Yasper, Monk 20, Guantelete+Shield
    arregloDMDs += "017,M,023,110,????????,milmaterpala20m  "; // Paladin de Ilmater, Paladin 20, Guantelete+Shield
    arregloDMDs += "017,M,023,110,????????,milmaterpala20f  "; // Paladina de Ilmater, Paladin 20, Guantelete+Shield
    arregloDMDs += "018,M,023,110,????????,milmatercler20m  "; // Clerigo de Ilmater, Cleric 20, Guantelete+Shield
    arregloDMDs += "018,M,023,110,????????,milmatercler20f  "; // Cleriga de Ilmater, Cleric 20, Guantelete+Shield
    return arregloDMDs;
}

//____________________________ Iglesia / Malar _______________________________
// CRs: 4-18         Factions: Plebeyo
string ADE_Iglesia_Malar_get();
string ADE_Iglesia_Malar_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "004,M,023,110,????????,mhomalarcleri04m  "; // Malarita Semiorco D&D, Cleric 4
    arregloDMDs += "004,M,023,110,????????,mhomalardruid04m  "; // Druida Malarita Semiorco D&D, Druid 4
    arregloDMDs += "006,M,023,110,????????,mhomalarcleri06m  "; // Malarita Semiorco D&D, Cleric 6
    arregloDMDs += "006,M,023,110,????????,mhomalardruid06m  "; // Druida Malarita Semiorco D&D, Druid 6
    arregloDMDs += "008,M,023,110,????????,mhomalarcleri08m  "; // Malarita Semiorco D&D, Cleric 8
    arregloDMDs += "008,M,023,110,????????,mhomalardruid08m  "; // Druida Malarita Semiorco D&D, Druid 8
    arregloDMDs += "010,M,023,110,????????,mhomalarcleri11m  "; // Malarita Semiorco D&D, Cleric 11
    arregloDMDs += "010,M,023,110,????????,mhomalardruid11m  "; // Druida Malarita Semiorco D&D, Druid 11
    arregloDMDs += "013,M,023,110,????????,mhomalarcleri14m  "; // Malarita Semiorco D&D, Cleric 14
    arregloDMDs += "013,M,023,110,????????,mhomalardruid14m  "; // Druida Malarita Semiorco D&D, Druid 14
    arregloDMDs += "016,M,023,110,????????,mhomalarcleri17m  "; // Malarita Semiorco D&D, Cleric 17
    arregloDMDs += "016,M,023,110,????????,mhomalardruid17m  "; // Druida Malarita Semiorco D&D, Druid 17
    arregloDMDs += "018,M,023,110,????????,mhomalarcleri20m  "; // Malarita Semiorco D&D, Cleric 20
    arregloDMDs += "018,M,023,110,????????,mhomalardruid20m  "; // Druida Malarita Semiorco D&D, Druid 20
    return arregloDMDs;
}

//____________________________ Iglesia / Waukin _______________________________
// CRs: 4        Factions: Plebeyo
string ADE_Iglesia_Waukin_get();
string ADE_Iglesia_Waukin_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "004,M,023,110,????????,mwaukincler04m   "; // Clerigo de Waukin, Cleric 4, Nunchako+Shield
    return arregloDMDs;
}

//____________________________ Iglesia / Yondalla _______________________________
// CRs: 3-18         Factions: Plebeyo
string ADE_Iglesia_Yondalla_get();
string ADE_Iglesia_Yondalla_get() {
    string arregloDMDs;
               //  "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
    arregloDMDs += "003,M,023,110,????????,partyb007        "; // Cleriga de Yondalla D&D, Cleric 4
    arregloDMDs += "003,M,023,110,????????,partyb004        "; // Clerigo de Yondalla D&D, Cleric 4
    arregloDMDs += "005,M,023,110,????????,partyb0022       "; // Cleriga de Yondalla D&D, Cleric 6
    arregloDMDs += "005,M,023,110,????????,partyb0021       "; // Clerigo de Yondalla D&D, Cleric 6
    arregloDMDs += "007,M,023,110,????????,partyb0038       "; // Cleriga de Yondalla D&D, Cleric 8
    arregloDMDs += "007,M,023,110,????????,partyb0037       "; // Clerigo de Yondalla D&D, Cleric 8
    arregloDMDs += "010,M,023,110,????????,partyb0054       "; // Cleriga de Yondalla D&D, Cleric 11
    arregloDMDs += "010,M,023,110,????????,partyb0053       "; // Clerigo de Yondalla D&D, Cleric 11
    arregloDMDs += "013,M,023,110,????????,partyb0069       "; // Cleriga de Yondalla D&D, Cleric 14
    arregloDMDs += "013,M,023,110,????????,partyb0070       "; // Clerigo de Yondalla D&D, Cleric 14
    arregloDMDs += "015,M,023,110,????????,myondcleric17f   "; // Cleriga de Yondalla D&D, Cleric 17
    arregloDMDs += "015,M,023,110,????????,myondcleric17m   "; // Clerigo de Yondalla D&D, Cleric 17
    arregloDMDs += "018,M,023,110,????????,myondcleric20f   "; // Cleriga de Yondalla D&D, Cleric 20
    arregloDMDs += "018,M,023,110,????????,myondcleric20m   "; // Clerigo de Yondalla D&D, Cleric 20
    return arregloDMDs;
}
