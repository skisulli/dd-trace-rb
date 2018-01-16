require 'spec_helper'

require 'ddtrace'
require 'faraday'
require 'ddtrace/ext/distributed'

RSpec.describe 'Faraday middleware' do
  let(:tracer) { Datadog::Tracer.new(writer: FauxWriter.new) }

  let(:client) do
    ::Faraday.new('http://example.com') do |builder|
      builder.use(:ddtrace, middleware_options)
      builder.adapter(:test) do |stub|
        stub.get('/success') { |_| [200, {}, 'OK'] }
        stub.post('/failure') { |_| [500, {}, 'Boom!'] }
        stub.get('/not_found') { |_| [404, {}, 'Not Found.'] }
      end
    end
  end

  let(:middleware_options) { {} }

  let(:request_span) do
    tracer.writer.spans(:keep).find { |span| span.name == Datadog::Contrib::Faraday::NAME }
  end

  before(:each) do
    Datadog.configure do |c|
      c.use :faraday, tracer: tracer
    end
  end

  context 'when there is no interference' do
    subject!(:response) { client.get('/success') }

    it do
      expect(response).to be_a_kind_of(::Faraday::Response)
      expect(response.body).to eq('OK')
      expect(response.status).to eq(200)
    end
  end

  context 'when there is successful request' do
    subject!(:response) { client.get('/success') }

    it do
      # binding.pry if Datadog::Pin.get_from(::Faraday).tracer.object_id != tracer.object_id
      expect(request_span).to_not be nil
      expect(request_span.service).to eq(Datadog::Contrib::Faraday::SERVICE)
    #   # assert_equal(NAME, request_span.name)
    #   # assert_equal('GET', request_span.resource)
    #   # assert_equal('GET', request_span.get_tag(Ext::HTTP::METHOD))
    #   # assert_equal('200', request_span.get_tag(Ext::HTTP::STATUS_CODE))
    #   # assert_equal('/success', request_span.get_tag(Ext::HTTP::URL))
    #   # assert_equal('example.com', request_span.get_tag(Ext::NET::TARGET_HOST))
    #   # assert_equal('80', request_span.get_tag(Ext::NET::TARGET_PORT))
    #   # assert_equal(Ext::HTTP::TYPE, request_span.span_type)
    #   # refute_equal(Ext::Errors::STATUS, request_span.status)
    end
  end
end
