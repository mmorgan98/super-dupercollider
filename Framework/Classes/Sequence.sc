Sequence : BaseModule {
    classvar <registry, <bpm, <clock, <patterns, <patternStepBeats;
    var <sound, <steps, <stepBeats, <baseParams, <loop, <cursor, <player, <playing;

    *initClass {
        registry = Dictionary.new;
        bpm = 140;
        clock = nil;
        patterns = Dictionary.new;
        patternStepBeats = Dictionary.new;
    }

    *ensureClock {
        if (clock.isNil) {
            clock = TempoClock.new((bpm ? 140) / 60);
        };
        ^clock;
    }

    *setBpm { |newBpm = 140|
        bpm = newBpm.asFloat.max(1);
        this.ensureClock.tempo = bpm / 60;
        ^bpm;
    }

    *beat {
        ^this.ensureClock.beats;
    }

    *stopClock {
        if (clock.notNil) { clock.clear };
        ^clock;
    }

    *new { |name, sound, steps = nil, stepBeats = 0.25, baseParams = nil, loop = true|
        ^super.new(name, \Sequence).initSequence(sound, steps, stepBeats, baseParams, loop);
    }

    *named { |name|
        ^registry.at(name.asString);
    }

    *play { |name, overrides = nil, quant = 1|
        var seq = this.named(name);
        if (seq.isNil) {
            ("[Sequence] Unknown sequence: " ++ name.asString).warn;
            ^nil;
        };
        ^seq.play(overrides, quant);
    }

    *stop { |name|
        var seq = this.named(name);
        if (seq.notNil) { seq.stop };
        ^seq;
    }

    *stopAll {
        registry.values.do { |seq| seq.stop };
        ^this;
    }

    *allNames {
        ^registry.keys.collect { |k| k.asSymbol };
    }

    *registerPattern { |name, steps, stepBeats = 0.25|
        patterns[name.asSymbol] = (steps ? [1, 0, 0, 0]).copy;
        patternStepBeats[name.asSymbol] = stepBeats.max(0.001);
        ^name.asSymbol;
    }

    *patternNames {
        ^patterns.keys.asArray.collect { |k| k.asSymbol }.sort({ |a, b| a.asString <= b.asString });
    }

    *make { |sequenceName, sound, patternName = \fourOnFloor, baseParams = nil, loop = true, bpm = nil|
        var usePattern = patternName;
        var useParams = baseParams;
        var useLoop = loop;
        var useBpm = bpm;
        var pattern;
        var stepBeats;

        // Friendly fallback for calls like:
        // Sequence.make(\name, sound, (amp: 0.3), true, 140)
        if (patternName.isKindOf(Dictionary)) {
            usePattern = \fourOnFloor;
            useParams = patternName;
            if (((baseParams == true) or: { baseParams == false }) and: { loop.isNumber and: { bpm.isNil } }) {
                useLoop = baseParams;
                useBpm = loop;
            };
        };

        if (usePattern.isKindOf(String)) { usePattern = usePattern.asSymbol };
        pattern = patterns[usePattern.asSymbol];
        stepBeats = patternStepBeats[usePattern.asSymbol] ? 0.25;
        if (pattern.isNil) {
            ("[Sequence] Unknown pattern: " ++ usePattern.asString).warn;
            ^nil;
        };
        if (useBpm.notNil) { this.setBpm(useBpm) };
        ^this.new(sequenceName, sound, pattern, stepBeats, useParams, useLoop);
    }

    initSequence { |inSound, inSteps, inStepBeats, inBaseParams, inLoop|
        if (inSound.isNil or: { inSound.respondsTo(\play).not }) {
            ("[Sequence] Invalid sound for `" ++ this.name ++ "`.").warn;
            ^this;
        };

        sound = inSound;
        steps = (inSteps ? [1, 0, 0, 0]).copy;
        stepBeats = inStepBeats.max(0.001);
        baseParams = (inBaseParams ? ()).copy;
        loop = inLoop;
        cursor = 0;
        player = nil;
        playing = false;
        registry.put(this.name.asString, this);
        ^this;
    }

    eventForStep { |step|
        if (step.isKindOf(Dictionary)) { ^step };
        if (step.isNumber) {
            if (step <= 0) { ^nil };
            ^(amp: step.asFloat);
        };
        if (step == true) { ^() };
        ^nil;
    }

    play { |overrides = nil, quant = 1|
        var useClock = this.class.ensureClock;
        var count = steps.size.max(1);

        this.stop;
        playing = true;
        player = Task({
            var idx = cursor.clip(0, count - 1);
            var running = true;

            while { running and: { playing } } {
                var step = steps.wrapAt(idx);
                var event = this.eventForStep(step);
                var params = baseParams.copy;

                if (overrides.notNil and: { overrides.isKindOf(Dictionary) }) {
                    params.putAll(overrides);
                };
                if (event.notNil) {
                    params.putAll(event);
                    sound.play(params);
                };

                idx = idx + 1;
                if (idx >= count) {
                    if (loop) { idx = 0 } { running = false };
                };
                cursor = idx;
                stepBeats.wait;
            };

            playing = false;
            player = nil;
        }).play(useClock, quant: quant);
        state = \playing;
        ^this;
    }

    stop {
        playing = false;
        if (player.notNil) {
            player.stop;
            player = nil;
        };
        if (sound.notNil and: { sound.respondsTo(\stop) }) {
            sound.stop;
        };
        state = \stopped;
        ^this;
    }

    seek { |beatOrStep = 0|
        var stepIndex = if (beatOrStep.isNumber and: { beatOrStep.frac == 0 }) {
            beatOrStep.asInteger;
        } {
            (beatOrStep / stepBeats).floor.asInteger;
        };
        cursor = stepIndex.clip(0, steps.size.max(1) - 1);
        position = cursor;
        ^this;
    }

    setSteps { |newSteps|
        steps = (newSteps ? [1, 0, 0, 0]).copy;
        cursor = 0;
        ^this;
    }

    setStepBeats { |newStepBeats = 0.25|
        stepBeats = newStepBeats.max(0.001);
        ^this;
    }

    setLoop { |enabled = true|
        loop = enabled;
        ^this;
    }

    free {
        this.stop;
        registry.removeAt(this.name.asString);
        ^this;
    }
}
