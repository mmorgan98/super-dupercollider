// =============================================================================
// RHYTHM: DRIVING 16
// =============================================================================
(
if (\Sequence.asClass.isNil) {
    "[Rhythm] Sequence class is not available. Evaluate Framework/Base.scd first.".warn;
    ^nil;
};
Sequence.registerPattern(\driving16, [1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1], 0.25);
)
