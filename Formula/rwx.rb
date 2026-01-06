class Rwx < Formula
  desc "RWX is the CI platform with the best developer experience, powering the fastest builds"
  homepage "https://www.rwx.com"
  version "2.3.3"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-darwin-x86_64", user_agent: :fake
      sha256 "84fd1813a4e9062490ef5d477017360cc5568b538af192babcafbb4dd84df7e3"
    elsif Hardware::CPU.arm?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-darwin-aarch64", user_agent: :fake
      sha256 "5b04ed9eb31ad5f172c0a9f9213e619a51b10dffcf2908a9f1db2f95b581a830"
    end
  else
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-linux-x86_64", user_agent: :fake
      sha256 "7d8173ac0a816a7f91d01bf9800aff24687461e9f8db70776d28fa00713164f4"
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
