class Rwx < Formula
  desc "RWX is the CI platform with the best developer experience, powering the fastest builds"
  homepage "https://www.rwx.com"
  version "3.5.2"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-darwin-x86_64", user_agent: :fake
      sha256 "24d9b09c099d9643883331b4880b4a676f2f6c9d7df48e8568999aabea4f86ce"
    elsif Hardware::CPU.arm?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-darwin-aarch64", user_agent: :fake
      sha256 "0b0a1a17bb7014b0c3d2b2b47ef75ebc978456351bb68450beaa6ec9480a68fe"
    end
  else
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-linux-x86_64", user_agent: :fake
      sha256 "d008d897e6953384c5ac842b896425cf2058714deecfbe891fed596d1e024447"
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
