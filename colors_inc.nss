/******************************************************************************
08-12-08 Script by dragoncin base on Rich Dersheimer's Custom Text Colors mod

Agrega funciones para colorear cadenas de caracteres
******************************************************************************/

const string Colors_colorHolder_VN      = "color_";
const string Colors_colorManagerTag_RN  = "color_manager";

const string Colors_CLOSE_TAG           = "</c>";

const string COLOR_WHITE        = "<c���>";
const string COLOR_YELLOW       = "<c�� >";
const string COLOR_MAGENTA      = "<c� �>";
const string COLOR_CYAN         = "<c ��>";
const string COLOR_RED          = "<c�  >";
const string COLOR_GREEN        = "<c � >";
const string COLOR_BLUE         = "<c  �>";
const string COLOR_LIME         = "<c��d>";
const string COLOR_PALEBLUE     = "<cdd�>";
const string COLOR_VIOLET       = "<c�d�>";
const string COLOR_PURPLE       = "<c�Gd>";
const string COLOR_SANDY        = "<c�dG>";
const string COLOR_DARKRED      = "<c�*0>";
const string COLOR_PINK         = "<c�dd>";
const string COLOR_LIGHTPINK    = "<c�dd>";
const string COLOR_GREY         = "<c���>";

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
