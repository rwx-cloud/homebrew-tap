require "json"
require "time"

class RwxUnstable < Formula
  desc "RWX CLI for running and analyzing CI builds"
  homepage "https://www.rwx.com"
  release_metadata = JSON.parse(
    Utils::Curl.curl_output(
      "--location",
      "--header",
      "Accept: application/vnd.github+json",
      "https://api.github.com/repos/rwx-cloud/cli/releases/tags/unstable",
    ).stdout,
  )
  release_assets = release_metadata.fetch("assets").each_with_object({}) do |asset, assets|
    assets[asset.fetch("name")] = asset
  end
  asset_sha256 = lambda do |name|
    digest = release_assets.fetch(name).fetch("digest")
    raise "Unexpected digest format for #{name}: #{digest}" unless digest.start_with?("sha256:")

    digest.delete_prefix("sha256:")
  end

  version Time.iso8601(release_metadata.fetch("updated_at")).utc.strftime("%Y.%m.%d.%H%M%S")

  if OS.mac?
    if Hardware::CPU.intel?
      url release_assets.fetch("rwx-darwin-x86_64").fetch("browser_download_url"), user_agent: :fake
      sha256 asset_sha256.call("rwx-darwin-x86_64")
    elsif Hardware::CPU.arm?
      url release_assets.fetch("rwx-darwin-aarch64").fetch("browser_download_url"), user_agent: :fake
      sha256 asset_sha256.call("rwx-darwin-aarch64")
    end
  else
    if Hardware::CPU.intel?
      url release_assets.fetch("rwx-linux-x86_64").fetch("browser_download_url"), user_agent: :fake
      sha256 asset_sha256.call("rwx-linux-x86_64")
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
    system "#{bin}/rwx", "--version"
  end
end
