module ApiRendererHelper
  def render_unauthorized
    render(json: { message: t('api.unauthorized') }, status: :unauthorized)
  end

  def render_success(message)
    render(json: { message: message }, status: :ok)
  end

  def render_error(errors)
    render(json: { errors: errors }, status: :unprocessable_entity)
  end

  def render_resource_not_found(entity)
    render(json: { message: t('api.not_found', entity: entity) }, status: :not_found)
  end

  def render_resource(resource)
    render json: resource
  end
end
