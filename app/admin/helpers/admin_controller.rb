module AdminController
  def self.register(model, &block)
    ActiveAdmin.register(model) do
      extend AdminController::Helpers

      actions :all, :except => :destroy

      @model = model

      update_form(model.permitted_params)

      index do
        id_column
        model.index_columns(current_user).each { |c| column(c) }
      end

      show do |resource|
        attributes_table do
          model.reflections.each do |k, ref|
            row(k.to_sym) unless ref.macro == :has_many
          end
          model.columns_hash.each do |k, adapter|
            next if k =~ /^id$|_(password|token|id)$/
            if  k == 'roles_mask'
              row(:roles) { resource.roles.to_a }
            else
              col = k.gsub(/_(cents)$/, '').to_sym
              col = :"#{col}_text" if resource.respond_to?("#{col}_text")
              row(col)
            end
          end
          tabs do
            model.reflections.each do |k, ref|
              next unless ref.macro == :has_many
              next if k == 'versions'
              tab(model.human_attribute_name(k)) do
                table_for(resource.public_send(k)) do
                  column(ref.klass.model_name.human) { |a| link_to(a, [:admin, a]) }
                  ref.klass.index_columns(current_user).each { |c| column(c) }
                end
              end
            end
          end
        end
      end

      instance_exec(&block) if block_given?

      # controller do
      #   def new
      #     super
      #     binding.pry
      #   end

      #   # def end_of_association_chain
      #   #   return super unless %w(show index).include?(request.params[:action])
      #   #   included = [:portfolio,
      #   #               payment_plans: :contract,
      #   #               proposal: { company: { requirer: { person: :user } } },
      #   #               student_proposal: { requirer: { person: :user } }]
      #   #   super.includes(included)
      #   # end
      # end
    end
  end

  module Helpers
    def resource_action(action, title:, args: nil, link_data: nil)
      args ||= @model.action_params[action].presence
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
