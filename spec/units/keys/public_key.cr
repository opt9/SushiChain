# Copyright © 2017-2018 The SushiChain Core developers
#
# See the LICENSE file at the top-level directory of this distribution
# for licensing information.
#
# Unless otherwise agreed in a custom licensing agreement with the SushiChain Core developers,
# no part of this software, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained in the
# LICENSE file.
#
# Removal or modification of this copyright notice is prohibited.

require "./../../spec_helper"
require "./../utils"

include Sushi::Core
include Sushi::Core::Keys

describe PublicKey do
  describe "#initialize" do
    it "should create a public key object from a public key string" do
      secp256k1 = ECDSA::Secp256k1.new
      key_pair = secp256k1.create_key_pair
      hex_public_key = key_pair[:public_key].x.to_s(16) + key_pair[:public_key].y.to_s(16)

      public_key = PublicKey.new(hex_public_key)
      public_key.as_hex.should eq(hex_public_key)
    end

    it "should raise an error if the public key hex string is not a valid public key" do
      expect_raises(Exception, "invalid public key: 123") do
        PublicKey.new("123")
      end
    end
  end

  describe "#from hex" do
    it "should create a public key object from a public key string" do
      secp256k1 = ECDSA::Secp256k1.new
      key_pair = secp256k1.create_key_pair
      hex_public_key = key_pair[:public_key].x.to_s(16) + key_pair[:public_key].y.to_s(16)

      public_key = PublicKey.from(hex_public_key)
      public_key.as_hex.should eq(hex_public_key)
    end
  end

  describe "#x and #y" do
    it "should return values for x and y identical to the original x and y" do
      secp256k1 = ECDSA::Secp256k1.new
      key_pair = secp256k1.create_key_pair
      public_key_x = key_pair[:public_key].x
      public_key_y = key_pair[:public_key].y
      hex_public_key = key_pair[:public_key].x.to_s(16) + key_pair[:public_key].y.to_s(16)

      public_key = PublicKey.from(hex_public_key)
      public_key.x.should eq(public_key_x)
      public_key.y.should eq(public_key_y)
    end

    it "should return an ECDSA Point for public key" do
      secp256k1 = ECDSA::Secp256k1.new
      key_pair = secp256k1.create_key_pair
      hex_public_key = key_pair[:public_key].x.to_s(16) + key_pair[:public_key].y.to_s(16)

      public_key = PublicKey.from(hex_public_key)
      public_key.point.x.should eq(key_pair[:public_key].x)
      public_key.point.y.should eq(key_pair[:public_key].y)
      public_key.point.infinity?.should eq(key_pair[:public_key].infinity?)
    end
  end

  describe "#from bytes" do
    it "should create a public key object from a public key byte array" do
      secp256k1 = ECDSA::Secp256k1.new
      key_pair = secp256k1.create_key_pair
      hex_public_key = key_pair[:public_key].x.to_s(16) + key_pair[:public_key].y.to_s(16)
      hexbytes = hex_public_key.hexbytes

      public_key = PublicKey.from(hexbytes)
      public_key.as_bytes.should eq(hexbytes)
      public_key.as_hex.should eq(hex_public_key)
    end
    it "should raise an error if the public key byte array is not a valid public key" do
    end
  end

  it "should convert a public key from hex to bytes with #as_bytes" do
    secp256k1 = ECDSA::Secp256k1.new
    key_pair = secp256k1.create_key_pair
    hex_public_key = key_pair[:public_key].x.to_s(16) + key_pair[:public_key].y.to_s(16)
    hexbytes = hex_public_key.hexbytes

    public_key = PublicKey.from(hex_public_key)
    public_key.as_bytes.should eq(hexbytes)
  end

  it "should convert a public key from bytes to hex with #as_hex" do
    secp256k1 = ECDSA::Secp256k1.new
    key_pair = secp256k1.create_key_pair
    hex_public_key = key_pair[:public_key].x.to_s(16) + key_pair[:public_key].y.to_s(16)
    hexbytes = hex_public_key.hexbytes

    public_key = PublicKey.from(hexbytes)
    public_key.as_hex.should eq(hex_public_key)
  end

  describe "#network" do
    it "should return the mainnet by default" do
      Keys.generate.public_key.network.should eq(MAINNET)
    end
    it "should return the supplied network" do
      Keys.generate(TESTNET).public_key.network.should eq(TESTNET)
    end
  end

  describe "#address" do
    it "should return the address" do
      hex_public_key = "b9a152547ec31de50a726896293c7b99e63e6d9588b6d48fde5c926a1794d0616af3598724f335ec71b00509a69e3ce376a285ca5dd77ed5cce8e558c9d5b7e7"

      public_key = PublicKey.from(hex_public_key)
      public_key.address.as_hex.should eq("TTA5YjVkYTA1NWVkNWQyNDYyMmNiMWU5M2EwZWVhZmFmODA4MDg3MjU5NzAxNTll")
    end

    it "should return a mainnet address" do
      keys = Keys.generate
      decoded_address = Base64.decode_string(keys.public_key.address.as_hex)
      decoded_address[0..1].should eq("M0")
    end

    it "should return a testnet address" do
      keys = Keys.generate(TESTNET)
      decoded_address = Base64.decode_string(keys.public_key.address.as_hex)
      decoded_address[0..1].should eq("T0")
    end
  end

  describe "#is_valid?" do
    it "should return true if the public key is valid" do
      Keys.generate.public_key.is_valid?.should be_true
    end
  end
  STDERR.puts "< Keys::PublicKey"
end
