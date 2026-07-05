class Crustyimg < Formula
  desc "A fast Rust CLI to view and transform images."
  homepage "https://github.com/jysf/crustyimg"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jysf/crustyimg/releases/download/v0.2.0/crustyimg-aarch64-apple-darwin.tar.xz"
      sha256 "758868cdb3f3c7634ad1f2a9b83ad576551c653ce47ff81b7352195bb34370e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jysf/crustyimg/releases/download/v0.2.0/crustyimg-x86_64-apple-darwin.tar.xz"
      sha256 "8d4dca82ee7500f4ff622feccb6e2dd7ca4e768d84e2656df8f90d4885a54cc5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jysf/crustyimg/releases/download/v0.2.0/crustyimg-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "80e0965b51a12bd4d0f929b17b516007884460607b55c5d49a9bf995ce479d42"
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
    bin.install "crustyimg" if OS.mac? && Hardware::CPU.arm?
    bin.install "crustyimg" if OS.mac? && Hardware::CPU.intel?
    bin.install "crustyimg" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
