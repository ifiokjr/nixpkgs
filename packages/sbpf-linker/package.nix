{
  lib,
  rustPlatform,
  fetchFromGitHub,
  llvmPackages_22,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sbpf-linker";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "blueshift-gg";
    repo = "sbpf-linker";
    rev = "48a8abc1d48a0f8021a5bb79ae675e4654d660c1";
    hash = "sha256-E1b0e95dm6TEzhS4wAJdMGEOcYCptHVPSS7YaJVUjR0=";
  };

  cargoHash = "sha256-7rgTqfskgbnQ/uk3FqmlFG9JveXAzn5OnruhTSspF6s=";
  cargoPatches = [ ./Cargo.lock.patch ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "upstream-gallery-22" ];

  nativeBuildInputs = [ llvmPackages_22.llvm ];
  buildInputs = [ llvmPackages_22.libllvm ];
  env.LLVM_PREFIX = "${llvmPackages_22.llvm.dev}";

  doCheck = false;

  meta = {
    description = "Upstream BPF linker for SBPF V0 programs";
    homepage = "https://github.com/blueshift-gg/sbpf-linker";
    license = lib.licenses.mit;
    mainProgram = "sbpf-linker";
    tags = [
      "cli"
      "linker"
      "solana"
      "bpf"
    ];
  };
})
