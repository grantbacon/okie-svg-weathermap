from urllib2 import urlopen

class Mez:

    def __init__(self):
        self.url = 'http://www.mesonet.org/data/public/mesonet/current/current.csv.txt'

    def get_data(self, url = None):
        if not url: url = self.url
        resp = urlopen(url)
        body = resp.read()
        return self._parse_data(body)
    
    def get_pressure_data(self, url = None):
        if not url: url = self.url
        resp = urlopen(url)
        body = resp.read()
        return self._parse_pressure_data(body)

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
    
    def _parse_pressure_data(self, raw_data):
        result_set = []
        pres_set = {}
        minPressure, maxPressure = 50, 0
        data_lines = raw_data.split("\n")[1:] # split by line and drop headers line (1)
        for l in data_lines:
            values = l.split(',')
            try:
                if len(values) > 18:
                    if values[18] == ' ': continue
                    (city, lat, long, pres) = values[1], values[3], values[4], float(values[18])
                    pres *= 0.0295333727
                    minPressure = min(minPressure, pres)
                    maxPressure = max(maxPressure, pres)
                    result = (lat, long, pres)
                    result_set.append(result)
                    pres_set[city] = '%.2f' % pres
            except IndexError, e:
                pass

        processed_result_set = []
        
        for result in result_set:
            color = pres_to_color(result[2], minPressure, maxPressure)
            processed_result_set.append((result[0], result[1], color))

        return (self._set_to_string(processed_result_set), pres_set, minPressure, maxPressure)

# custom HSV to RGB converter that switches blue and cyan so that cyan is colder
def hue_to_rgb(hue):
    rgbColors = [
        (255, 0, 0),
        (255, 255, 0),
        (0, 255, 0),
        (0, 0, 255),
        (0, 255, 255),
        (255, 0, 255),
    ]
    hue %= 300
    which = int(hue) / 60
    factor = (hue % 60.0) / 60.0
    rgbColor = map(lambda a,b: int(a*(1-factor)+b*factor), rgbColors[which], rgbColors[which+1])
    return rgbColor

def temp_to_color(temp):
    cold = 0.0
    hot = 100.0

    if temp < cold:
        temp = cold
    elif temp > hot:
        temp = hot

    hue = ((temp - cold) * (300.0 / (hot - cold))) # allow degrees from 0 - 300 as to not reuse red
    return hue_to_rgb(300 - hue)

def pres_to_color(pres, base, limit):
    if pres < base:
        pres = base
    elif pres > limit:
        pres = limit
    scale = 1.0 / (limit - base)
    return ",".join(map(str, hue_to_rgb(300 * scale * (pres - base))))

