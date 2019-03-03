# frozen_string_literal: true

module AdminViewsHelper
  def tab_title(string)
    string.dup.tap do |s|
      s.instance_eval do
        x = rand
        define_singleton_method :parameterize do
          "#{self}.#{x}".parameterize
        end
      end
    end
  end

  def unique_anchor_tab(title, &block)
    tab tab_title(title), &block
  end

  def file_url(object, attribute)
    if object.is_a?(Document) && object.ofx?
      admin_document_path(object)
    else
      object.public_send(attribute).url
    end
  end

  ONE_WEEK = 60 * 60 * 24 * 7

  def display_or_link_attachment(object, attribute, *_label_attributes)
    return if object.public_send(attribute).blank?

    content_type = object.public_send("#{attribute}_content_type")
    file_name = object.public_send("#{attribute}_file_name")
    url = object.public_send(attribute).expiring_url(ONE_WEEK)

    if content_type&.match(%r{^image/})
      div(class: 'document-file') do
        div(class: 'document-image') do
          link_to_new_tab(url) do
            div(file_name) +
              img(src: url, style: 'max-width: 600px')
          end
        end
      end
    else
      link_to(file_name, url)
    end
  end

  def with_icon(text, icon)
    content_tag :span do
      fa_icon(icon) + ' ' + text
    end
  end

  def humanized_rate(rate, precision = 4)
    number_to_percentage(rate.to_f * 100, precision: precision, separator: ',', delimiter: '.') if rate.present?
  end

  def datefmt(date_or_time, format)
    date_or_time.beginning_of_day.strftime format
  end

  def link_to_new_tab(name, url = nil, &block)
    # This works pretty much everywhere except Opera, and nobody in
    # the company uses Opera.
    if block_given?
      url = name
      a(href: url, onclick: "js:window.open(\"#{url}\").opener = null; return false", &block)
    else
      url ||= name
      a(name, href: url, onclick: "js:window.open(\"#{url}\").opener = null; return false")
    end
  end

  def translated_yes_or_no(bool)
    return if bool.blank?

    bool == 'yes' ? 'Sim' : 'Não'
  end
end
