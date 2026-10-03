class Axon < Formula
  desc "Local, harness-agnostic observability for AI coding agents — one binary, in your browser."
  homepage "https://github.com/danieltamas/axon"
  version "0.4.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.6/axon-aarch64-apple-darwin.tar.xz"
      sha256 "cd41aa52a996306767d93d7d228f0c49658e7bc014d819f311fb316abee2c983"
    end
    if Hardware::CPU.intel?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.6/axon-x86_64-apple-darwin.tar.xz"
      sha256 "51a05001f8d767d75c28b9726e071b5b0c2423dc43b5a261531aaa71267516ae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.6/axon-aarch64-unknown-linux-musl.tar.xz"
      sha256 "fd39b0d1bddc820751e45633bd1c9795fac0ccb0f5d2546c41fde89255cfc20a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.6/axon-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e04e22f6e57fe4da236cc9d4cc4170ce1e1b6c7d354ed780b73dfa2539e72b00"
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
