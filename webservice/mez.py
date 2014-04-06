from urllib2 import urlopen
from colorsys import hsv_to_rgb

class Mez:

    def __init__(self):
        self.url = 'http://www.mesonet.org/data/public/mesonet/current/current.csv.txt'

    def get_data(self, url = None):
        if not url: url = self.url
        resp = urlopen(url)
        body = resp.read()
        return self._parse_data(body)

    def _set_to_string(self, data_set):
        result_string = ''
        for row in data_set:
            result_string += row[0] + " " + row[1] + " " + row[2] + "\n"

        return result_string

    def _parse_data(self, raw_data):
        result_set = []
        temp_set = {}
        data_lines = raw_data.split("\n")[1:] # split by line and drop headers line (1)
        for l in data_lines:
            values = l.split(',')
            try:
                if values[10] != ' ':
                    (city, lat, long, temp) = values[1], values[3], values[4], float(values[10])
                    color = ",".join(map(str, temp_to_color(temp)))
                    result = (lat, long, color)
                    temp_data = (city, temp)
                    result_set.append(result)
                    temp_set[city] = temp
            except IndexError:
                pass

        return (self._set_to_string(result_set), temp_set)

def temp_to_color(temp):
    cold = 25.0
    hot = 105.0

    if temp < cold:
        temp = cold
    elif temp > hot:
        temp = hot

    hue = ((temp - cold) * (300.0 / (hot - cold))) / 360.0 # allow degrees from 0 - 300 as to not reuse red
    saturation = 1.0
    value = 1.0

    return map(lambda x: int(x*255.0), hsv_to_rgb((0.8333 - hue), saturation, value)) # 0.8333 = 300/360 ('modified complement')

