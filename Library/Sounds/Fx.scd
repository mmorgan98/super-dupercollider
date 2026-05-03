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

    names: [\riser, \downlifter, \impact, \noiseSweep],

    play: { |self, name, overrides=nil|
        var sound = self[name.asSymbol];
        if (sound.isNil) {
            ("[Fx] Unknown fx sound: " ++ name.asString).warn;
            ^nil;
        };
        sound.play(overrides);
    },

    stop: { |self, name|
        var sound = self[name.asSymbol];
        if (sound.notNil) { sound.stop };
    },

    stopAll: { |self|
        self[\names].do { |name| self[name].stop };
    }
);

"Fx module ready: ~fx[\\riser].play, ~fx.play(\\impact)".postln;
)
