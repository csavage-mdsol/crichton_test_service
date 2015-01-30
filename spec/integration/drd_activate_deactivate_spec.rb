RSpec.describe Moya do
  describe '#activate' do
    context 'when requesting hale json' do
      include_context 'shared drd hale context'

      before do
        req_body = {name: 'deactivated drd', status: 'deactivated', kind: 'standard'}.merge(can_do_hash)
        response = post(create_url, req_body)
        @drd = parse_hale(response.body)
      end

      after { delete hale_url_for("delete", @drd) }

      it 'responds idempotently to an activate call' do
        activate_url =  hale_url_for("activate", @drd)

        # Activate twice.
        put activate_url
        response = put activate_url
        expect(response.status).to eq(204)

        # Verify
        response = get hale_url_for("self", @drd), can_do_hash
        expect(parse_hale(response.body).properties['status']).to eq('activated')
      end

    end
  end

  describe '#deactivate' do
    context 'when requesting hale json' do
      include_context 'shared drd hale context'

      before do
        req_body = {name: 'activated drd', status: 'activated', kind: 'standard'}.merge(can_do_hash)
        response = post(create_url, req_body)
        @drd = parse_hale(response.body)
      end

      after { delete hale_url_for("delete", @drd) }

      it 'responds idempotently to a deactivate call' do
        deactivate_url = hale_url_for("deactivate", @drd)

        # Deactivate twice.
        put deactivate_url
        response = put deactivate_url
        expect(response.status).to eq(204)

        # Verify
        response = get hale_url_for("self", @drd), can_do_hash
        expect(parse_hale(response.body).properties['status']).to eq('deactivated')
      end

    end
  end

end
