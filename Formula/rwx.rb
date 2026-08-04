class Rwx < Formula
  desc "RWX is the CI platform with the best developer experience, powering the fastest builds"
  homepage "https://www.rwx.com"
  version "3.22.1"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-darwin-x86_64", user_agent: :fake
      sha256 "1affd5c73ec4faaa68f31fa624725a4739ee0d8ae1e144afedf7c4d34764ac57"
    elsif Hardware::CPU.arm?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-darwin-aarch64", user_agent: :fake
      sha256 "cd1753088ac55d9d5e7f5559a91a84f3fcbf529bf394ecb1969eb79970fd79e1"
    end
  else
    if Hardware::CPU.intel?
      url "https://github.com/rwx-cloud/rwx/releases/download/v#{version}/rwx-linux-x86_64", user_agent: :fake
      sha256 "9c319e13b940249f62c911b454eec8e97fd9f3ec3d46cefce95ebd88c32facd1"
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
