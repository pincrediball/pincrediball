if (!$args[0]) { throw "First script argument should be your steam username with rights to upload depots"; }

& ./builder/steamcmd.exe +login $args[0] +run_app_build ../steamworks_app_build.vdf +quit
