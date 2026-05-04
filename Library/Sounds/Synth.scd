// =============================================================================
// SYNTH MODULE — extra tonal voices
// =============================================================================
(
if (\Sound.asClass.isNil) {
    "[Synth] Sound class is not available. Recompile class library first (Ctrl+Shift+L).".warn;
    ^nil;
};

~synth = (
    pluck: Sound.new("synth_pluck", { |freq=330, amp=0.2, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.001, 0.28, curve: -6), gate: gate, doneAction: 2);
        var sig = Saw.ar(freq * [1, 1.01]).sum * 0.45;
        sig = RLPF.ar(sig, 900 + (env * 4200), 0.25);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 330, amp: 0.2, gate: 1, pan: 0, out: 0, pos: 0)),

    bell: Sound.new("synth_bell", { |freq=660, amp=0.18, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.001, 1.4, curve: -4), gate: gate, doneAction: 2);
        var sig = SinOsc.ar(freq) + (SinOsc.ar(freq * 2.7, 0, 0.4)) + (SinOsc.ar(freq * 4.1, 0, 0.22));
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 660, amp: 0.18, gate: 1, pan: 0, out: 0, pos: 0)),

    brass: Sound.new("synth_brass", { |freq=220, amp=0.2, gate=1, pan=0, out=0, pos=0, rel=0.35|
        var env = EnvGen.kr(Env.asr(0.02, 1, rel), gate: gate, doneAction: 2);
        var sig = VarSaw.ar(freq * [1, 1.01, 2], 0, 0.6).sum * 0.28;
        sig = LPF.ar(sig, 1600 + (env * 2200));
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 220, amp: 0.2, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.35)),

    keys: Sound.new("synth_keys", { |freq=262, amp=0.17, gate=1, pan=0, out=0, pos=0, rel=0.5|
        var env = EnvGen.kr(Env.asr(0.005, 1, rel), gate: gate, doneAction: 2);
        var sig = Pulse.ar(freq * [1, 2], [0.45, 0.35]).sum * 0.35;
        sig = RLPF.ar(sig, 700 + (env * 2600), 0.3);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 262, amp: 0.17, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.5)),

    arp: Sound.new("synth_arp", { |freq=440, amp=0.14, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.001, 0.18, curve: -6), gate: gate, doneAction: 2);
        var sig = Saw.ar(freq * [1, 2, 4]).sum * 0.22;
        sig = HPF.ar(sig, 900);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 440, amp: 0.14, gate: 1, pan: 0, out: 0, pos: 0)),

    pwmPad: Sound.new("synth_pwm_pad", { |freq=220, amp=0.15, gate=1, pan=0, out=0, pos=0, rel=0.6, rate=0.17|
        var env = EnvGen.kr(Env.asr(0.03, 1, rel), gate: gate, doneAction: 2);
        var width = SinOsc.kr(rate, 0, 0.2, 0.5);
        var sig = Pulse.ar(freq * [1, 1.01, 2], width).sum * 0.22;
        sig = LPF.ar(sig, 1900 + (env * 1400));
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 220, amp: 0.15, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.6, rate: 0.17)),

    choirish: Sound.new("synth_choirish", { |freq=247, amp=0.14, gate=1, pan=0, out=0, pos=0, rel=0.65|
        var env = EnvGen.kr(Env.asr(0.02, 1, rel), gate: gate, doneAction: 2);
        var src = Saw.ar(freq * [1, 1.005]).sum * 0.35;
        var sig = BPF.ar(src, 620, 0.18) + (BPF.ar(src, 1050, 0.14) * 0.8);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 247, amp: 0.14, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.65)),

    names: [\pluck, \bell, \brass, \keys, \arp, \pwmPad, \choirish]
);

"Synth module ready: ~synth[\\pluck].play, ~synth[\\bell].play, ~synth[\\brass].play".postln;
)
