// =============================================================================
// RHYTHM: GALLOP
// =============================================================================
(
if (\Sequence.asClass.isNil) {
    "[Rhythm] Sequence class is not available. Evaluate Framework/Base.scd first.".warn;
    ^nil;
};

Sequence.registerPattern(\gallop, [1,0,1, 1,0,1, 1,0,1, 1,0,1], (1/6));
)
