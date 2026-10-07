Section : BaseModule {
    classvar <registry;
    var <sequences, <playing;

    *initClass {
        registry = Dictionary.new;
    }

    *new { |name, sequences = nil|
        ^super.new(name, \Section).initSection(sequences);
    }

    *named { |name|
        ^registry.at(name.asString);
    }

    *play { |name, overrides = nil, quant = 1|
        var section = this.named(name);
        if (section.isNil) {
            ("[Section] Unknown section: " ++ name.asString).warn;
            ^nil;
        };
        ^section.play(overrides, quant);
    }

    *stop { |name|
        var section = this.named(name);
        if (section.notNil) { section.stop };
        ^section;
    }

    *stopAll {
        registry.values.do { |section| section.stop };
        ^this;
    }

    *allNames {
        ^registry.keys.collect { |k| k.asSymbol };
    }

    *setBpm { |newBpm = 140|
        ^Sequence.setBpm(newBpm);
    }

    *bpm {
        ^Sequence.bpm;
    }

    initSection { |inSequences|
        sequences = List.new;
        playing = false;
        this.addAll(inSequences);
        registry.put(this.name.asString, this);
        ^this;
    }

    resolveSequence { |item|
        var seq;
        if (item.isNil) { ^nil };
        if (item.isKindOf(Sequence)) { ^item };
        seq = Sequence.named(item);
        if (seq.isNil) {
            ("[Section] Unknown sequence for `" ++ this.name ++ "`: " ++ item.asString).warn;
        };
        ^seq;
    }

    add { |sequenceOrName|
        var seq = this.resolveSequence(sequenceOrName);
        if (seq.isNil) { ^this };
        if (sequences.detect({ |s| s === seq }).isNil) {
            sequences.add(seq);
        };
        ^this;
    }

    addAll { |items|
        if (items.isNil) { ^this };
        if (items.isKindOf(SequenceableCollection).not) {
            this.add(items);
            ^this;
        };
        items.do { |item| this.add(item) };
        ^this;
    }

    remove { |sequenceOrName|
        var seq = this.resolveSequence(sequenceOrName);
        if (seq.notNil) {
            sequences.removeAllSuchThat({ |s| s === seq });
        };
        ^this;
    }

    clear {
        sequences.clear;
        ^this;
    }

    sequenceNames {
        ^sequences.collect { |seq| seq.name.asSymbol };
    }

    play { |overrides = nil, quant = 1|
        if (sequences.isEmpty) {
            ("[Section] No sequences in `" ++ this.name ++ "`.").warn;
            ^this;
        };
        Sequence.ensureClock;
        playing = true;
        sequences.do { |seq|
            if (seq.notNil) { seq.play(overrides, quant) };
        };
        state = \playing;
        ^this;
    }

    stop {
        playing = false;
        sequences.do { |seq|
            if (seq.notNil) { seq.stop };
        };
        state = \stopped;
        ^this;
    }

    seek { |beatOrStep = 0|
        sequences.do { |seq|
            if (seq.notNil) { seq.seek(beatOrStep) };
        };
        position = beatOrStep;
        ^this;
    }

    free {
        this.stop;
        registry.removeAt(this.name.asString);
        ^this;
    }
}
