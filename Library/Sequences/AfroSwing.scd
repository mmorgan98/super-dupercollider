// =============================================================================
// RHYTHM: AFRO SWING
// =============================================================================
(
if (\Sequence.asClass.isNil) {
    "[Rhythm] Sequence class is not available. Evaluate Framework/Base.scd first.".warn;
    ^nil;
};

Sequence.registerPattern(\afroSwing, [1,0,0.7,0, 1,0,0.7,0, 0,1,0.7,0, 1,0,0.7,0], 0.25);
)
