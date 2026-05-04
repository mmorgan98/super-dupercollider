// =============================================================================
// RHYTHM: PULSE 8
// =============================================================================
(
if (\Sequence.asClass.isNil) {
    "[Rhythm] Sequence class is not available. Evaluate Framework/Base.scd first.".warn;
    ^nil;
};

Sequence.registerPattern(\pulse8, [1,0,1,0, 1,0,1,0], 0.5);
)
