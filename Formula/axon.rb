class Axon < Formula
  desc "Local, harness-agnostic observability for AI coding agents — one binary, in your browser."
  homepage "https://github.com/danieltamas/axon"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.4/axon-aarch64-apple-darwin.tar.xz"
      sha256 "21eb495f85a241aba374e6c3e7f65a4dfe279b8d8fa3f7bdb40c0a14f5af3b71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.4/axon-x86_64-apple-darwin.tar.xz"
      sha256 "3ab161f3d2445351f783d3cb510125ffeb9e707713c68dd12a4ac8aa8c5a31d0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.4/axon-aarch64-unknown-linux-musl.tar.xz"
      sha256 "7cf37d8c973602b05bdb63eba46f285d2a639e86089d3b7f1faa9b75a25eeeb4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.4/axon-x86_64-unknown-linux-musl.tar.xz"
      sha256 "de2cb77d1d97ab1f40b9f990040b0a164501dd62852a73934f8b5a83a2494a3f"
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
