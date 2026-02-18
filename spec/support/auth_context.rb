RSpec.shared_context "with authenticated user" do
  let!(:authenticated_api_key) { ApiKey.create!(token: SecureRandom.hex(20), name: "Test User") }
  let(:auth_headers) { { 'X-Api-Key' => authenticated_api_key.token } }
end
