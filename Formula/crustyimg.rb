class Crustyimg < Formula
  desc "A fast Rust CLI to view and transform images."
  homepage "https://github.com/jysf/crustyimg"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jysf/crustyimg/releases/download/v0.6.0/crustyimg-aarch64-apple-darwin.tar.xz"
      sha256 "0c55f939233aba1890b1d8c3df293baa8cb508042fbde5d23be7191249f3a1e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jysf/crustyimg/releases/download/v0.6.0/crustyimg-x86_64-apple-darwin.tar.xz"
      sha256 "de6b70ab8678067d4a74863eaf4e29d517774d318ae3ae8bf5ecb37c6bbe6c22"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jysf/crustyimg/releases/download/v0.6.0/crustyimg-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0706edbffce432418873b3286760877f5e0db7f3fa8dfb10ce4e66cc5151d7ab"
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
