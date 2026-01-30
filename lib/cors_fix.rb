# lib/cors_fix.rb
class CorsFix
  def initialize(app)
    @app = app
  end

  def call(env)
    # Handle OPTIONS requests first
    if env['REQUEST_METHOD'] == 'OPTIONS'
      return [200, {
        'Access-Control-Allow-Origin' => 'https://jira-clone-frontend-self.vercel.app',
        'Access-Control-Allow-Methods' => 'GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD',
        'Access-Control-Allow-Headers' => 'Content-Type, Authorization, Accept, X-Requested-With',
        'Access-Control-Allow-Credentials' => 'true',
        'Access-Control-Max-Age' => '600'
      }, []]
    end

    # Pass through all other requests
    status, headers, response = @app.call(env)
    
    # Add CORS headers to all responses
    headers['Access-Control-Allow-Origin'] = 'https://jira-clone-frontend-self.vercel.app'
    headers['Access-Control-Allow-Credentials'] = 'true'
    
    [status, headers, response]
  end
end