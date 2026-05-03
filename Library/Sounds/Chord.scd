// =============================================================================
// CHORD MODULE — EDM chord starters
// =============================================================================
(
if (\Sound.asClass.isNil) {
    "[Chord] Sound class is not available. Recompile class library first (Ctrl+Shift+L).".warn;
    ^nil;
};

~chord = (
    stabs: Sound.new("chord_stabs", { |freq=220, amp=0.2, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.002, 0.25, curve: -5), gate: gate, doneAction: 2);
        var intervals = [1, 1.2599, 1.4983];
        var sig = Saw.ar(freq * intervals).sum * 0.33;
        sig = RLPF.ar(sig, 1200 + (env * 3500), 0.25);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 220, amp: 0.2, gate: 1, pan: 0, out: 0, pos: 0)),

    pad: Sound.new("chord_pad", { |freq=220, amp=0.14, gate=1, pan=0, out=0, pos=0, rel=1.6|
        var env = EnvGen.kr(Env.asr(0.35, 1, rel), gate: gate, doneAction: 2);
        var intervals = [1, 1.2599, 1.4983, 2];
        var sig = VarSaw.ar(freq * intervals, 0, 0.4).sum * 0.2;
        sig = LPF.ar(sig, 1900);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 220, amp: 0.14, gate: 1, pan: 0, out: 0, pos: 0, rel: 1.6)),

    futureChords: Sound.new("chord_future", { |freq=246, amp=0.18, gate=1, pan=0, out=0, pos=0, rel=0.7|
        var env = EnvGen.kr(Env.asr(0.02, 1, rel), gate: gate, doneAction: 2);
        var intervals = [1, 1.3348, 1.6818];
        var sig = Pulse.ar(freq * intervals, 0.45).sum * 0.3;
        sig = BLowPass4.ar(sig, 900 + (env * 2600), 0.6);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 246, amp: 0.18, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.7)),

    names: [\stabs, \pad, \futureChords],

    play: { |self, name, overrides=nil|
        var sound = self[name.asSymbol];
        if (sound.isNil) {
            ("[Chord] Unknown chord sound: " ++ name.asString).warn;
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

"Chord module ready: ~chord[\\stabs].play, ~chord.play(\\pad)".postln;
)
