require "spec_helper"

describe "influxdb" do
	it "should populate database and " do
		query_influx("drop series instance_metrics")

		now = (Time.now.to_f * 1000).to_i
		100.times do |i|
			add_data_point(metric_template % [(now-1000) + 10*(i+1), 1, Math.tan((i+1)*10)])
		end

		result = query_influx("select count(trackingObjectId) from instance_metrics")
		expect(row_count(result)).to eq(100)
	end

	def row_count(result)
		result[0]["points"][0][1]
	end

  def add_data_point(influx_json_data)
	  RestClient.post "http://localhost:8086/db/instance-metrics/series?u=root&p=root", influx_json_data, :content_type => :json, :accept => :json
	end

  def query_influx(query)
		q = URI::encode("q=#{query}")
		request = "http://localhost:8086/db/instance-metrics/series?u=root&p=root&#{q}"
		JSON.parse(RestClient.get request)
	end

	def metric_template
		@metric_template ||= IO.read("spec/fixtures/instance_metric_schema.json")
	end
end
