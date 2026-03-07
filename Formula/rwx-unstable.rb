require "json"
require "time"

class RwxUnstable < Formula
  desc "RWX CLI for running and analyzing CI builds"
  homepage "https://www.rwx.com"

  class << self
    def architecture
      return :intel if Hardware::CPU.intel?
      return :arm if Hardware::CPU.arm?
      raise "Unsupported architecture for rwx-unstable"
    end

    def release_api_url
      "https://api.github.com/repos/rwx-cloud/cli/releases/tags/unstable"
    end

    def release_metadata
      @release_metadata ||= begin
        response = Utils::Curl.curl_output(
          "--location",
          "--header",
          "Accept: application/vnd.github+json",
          release_api_url,
        )

        JSON.parse(response.stdout)
      end
    end

    def release_assets
      @release_assets ||= release_metadata.fetch("assets").each_with_object({}) do |asset, assets|
        assets[asset.fetch("name")] = asset
      end
    end

    def release_version
      @release_version ||= Time.iso8601(release_metadata.fetch("updated_at")).utc.strftime("%Y.%m.%d.%H%M%S")
    end

    def asset_name
      if OS.mac?
        return "rwx-darwin-x86_64" if architecture == :intel
        return "rwx-darwin-aarch64" if architecture == :arm
      elsif OS.linux?
        return "rwx-linux-x86_64" if architecture == :intel
        return "rwx-linux-aarch64" if architecture == :arm
      end

      raise "Unsupported platform for rwx-unstable"
    end

    def asset_metadata
      @asset_metadata ||= release_assets.fetch(asset_name)
    rescue KeyError
      raise "Unable to find #{asset_name} in the rwx unstable release"
    end

    def asset_sha256
      digest = asset_metadata.fetch("digest")
      raise "Unexpected digest format for #{asset_name}: #{digest}" unless digest.start_with?("sha256:")

      digest.delete_prefix("sha256:")
    end
  end

  url asset_metadata.fetch("browser_download_url"), user_agent: :fake
  version release_version
  sha256 asset_sha256

  livecheck do
    skip "Version and checksum are derived from the unstable release metadata at install time."
  end

  def install
    bin.install self.class.asset_name => "rwx"
  end

  test do
    system "#{bin}/rwx", "--version"
  end
end
