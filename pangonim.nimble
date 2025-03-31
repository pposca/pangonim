# Package

version       = "0.1.0"
author        = "Pepe Osca"
description   = "PangoNim Web Framework"
license       = "Proprietary"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["pangonim"]


# Dependencies

requires "nim >= 2.2.2",
    "colors >= 0.1.2",
    "regex >= 0.26.3"
