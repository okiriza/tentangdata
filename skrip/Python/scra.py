# Skrip Python untuk meng-crawl data dari Web weddingku.com
# pada tulisan "Tempat Resepsi Jakarta bagian 1: Pengumpulan dan Pemrosesan Awal"
# oleh Ali, Maret 2015


from httplib2 import Http
from urllib import urlencode
from BeautifulSoup import BeautifulSoup as BS
from HTMLParser import HTMLParser
import csv

http = Http()
h = HTMLParser()

class Venue():
	def __init__(self, name, love, rating, review, url, img):
		self.name = name
		self.love = love
		self.rating = rating
		self.review = review
		self.url = url
		self.img = img

	def __str__(self):
		return '"%s",%s,%s,%s,"%s","%s"' % (self.name, self.love, self.rating, self.review, self.url, self.img)

def getPage(url):
	resp, content = http.request(url)
	return content

def writeList(filename):
	with open(filename,'w') as f:
		for page in range(15):
			resp, content = http.request("http://www.weddingku.com/ajax/searchvendors.asp?city=JKT&dc=74&page=%d" % (page + 1))
			f.write(content)
			f.flush()

def parse(filename):
	f = open(filename)
	soup = BS(f.read())

	venues = []

	lis = soup.findAll('li')
	for li in lis:
		name = h.unescape(li.find('h3')).text.encode('ascii', 'ignore')
		love = li.find('i', {'title': 'Love'})
		love = int(love.nextSibling[12:]) if love != None else 0
		rating = li.find('span', {'class': 'ratebig'})
		rating = float(rating.text) if rating != None else 0
		review = li.find('div', {'class': 'vendorrate'})
		review = review.find('a').text if review != None else 0
		if review != 0:
			review = review[:review.find(' ')]
		url = li.find('a', {'class': 'title'}).attrs[0][1].encode('ascii', 'ignore')
		img = li.find('img').attrs[0][1]
		venues.append(Venue(name, love, rating, review, url, img))
	return venues

def getAddresses(filename):
	with open(filename) as f:
		f = csv.reader(f)
		out = csv.writer(open('add.csv','w'))
		i = 1
		for data in f:
			soup = BS(getPage(data[4]))
			c = soup.find('div', {'id': 'divAddress'})
			if c != None:
				out.write([i, c.contents[6].strip()])
			else:
				out.write([i, None])
			i += 1

def getReview(pid):
	soup = BS(getPage('http://www.weddingku.com/directory/ajax/getVendorReview.asp?pid=%s' % pid))
	reviewer = soup.find('a')
	article = soup.find('article', {'class': 'brief'})
	if article != None:
		return "%s|%s" % (reviewer.text, article.text)
	else:
		return None

def getReviews(filename):
	with open(filename) as f:
		f.readline()
		f = csv.reader(f)
		i = 1
		for data in f:
			print "%d|%s" % (i, getReview(data[4].split('/')[6]))
			i += 1

if __name__ == '__main__':
	writeList('test.html')
	venues = parse('test.html')
	out = csv.writer(open('w.csv','w'))
	for v in venues:
		out.write(v)
	getAddresses('w.csv')
	getReviews('w.csv')
