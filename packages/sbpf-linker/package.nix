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
    rev = "06b4e60fba2960f6ec6c433659a88931da934546";
    hash = "sha256-BqlgczHTV6T0ZBBke8jheQvbQqQU7ik5wloIF+1rpKU=";
  };

  cargoHash = "sha256-G+2vSiN3Y6n5BUIVu6jxQwXn+WM1cq4IJYVpxezssSU=";
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
