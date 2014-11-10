package performance

import (
	"testing"
	"net/http"
	"io/ioutil"
	"github.com/bradfitz/iter"
	. "gopkg.in/check.v1"
)
func Test(t *testing.T) { TestingT(t) }

type DataTestSuite struct {
	client *DataTestClient
	dbname string
}

var _ = Suite(&DataTestSuite{})

func (self *DataTestSuite) SetUpSuite(c *C) {
	self.dbname = "testdb"
	http.DefaultTransport.(*http.Transport).CloseIdleConnections()
}

func (self *DataTestSuite) SetUpTest(c *C) {
	self.client = &DataTestClient{}
	self.client.CreateDatabase(self.dbname, c)
	self.client.SetDB(self.dbname)
}

func (self *DataTestSuite) TearDownTest(c *C) {
	self.client.DeleteDatabase(self.dbname, c)
	self.client = nil
}

func loadInstanceMetricTemplate(c *C) string{
	data, err := ioutil.ReadFile("../spec/fixtures/instance_metric_schema.json")
	c.Assert(err,IsNil)
	return string(data)
}

func (self *DataTestSuite) TestWriteOneItem(c *C) {
	data := loadInstanceMetricTemplate(c)
	entries := 70000
	for _ = range iter.N(entries){
		self.client.WriteJsonData(data, c)
	}
	result := self.client.RunQuery("select count(trackingObjectId) from instance_metrics", c)
//	c.Assert(result, HasLen, 1)
	maps := ToMap(result[0])
//	c.Assert(maps, HasLen, 1)
	c.Assert(maps[0]["count"], Equals, float64(entries))
}
