class Rwx < Formula
  desc "RWX is the CI platform with the best developer experience, powering the fastest builds"
  homepage "https://www.rwx.com"
  version "3.7.1"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-darwin-x86_64", user_agent: :fake
      sha256 "1f65e2c629e36b9c3f0bbf7e577ac719c729eeba5c8a880b07656add0cfa2733"
    elsif Hardware::CPU.arm?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-darwin-aarch64", user_agent: :fake
      sha256 "8deae5e17ef904a25e64814752ae6b049c833cbf687885f2c33bfdba263b30a3"
    end
  else
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/cli/releases/download/v#{version}/rwx-linux-x86_64", user_agent: :fake
      sha256 "9c92c84fb37e4e3980cad166e45451ff24f0c0b261ce7abc5d0a234f3e3b52dd"
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
