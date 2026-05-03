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
                ("[fw] Library folder not found: " ++ folderName.asString).warn;
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
            libraryDir.folders
                .sort({ |a, b| a.fileName <= b.fileName })
                .do({ |folder| loadFromDir.(folder) });
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
    "Framework loaded (BaseModule + Sound classes available).".postln;
};

if (~fw[\autoLoadLibrary]) {
    "[fw] Auto-loading Library modules...".postln;
    ~fw[\loadLibraryModules].();
};
)
