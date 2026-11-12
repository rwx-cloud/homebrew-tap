class Rwx < Formula
  desc "RWX is the CI platform with the best developer experience, powering the fastest builds"
  homepage "https://www.rwx.com"
  version "3.37.1"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-darwin-x86_64", user_agent: :fake
      sha256 "30b5b3ff1f03a666fd9442ca329917670e314fb8e12c5b9f2f3412396835dc25"
    elsif Hardware::CPU.arm?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-darwin-aarch64", user_agent: :fake
      sha256 "94b788d322fe0b078573f649cf8d523b9f1c29af2b574fc7431848c9e03f1add"
    end
  else
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-linux-x86_64", user_agent: :fake
      sha256 "ccc7174f52e93412eb8a2a78e1ba0e483e391af93800e2c481da4f5c1952ec95"
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
