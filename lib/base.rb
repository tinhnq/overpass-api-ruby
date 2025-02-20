# encoding 'utf-8'
require 'httpi'
require 'json'
require 'csv'

module OverpassAPI
  # base class, ql and xml extend this
  class Base
    DEFAULT_ENDPOINT = 'http://overpass-api.de/api/interpreter'.freeze

    def initialize(args = {})
      bbox = args[:bbox]
      bounding_box(bbox[:s], bbox[:n], bbox[:w], bbox[:e]) if bbox

      @endpoint = args[:endpoint] || DEFAULT_ENDPOINT
      @timeout = args[:timeout]
      @out = args[:out] || 'json'
    end

    def bounding_box(south, north, west, east)
      @bbox = "#{south},#{west},#{north},#{east}"
    end

    def query(query)
      perform build_query(query)
    end

    def raw_query(query)
      perform query
    end

    private

    def perform(query)
      r = HTTPI::Request.new(url: @endpoint, body: query)
      if @out.include?('csv')
        csv = CSV.parse(HTTPI.post(r).body.force_encoding('utf-8'), headers: true, col_sep: "\t")
        JSON.parse(csv.map(&:to_h).to_json, symbolize_names: true)
      else
        JSON.parse(HTTPI.post(r).body, symbolize_names: true)
      end
    end
  end
end
