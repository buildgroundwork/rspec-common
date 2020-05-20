# frozen_string_literal: true

# A memory-only service for ActiveStorage.  Any "uploaded" files live in memory
# and can be accessed by their given key.
#
# The `#override` method inserts files into memory as if they had been uploaded
# previously.
#
# The `#reset!` method clears all files. This line should be somewhere in your
# rails_helper.rb config:
#
#   config.before { ActiveStorage::Blob.service.reset! }

module ActiveStorage
  class Service::MemoryService < Service
    def initialize(**config); end

    def reset!
      @storage = nil
    end

    def override(key, content)
      write(key, content)
    end

    def upload(key, io, checksum: nil, **)
      instrument(:upload, key: key, checksum: checksum) do
        content = io.read
        ensure_integrity_of(content, checksum) if checksum
        write(key, content)
      end
    end

    def download(key, &block)
      verify!(key)

      if block_given?
        instrument(:streaming_download, key: key) { stream(key, &block) }
      else
        instrument(:download, key: key) { storage[key].force_encoding(Encoding::BINARY) }
      end
    end

    def download_chunk(key, range)
      verify!(key)

      instrument(:download_chunk, key: key, range: range) do
        io = StringIO.new(storage[key])
        io.seek(range.begin)
        io.read(range.size).force_encoding(Encoding::BINARY)
      end
    end

    def delete(key)
      instrument(:delete, key: key) { storage.delete(key) }
    end

    def delete_prefixed(prefix)
      instrument(:delete_prefixed, prefix: prefix) do
        storage.keys.grep(/\A#{prefix}/).each { |key| delete(key) }
      end
    end

    def exist?(key)
      instrument(:exist, key: key) do |payload|
        payload[:exist] = storage.has_key?(key)
      end
    end

    def url(key, filename: , **)
      instrument(:url, key: key) do |payload|
        payload[:url] = "http://test.host/#{filename}"
      end
    end

    def url_for_direct_upload(key, **)
      instrument(:url, key: key) do |payload|
        payload[:url] = "http://test.upload.host/#{key}"
      end
    end

    private

    def storage
      @storage ||= {}
    end

    def write(key, content)
      storage[key] = content.dup
    end

    def verify!(key)
      raise(ActiveStorage::FileNotFoundError) unless storage.has_key?(key)
    end

    def stream(key)
      io = StringIO.new(storage[key])
      yield(io.read(1_000).force_encoding(Encoding::BINARY)) until io.eof?
    end

    def ensure_integrity_of(content, checksum)
      digest = Digest::MD5.base64digest(content)
      raise(ActiveStorage::IntegrityError) unless digest == checksum
    end
  end
end

