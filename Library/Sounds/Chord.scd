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

    organ: Sound.new("chord_organ", { |freq=220, amp=0.14, gate=1, pan=0, out=0, pos=0, rel=0.45|
        var env = EnvGen.kr(Env.asr(0.01, 1, rel), gate: gate, doneAction: 2);
        var intervals = [1, 1.2599, 1.4983];
        var sig = SinOsc.ar(freq * intervals, 0, [0.6, 0.35, 0.3]).sum;
        sig = LPF.ar(sig, 2800);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 220, amp: 0.14, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.45)),

    mellow: Sound.new("chord_mellow", { |freq=196, amp=0.12, gate=1, pan=0, out=0, pos=0, rel=1.2|
        var env = EnvGen.kr(Env.asr(0.08, 1, rel), gate: gate, doneAction: 2);
        var intervals = [1, 1.2, 1.5, 2];
        var sig = Pulse.ar(freq * intervals, 0.38).sum * 0.22;
        sig = RLPF.ar(sig, 800 + (env * 1800), 0.35);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 196, amp: 0.12, gate: 1, pan: 0, out: 0, pos: 0, rel: 1.2)),

    wideStab: Sound.new("chord_wide_stab", { |freq=220, amp=0.16, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.002, 0.3, curve: -5), gate: gate, doneAction: 2);
        var intervals = [1, 1.2599, 1.4983];
        var left = Saw.ar(freq * intervals * [1, 1.005, 0.995]).sum * 0.18;
        var right = Saw.ar(freq * intervals * [1.004, 0.998, 1.002]).sum * 0.18;
        left = left * env * amp;
        right = right * env * amp;
        [left, right]
    }, (freq: 220, amp: 0.16, gate: 1, pan: 0, out: 0, pos: 0)),

    tranceStack: Sound.new("chord_trance_stack", { |freq=247, amp=0.14, gate=1, pan=0, out=0, pos=0, rel=0.9|
        var env = EnvGen.kr(Env.asr(0.03, 1, rel), gate: gate, doneAction: 2);
        var intervals = [1, 1.2599, 1.4983, 2];
        var sig = Saw.ar(freq * intervals * [1, 1.003, 0.997, 1.006]).sum * 0.17;
        sig = LPF.ar(sig, 2600);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 247, amp: 0.14, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.9)),

    names: [\stabs, \pad, \futureChords, \organ, \mellow, \wideStab, \tranceStack]
);

"Chord module ready: ~chord[\\stabs].play, ~chord[\\organ].play".postln;
)
