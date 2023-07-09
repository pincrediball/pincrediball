# Pincrediball Scripts

Some limited documentation (more like "notes to self") about using these scripts.

## Steamworks

The following abbreviated folder structure is expected:

```none
.
|-- pincrediball
|-- pincrediball-builds
    |-- build-output
        |-- linux
        |-- macos
        |-- windows
    |-- steamworks
        |-- sdk
            |-- tools
                |-- ContentBuilder
```

And you should:

- duplicate the `.vdf` and `.ps1` into that `ContentBuilder` folder
- run exports from Godot, which should automatically land in the `build-output` subfolders

Then if you run a Powershell prompt straight from the `ContentBuilder` folder like so:

```powershell
./steamworks_upload_depots.ps1 YourSteamUserName
```

Then it should prompt you to log in (the first time only) and start uploading the builds for all three depots.