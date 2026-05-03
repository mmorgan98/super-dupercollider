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

    names: [\supersaw, \pluckLead, \raveLead],

    play: { |self, name, overrides=nil|
        var sound = self[name.asSymbol];
        if (sound.isNil) {
            ("[Lead] Unknown lead: " ++ name.asString).warn;
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

"Lead module ready: ~lead[\\supersaw].play, ~lead.play(\\pluckLead)".postln;
)
