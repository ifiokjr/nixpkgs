{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-10";
  version = "10.34.9";
  hashes = {
    "x86_64-linux" = "sha256-vUc+pQpIR1UI3t3bkqa45wTahnBToRInHpvZ5e0SVrM=";
    "aarch64-linux" = "sha256-VVdT0tLf8bGzQXmSbeZDFQFYBhx2wmYR7QynklD19HI=";
    "x86_64-darwin" = "sha256-0Qvc6hWD7+/nvWR8Pn7jZ7/s7rUKwlSJT5RnF/vMaM4=";
    "aarch64-darwin" = "sha256-6L8CAaQWjeN593ZHX0Qidi/CvGnWy1nBHVrSUtwBQQs=";
  };
}
