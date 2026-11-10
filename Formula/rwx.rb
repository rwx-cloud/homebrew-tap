class Rwx < Formula
  desc "RWX is the CI platform with the best developer experience, powering the fastest builds"
  homepage "https://www.rwx.com"
  version "3.37.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-darwin-x86_64", user_agent: :fake
      sha256 "a0edc92a115a0b9896378cb9ed8b63ec004033f69fd182a8591973a12995fddc"
    elsif Hardware::CPU.arm?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-darwin-aarch64", user_agent: :fake
      sha256 "e0a960e113de93493f2ae6e43773ca93c0d66c270f29a1533813797810aff7ba"
    end
  else
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-linux-x86_64", user_agent: :fake
      sha256 "73df4c88f5fb0cbda8d1afcfaf9517d837049acfa6c2fdf5d8a9817ee4d056d9"
    end
  end

  def install
    filename = case
                 when OS.mac? && Hardware::CPU.intel? then "rwx-darwin-x86_64"
                 when OS.mac? && Hardware::CPU.arm? then "rwx-darwin-aarch64"
                 when OS.linux? && Hardware::CPU.intel? then "rwx-linux-x86_64"
               end
    bin.install filename => "rwx"
  end

  test do
    system "#{bin}/rwx --version"
  end
end
