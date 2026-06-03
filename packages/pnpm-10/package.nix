{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-10";
  version = "10.34.1";
  hashes = {
    "x86_64-linux" = "sha256-5YyPJbvePtmJ6lCQYQORZ8s2/ITFkWobfSIxZFlCCCo=";
    "aarch64-linux" = "sha256-Xsopw/oycet3Z76CL6IxmGY8iBkS/SlYjVUWKx0mWt0=";
    "x86_64-darwin" = "sha256-aGd+IVggbr2etJA8gQS2y2BxGlURG1ODTzwxk3wPSp8=";
    "aarch64-darwin" = "sha256-ZXyAUg/CPYPiwuVtkNBTTZOVIeesqX76K0maWZtcxKc=";
  };
}
