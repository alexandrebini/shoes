if defined?(ExceptionNotification)
  Shoes::Application.config.middleware.use ExceptionNotification::Rack,
    email: {
      email_prefix: '[shoes] ',
      sender_address: %{"contato" <contato@buscasapato.com.br>},
      exception_recipients: %w{alexandrebini@gmail.com saulodasilvasantiago@gmail.com}
    }
end