BaseModule : Object {
    var <name, <type, <state, <position;

    *new { |name = "unnamed", type = \Base|
        ^super.new.init(name, type);
    }

    init { |inName, inType|
        name = inName.asString;
        type = inType;
        state = \stopped;
        position = 0;
        ^this;
    }

    setName { |newName|
        name = newName.asString;
        ^this;
    }

    play { |args = nil|
        state = \playing;
        ^this;
    }

    stop {
        state = \stopped;
        ^this;
    }

    seek { |newPosition = 0|
        position = newPosition;
        ^this;
    }

    status {
        ^state;
    }

    clone { |newName = nil|
        ^this.class.new(newName ? (name ++ "_copy"), type);
    }
}
