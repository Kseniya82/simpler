class TestsController < Simpler::Controller
  def index
    @time = Time.now
    headers['Content-Type'] = 'text/plain'
    render plain: "Plain text response"
  end

  def create
    status 201
  end

  def show
    @id = params[:id]
  end
end
