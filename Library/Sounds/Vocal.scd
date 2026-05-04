// =============================================================================
// VOCAL MODULE — formant/talk style tones
// =============================================================================
(
if (\Sound.asClass.isNil) {
    "[Vocal] Sound class is not available. Recompile class library first (Ctrl+Shift+L).".warn;
    ^nil;
};

~vocal = (
    ah: Sound.new("vocal_ah", { |freq=220, amp=0.16, gate=1, pan=0, out=0, pos=0, rel=0.3|
        var env = EnvGen.kr(Env.asr(0.004, 1, rel), gate: gate, doneAction: 2);
        var src = Saw.ar(freq) + Pulse.ar(freq * 1.5, 0.42, 0.25);
        var sig = BPF.ar(src, 850, 0.15) + (BPF.ar(src, 1150, 0.12) * 0.9);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 220, amp: 0.16, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.3)),

    oh: Sound.new("vocal_oh", { |freq=196, amp=0.16, gate=1, pan=0, out=0, pos=0, rel=0.34|
        var env = EnvGen.kr(Env.asr(0.004, 1, rel), gate: gate, doneAction: 2);
        var src = VarSaw.ar(freq * [1, 1.01], 0, 0.45).sum * 0.55;
        var sig = BPF.ar(src, 520, 0.2) + (BPF.ar(src, 900, 0.14) * 0.8);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 196, amp: 0.16, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.34)),

    ee: Sound.new("vocal_ee", { |freq=330, amp=0.15, gate=1, pan=0, out=0, pos=0, rel=0.25|
        var env = EnvGen.kr(Env.asr(0.002, 1, rel), gate: gate, doneAction: 2);
        var src = Pulse.ar(freq * [1, 2], [0.46, 0.34]).sum * 0.45;
        var sig = BPF.ar(src, 2200, 0.11) + (BPF.ar(src, 2900, 0.09) * 0.7);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 330, amp: 0.15, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.25)),

    talk: Sound.new("vocal_talk", { |freq=170, amp=0.16, gate=1, pan=0, out=0, pos=0, rate=3.2, rel=0.35|
        var env = EnvGen.kr(Env.asr(0.003, 1, rel), gate: gate, doneAction: 2);
        var src = Saw.ar(freq * [1, 1.01]).sum;
        var f1 = SinOsc.kr(rate, 0, 260, 620);
        var f2 = SinOsc.kr(rate * 1.4, 0, 420, 1300);
        var sig = BPF.ar(src, f1.max(120), 0.18) + (BPF.ar(src, f2.max(200), 0.13) * 0.85);
        Pan2.ar((sig * 2).tanh * env * amp, pan)
    }, (freq: 170, amp: 0.16, gate: 1, pan: 0, out: 0, pos: 0, rate: 3.2, rel: 0.35)),

    names: [\ah, \oh, \ee, \talk]
);

"Vocal module ready: ~vocal[\\ah].play, ~vocal[\\talk].play".postln;
)
