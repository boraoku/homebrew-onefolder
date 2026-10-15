class Onefolder < Formula
  desc "Sync local folders to OneDrive and external drives with rclone, from a calm terminal app"
  homepage "https://github.com/boraoku/onefolder"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/boraoku/onefolder/releases/download/v0.1.0/onefolder-aarch64-apple-darwin.tar.xz"
      sha256 "97869d5b678790d9f8312e2c2b09eb6c01156695331996324457bd416a048f33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boraoku/onefolder/releases/download/v0.1.0/onefolder-x86_64-apple-darwin.tar.xz"
      sha256 "88f71d1ab30d320995efef82480f4d8da1a592a084436a886ef6de7dc71d81ed"
    end
  end
  license "MIT"
  depends_on "rclone"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {}
  }

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
      bin.install "onefolder"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "onefolder"
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
