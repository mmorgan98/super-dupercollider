// =============================================================================
// LEAD MODULE — EDM lead starters
// =============================================================================
(
if (\Sound.asClass.isNil) {
    "[Lead] Sound class is not available. Recompile class library first (Ctrl+Shift+L).".warn;
    ^nil;
};

~lead = (
    supersaw: Sound.new("lead_supersaw", { |freq=220, amp=0.18, gate=1, pan=0, out=0, pos=0, detune=0.012, rel=0.3|
        var env = EnvGen.kr(Env.asr(0.01, 1, rel), gate: gate, doneAction: 2);
        var osc = Saw.ar(freq * [1 - detune, 1, 1 + detune, 2]) * [0.25, 0.35, 0.25, 0.15];
        var sig = LPF.ar(Mix(osc), 4800);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 220, amp: 0.18, gate: 1, pan: 0, out: 0, pos: 0, detune: 0.012, rel: 0.3)),

    pluckLead: Sound.new("lead_pluck", { |freq=330, amp=0.2, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.001, 0.2, curve: -6), gate: gate, doneAction: 2);
        var sig = Pulse.ar(freq * [1, 1.01], 0.45).sum * 0.6;
        sig = RLPF.ar(sig, 1000 + (env * 5500), 0.2);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 330, amp: 0.2, gate: 1, pan: 0, out: 0, pos: 0)),

    raveLead: Sound.new("lead_rave", { |freq=262, amp=0.22, gate=1, pan=0, out=0, pos=0, rel=0.22|
        var env = EnvGen.kr(Env.asr(0.002, 1, rel), gate: gate, doneAction: 2);
        var sig = VarSaw.ar(freq * [1, 2], 0, [0.6, 0.35]).sum;
        sig = BHiPass4.ar(sig.tanh, 450, 0.75);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 262, amp: 0.22, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.22)),

    fmLead: Sound.new("lead_fm", { |freq=330, amp=0.2, gate=1, pan=0, out=0, pos=0, mod=2.3, rel=0.25|
        var env = EnvGen.kr(Env.asr(0.003, 1, rel), gate: gate, doneAction: 2);
        var modSig = SinOsc.ar(freq * 2.01, 0, freq * mod * env);
        var sig = SinOsc.ar(freq + modSig) + (Saw.ar(freq * 0.5) * 0.25);
        sig = BLowPass4.ar(sig, 1200 + (env * 3800), 0.5);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 330, amp: 0.2, gate: 1, pan: 0, out: 0, pos: 0, mod: 2.3, rel: 0.25)),

    whistle: Sound.new("lead_whistle", { |freq=880, amp=0.16, gate=1, pan=0, out=0, pos=0, rel=0.18|
        var env = EnvGen.kr(Env.asr(0.001, 1, rel), gate: gate, doneAction: 2);
        var sig = SinOsc.ar(freq) + (SinOsc.ar(freq * 2, 0, 0.25));
        sig = HPF.ar(sig, 1500);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 880, amp: 0.16, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.18)),

    trance: Sound.new("lead_trance", { |freq=330, amp=0.18, gate=1, pan=0, out=0, pos=0, rel=0.28|
        var env = EnvGen.kr(Env.asr(0.005, 1, rel), gate: gate, doneAction: 2);
        var sig = Saw.ar(freq * [1, 1.004, 1.009, 2]).sum * 0.23;
        sig = HPF.ar(sig, 300);
        sig = LPF.ar(sig, 5200);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 330, amp: 0.18, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.28)),

    chip: Sound.new("lead_chip", { |freq=523, amp=0.14, gate=1, pan=0, out=0, pos=0|
        var env = EnvGen.kr(Env.perc(0.0005, 0.12, curve: -7), gate: gate, doneAction: 2);
        var sig = Pulse.ar(freq * [1, 2], 0.5).sum * 0.55;
        sig = HPF.ar(sig, 1200);
        Pan2.ar(sig * env * amp, pan)
    }, (freq: 523, amp: 0.14, gate: 1, pan: 0, out: 0, pos: 0)),

    voxAh: Sound.new("lead_vox_ah", { |freq=330, amp=0.16, gate=1, pan=0, out=0, pos=0, rel=0.24|
        var env = EnvGen.kr(Env.asr(0.002, 1, rel), gate: gate, doneAction: 2);
        var src = Saw.ar(freq) + Pulse.ar(freq * 1.5, 0.4, 0.35);
        var form = BPF.ar(src, 900, 0.15) + (BPF.ar(src, 1200, 0.12) * 0.9);
        Pan2.ar(form * env * amp, pan)
    }, (freq: 330, amp: 0.16, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.24)),

    voxOh: Sound.new("lead_vox_oh", { |freq=294, amp=0.16, gate=1, pan=0, out=0, pos=0, rel=0.26|
        var env = EnvGen.kr(Env.asr(0.003, 1, rel), gate: gate, doneAction: 2);
        var src = VarSaw.ar(freq * [1, 1.01], 0, 0.45).sum * 0.6;
        var form = BPF.ar(src, 520, 0.2) + (BPF.ar(src, 880, 0.16) * 0.8);
        Pan2.ar(form * env * amp, pan)
    }, (freq: 294, amp: 0.16, gate: 1, pan: 0, out: 0, pos: 0, rel: 0.26)),

    names: [\supersaw, \pluckLead, \raveLead, \fmLead, \whistle, \trance, \chip, \voxAh, \voxOh]
);

"Lead module ready: ~lead[\\supersaw].play, ~lead[\\fmLead].play".postln;
)
