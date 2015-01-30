RSpec.describe Moya do
  describe '#show' do
    context 'when requesting hale json' do
      include_context 'shared drd hale context'

      it 'responds appropriately to a drd show call' do
        show_url = hale_url_for("self", drds.embedded["items"].sample)
        expect(get(show_url).status).to eq(200)
      end

      it 'returns the appropriate attributes for a drd show call' do
        show_url = hale_url_for("self", drds.embedded["items"].sample)
        drd = parse_hale(get(show_url).body)
        expect(drd.properties.keys).to match_array(drd_properties)
      end

      it 'returns an appropriate 404 response for an unkown drd' do
        show_url = hale_url_for("self", drds.embedded["items"].sample)
        # Trim off the uuid and .hale_json, add back another uuid and .hale_json
        bad_show_url = "#{show_url[0...-46]}#{SecureRandom.uuid}.hale_json"

        response = get bad_show_url
        expect(response.status).to eq(404)
        expect(parse_hale(response.body).properties.keys).to match_array(error_properties)
      end

    end
  end
end
