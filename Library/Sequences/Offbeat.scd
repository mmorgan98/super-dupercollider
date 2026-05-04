// =============================================================================
// RHYTHM: OFFBEAT
// =============================================================================
(
if (\Sequence.asClass.isNil) {
    "[Rhythm] Sequence class is not available. Evaluate Framework/Base.scd first.".warn;
    ^nil;
};
Sequence.registerPattern(\offbeat, [0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0], 0.25);
)
