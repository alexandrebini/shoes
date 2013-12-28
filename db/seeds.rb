# Stores create

melissa = Store.new(
  name: 'Melissa',
  url: 'http://lojamelissa.com.br',
  start_url: 'http://lojamelissa.com.br',
  verification_matcher: 'UA-1507369-1',
  logo: 'http://lojamelissa.com.br/skin/frontend/default/melissa/images/logo.png'
)
p "Melissa created? #{ melissa.save }"

corello = Store.new(
  name: 'Corello',
  url: 'http://shop.corello.com.br',
  start_url: 'http://shop.corello.com.br',
  verification_matcher: 'UA-26309255-1',
  logo: 'http://shop.corello.com.br/locales/global/img/logo.png'
)
p "Corello created? #{ corello.save }"

carmensteffens = Store.new(
  name: 'Carmen Steffens',
  url: 'http://www.carmensteffens.com.br/',
  start_url: 'http://www.carmensteffens.com.br/',
  verification_matcher: 'UA-25208798-1',
  logo: 'http://www.carmensteffens.com.br/estilo/images/003/header-logo.jpg'
)
p "Carmen Steffens created? #{ carmensteffens.save }"