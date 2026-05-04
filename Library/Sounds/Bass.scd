// =============================================================================
// BASS MODULE — EDM bass starters
// =============================================================================
(
if (\Sound.asClass.isNil) {
    "[Bass] Sound class is not available. Recompile class library first (Ctrl+Shift+L).".warn;
    ^nil;
};

~bass = (
    sub: Sound.new("bass_sub", { |freq=45, amp=0.28, gate=1, pan=0, out=0, pos=0, rel=0.35|
        var env = EnvGen.kr(Env.asr(0.005, 1, rel), gate: gate, doneAction: 2);
        var sig = SinOsc.ar(freq, 0, 0.8) + SinOsc.ar(freq * 0.5, 0, 0.35);
        sig = LPF.ar(sig, 220 + (env * 280));
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 45, amp: 0.28, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.35)),

    mono: Sound.new("bass_mono", { |freq=55, amp=0.25, gate=1, pan=0, out=0, pos=0, cutoff=1200, rel=0.25, sub=0.45|
        var env = EnvGen.kr(Env.asr(0.005, 1, rel), gate: gate, doneAction: 2);
        var body = Saw.ar(freq * [1, 1.01]) * 0.55;
        var subOsc = SinOsc.ar(freq * 0.5, 0, sub);
        var sig = LPF.ar(Mix(body) + subOsc, cutoff + (env * 700));
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 55, amp: 0.25, gate: 1, pan: 0, out: 0, pos: 0, cutoff: 1200, rel: 0.25, sub: 0.45)),

    wobble: Sound.new("bass_wobble", { |freq=55, amp=0.24, gate=1, pan=0, out=0, pos=0, wobbleRate=4, rel=0.3|
        var env = EnvGen.kr(Env.asr(0.01, 1, rel), gate: gate, doneAction: 2);
        var lfo = SinOsc.kr(wobbleRate, 0, 0.5, 0.5);
        var cutoff = LinExp.kr(lfo, 0, 1, 180, 2200);
        var sig = Saw.ar(freq * [1, 1.005]) + Pulse.ar(freq * 0.5, 0.45, 0.4);
        sig = RLPF.ar(Mix(sig), cutoff, 0.25);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 55, amp: 0.24, gate: 1, pan: 0, out: 0, pos: 0, wobbleRate: 4, rel: 0.3)),

    reese: Sound.new("bass_reese", { |freq=50, amp=0.24, gate=1, pan=0, out=0, pos=0, detune=0.018, rel=0.35|
        var env = EnvGen.kr(Env.asr(0.01, 1, rel), gate: gate, doneAction: 2);
        var osc = Saw.ar(freq * [1 - detune, 1, 1 + detune]) * [0.35, 0.4, 0.35];
        var movement = SinOsc.kr(0.12, 0, 450, 700);
        var sig = RLPF.ar(Mix(osc), movement, 0.3);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 50, amp: 0.24, gate: 1, pan: 0, out: 0, pos: 0, detune: 0.018, rel: 0.35)),

    fmGrowl: Sound.new("bass_fm_growl", { |freq=52, amp=0.22, gate=1, pan=0, out=0, pos=0, modIndex=3.2, rel=0.3|
        var env = EnvGen.kr(Env.asr(0.005, 1, rel), gate: gate, doneAction: 2);
        var mod = SinOsc.ar(freq * 1.98, 0, freq * modIndex * env);
        var car = SinOsc.ar(freq + mod) * 0.8;
        var sig = BLowPass4.ar(car + (LFTri.ar(freq * 0.5) * 0.2), 300 + (env * 2200), 0.5);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 52, amp: 0.22, gate: 1, pan: 0, out: 0, pos: 0, modIndex: 3.2, rel: 0.3)),

    neuro: Sound.new("bass_neuro", { |freq=48, amp=0.22, gate=1, pan=0, out=0, pos=0, rate=3.5, rel=0.35|
        var env = EnvGen.kr(Env.asr(0.01, 1, rel), gate: gate, doneAction: 2);
        var src = (Saw.ar(freq * [1, 1.01]) + Pulse.ar(freq * 2, 0.35, 0.35)).sum;
        var lfo = LFTri.kr(rate).range(180, 2800);
        var sig = RLPF.ar(src.tanh, lfo, 0.18);
        sig = (sig * 2.4).tanh;
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 48, amp: 0.22, gate: 1, pan: 0, out: 0, pos: 0, rate: 3.5, rel: 0.35)),

    donk: Sound.new("bass_donk", { |freq=58, amp=0.27, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.001, 0.24, curve: -5), gate: gate, doneAction: 2);
        var pitch = EnvGen.kr(Env([freq * 1.8, freq], [0.03], -6), gate: gate);
        var sig = SinOsc.ar(pitch) + (SinOsc.ar(pitch * 2) * 0.25);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 58, amp: 0.27, gate: 1, pan: 0, out: 0, pos: 0)),

    subDirty: Sound.new("bass_sub_dirty", { |freq=43, amp=0.24, gate=1, pan=0, out=0, pos=0, drive=1.8, rel=0.35|
        var env = EnvGen.kr(Env.asr(0.005, 1, rel), gate: gate, doneAction: 2);
        var sig = SinOsc.ar(freq) + (SinOsc.ar(freq * 0.5) * 0.3);
        sig = (sig * drive).tanh;
        sig = LPF.ar(sig, 260 + (env * 180));
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 43, amp: 0.24, gate: 1, pan: 0, out: 0, pos: 0, drive: 1.8, rel: 0.35)),

    pluckBass: Sound.new("bass_pluck", { |freq=65, amp=0.22, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.001, 0.22, curve: -5), gate: gate, doneAction: 2);
        var sig = Pulse.ar(freq, 0.45) + (SinOsc.ar(freq * 0.5) * 0.35);
        sig = RLPF.ar(sig, 500 + (env * 2600), 0.2);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 65, amp: 0.22, gate: 1, pan: 0, out: 0, pos: 0)),

    acid: Sound.new("bass_acid", { |freq=55, amp=0.2, gate=1, pan=0, out=0, pos=0, res=0.18, rel=0.22|
        var env = EnvGen.kr(Env.asr(0.002, 1, rel), gate: gate, doneAction: 2);
        var filtEnv = EnvGen.kr(Env.perc(0.001, 0.18, 1, -4), gate: gate);
        var sig = Saw.ar(freq);
        sig = RLPF.ar(sig, 260 + (filtEnv * 3200), res);
        Pan2.ar((sig * 2).tanh * env * amp, pan)
    }, (freq: 55, amp: 0.2, gate: 1, pan: 0, out: 0, pos: 0, res: 0.18, rel: 0.22)),

    squareSub: Sound.new("bass_square_sub", { |freq=42, amp=0.23, gate=1, pan=0, out=0, pos=0, rel=0.3|
        var env = EnvGen.kr(Env.asr(0.003, 1, rel), gate: gate, doneAction: 2);
        var sig = Pulse.ar(freq, 0.5) * 0.7 + SinOsc.ar(freq * 0.5, 0, 0.35);
        sig = LPF.ar(sig, 220);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 42, amp: 0.23, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.3)),

    talkBass: Sound.new("bass_talk", { |freq=52, amp=0.2, gate=1, pan=0, out=0, pos=0, rate=2.8, rel=0.35|
        var env = EnvGen.kr(Env.asr(0.004, 1, rel), gate: gate, doneAction: 2);
        var src = Saw.ar(freq * [1, 1.01]).sum;
        var f1 = SinOsc.kr(rate, 0, 450, 700);
        var f2 = SinOsc.kr(rate * 1.3, 0, 700, 1300);
        var sig = BPF.ar(src, f1.max(90), 0.2) + (BPF.ar(src, f2.max(120), 0.15) * 0.8);
        sig = (sig * 2).tanh;
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 52, amp: 0.2, gate: 1, pan: 0, out: 0, pos: 0, rate: 2.8, rel: 0.35)),

    fmScream: Sound.new("bass_fm_scream", { |freq=65, amp=0.19, gate=1, pan=0, out=0, pos=0, index=5.5, rel=0.24|
        var env = EnvGen.kr(Env.asr(0.002, 1, rel), gate: gate, doneAction: 2);
        var mod = SinOsc.ar(freq * 2.5, 0, freq * index * env);
        var sig = SinOsc.ar(freq + mod);
        sig = BHiPass4.ar((sig * 2.6).tanh, 220, 0.55);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 65, amp: 0.19, gate: 1, pan: 0, out: 0, pos: 0, index: 5.5, rel: 0.24)),

    names: [\sub, \mono, \wobble, \reese, \fmGrowl, \neuro, \donk, \subDirty, \pluckBass, \acid, \squareSub, \talkBass, \fmScream]
);

"Bass module ready: ~bass[\\sub].play, ~bass[\\reese].play, ~bass[\\subDirty].play".postln;
)
