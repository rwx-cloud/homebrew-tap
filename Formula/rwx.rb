class Rwx < Formula
  desc "RWX is the CI platform with the best developer experience, powering the fastest builds"
  homepage "https://www.rwx.com"
  version "3.16.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-darwin-x86_64", user_agent: :fake
      sha256 "ed7e97352af243fca33be8310e74282e5b749e5c4d2d98b963114adca25f4cb3"
    elsif Hardware::CPU.arm?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-darwin-aarch64", user_agent: :fake
      sha256 "b6b0cd0b656a6f7b948cd039370be59a9d8ef98d39bc9c25fa330c9817babc81"
    end
  else
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-linux-x86_64", user_agent: :fake
      sha256 "9a305df96791ccc1a1ec504b0685e6ec7eee01f127924bcd6fd5553b6667b5e9"
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
