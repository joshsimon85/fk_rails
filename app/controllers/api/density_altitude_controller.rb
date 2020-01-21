require 'dark_skies_api/client.rb'
require 'elevation_api/client.rb'

class Api::DensityAltitudeController < ApplicationController
  def create
    da_args = get_density_alt_params(params[:lat], params[:long])
    da = calculate_density_alt(da_args)
    corrected_da =  da < da_args[:elevation] ? da_args[:elevation].round : da

    respond_to do |format|
      format.json { render :json =>
        {
          density_altitude: corrected_da,
          elevation: da_args[:elevation].round,
          time: format_time(da_args[:time])
        }
      }
    end
  end

  private

  def fetch_weather(lat, long)
    client = DarkSkiesApi::Client.new(params[:lat], params[:long])
    client.fetch_weather
  end

  def fetch_elevation(lat, long)
    client = ElevationApi::Client.new(params[:lat], params[:long])
    client.fetch_elevation
  end

  def get_density_alt_params(lat, long)
    result = {}
    
    result[:elevation] = fetch_elevation(lat, long) * 3.281
    weather = fetch_weather(lat, long)
    result[:pressure] = weather['currently']['pressure']
    result[:temprature] = weather['currently']['temperature']
    result[:time] = Time.at(weather['currently']['time'])
    result
  end

  def calculate_density_alt(params)
    pa = (29.92 - (params[:pressure] * 0.029530)) * 1000 + params[:elevation]
    oat = (((params[:temprature] - 32) * 5) / 9).round
    isa = ((params[:elevation] / 1000) * -2) + 15
    (((oat - isa) * 120) + pa).round
  end

  def format_time(datetime)
    datetime.strftime('%a %m/%d/%Y%l:%M%P %Z')
  end
end
