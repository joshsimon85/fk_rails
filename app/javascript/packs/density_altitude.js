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
    getWeather: function(lat, long) {
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
      return window.localStorage.getItem(ip);
    },
    storeData: function(ip, locationData) {
      window.localStorage.setItem(ip, JSON.stringify(locationData));
    },
    addDensityAltToView: function(weather) {
      // check weather.elevation for the point elevation
      this.$el.find('h3 span').text(this.physicalLocation);
      this.$el.find('p:first-of-type').text(weather.density_altitude + "'");
      this.$el.find('p:nth-of-type(2) span').text(weather.time);
      this.$el.show();
    },
    getLocation: function() {
      let ip = $('[name="ip"]').val();
      let self = this;
      //let storedData = this.checkStore(ip);

      // if (storedData) {
      //   let weather = null;
      //
      //   storedData = JSON.parse(storedData);
      //   this.getWeather(storedData.latitude, storedData.longitude).then(function(data) {
      //
      //   });
      // } else {
        const locationPromise = new Promise((resolve, reject) => {
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

        locationPromise.then(function(response) {
          let locationData = new Location(response);
          self.physicalLocation = locationData.city + ', ' + locationData.regionCode;
          self.storeData(response.ip, locationData);

          return self.getWeather(locationData.latitude, locationData.longitude)
        }).then(function(weather) {
          self.addDensityAltToView(weather);
        }).catch(function(error) {
          console.log(error);
        });
        // locationPromise = new Promise((resolve, reject) => {
        //   $.getJSON('https://ipapi.co/json/', function(data) {
        //     resolve(data)
        //
        //   });
        // });
      //}
        // $.getJSON('https://ipapi.co/json/', function(data) {
        //   let locationData = new Location(data);
        //
        //   window.localStorage.setItem(data.ip, JSON.stringify(locationData));
        //
        //   self.getWeather(locationData.latitude, locationData.longitude)
        //       .then(function(weather) {
        //         debugger;
        //         self.$el.find('span.location').text('')
        //       }).catch(function(error) {
        //         console.log(error)
        //       });
        // });
      //}
    },
    init: function() {
      this.getLocation();
    }
  };

  DensityAltitude.init();
});
