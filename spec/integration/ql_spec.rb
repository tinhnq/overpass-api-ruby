require 'spec_helper'
require 'overpass_api_ruby'

describe OverpassAPI::QL do
  it 'should return the right elements' do
    options = { bbox: { s: -34.705448, n: -34.526562,
                        w: -58.531471, e: -58.335159 },
                timeout: 900,
                maxsize: 10_000 }

    overpass = OverpassAPI::QL.new(options)

    ba_query = "rel['route'='subway'];(._;>;);out body;"

    expect(overpass.query(ba_query)[:elements]).to be_a(Array)
  end

  it 'supports query with csv output' do

    overpass = OverpassAPI::QL.new({out: 'csv'})

    raw_query = "[out:csv('name',::id,::type)][timeout:900];area(3600049915)->.searchArea;(relation['admin_level'='4'](area.searchArea););out body;"

    expect(overpass.raw_query(raw_query)).to be_a(Array)
  end
end
