class Api::CryptoRatesController < ApplicationController
  include HTTParty
  BASE_URL = 'https://api.coingecko.com/api/v3'

  # New action to securely fetch spot prices for individual coins
  def spot_prices
    # Ensure the coin ID parameter is lowercase (e.g., 'bitcoin')
    coin_id = params[:coin_id].to_s.downcase
    api_key = ENV['COINGECKO_API_KEY']; # Replace with your real key string safely

    # Cache individual spot prices for 2 minutes to optimize button clicks
    cache_key = "spot_price_#{coin_id}"
    
    response_data = Rails.cache.fetch(cache_key, expires_in: 2.minutes) do
      url = "#{BASE_URL}/simple/price?ids=#{coin_id}&vs_currencies=usd"
      response = HTTParty.get(url, headers: { 'x-cg-demo-api-key' => api_key })

      if response.success?
        response.parsed_response
      else
        { error: "CoinGecko fetch failed for #{coin_id}" }
      end
    end

    render json: response_data
  end

  def historical_month
    coins = { bitcoin: 'bitcoin', ethereum: 'ethereum', litecoin: 'litecoin' }
    api_key = "CG-Fake Key"
    requested_days = params[:days].present? ? params[:days] : "30"
    cache_key = "crypto_prices_#{requested_days}"

    response_data = Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
      data_accumulator = {}

      coins.each do |key, coin_id|
        url = "#{BASE_URL}/coins/#{coin_id}/market_chart?vs_currency=usd&days=#{requested_days}"      
        response = HTTParty.get(url, headers: { 'x-cg-demo-api-key' => api_key })

        if response.success? && response['prices'].present?
          data_accumulator[key] = response['prices']
        else
          data_accumulator[key] = []
        end
        sleep(0.5)
      end
      data_accumulator 
    end 
    render json: response_data
  end
end
