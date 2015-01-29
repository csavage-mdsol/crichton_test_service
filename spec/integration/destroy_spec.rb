RSpec.describe Moya do
  describe '#destroy' do
    context 'when requesting hale json' do
      include_context 'shared drd hale context'

      it 'responds to a destroy call' do
        # Create a drd
        response = post create_url, drd_hash

        #Make sure it is there
        self_url = hale_url_for("self", parse_hale(response.body))
        response = get self_url, can_do_hash
        expect(response.status).to eq(200)

        #blow it up
        destroy_url = hale_url_for("delete", parse_hale(response.body))
        response = delete destroy_url
        expect(response.status).to eq(204)

        # make sure it is gone
        response = get self_url
        expect(response.status).to eq(404)
      end

    end
  end
end
