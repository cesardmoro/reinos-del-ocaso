/************************** class Position ************************************
package: position tools
Autor: Inquisidor
Version: 0.1
Descripcion: funciones utiles para tratar posiciones (locations and vectors).
*******************************************************************************/

location Position_relativeAdd( location reference, float longitudinalDistance, float transversalDistance, float facing );
location Position_relativeAdd( location reference, float longitudinalDistance, float transversalDistance, float facing ) {
    float longitudinalDirection = GetFacingFromLocation( reference );
    vector longitudinalAxis = AngleToVector( longitudinalDirection );
    vector transversalAxis = AngleToVector( longitudinalDirection + 90.0 );
    return Location(
        GetAreaFromLocation(reference),
        GetPositionFromLocation(reference) + longitudinalDistance * longitudinalAxis + transversalDistance * transversalAxis,
        longitudinalDirection + facing
    );
}
