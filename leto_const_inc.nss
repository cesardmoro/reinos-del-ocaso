/* local copies for easy redistribution out of the PRC */

//these are the names of local variables, normally ints, to set on the module

//set this if using any letoscript
const string PRC_USE_LETOSCRIPT                      = "PRC_USE_LETOSCRIPT";

 //* Set this to 1 if using build 18
const string PRC_LETOSCRIPT_PHEONIX_SYNTAX           = "PRC_LETOSCRIPT_PHEONIX_SYNTAX";

 //* Letoscript needs a string named PRC_LETOSCRIPT_NWN_DIR set to the
 //* directory of NWN. If it doesnt work, try different slash options: // \\ / \
const string PRC_LETOSCRIPT_NWN_DIR                  = "PRC_LETOSCRIPT_NWN_DIR";

 //* Switch so that Unicorn will use the SQL database for SCO/RCO
 //* Must have the zeoslib.dlls installed for this
 //*
 //* UNTESTED!!!
const string PRC_LETOSCRIPT_UNICORN_SQL              = "PRC_LETOSCRIPT_UNICORN_SQL";

 //* This is a string, not integer.
 //* If the IP is set, Letoscript will use ActivatePortal instead of booting.
 //* The IP and Password must be correct for your server or bad things will happen.
 //* - If your IP is non-static make sure this is kept up to date.
 //*
 //* See the Lexicon entry on ActivatePortal for more information.
 //*
 //* @see PRC_LETOSCRIPT_PORTAL_PASSWORD
const string PRC_LETOSCRIPT_PORTAL_IP                = "PRC_LETOSCRIPT_PORTAL_IP";

 //* This is a string, not integer.
 //* If the IP is set, Letoscript will use ActivatePortal instead of booting.
 //* The IP and Password must be correct for your server or bad things will happen.
 //* - If your IP is non-static make sure this is kept up to date.
 //*
 //* See the Lexicon entry on ActivatePortal for more information.
 //*
 //* @see PRC_LETOSCRIPT_PORTAL_IP
const string PRC_LETOSCRIPT_PORTAL_PASSWORD          = "PRC_LETOSCRIPT_PORTAL_PASSWORD";

 //* If set you must be using Unicorn.
 //* Will use getnewest bic instead of filename reconstruction (which fails if
 //* multiple characters have the same name)
const string PRC_LETOSCRIPT_GETNEWESTBIC             = "PRC_LETOSCRIPT_GETNEWESTBIC";

// * Set this if you are using SQLite (the built-in database in NWNX-ODBC2).
// * This will use transactions and SQLite specific syntax.
const string PRC_DB_SQLLITE                          = "PRC_DB_SQLLITE";

const int PRC_SQL_ERROR = 0;
const int PRC_SQL_SUCCESS = 1;
