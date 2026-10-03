class Axon < Formula
  desc "Local, harness-agnostic observability for AI coding agents — one binary, in your browser."
  homepage "https://github.com/danieltamas/axon"
  version "0.4.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.5/axon-aarch64-apple-darwin.tar.xz"
      sha256 "a2def01ea3eddfb7937e7fca0fa33ab4f6559823abab865375db0591ec66e9a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.5/axon-x86_64-apple-darwin.tar.xz"
      sha256 "c83536c3306b99b94cae83674d1a516e48830e0c829a4c895082174f9997f4ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.5/axon-aarch64-unknown-linux-musl.tar.xz"
      sha256 "369a56bb1bfbc7afef4180d3d5bf961113326e8cb4b6307ec16af70554ec7d7d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.5/axon-x86_64-unknown-linux-musl.tar.xz"
      sha256 "edd7b7118e0fa23ffdc87428760b73dff06a2b6abfff55992227e279b66bd280"
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
