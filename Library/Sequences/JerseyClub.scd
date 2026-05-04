// =============================================================================
// RHYTHM: JERSEY CLUB
// =============================================================================
(
if (\Sequence.asClass.isNil) {
    "[Rhythm] Sequence class is not available. Evaluate Framework/Base.scd first.".warn;
    ^nil;
};

Sequence.registerPattern(\jerseyClub, [1,0,0,1, 0,1,1,0, 1,0,0,1, 0,1,1,0], 0.25);
)
