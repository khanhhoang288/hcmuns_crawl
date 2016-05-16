require "net/http"
require "uri"

params = {
	"__EVENTTARGET" => "",
	"__EVENTARGUMENT" => "",
	"__VIEWSTATE" => "/wEPDwUKLTk0MjM1OTc2M2RkZnJtyCJi5ie9zI96OV/PsVPge36vAdyoGz3ZlFzzV+8=",
	"ctl00$MainContent$txtMaSV" => "14080131"
}

uri = URI.parse("http://www.hui.edu.vn/KhoaNgoaiNgu/XemDiemThiXepLop.aspx?MenuID=225")
# Clear old data
` > list.txt`
res = []

# Full control
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri)

start = 14000001
index = 0
while (start < 14999999) do
	begin
		masv = start
		params["ctl00$MainContent$txtMaSV"] = masv.to_s
		request.set_form_data(params)
		response, data = http.request(request)
		body = response.body.gsub("\r\n", "").gsub("\"", "'")
		# id = body.scan(/value='(\d+)'/ix)
		# if id
		# 	id = id.first.first
		# end
		ps = /weight:bold;'>(.*)<td\salign='r/ix
		name = body.scan(ps)
		if !name.empty?
			name = name.first.first.split("</td>")[0]
			res << [masv, name]
		end
	end
	index += 1
	start += 10
	if index % 1000 == 0
		p "Current at #{masv}"
		res.each {|x| x.join(' - ')}
		`echo "#{res.join('\n')}" >> list.txt`
		res = []
	end
end
p "Complete crawling"