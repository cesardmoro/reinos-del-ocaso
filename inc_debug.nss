//:://////////////////////////////////////////////
//:: Debug include
//:: inc_debug
//:://////////////////////////////////////////////
/** @file
    This file contains a debug printing function, the
    purpose of which is to be leavable in place in code,
    so that debug printing can be centrally turned off
    by commenting out the contents of the function.

    Also, an assertion function and related function for
    killing script execution.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

/**
 * Prefix all your debug calls with an if(DEBUG) so that they get stripped away
 * during compilation as dead code when this is turned off.
 */
const int DEBUG = FALSE;


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * May print the given string, depending on whether debug printing is needed.
 *
 * Calls to this function should be guarded by an "if(DEBUG)" clause in order
 * to be disableable.
 *
 * @param sString The string to print
 */
void DoDebug(string sString, object oAdditionalRecipient = OBJECT_INVALID);

/**
 * Kills script execution using the Die() function if the given assertion
 * is false. If a message has been given, also prints it using DoDebug().
 * An assertion is something that should always be true if the program
 * is functioning correctly. An assertion being false indicates a fatal error.
 *
 * The format of the string printed when an assertion fails is:
 *  "Assertion failed: sAssertion\nsMessage; At sScriptName: sFunction"
 *
 * Calls to this function should be guarded by an "if(DEBUG)" clause in order
 * to be disableable.
 *
 * Example use:
 *
 * if(DEBUG) Assert(1 == 1, "1 == 1", "Oh noes! Arithmetic processing is b0rked.", "fooscript", "Baz()");
 *
 * @param bAssertion  The result of some evaluation that should always be true.
 * @param sAssertion  A string containing the statement evalueated for bAssertion.
 * @param sMessage    The message to print if bAssertion is FALSE. Will be
 *                    prefixed with "Assertion failed: " when printed.
 *                    If left to default (empty), the message printed will simply
 *                    be "Assertion failed!".
 * @param sFileName   Name of the script file where the call to this function occurs.
 * @param sFunction   Name of the function where the call to this function occurs.
 */
void Assert(int bAssertion, string sAssertion, string sMessage = "", string sFileName = "", string sFunction = "");

/**
 * Kills the execution of the current script by forcing a Too Many Instructions
 * error.
 * Not recommended for use outside of debugging purposes. Scripts should be able
 * to handle expectable error conditions gracefully.
 */
void Die();


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

void DoDebug(string sString, object oAdditionalRecipient = OBJECT_INVALID)
{
    SendMessageToPC(GetFirstPC(), "<c´jŸ>" + sString + "</c>");
    if(oAdditionalRecipient != OBJECT_INVALID)
        SendMessageToPC(oAdditionalRecipient, "<c´jŸ>" + sString + "</c>");
    WriteTimestampedLogEntry(sString);
}

void Assert(int bAssertion, string sAssertion, string sMessage = "", string sFileName = "", string sFunction = "")
{
    if(bAssertion == FALSE)
    {
        string sErr = "Assertion failed: " + sAssertion;

        if(sMessage != "" || sFileName != "" || sFunction != "")
        {
            sErr += "\n";

            if(sMessage != "")
                sErr += sMessage;

            if(sFileName != "" || sFunction != "")
            {
                if(sMessage != "")
                    sErr += "\n";

                sErr += "At " + sFileName;

                if(sFileName != "" && sFunction != "")
                    sErr += ": ";

                sErr += sFunction;
            }
        }

        DoDebug(sErr);
        Die();
    }
}

void Die()
{
    while(TRUE);
}
