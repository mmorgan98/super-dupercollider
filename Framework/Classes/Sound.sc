Sound : BaseModule {
    classvar <registry;
    var <graph, <defaults, <defName, <node, <activeNodes;

    *initClass {
        registry = Dictionary.new;
    }

    *new { |name, graph, defaults = nil|
        ^super.new(name, \Sound).initSound(graph, defaults ? ());
    }

    *named { |name|
        ^registry.at(name.asString);
    }

    initSound { |inGraph, inDefaults|
        graph = inGraph;
        defaults = (inDefaults ? ()).copy;
        defName = ("snd_" ++ this.name).asSymbol;
        node = nil;
        activeNodes = List.new;
        registry.put(this.name.asString, this);
        ^this;
    }

    setDefaults { |newDefaults = nil|
        defaults = (newDefaults ? ()).copy;
        ^this;
    }

    compile {
        var server = Server.default;

        if (graph.isKindOf(Function).not) {
            ("[Sound] Graph must be a Function for `" ++ this.name ++ "`.").warn;
            ^this;
        };

        SynthDef(defName, { |out = 0, freq = 440, amp = 0.2, gate = 1, pan = 0, pos = 0|
            var signal = graph.value(freq, amp, gate, pan, out, pos);
            signal = signal.isArray.if({ Mix(signal) }, { signal });
            Out.ar(out, signal);
        }).send(server);

        ^this;
    }

    play { |overrides = nil|
        var server = Server.default;
        var params = defaults.copy;
        var currentNode;

        if (server.serverRunning.not) {
            "[Sound] Server is not running. Boot with s.boot.".warn;
            ^this;
        };

        if (overrides.notNil and: { overrides.isKindOf(Dictionary) }) {
            params.putAll(overrides);
        };

        Routine({
            this.compile;
            server.sync;
            currentNode = Synth(defName, params.asKeyValuePairs, server.defaultGroup, \addToHead);
            node = currentNode;
            activeNodes.add(currentNode);
            NodeWatcher.register(currentNode);
            currentNode.register;
            currentNode.onFree({
                activeNodes.remove(currentNode);
                if (node === currentNode) {
                    node = nil;
                };
                if (activeNodes.isEmpty) {
                    state = \stopped;
                };
            });
            state = \playing;
        }).play(SystemClock);

        ^this;
    }

    stop {
        activeNodes.copy.do { |n|
            if (n.notNil and: { n.isPlaying }) { n.free };
        };
        activeNodes.clear;
        node = nil;
        state = \stopped;
        ^this;
    }

    seek { |newPosition = 0|
        position = newPosition;
        if (node.notNil) {
            if (node.isPlaying) { node.set(\pos, newPosition) };
        };
        ^this;
    }

    free {
        this.stop;
        registry.removeAt(this.name.asString);
        ^this;
    }
}
