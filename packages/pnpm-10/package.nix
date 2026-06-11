{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-10";
  version = "10.34.2";
  hashes = {
    "x86_64-linux" = "sha256-4s7zKrjfzNvJUP/NOovzdPMhUop1rU1Z1f108QDvwhc=";
    "aarch64-linux" = "sha256-uVLMMXXW1xMmPRgqsktZG0H8JF21My/QLua6r4gTSng=";
    "x86_64-darwin" = "sha256-TQvBdzC7W0W1ogPYfnWMk3KQ1AdXMKYy1jT7dcILix0=";
    "aarch64-darwin" = "sha256-r59FAD7xalRN7aDq20saurdVAdZAGBziKqW5mDpCdmA=";
  };
}
