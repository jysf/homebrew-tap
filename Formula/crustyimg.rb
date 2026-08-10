class Crustyimg < Formula
  desc "A fast Rust CLI to view and transform images."
  homepage "https://github.com/jysf/crustyimg"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jysf/crustyimg/releases/download/v0.7.0/crustyimg-aarch64-apple-darwin.tar.xz"
      sha256 "8f282eefb4c690fdfe902345fb9abb7b5430d03352b20139d5a338e9a7043097"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jysf/crustyimg/releases/download/v0.7.0/crustyimg-x86_64-apple-darwin.tar.xz"
      sha256 "02696daedd9ab1a87c11b4da97df2ca134fbf95b7d03bf2799841284d31069da"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jysf/crustyimg/releases/download/v0.7.0/crustyimg-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2357c19e13b521f56b93b1162d4bd0bd0d5790ec692780a33d270f44647ccf5d"
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
