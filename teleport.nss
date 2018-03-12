#include "inc_draw"

void main()
{
int bTeleportingParty = GetSpellId();
location lCaster = GetLocation(OBJECT_SELF);
BeamPolygon(DURATION_TYPE_PERMANENT, VFX_BEAM_LIGHTNING, lCaster,
                    bTeleportingParty ? FeetToMeters(10.0) : FeetToMeters(3.0), // Single TP: 3ft radius; Party TP: 10ft radius
                    bTeleportingParty ? 15 : 10, // More nodes for the group VFX
                    1.5f, "prc_invisobj", 1.0f, 0.0f, 0.0f, "z", 0.0f, 0.0f,
                    -1, -1, 0.0f, 1.0f, // No secondary VFX
                    2.0f // Non-zero lifetime, so the placeables eventually get removed
                    );
}
