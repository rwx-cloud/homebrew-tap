class Rwx < Formula
  desc "RWX is the CI platform with the best developer experience, powering the fastest builds"
  homepage "https://www.rwx.com"
  version "2.3.1"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-darwin-x86_64", user_agent: :fake
      sha256 "37a30fd03e195907a3e8172f348c79d1a01c34ab4fff0910416dd24139738f3d"
    elsif Hardware::CPU.arm?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-darwin-aarch64", user_agent: :fake
      sha256 "a527cf5bd349466c91f08c59168c32588dd05f43b1e502450c6b906daca76dab"
    end
  else
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-linux-x86_64", user_agent: :fake
      sha256 "d467aab2457e90314a02bd746de894a0e5ad4f147132461dc0ac98cdf505a6d1"
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
