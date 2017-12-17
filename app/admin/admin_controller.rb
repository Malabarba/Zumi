# class ActiveAdmin::ResourceController
# end

module AdminController
  def resource_action(action, title:, args: nil, link_data: nil)
    link_method = args ? :get : :patch
    action_item action, only: [:show] do
      link_to title,
              public_send("#{action}_admin_#{resource.param_key}_path", resource, redirect_uri: request.path),
              { resource: resource, action: action },
              { method: link_method, data: link_data }
      # if authorized?(:publish, resource)
      # end
    end

    member_action action, method: [:patch, link_method].uniq do
      if request.patch?
        msg = ["#{action}!"]
        if args
          key = resource.param_key
          msg << params.require(key).permit(*args).to_h.symbolize_keys
        end
        if resource.public_send(*msg)
          redirect_to_resource
        else
          flash[:notice] = 'Erro'
          render action
        end
      elsif request.get?
        render 'admin/action', locals: { permitted_params: args }
      end
    end
  end

  def redirect_to_resource(*opts)
    target = params[:redirect_uri]
    target ||= if params[:id] && resource.present?
                 [:admin, resource]
               elsif params[:controller].present?
                 "/#{params[:controller]}"
               else
                 [:admin]
               end
    redirect_to(target, *opts)
  end

  def check_model_errors(object)
    return unless object.errors.any?
    flash[:error] ||= []
    flash[:error].concat(object.errors.full_messages)
  end

  def send_pdf(string, filename)
    send_data string,
              filename: filename,
              status: 200,
              disposition: :inline,
              type: 'application/pdf'
  end

  def current_user
    current_admin_user
  end
end
