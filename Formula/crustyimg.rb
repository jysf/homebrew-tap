class Crustyimg < Formula
  desc "A fast Rust CLI to view and transform images."
  homepage "https://github.com/jysf/crustyimg"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jysf/crustyimg/releases/download/v0.8.1/crustyimg-aarch64-apple-darwin.tar.xz"
      sha256 "31d00202702bcf7761412008b6645cb077e2e0fb2a05d61ca28a7968738bdb3f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jysf/crustyimg/releases/download/v0.8.1/crustyimg-x86_64-apple-darwin.tar.xz"
      sha256 "ef2dfe72db7b84bffae037241bea7d1e78de91fce02387da851a2c103385c2e5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jysf/crustyimg/releases/download/v0.8.1/crustyimg-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "abd8e95a11f4bb25a385886b3c4f3107d5b3ee51e922cc3a188cc42b92c0972b"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
      bin.install "crustyimg"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "crustyimg"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "crustyimg"
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
