class Crustyimg < Formula
  desc "A fast Rust CLI to view and transform images."
  homepage "https://github.com/jysf/crustyimg"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jysf/crustyimg/releases/download/v0.3.1/crustyimg-aarch64-apple-darwin.tar.xz"
      sha256 "87d7aeff3bcf1057c694f5a52701b7d6eab6196c16d49d121c89cdf824379b7b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jysf/crustyimg/releases/download/v0.3.1/crustyimg-x86_64-apple-darwin.tar.xz"
      sha256 "958b60fe8b0d6e3337f75a1ea286d7f435a6bc3f55caea64e63236bf50e5de4f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jysf/crustyimg/releases/download/v0.3.1/crustyimg-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "53ec2cdae399260e499df97e4e6091b280fb485e3cf0a686f28417c1c68e45d2"
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
