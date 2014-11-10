require "spec_helper"
require 'net/http'
require 'em-http-request'
require 'influxdb'

class InfluxDB::Client
  public :post
end
describe "influxdb" do
 it "should" do
	username = 'root'
	password = 'root'
	database = 'instance_metrics'
	name     = 'test'

	influxdb = InfluxDB::Client.new database, :username => username, :password => password
	# Enumerator that emits a sine wave
	# Value = (0..360).to_a.map {|i| Math.send(:sin, i / 10.0) * 10 }.each

	query_influx("drop series instance_metrics")
	70000.times do
	  influxdb.post("http://localhost:8086/db/instance_metrics/series?u=root&p=root",metric_template % [now_in_ms, 1, 1])
	end

	result = query_influx("select count(trackingObjectId) from instance_metrics")
	expect(row_count(result)).to eq(1)
 end

	# it "should populate database and show the population" do
	# 	query_influx("drop series instance_metrics")
	#
	# 	# EventMachine.run do
	# 	  70000.times do |i|
	# 		  add_data_point(metric_template % [now_in_ms, 1, Math.tan((i+1)*10)])
	# 	  end
	#   # end
	#
	# 	result = query_influx("select count(trackingObjectId) from instance_metrics")
	# 	expect(row_count(result)).to eq(1)
	# end




	def now_in_ms
		(Time.now.to_f * 1000).to_i
	end

	def row_count(result)
		result[0]["points"][0][1]
	end

  def add_data_point(influx_json_data)
	  RestClient.post "http://localhost:8086/db/instance_metrics/series?u=root&p=root", influx_json_data, :content_type => :json, :accept => :json
		# RestClient::Request.execute(
		#   :method => :post,
		# 	:url => "http://localhost:8086/db/instance_metrics/series?u=root&p=root",
		# 	:timeout => 500,
		# 	:payload => influx_json_data,
		# 	:headers => {:content_type => :json, :accept => :json},
		# 	:open_timeout => 500)
	end

	def add_data_point2(influx_json_data)
      http = EventMachine::HttpRequest.new("http://localhost:8086/db/instance_metrics/series?u=root&p=root").post(
			  :body => influx_json_data,
			  :head => {:content_type => :json, :accept => :json}
			)
			http.errback { p http.response }
	end

  def query_influx(query)
		q = URI::encode("q=#{query}")
		request = "http://localhost:8086/db/instance_metrics/series?u=root&p=root&#{q}"
		JSON.parse(RestClient.get request)
	end

	def metric_template
		@metric_template ||= IO.read("spec/fixtures/instance_metric_schema.json")
	end
end
