
Rails.application.configure do
  config.after_initialize do
    begin
      # Testar conexão com ClickHouse
      require "net/http"
      require "uri"

      clickhouse_host = ENV["CLICKHOUSE_HOST"] || "clickhouse"
      clickhouse_port = ENV["CLICKHOUSE_PORT"] || "8123"

      30.times do
        begin
          uri = URI("http://#{clickhouse_host}:#{clickhouse_port}/ping")
          response = Net::HTTP.get_response(uri)
          if response.code == "200"
            Rails.logger.info "Connected - #{clickhouse_host}:#{clickhouse_port}"
            break
          end
        rescue => e
          Rails.logger.info "Waiting - (#{e.message})"
          sleep 1
        end
      end
    rescue => e
      Rails.logger.warn "CH unavailable: #{e.message}"
    end
  end
end
