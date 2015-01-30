RSpec.describe Moya do
  describe '#destroy' do
    context 'when requesting hale json' do
      include_context 'shared drd hale context'

      # Create a drd
      before do
        response = post create_url, drd_hash.merge(can_do_hash)
        @drd = parse_hale response.body
      end

      it 'responds to a destroy call' do
        #Make sure it is there
        self_url = hale_url_for("self", @drd)
        response = get self_url
        expect(response.status).to eq(200)

        # Blow it up
        response = delete hale_url_for("delete", @drd)
        expect(response.status).to eq(204)

        # make sure it is gone
        response = get self_url
        expect(response.status).to eq(404)
      end

    end
  end
end
