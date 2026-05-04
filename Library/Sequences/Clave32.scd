// =============================================================================
// RHYTHM: CLAVE 3-2
// =============================================================================
(
if (\Sequence.asClass.isNil) {
    "[Rhythm] Sequence class is not available. Evaluate Framework/Base.scd first.".warn;
    ^nil;
};

// Two-bar 3-2 son-clave style mapped to 16th steps.
Sequence.registerPattern(\clave32, [1,0,0,1, 0,0,1,0, 0,0,1,0, 0,1,0,0], 0.25);
)
