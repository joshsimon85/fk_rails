$(function() {

  function Location(resp) {
    this.city = resp.city;
    this.state = resp.region;
    this.latitude = resp.latitude;
    this.longitude = resp.longitude;
    this.regionCode = resp.region_code;
  }

  const DensityAltitude = {
    $el: $('.density-altitude'),
    fetchWeather: function(lat, long) {
      return new Promise((resolve, reject) => {
        $.ajax({
          url: window.location.href + 'api/density_altitude',
          type: 'get',
          contentType: 'application/json',
          data: {
            lat: lat,
            long: long
          },
          success: function(response) {
            resolve(response);
          },
          error: function(error) {
            reject(error);
          }
        });
      });
    },
    checkStore: function(ip) {
      return window.localStorage.getItem(+ip);
    },
    storeData: function(ip, locationData) {
      window.localStorage.setItem(ip, JSON.stringify(locationData));
    },
    addDensityAltToView: function(weather) {
      this.$el.find('h3 span').text(this.physicalLocation);
      this.$el.find('p:first-of-type').text(weather.density_altitude + "'");
      this.$el.find('p:nth-of-type(2) span').text(this.toLocalTimeDate(weather.time));
      this.$el.show();
    },
    fetchLatLong: function() {
      return new Promise((resolve, reject) => {
        $.ajax({
          url: 'https://ipapi.co/json/',
          type: 'get',
          contentType: 'application/json',
          success: function(response) {
            resolve(response);
          },
          error: function(error) {
            reject(error);
          }
        });
      });
    },
    fetchWeatherFromNewLocation: function() {
      let self = this;

      this.fetchLatLong().then(function(response) {
        let locationData = new Location(response);

        self.addPhysicalLocation(locationData);
        self.storeData(response.ip, locationData);
        return self.fetchWeather(locationData.latitude, locationData.longitude)
      }).then(function(weather) {
        self.addDensityAltToView(weather);
      }).catch(function(error) {
        console.log(error);
      });
    },
    fetchWeatherFromStoredLocation: function(lat, long) {
      let self = this;

      this.fetchWeather(lat, long).then(function(weather) {
        self.addDensityAltToView(weather);
      }).catch(function(error) {
        console.log(error);
      });
    },
    addPhysicalLocation: function(locationObj) {
      this.physicalLocation = locationObj.city + ', ' + locationObj.regionCode;
    },
    fetchDensityAltitude: function() {
      let ip = $('[name="ip"]').val();
      let storedData = this.checkStore(ip);

      if (storedData) {
        let weather = null;

        storedData = JSON.parse(storedData);
        this.addPhysicalLocation(storedData);
        this.fetchWeatherFromStoredLocation(storedData.latitude, storedData.longitude);
      } else {
        this.fetchWeatherFromNewLocation();
      }
    },
    formatTimeZone: function(date) {
      const regex = /\(.+\)/g;
      let match = date.toString().match(regex)[0];
      var timeZonePars;

      if (match) {
        timeZoneParts = match.replace(/[\(\)]/g, '').split(' ');
        return timeZoneParts.map(function(part) {
          return part[0].toUpperCase();
        }).join('');
      }
    },
    formatTimeString: function(date) {
      let hours = date.getHours();
      let minutes = date.getMinutes();
      let ampm = hours >= 12 ? 'pm' : 'am';

      hours = hours % 12;
      hours = hours ? hours : 12;
      minutes = minutes < 10 ? '0'+ minutes : minutes;
      return hours + ':' + minutes + ampm;
    },
    toLocalTimeDate: function(dateTime) {
      const DAYS = ['Sun', 'Mon', 'Tues', 'Wed', 'Thur', 'Fri', 'Sat'];
      const NEWDATE = new Date(dateTime);
  
      return DAYS[NEWDATE.getDay()] + ' ' + NEWDATE.toLocaleDateString() + ' ' + this.formatTimeString(NEWDATE) + ' ' + this.formatTimeZone(NEWDATE);
    },
    init: function() {
      this.fetchDensityAltitude();
    }
  };

  DensityAltitude.init();
});
