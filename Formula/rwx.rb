class Rwx < Formula
  desc "RWX is the CI platform with the best developer experience, powering the fastest builds"
  homepage "https://www.rwx.com"
  version "3.13.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-darwin-x86_64", user_agent: :fake
      sha256 "ca75a2219f45954711bbcd8da6ad467f795a600a241377073854b89eea372c39"
    elsif Hardware::CPU.arm?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-darwin-aarch64", user_agent: :fake
      sha256 "ba1a8e59c5e60d2fe6332b1d30878ca2d642dbdc638759459c421844f2462ce6"
    end
  else
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-linux-x86_64", user_agent: :fake
      sha256 "4d2331ce607cadbe9aba2d48c40a8336d23b6bc0b3f21d3737b1b169713c20a4"
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
