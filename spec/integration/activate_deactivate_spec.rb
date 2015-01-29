RSpec.describe Moya do
  describe '#activate' do
    context 'when requesting hale json' do
      include_context 'shared drd hale context'

      it 'responds idempotently to an activate call' do
        # Create deactivated drd
        req_body = {name: 'deactivated drd', status: 'deactivated', kind: 'standard'}.merge(can_do_hash)
        response = post(create_url, req_body)

        # Get the activate URL
        drd = parse_hale(response.body)
        activate_url = "#{get_transition_uri(drd, "activate")}.hale_json"

        # Activate twice.
        put activate_url
        response = put activate_url
        expect(response.status).to eq(204)

        # Verify
        response = get hale_url_for("self", drd), can_do_hash
        expect(parse_hale(response.body).properties['status']).to eq('activated')

        # Destroy our drd
        delete hale_url_for("delete", drd)
      end

    end
  end

  describe '#deactivate' do
    context 'when requesting hale json' do
      include_context 'shared drd hale context'

      it 'responds idempotently to a deactivate call' do
        # Create deactivated drd
        req_body = {name: 'activated drd', status: 'activated', kind: 'standard'}.merge(can_do_hash)
        response = post(create_url, req_body)

        # Get the activate URL
        drd = parse_hale(response.body)
        deactivate_url = hale_url_for("deactivate", drd)

        # Deactivate twice.
        put deactivate_url
        response = put deactivate_url
        expect(response.status).to eq(204)

        # Verify
        response = get hale_url_for("self", drd), can_do_hash
        expect(parse_hale(response.body).properties['status']).to eq('deactivated')

        # Destroy our drd
        delete hale_url_for("delete", drd)
      end

    end
  end

end
