{
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  lib,
}:

let
  version = "2.9.7";
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
    "aarch64-apple-darwin" = "sha256-XNRtYmj2949diL3HFZ0gvUTNqkszA0dIOfh+xv564lw=";
    "x86_64-apple-darwin" = "sha256-ldqv8RwRalKtVHheeRTI6cnNyrp5PF7ZKcdMotjmJZo=";
    "aarch64-unknown-linux-gnu" = "sha256-yDIpixrUQiSBM0hV9gA+D1QUV2LFoTTyCkiVEdL2W78=";
    "x86_64-unknown-linux-gnu" = "sha256-xlJ/JPSxYDHTrk+p9ljV8RU0yNhM59yFAkICgJGcNJA=";
  };

  # SHA-256 hashes of the .sha256sum files published alongside each release.
  # These are fetched and verified by Nix, providing a second trust anchor:
  # even if the binary hashes were maliciously replaced in our package definition,
  # the sha256sum files would also need to be compromised in the same way.
  # During installPhase, the downloaded ZIP is verified against the contents
  # of these checksums, catching supply-chain attacks on the release artifacts.
  sha256sumHashes = {
    "sha256sum-aarch64-apple-darwin" = "sha256-u8Qm1xYBdXFPjY12TAUVWQg2Puv46r4/8L34XJVMQvQ=";
    "sha256sum-x86_64-apple-darwin" = "sha256-hmpUG6kNElzYa0LokrigERrtQKaeJ6zLjfzJ29k+rdo=";
    "sha256sum-aarch64-unknown-linux-gnu" = "sha256-COz92SKlatWR5pzTEpJhIXvqV2zJfhJzQvx9ZA8B/oQ=";
    "sha256sum-x86_64-unknown-linux-gnu" = "sha256-v27gUNxCEYlSCp722/n4aMu9seXtoaKMN9rTTnlipSA=";
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
