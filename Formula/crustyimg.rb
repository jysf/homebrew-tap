class Crustyimg < Formula
  desc "A fast Rust CLI to view and transform images."
  homepage "https://github.com/jysf/crustyimg"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jysf/crustyimg/releases/download/v0.8.2/crustyimg-aarch64-apple-darwin.tar.xz"
      sha256 "a3ed5365c0de1a5b35a7cea21bf3f97abb136fa19843db2167b85688d908b0a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jysf/crustyimg/releases/download/v0.8.2/crustyimg-x86_64-apple-darwin.tar.xz"
      sha256 "b9ea45c9cdb8d921d4d8ac3a5d93038e3328c4c83a52379b6a265fc5c8ead47e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jysf/crustyimg/releases/download/v0.8.2/crustyimg-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e9ae4d94f2a433032a12c499ca3640c37376d0d9666721a33c06470b76b56363"
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
