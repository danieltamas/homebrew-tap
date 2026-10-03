class Axon < Formula
  desc "Local, harness-agnostic observability for AI coding agents — one binary, in your browser."
  homepage "https://github.com/danieltamas/axon"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.3/axon-aarch64-apple-darwin.tar.xz"
      sha256 "e54497b6331be853adb13280b94e3574a3844765cf54390acb3d1ef406847a5f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.3/axon-x86_64-apple-darwin.tar.xz"
      sha256 "517f7500f75434d0326a1964b2a21522e8e1a2ac8dcf8dc3b19b1cf695152694"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.3/axon-aarch64-unknown-linux-musl.tar.xz"
      sha256 "a06ded3ac1be238a5d2e7fcef61574c3326fef7586357f022128b1f456df12c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.3/axon-x86_64-unknown-linux-musl.tar.xz"
      sha256 "02c8a87a4e038d3f8c4a410d64de912d945cb6f2fa4b6f641cb6102100177c2c"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "axon"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "axon"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "axon"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "axon"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
