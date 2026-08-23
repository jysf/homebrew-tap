class Crustyimg < Formula
  desc "A fast Rust CLI to view and transform images."
  homepage "https://github.com/jysf/crustyimg"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jysf/crustyimg/releases/download/v0.7.1/crustyimg-aarch64-apple-darwin.tar.xz"
      sha256 "585d6adb7b5500657911e9d1b13d8a1441575c3170da6f63eed4382effee4525"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jysf/crustyimg/releases/download/v0.7.1/crustyimg-x86_64-apple-darwin.tar.xz"
      sha256 "87d6a743312ef7074e3c6fd49f5bcfe6732927a863537ff6bf07ec48f15915f5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jysf/crustyimg/releases/download/v0.7.1/crustyimg-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "937260a3342ef817904da546e0e8d7f349c0a1e167dfff3289bfac67646575b6"
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
