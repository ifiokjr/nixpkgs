{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-10";
  version = "10.34.7";
  hashes = {
    "x86_64-linux" = "sha256-DM1Kuf/uYumQU5bf2fnJ1nc39YVjpOkZmBHPRmWWUGI=";
    "aarch64-linux" = "sha256-5fAEvF4LGsq3tv2gGn1B93Zw8H8OpFzp5Wh4k42JgpI=";
    "x86_64-darwin" = "sha256-UgDnSywJ/aHorJC/HNn13m/N9ReyNjFgLIBbv0aGUpU=";
    "aarch64-darwin" = "sha256-/fFdub1YfUTTQDz7dsHYiFvz8CVk0HmVM8TE2S9mKWw=";
  };
}
