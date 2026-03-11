require "json"
require "net/http"
require "time"
require "uri"

class RwxUnstable < Formula
  desc "RWX CLI for running and analyzing CI builds"
  homepage "https://www.rwx.com"

  class << self
    def release_metadata
      @release_metadata ||= begin
        uri = URI("https://api.github.com/repos/rwx-cloud/rwx/releases/tags/unstable")
        request = Net::HTTP::Get.new(uri)
        request["Accept"] = "application/vnd.github+json"

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end

        unless response.is_a?(Net::HTTPSuccess)
          raise "Failed to fetch #{uri}: #{response.code} #{response.message}"
        end

        JSON.parse(response.body)
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
