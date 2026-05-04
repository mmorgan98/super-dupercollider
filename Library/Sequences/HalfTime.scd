// =============================================================================
// RHYTHM: HALF TIME
// =============================================================================
(
if (\Sequence.asClass.isNil) {
    "[Rhythm] Sequence class is not available. Evaluate Framework/Base.scd first.".warn;
    ^nil;
};
Sequence.registerPattern(\halfTime, [1,0,0,0, 0,0,0,0], 0.5);
)
