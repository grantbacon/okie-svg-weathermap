from urllib2 import urlopen
from mez import temp_to_color

class Location:
    def __init__(self, city, state, lat, long):
        self.city = city
        self.state = state
        self.lat = lat
        self.long = long

class NWS(object):
    """
    Gets out of state temperature data from the National Weather Service for
    a few cities in neighboring states.  These are used as data points for
    the temperature on the edges of Oklahoma.
    """

    def __init__(self):
        self.locations = [ Location('LAMAR', 'CO', 38.086111, -102.619444),
                           Location('CLAYTON', 'NM', 36.449722, -103.180833),
                           Location('WINFIELD', 'KS', 37.247778, -96.980556),
                           Location('JOPLIN', 'MO', 37.084167, -94.513056),
                           Location('MENA', 'AR', 34.582222, -94.239167),
                           Location('TEXARKANA', 'AR', 33.433056, -94.020556),
                           Location('CHILDRESS', 'TX', 34.425, -100.213889),
                           Location('PARIS', 'TX', 33.6625, -95.547778),
                           Location('WICHITA FALLS', 'TX', 33.896944, -98.515),
                           Location('DENTON', 'TX', 33.216389, -97.129167) ]

    def _get_temp(self, loc):
        url = 'http://www.nws.noaa.gov/view/prodsByState.php?state=%s&prodtype=hourly' % loc.state
        resp = urlopen(url)
        if not resp: return ''

        temp = None
        for line in resp:
            if line.startswith(loc.city):
                # if data for location is unavailable, try using slightly older data
                if len(line) <= 25: continue
                data = line[25:].split()
                if not data: continue
                print data
                try: temp = int(data[0])
                except ValueError: continue
                break
        if not temp: return ''

        color = ",".join(map(str, temp_to_color(temp)))
        return '%f %f %s\n' % (loc.lat, loc.long, color)

    def _get_pressure(self, loc, minPres, maxPres):
        url = 'http://www.nws.noaa.gov/view/prodsByState.php?state=%s&prodtype=hourly' % loc.state
        resp = urlopen(url)
        if not resp: return ''

        temp = None
        for line in resp:
            if line.startswith(loc.city):
                # if data for location is unavailable, try using slightly older data
                if len(line) <= 25: continue
                data = line[25:].split()
                if not data: continue
                if len(data) < 5: continue
                pres = float(data[4].strip('SFR'))
                break
        if not temp: return ''

        color = pres_to_color(pres, minPres, maxPres)
        return '%f %f %s\n' % (loc.lat, loc.long, color)

    def get_temp_data(self):
        result_string = ''
        for loc in self.locations:
            result_string += self._get_temp(loc)
        return result_string

    def get_pressure_data(self, minPres, maxPres):
        result_string = ''
        for loc in self.locations:
            result_string += self._get_pressure(loc, minPres, maxPres)
        return result_string



