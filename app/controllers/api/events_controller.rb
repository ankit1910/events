class Api::EventsController < Api::BaseController
  before_action :set_event, only: [:show, :update, :destroy]

  def index
    render_resource(current_user.events)
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      render_resource(@event)
    else
      render_error(@event.errors)
    end
  end

  def show
    render_resource(@event)
  end

  def update
    if @event.update(event_params)
      render_resource(@event)
    else
      render_error(@event.errors)
    end
  end

  def destroy
    if @event.destroy
      render_success(t('api.destroy', entity: 'Event'))
    else
      render_error(@event.errors)
    end
  end

  private
    def set_event
      @event = current_user.events.find_by(id: params[:id])
      render_resource_not_found('Event') unless @event
    end

    def event_params
      params.require(:event).permit(:start_time, :end_time)
    end
end
