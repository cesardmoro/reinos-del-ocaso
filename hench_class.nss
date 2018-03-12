void main()
{
    if (GetClassByPosition(1)==0) {
        SetCustomToken(103, "Rompo huesos");
    } else if (GetClassByPosition(1)==1) {
        SetCustomToken(103, "Ah, Bueno. Para comenzar... *Se pierde en un sinfin de palabras*");
    } else if (GetClassByPosition(1)==2 ) {
        SetCustomToken(103, "Castigo a todos los herejes");
    } else if (GetClassByPosition(1)==3) {
        SetCustomToken(103, "Conmigo tendrias la naturaleza de tu lado");
    } else if (GetClassByPosition(1)==4) {
        SetCustomToken(103, "Me enfrento a las mas feroces criaturas");
    } else if (GetClassByPosition(1)==5) {
        SetCustomToken(103, "Lo puedo ayudar a trascender toda necesidad de armas");
    } else if (GetClassByPosition(1)==6) {
        SetCustomToken(103, "Castigo infieles");
    } else if (GetClassByPosition(1)==7) {
        SetCustomToken(103, "Puedo llevarlo a donde sea");
    } else if (GetClassByPosition(1)==8) {
        SetCustomToken(103, "Solo soy certero...");
    } else if (GetClassByPosition(1)==9) {
        SetCustomToken(103, "Hago lo que mi sangre me indica");
    } else if (GetClassByPosition(1)==10) {
        SetCustomToken(103, "Puedo crear los mas intrigantes esquemas");
    } else {
        SetCustomToken(103, "error");
    }
}
