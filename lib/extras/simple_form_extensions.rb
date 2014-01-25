module WrappedButton
  def wrapped_button(*args, &block)
    template.content_tag :div, class: 'form-actions' do
      options = args.extract_options!
      loading = self.object.new_record? ? I18n.t('simple_form.creating') : I18n.t('simple_form.updating')
      options[:"data-loading-text"] = [loading, options[:"data-loading-text"]].compact
      options[:class] = ['btn btn-primary', options[:class]].compact
      args << options

      destroy_button = if self.object.persisted?
        template.link_to I18n.t('.destroy', default: I18n.t('helpers.links.destroy')), self.options[:url], method: :delete, data: { confirm: I18n.t('.confirm', default: I18n.t('helpers.links.confirm')) }, class: 'btn btn-danger'
      end
      cancel_button = if options[:cancel]
        template.link_to I18n.t('helpers.links.cancel'), options.delete(:cancel), class: 'btn'
      end

      submit(*args, &block) + ' ' + destroy_button + ' ' + cancel_button
    end
  end
end
SimpleForm::FormBuilder.send :include, WrappedButton