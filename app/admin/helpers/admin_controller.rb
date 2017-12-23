module AdminController
  def self.register(model, &block)
    ActiveAdmin.register(model) do
      extend AdminController::Helpers

      update_form(model.permitted_params)

      index do
        id_column
        model.index_columns(current_user).each { |c| column(c) }
      end

      show do |r|
        attributes_table do
          model.columns_hash.each do |k, adapter|
            next if k =~ /^id$|_(password|token)$/
            col = k.gsub(/_(cents|id)$/, '').to_sym
            col = :"#{col}_text" if r.respond_to?("#{col}_text")
            row(col)
          end
        end
      end

      instance_exec(&block) if block_given?
    end
  end

  module Helpers
    def resource_action(action, title:, args: nil, link_data: nil)
      link_method = args ? :get : :patch
      action_item action, only: [:show] do
        if resource.may?(action)
          link_to title,
                  public_send("#{action}_admin_#{resource.param_key}_path", resource, redirect_uri: request.path),
                  { method: link_method, data: link_data }
        end
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
            flash[:alert] = resource.errors.full_messages.to_sentence
            if args
              render 'admin/action', locals: { permitted_params: args }
            else
              redirect_to_resource
            end
          end
        elsif request.get?
          render 'admin/action', locals: { permitted_params: args }
        end
      end
    end

    def update_form(params)
      permit_params(*params)

      form do |f|
        f.semantic_errors(*f.object.errors.keys)
        f.inputs { AdminForm.make_inputs(f, params) }
        f.actions
      end
    end
  end
end

class ActiveAdmin::ResourceController
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
end
