RSpec.describe Moya do
  describe '#update' do
    context 'when requesting hale json' do
      include_context 'shared drd hale context'

      let(:update_all_properties) {
        { 'status' => 'deactivated',
          'old_status' => 'activated',
          'kind' => 'sentinel',
          'size' => 'medium',
          'location' => 'Mars',
          'location_detail' => 'Olympus Mons',
          'destroyed_status' => true
        }
      }

      it 'responds appropirately to an update call with all permissible attributes' do
        # Create a drd
        response = post create_url, drd_hash.merge(can_do_hash)
        drd = parse_hale(response.body)

        # Update the drd with all permissible attributes
        expect(drd.properties['name']).to eq('Pike')

        response = put hale_url_for("update", drd), update_all_properties
        expect(response.status).to eq(303)

        # Check that it is really updated
        response = get hale_url_for("self", drd)
        drd = parse_hale(response.body)

        expect(drd.properties.slice(*update_all_properties.keys)).to eq(update_all_properties)
      end

    end
  end
end
