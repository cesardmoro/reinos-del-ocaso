/******************************************************************************
08-12-08 Script by dragoncin base on Rich Dersheimer's Custom Text Colors mod

Agrega funciones para colorear cadenas de caracteres
******************************************************************************/

const string Colors_colorHolder_VN      = "color_";
const string Colors_colorManagerTag_RN  = "color_manager";

const string Colors_CLOSE_TAG           = "</c>";

const string COLOR_WHITE        = "<cÿÿÿ>";
const string COLOR_YELLOW       = "<cÿÿ >";
const string COLOR_MAGENTA      = "<cÿ ÿ>";
const string COLOR_CYAN         = "<c ÿÿ>";
const string COLOR_RED          = "<cÿ  >";
const string COLOR_GREEN        = "<c ÿ >";
const string COLOR_BLUE         = "<c  ÿ>";
const string COLOR_LIME         = "<c¡Òd>";
const string COLOR_PALEBLUE     = "<cdd¡>";
const string COLOR_VIOLET       = "<c¡dÑ>";
const string COLOR_PURPLE       = "<c¢Gd>";
const string COLOR_SANDY        = "<c¢dG>";
const string COLOR_DARKRED      = "<c¡*0>";
const string COLOR_PINK         = "<cÒdd>";
const string COLOR_LIGHTPINK    = "<cÒdd>";
const string COLOR_GREY         = "<c¡¡±>";

// Colorea la cadena de caracteres cadena con el color color
// Los colores disponibles son:
//            COLOR_WHITE
//            COLOR_YELLOW
//            COLOR_MAGENTA
//            COLOR_CYAN
//            COLOR_RED
//            COLOR_GREEN
//            COLOR_BLUE
//            COLOR_LIME
//            COLOR_PALEBLUE
//            COLOR_VIOLET
//            COLOR_PURPLE
//            COLOR_SANDY
//            COLOR_DARKRED
//            COLOR_PINK
//            COLOR_LIGHTPINK
//            COLOR_GREY
string ColorString( string cadena, string color );
string ColorString( string cadena, string color )
{
    return color+cadena+Colors_CLOSE_TAG;
}
