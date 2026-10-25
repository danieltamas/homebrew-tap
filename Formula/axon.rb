class Axon < Formula
  desc "Local, harness-agnostic observability for AI coding agents — one binary, in your browser."
  homepage "https://github.com/danieltamas/axon"
  version "0.4.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.8/axon-aarch64-apple-darwin.tar.xz"
      sha256 "f9c4b17b8e7a91a6d0364fe84e6aaa3213543b1e13eec19c92cab6dceb818a13"
    end
    if Hardware::CPU.intel?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.8/axon-x86_64-apple-darwin.tar.xz"
      sha256 "b353268f4686a16ddd06029f343f8204209baee09f38a8cb725984b4421fae58"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.8/axon-aarch64-unknown-linux-musl.tar.xz"
      sha256 "7b6945299423db8295abd64fcea2604ef8ceb0ee1c5e940da365ae4c560a2e42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/danieltamas/axon/releases/download/v0.4.8/axon-x86_64-unknown-linux-musl.tar.xz"
      sha256 "92a9c36ca47c01c908c2757591395d271da24baf88bfc2b3b9f3b510e6fe7627"
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
