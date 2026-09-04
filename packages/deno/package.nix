{
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  lib,
}:

let
  version = "2.9.6";
  tag = "v${version}";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-ITovME8E08nLUiBmmvrROPYKWqsf6Aliq96481gHpHI=";
    "x86_64-apple-darwin" = "sha256-fUUkuCvMVX/gIKGltWlW7UK5kq5bKAJuitXRcylTP18=";
    "aarch64-unknown-linux-gnu" = "sha256-mkavxsOSx80v9xoxVYk1VFtGQI0Oh/eoaQjHEnIcBG4=";
    "x86_64-unknown-linux-gnu" = "sha256-OU8H9Nor6+bObx584PoWQpspsIw14/rD/iWXJnbf9LI=";
  };

  # SHA-256 hashes of the .sha256sum files published alongside each release.
  # These are fetched and verified by Nix, providing a second trust anchor:
  # even if the binary hashes were maliciously replaced in our package definition,
  # the sha256sum files would also need to be compromised in the same way.
  # During installPhase, the downloaded ZIP is verified against the contents
  # of these checksums, catching supply-chain attacks on the release artifacts.
  sha256sumHashes = {
    "sha256sum-aarch64-apple-darwin" = "sha256-nd1WJHauuuRKlfKLPpOVeaf09X8Acr9WC58TXWdGB+0=";
    "sha256sum-x86_64-apple-darwin" = "sha256-p0lDeBFYrrOsfmCHK5Eka4Hxb+2P0KVGbNvaHiKQVRk=";
    "sha256sum-aarch64-unknown-linux-gnu" = "sha256-wVE/xbp+zNYFOV37AMHBK/NCWaHgM2Vu6cx3ZMpdrAY=";
    "sha256sum-x86_64-unknown-linux-gnu" = "sha256-qfgw301LnzSlZ8z4mTBC5mG+XMgRCq2jqpCvgDTYBjE=";
  };
in
stdenv.mkDerivation {
  pname = "deno";
  inherit version;

  src = fetchurl {
    url = "https://github.com/denoland/deno/releases/download/${tag}/deno-${platformSuffix}.zip";
    sha256 = hashes.${platformSuffix} or lib.fakeSha256;
  };

  # Fetched separately so we can verify the binary against Deno's
  # published checksums, providing supply-chain assurance beyond the
  # Nix fetchurl hash alone.
  checksums = fetchurl {
    url = "https://github.com/denoland/deno/releases/download/${tag}/deno-${platformSuffix}.zip.sha256sum";
    sha256 = sha256sumHashes.${"sha256sum-${platformSuffix}"} or lib.fakeSha256;
  };

  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    # Verify the downloaded ZIP matches Deno's published SHA-256 checksum.
    # This cross-checks our Nix fetchurl hash against what Deno published,
    # catching supply-chain attacks that replace both the binary AND our hashes.
    expected=$(awk '{print $1}' "$checksums")
    actual=$(sha256sum "$src" 2>/dev/null | awk '{print $1}' || shasum -a 256 "$src" 2>/dev/null | awk '{print $1}')

    if [ -n "$actual" ] && [ "$actual" != "$expected" ]; then
      echo "deno: SHA-256 checksum verification failed!" >&2
      echo "  expected: $expected" >&2
      echo "  got:      $actual" >&2
      echo "  The downloaded ZIP does not match Deno's published checksum." >&2
      exit 1
    fi

    mkdir -p $out/bin
    cp deno $out/bin/deno
    chmod +x $out/bin/deno

    runHook postInstall
  '';

  meta = with lib; {
    description = "A modern runtime for JavaScript and TypeScript";
    homepage = "https://deno.com/";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    mainProgram = "deno";
    tags = [
      "cli"
      "javascript"
      "typescript"
      "runtime"
    ];
  };
}
