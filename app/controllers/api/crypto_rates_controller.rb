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

  def global_volume
    cache_key = "global_transaction_volume"
    
    response_data = Rails.cache.fetch(cache_key, expires_in: 1.minute) do
      # Fetch all transaction history data records from the database
      all_transactions = Transaction.all

      # ✅ FIXED: Use Ruby's built-in grouping instead of relying on database SQL functions.
      # This groups your items by the exact calendar day perfectly on both SQLite and PostgreSQL.
      grouped_by_day = all_transactions.group_by { |t| t.created_at.to_date }

      # Map the collection into Highcharts friendly [timestamp_ms, total_usd] arrays
      grouped_by_day.map do |date, transactions|
        timestamp_ms = date.to_time.to_i * 1000
        total_usd = transactions.sum(&:total_amount).to_f.round(2)
        
        [timestamp_ms, total_usd]
      end.sort # Keeps your timeline chart chronologically ordered from left to right
    end

    render json: response_data
  end



end
