require 'aws-sdk-kms'
require 'base64'

module EJSONWrapper
  PrivateKeyNotFound = Class.new(StandardError)

  class DecryptPrivateKeyWithKMS
    def self.call(*args)
      new.call(*args)
    end

    KEY = '_private_key_enc'

    def call(ejson_file_path)
      ejson_hash = JSON.parse(File.read(ejson_file_path))
      encrypted_private_key = ejson_hash.fetch(KEY) do
        raise PrivateKeyNotFound, "Private key was not found in ejson file under key #{key}"
      end
      decrypt(Base64.decode64(encrypted_private_key))
    end

    private

    def decrypt(ciphertext_blob)
      Aws::KMS::Client.new.decrypt(ciphertext_blob: ciphertext_blob).plaintext
    end
  end
end