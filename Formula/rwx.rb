class Rwx < Formula
  desc "RWX is the CI platform with the best developer experience, powering the fastest builds"
  homepage "https://www.rwx.com"
  version "3.1.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-darwin-x86_64", user_agent: :fake
      sha256 "d7d69e64d52fe47298952f04b8ae204cb4e6629cec7bc6d8a912c7a04b359d42"
    elsif Hardware::CPU.arm?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-darwin-aarch64", user_agent: :fake
      sha256 "584044267daf6c567a5dc0de5fe12947522a7be10c0658db3ee8ae1c32924372"
    end
  else
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-linux-x86_64", user_agent: :fake
      sha256 "9e1b9afbf4212e4b552597667a08084ac0cf8657d478a27f724d0de8a7d9457d"
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
