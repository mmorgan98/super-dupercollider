// =============================================================================
// DRUM MODULE — EDM drum starters
// =============================================================================
(
if (\Sound.asClass.isNil) {
    "[Drum] Sound class is not available. Recompile class library first (Ctrl+Shift+L).".warn;
    ^nil;
};

~drum = (
    kick: Sound.new("kick", { |freq=50, amp=0.9, gate=1, pan=0, out=0, pos=0|
        var pitchEnv = EnvGen.kr(Env([freq * 2.8, freq], [0.05], -4), gate: gate);
        var bodyEnv = EnvGen.kr(Env.perc(0.001, 0.32, curve: -4), gate: gate, doneAction: 2);
        var clickEnv = EnvGen.kr(Env.perc(0.0005, 0.02), gate: gate);
        var body = SinOsc.ar(pitchEnv) * bodyEnv;
        var click = HPF.ar(WhiteNoise.ar(0.2), 3500) * clickEnv;
        Pan2.ar((body + click) * amp, pan)
    }, (freq: 50, amp: 0.9, gate: 1, pan: 0, out: 0, pos: 0)),

    snare: Sound.new("snare", { |freq=180, amp=0.7, gate=1, pan=0, out=0, pos=0|
        var noiseEnv = EnvGen.kr(Env.perc(0.001, 0.18, curve: -4), gate: gate);
        var toneEnv = EnvGen.kr(Env.perc(0.001, 0.12, curve: -4), gate: gate, doneAction: 2);
        var noise = BPF.ar(WhiteNoise.ar(1), 2200, 0.6) * noiseEnv;
        var tone = SinOsc.ar(freq) * toneEnv * 0.35;
        Pan2.ar((noise + tone) * amp, pan)
    }, (freq: 180, amp: 0.7, gate: 1, pan: 0, out: 0, pos: 0)),

    hat: Sound.new("hat", { |freq=9000, amp=0.35, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.0005, 0.08, curve: -8), gate: gate, doneAction: 2);
        var sig = HPF.ar(WhiteNoise.ar(1), freq) * env;
        Pan2.ar(sig * amp, pan)
    }, (freq: 9000, amp: 0.35, gate: 1, pan: 0, out: 0, pos: 0)),

    openHat: Sound.new("open_hat", { |freq=8500, amp=0.33, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.001, 0.32, curve: -6), gate: gate, doneAction: 2);
        var sig = HPF.ar(WhiteNoise.ar(1), freq) * env;
        Pan2.ar(sig * amp, pan)
    }, (freq: 8500, amp: 0.33, gate: 1, pan: 0, out: 0, pos: 0)),

    clap: Sound.new("clap", { |amp=0.55, gate=1, pan=0, out=0, pos=0|
        var burst = EnvGen.kr(Env([0, 1, 0, 1, 0], [0.003, 0.012, 0.003, 0.1], -4), gate: gate, doneAction: 2);
        var body = BPF.ar(WhiteNoise.ar(1), 1900, 0.8) * burst;
        Pan2.ar(body * amp, pan)
    }, (amp: 0.55, gate: 1, pan: 0, out: 0, pos: 0)),

    rim: Sound.new("rim", { |freq=2100, amp=0.4, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.0005, 0.05, curve: -10), gate: gate, doneAction: 2);
        var sig = SinOsc.ar(freq, 0, 0.8) + HPF.ar(WhiteNoise.ar(0.2), 3000);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 2100, amp: 0.4, gate: 1, pan: 0, out: 0, pos: 0)),

    perc: Sound.new("perc", { |freq=420, amp=0.45, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.001, 0.15, curve: -5), gate: gate, doneAction: 2);
        var sig = SinOsc.ar(freq * [1, 1.5], 0, [0.6, 0.35]).sum;
        sig = BPF.ar(sig, freq * 2.4, 0.4);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 420, amp: 0.45, gate: 1, pan: 0, out: 0, pos: 0)),

    names: [\kick, \snare, \hat, \openHat, \clap, \rim, \perc],

    play: { |self, name, overrides=nil|
        var drum = self[name.asSymbol];
        if (drum.isNil) {
            ("[Drum] Unknown drum: " ++ name.asString).warn;
            ^nil;
        };
        drum.play(overrides);
    },

    stop: { |self, name|
        var drum = self[name.asSymbol];
        if (drum.notNil) { drum.stop };
    },

    stopAll: { |self|
        self[\names].do { |name| self[name].stop };
    }
);

"Drum module ready: ~drum[\\kick].play, ~drum[\\clap].play, ~drum.play(\\openHat)".postln;
)
