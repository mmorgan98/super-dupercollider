// =============================================================================
// GUITAR MODULE — acoustic / nylon plucks
// =============================================================================
(
if (\Sound.asClass.isNil) {
    "[Guitar] Sound class is not available. Recompile class library first (Ctrl+Shift+L).".warn;
    ^nil;
};

~guitar = (
    acoustic: Sound.new("guitar_acoustic", { |freq=196, amp=0.22, gate=1, pan=0, out=0, pos=0, damp=0.45, brightness=3200|
        var exc = PinkNoise.ar(1) * EnvGen.kr(Env.perc(0.001, 0.02), gate: gate);
        var pluck = Pluck.ar(exc, gate, 0.2, freq.reciprocal, 4.5, damp);
        var body = BPF.ar(pluck, 180, 0.35) + BPF.ar(pluck, 420, 0.28);
        var air = HPF.ar(pluck, 900) * 0.55;
        var env = EnvGen.kr(Env.perc(0.001, 2.8, curve: -5), gate: gate, doneAction: 2);
        var sig = (pluck + (body * 0.55) + air);
        sig = LPF.ar(sig, brightness + (env * 900));
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 196, amp: 0.22, gate: 1, pan: 0, out: 0, pos: 0, damp: 0.45, brightness: 3200)),

    nylon: Sound.new("guitar_nylon", { |freq=220, amp=0.2, gate=1, pan=0, out=0, pos=0, damp=0.55|
        var exc = WhiteNoise.ar(1) * EnvGen.kr(Env.perc(0.0008, 0.015), gate: gate);
        var pluck = Pluck.ar(exc, gate, 0.2, freq.reciprocal, 5.5, damp);
        var soft = LPF.ar(pluck, 2400) + (SinOsc.ar(freq * 2, 0, 0.08) * EnvGen.kr(Env.perc(0.001, 0.4), gate: gate));
        var env = EnvGen.kr(Env.perc(0.001, 3.2, curve: -4), gate: gate, doneAction: 2);
        Pan2.ar(soft * env * amp, pan)
    }, (freq: 220, amp: 0.2, gate: 1, pan: 0, out: 0, pos: 0, damp: 0.55)),

    steel: Sound.new("guitar_steel", { |freq=247, amp=0.2, gate=1, pan=0, out=0, pos=0, damp=0.28|
        var exc = PinkNoise.ar(1) + (WhiteNoise.ar(0.35) * EnvGen.kr(Env.perc(0.0005, 0.01), gate: gate));
        var pluck = Pluck.ar(exc, gate, 0.2, freq.reciprocal, 3.8, damp);
        var bite = HPF.ar(pluck, 1500) * 0.4;
        var env = EnvGen.kr(Env.perc(0.001, 2.4, curve: -6), gate: gate, doneAction: 2);
        var sig = LPF.ar(pluck + bite, 5200);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 247, amp: 0.2, gate: 1, pan: 0, out: 0, pos: 0, damp: 0.28)),

    muted: Sound.new("guitar_muted", { |freq=196, amp=0.24, gate=1, pan=0, out=0, pos=0|
        var exc = PinkNoise.ar(1) * EnvGen.kr(Env.perc(0.0005, 0.008), gate: gate);
        var pluck = Pluck.ar(exc, gate, 0.1, freq.reciprocal, 0.35, 0.7);
        var env = EnvGen.kr(Env.perc(0.001, 0.18, curve: -8), gate: gate, doneAction: 2);
        var sig = LPF.ar(pluck, 1800);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 196, amp: 0.24, gate: 1, pan: 0, out: 0, pos: 0)),

    harmonic: Sound.new("guitar_harmonic", { |freq=392, amp=0.16, gate=1, pan=0, out=0, pos=0|
        var exc = WhiteNoise.ar(0.6) * EnvGen.kr(Env.perc(0.0005, 0.012), gate: gate);
        var pluck = Pluck.ar(exc, gate, 0.2, freq.reciprocal, 6.0, 0.15);
        var air = SinOsc.ar(freq * [2, 3, 4], 0, [0.2, 0.12, 0.08]).sum;
        var env = EnvGen.kr(Env.perc(0.001, 2.0, curve: -5), gate: gate, doneAction: 2);
        var sig = HPF.ar(pluck + (air * env), 600);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 392, amp: 0.16, gate: 1, pan: 0, out: 0, pos: 0)),

    names: [\acoustic, \nylon, \steel, \muted, \harmonic]
);

"Guitar module ready: ~guitar[\\acoustic].play, ~guitar[\\nylon].play, ~guitar[\\steel].play".postln;
)
