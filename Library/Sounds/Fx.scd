// =============================================================================
// FX MODULE — transitions and impacts
// =============================================================================
(
if (\Sound.asClass.isNil) {
    "[Fx] Sound class is not available. Recompile class library first (Ctrl+Shift+L).".warn;
    ^nil;
};

~fx = (
    riser: Sound.new("fx_riser", { |freq=200, amp=0.22, gate=1, pan=0, out=0, pos=0, rise=2.0|
        var env = EnvGen.kr(Env([0, 1], [rise], 2), gate: gate, doneAction: 2);
        var noise = BPF.ar(WhiteNoise.ar(1), 400 + (env * 5200), 0.25);
        var tone = SinOsc.ar(freq + (env * 1000), 0, 0.25);
        Pan2.ar((noise + tone) * amp, pan)
    }, (freq: 200, amp: 0.22, gate: 1, pan: 0, out: 0, pos: 0, rise: 2.0)),

    downlifter: Sound.new("fx_downlifter", { |freq=1800, amp=0.22, gate=1, pan=0, out=0, pos=0, drop=1.8|
        var env = EnvGen.kr(Env([1, 0], [drop], -2), gate: gate, doneAction: 2);
        var noise = BPF.ar(WhiteNoise.ar(1), 220 + (env * freq), 0.35);
        Pan2.ar(noise * amp, pan)
    }, (freq: 1800, amp: 0.22, gate: 1, pan: 0, out: 0, pos: 0, drop: 1.8)),

    impact: Sound.new("fx_impact", { |amp=0.6, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.001, 1.1, curve: -6), gate: gate, doneAction: 2);
        var low = SinOsc.ar(48, 0, 0.8);
        var hit = BPF.ar(WhiteNoise.ar(1), 1400, 0.3);
        var sig = (low + hit) * env;
        Pan2.ar(sig * amp, pan)
    }, (amp: 0.6, gate: 1, pan: 0, out: 0, pos: 0)),

    noiseSweep: Sound.new("fx_noise_sweep", { |amp=0.2, gate=1, pan=0, out=0, pos=0, rate=0.22|
        var env = EnvGen.kr(Env.asr(0.2, 1, 0.6), gate: gate, doneAction: 2);
        var cutoff = SinOsc.kr(rate, 0, 2400, 2600);
        var sig = RLPF.ar(WhiteNoise.ar(1), cutoff.max(120), 0.2);
        Pan2.ar(sig * env * amp, pan)
    }, (amp: 0.2, gate: 1, pan: 0, out: 0, pos: 0, rate: 0.22)),

    laser: Sound.new("fx_laser", { |freq=1400, amp=0.28, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.001, 0.24, curve: -6), gate: gate, doneAction: 2);
        var pitch = EnvGen.kr(Env([freq, freq * 0.35], [0.2], -4), gate: gate);
        var sig = SinOsc.ar(pitch) + (Pulse.ar(pitch * 0.5, 0.4, 0.3));
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 1400, amp: 0.28, gate: 1, pan: 0, out: 0, pos: 0)),

    noiseBurst: Sound.new("fx_noise_burst", { |amp=0.3, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.001, 0.35, curve: -5), gate: gate, doneAction: 2);
        var sig = BPF.ar(WhiteNoise.ar(1), 2400, 0.45) + HPF.ar(WhiteNoise.ar(0.4), 7000);
        Pan2.ar(sig * env * amp, pan)
    }, (amp: 0.3, gate: 1, pan: 0, out: 0, pos: 0)),

    reverseHit: Sound.new("fx_reverse_hit", { |amp=0.3, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env([0, 1, 0.2], [0.45, 0.1], 3), gate: gate, doneAction: 2);
        var sig = RLPF.ar(WhiteNoise.ar(1), 300 + (env * 5000), 0.25);
        Pan2.ar(sig * amp, pan)
    }, (amp: 0.3, gate: 1, pan: 0, out: 0, pos: 0)),

    tonalFall: Sound.new("fx_tonal_fall", { |freq=1200, amp=0.22, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.001, 0.5, curve: -4), gate: gate, doneAction: 2);
        var pitch = EnvGen.kr(Env([freq, freq * 0.3], [0.45], -3), gate: gate);
        var sig = SinOsc.ar(pitch) + (SinOsc.ar(pitch * 1.5) * 0.25);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 1200, amp: 0.22, gate: 1, pan: 0, out: 0, pos: 0)),

    names: [\riser, \downlifter, \impact, \noiseSweep, \laser, \noiseBurst, \reverseHit, \tonalFall]
);

"Fx module ready: ~fx[\\riser].play, ~fx[\\laser].play".postln;
)
