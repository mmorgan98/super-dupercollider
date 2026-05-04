// =============================================================================
// RHYTHM: CLAVE 2-3
// =============================================================================
(
if (\Sequence.asClass.isNil) {
    "[Rhythm] Sequence class is not available. Evaluate Framework/Base.scd first.".warn;
    ^nil;
};

// Two-bar 2-3 son-clave style mapped to 16th steps.
Sequence.registerPattern(\clave23, [0,0,1,0, 0,1,0,0, 1,0,0,1, 0,0,1,0], 0.25);
)
