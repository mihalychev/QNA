class Api::V1::ProfilesController < Api::V1::BaseController
  def index
    render json: { profiles: User.select { |user| user != current_resource_owner } } 
  end
  
  def me
    render json: current_resource_owner
  end
end