module Rescuable
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::UnknownFormat, with: :unknown_format
    rescue_from Rescuable::AccessDenied, with: :forbidden
    rescue_from Rescuable::Unauthorized, with: :unauthorized
    rescue_from ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved, with: :bad_record
    rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_key
    # rescue_from Paginatable::InvalidSortOrder, with: :invalid_sort
    rescue_from Rescuable::AlreadyLoggedIn, with: :already_logged_in

    protected

    def unknown_format
      render json: { message: 'Unknown format' }, status: 406
    end

    def not_found
      render json: { message: 'Not found' }, status: 404
    end

    def forbidden
      render json: { message: 'Forbidden' }, status: 403
    end

    def unauthorized
      render json: { message: 'Unauthorized' }, status: 401
    end

    # def invalid_sort
    #   render json: { message: 'Invalid sort_order or order_by' }, status: 400
    # end

    def invalid_key
      render json: { message: { error_messages: ['One of the ids provided is not valid'] } }, status: 400
    end

    def bad_record
      render json: { message: { error_messages: resource_instance.errors.messages.to_json } }, status: 400
    end

    def unprocessable_entity
      render json: { message: 'Unprocessable Entity' }, status: 422
    end

    def already_logged_in
      render json: { message: 'Usuário já está logado' }, status: 403
    end

    private

    def resource_instance
      name = params[:controller].split('/').last.singularize
      instance_variable_get("@#{name}")
    end
  end

  class AlreadyLoggedIn < StandardError;  end
  class AccessDenied < StandardError;  end
  class Unauthorized < StandardError;  end
end
