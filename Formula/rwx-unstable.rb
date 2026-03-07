require "json"
require "time"

class RwxUnstable < Formula
  desc "RWX CLI for running and analyzing CI builds"
  homepage "https://www.rwx.com"

  class << self
    def release_metadata
      @release_metadata ||= JSON.parse(
        Utils::Curl.curl_output(
          "--location",
          "--header",
          "Accept: application/vnd.github+json",
          "https://api.github.com/repos/rwx-cloud/cli/releases/tags/unstable",
        ).stdout,
      )
    end

    def release_assets
      @release_assets ||= release_metadata.fetch("assets").each_with_object({}) do |asset, assets|
        assets[asset.fetch("name")] = asset
      end
    end

    def release_version
      @release_version ||= Time.iso8601(release_metadata.fetch("updated_at")).utc.strftime("%Y.%m.%d.%H%M%S")
    end

    def asset_url(name)
      release_assets.fetch(name).fetch("browser_download_url")
    end

    def asset_sha256(name)
      digest = release_assets.fetch(name).fetch("digest")
      raise "Unexpected digest format for #{name}: #{digest}" unless digest.start_with?("sha256:")

      digest.delete_prefix("sha256:")
    end
  end

  version release_version

  if OS.mac?
    if Hardware::CPU.intel?
      url asset_url("rwx-darwin-x86_64"), user_agent: :fake
      sha256 asset_sha256("rwx-darwin-x86_64")
    elsif Hardware::CPU.arm?
      url asset_url("rwx-darwin-aarch64"), user_agent: :fake
      sha256 asset_sha256("rwx-darwin-aarch64")
    end
  else
    if Hardware::CPU.intel?
      url asset_url("rwx-linux-x86_64"), user_agent: :fake
      sha256 asset_sha256("rwx-linux-x86_64")
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
