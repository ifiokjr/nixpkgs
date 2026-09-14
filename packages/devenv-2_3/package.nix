{
  callPackage,
  cmake,
  libghostty-vt,
}:
callPackage ../devenv/common.nix {
  version = "2.3.1";
  hash = "sha256-zZB/UVcdL0VWuAPEe/ALY7onj8Q18efSUdL3ZJlUspk=";
  cargoHash = "sha256-oaBQMX8gTj/jFliJnfl+lO4yndSrorJT/Y3p2/YoRas=";
  devenvNixVersion = "2.35";
  devenvNixRev = "b9b81726b38469c55b9706d80d37d6c73cc7f76c";
  devenvNixHash = "sha256-3NT3yTvoRT7+rxLDNovpyeTDIJkZlBoO72rcu2x9Y9o=";
  extraNativeBuildInputs = [ cmake ];
  extraBuildInputs = [ libghostty-vt ];
  # Binding a TCP socket is not permitted in the darwin sandbox.
  extraCheckFlags = [
    "--skip"
    "waits_for_previous_proxy_to_release_control_socket"
  ];
}
