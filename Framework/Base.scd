(
var fwPath = thisProcess.nowExecutingPath.dirname.standardizePath;
var projectPath = (fwPath +/+ "..").standardizePath;

~fw = (
    version: "class-sound",
    frameworkPath: fwPath,
    classesPath: (fwPath +/+ "Classes").standardizePath,
    libraryPath: (projectPath +/+ "Library").standardizePath,
    soundsPath: (projectPath +/+ "Library" +/+ "Sounds").standardizePath,
    autoLoadLibrary: true,
    loadLibraryModules: { |folders=nil|
        var libraryDir = PathName.new(~fw[\libraryPath]);
        var loaded = [];
        var loadFromDir;
        var loadNamedFolder;
        var allFolders;
        var priority;
        var matchedFolder;
        var loadedFolderNames;

        loadFromDir = { |dir|
            dir.files
                .select({ |file|
                    (file.extension.asString.toLower == "scd")
                    and: { file.fileName != "LoadAll.scd" }
                })
                .sort({ |a, b| a.fileName <= b.fileName })
                .do({ |file|
                    file.fullPath.load;
                    loaded = loaded.add(file.fullPath);
                });

            dir.folders
                .sort({ |a, b| a.fileName <= b.fileName })
                .do({ |folder| loadFromDir.(folder) });
        };

        loadNamedFolder = { |folderName|
            var dir = PathName.new((~fw[\libraryPath] +/+ folderName.asString).standardizePath);
            if (dir.isFolder.not) {
                ^nil;
            };
            loadFromDir.(dir);
        };

        if (libraryDir.isFolder.not) {
            ("[fw] No library folder found at " ++ ~fw[\libraryPath]).warn;
            ^[];
        };

        if (folders.notNil and: { folders.isKindOf(SequenceableCollection) }) {
            folders.do { |folderName| loadNamedFolder.(folderName) };
        } {
            allFolders = libraryDir.folders.sort({ |a, b| a.fileName <= b.fileName });
            priority = ["sounds", "sequences", "tracks", "phrases"];
            loadedFolderNames = [];

            priority.do { |name|
                matchedFolder = allFolders.detect { |folder| folder.fileName.asString.toLower == name };
                if (matchedFolder.notNil) {
                    loadFromDir.(matchedFolder);
                    loadedFolderNames = loadedFolderNames.add(matchedFolder.fileName.asString.toLower);
                };
            };

            allFolders.do { |folder|
                if (loadedFolderNames.includes(folder.fileName.asString.toLower).not) {
                    loadFromDir.(folder);
                };
            };
        };

        ("[fw] Loaded library modules (" ++ loaded.size ++ "):").postln;
        loaded.do { |path| ("  - " ++ path).postln };
        loaded;
    },
    loadSoundLibrary: {
        ~fw[\loadLibraryModules].(["Sounds"]);
    }
);

~loadLibrary = { ~fw[\loadLibraryModules].() };

if (\Sound.asClass.isNil) {
    "[fw] Sound class is not compiled yet.".warn;
    "[fw] Add `Framework/Classes` to your SC class library include path (or copy those .sc files into Extensions), then recompile (Ctrl+Shift+L).".postln;
} {
    if (\Sequence.asClass.isNil) {
        "[fw] Sequence class is not compiled yet.".warn;
        "Framework loaded (BaseModule + Sound available). Recompile to enable Sequence.".postln;
    } {
        ~clock = (
            setBpm: { |self, bpm=140|
                Sequence.setBpm(bpm);
            },
            bpm: { |self| Sequence.bpm },
            beat: { |self| Sequence.beat },
            stop: { |self| Sequence.stopClock }
        );
        ~seq = (
            new: { |self, name, sound, steps=nil, stepBeats=0.25, baseParams=nil, loop=true|
                Sequence.new(name, sound, steps, stepBeats, baseParams, loop);
            },
            named: { |self, name| Sequence.named(name) },
            setBpm: { |self, bpm=140| Sequence.setBpm(bpm) },
            bpm: { |self| Sequence.bpm },
            beat: { |self| Sequence.beat },
            play: { |self, name, overrides=nil, quant=1| Sequence.play(name, overrides, quant) },
            stop: { |self, name| Sequence.stop(name) },
            stopAll: { |self| Sequence.stopAll }
        );

        if (\Section.asClass.isNil) {
            "[fw] Section class is not compiled yet.".warn;
            "Framework loaded (BaseModule + Sound + Sequence available). Recompile to enable Section.".postln;
        } {
            "Framework loaded (BaseModule + Sound + Sequence + Section classes available).".postln;
            ~section = (
                new: { |self, name, sequences=nil|
                    Section.new(name, sequences);
                },
                named: { |self, name| Section.named(name) },
                setBpm: { |self, bpm=140| Section.setBpm(bpm) },
                bpm: { |self| Section.bpm },
                play: { |self, name, overrides=nil, quant=1| Section.play(name, overrides, quant) },
                stop: { |self, name| Section.stop(name) },
                stopAll: { |self| Section.stopAll }
            );
        };
    };
};

if (~fw[\autoLoadLibrary]) {
    "[fw] Auto-loading Library modules...".postln;
    ~fw[\loadLibraryModules].(["Sounds", "Sequences"]);
    // Make missing sound modules obvious (e.g. Guitar.scd only on a feature branch).
    [\drum, \bass, \chord, \lead, \synth, \fx, \vocal, \guitar].do { |key|
        if (currentEnvironment.at(key).isNil) {
            ("[fw] ~" ++ key ++ " is nil — Library/Sounds module missing or Sound class not compiled.").postln;
        };
    };
};
)
