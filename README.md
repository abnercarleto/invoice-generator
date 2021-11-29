# Invoice Generator
Teste de um gerador de Invoice

## Como executar
Instalar docker e docker-compose
[Instruções para instalar docker](https://docs.docker.com/engine/install/)
[Instruções para instalar docker-compose](https://docs.docker.com/compose/install/)

### Executar API
Executar os comandos abaixo
```bash
$ cd api
$ docker-compose build
$ docker-compose run --rm --service-ports api
```

Para os testes executar o comando abaixo
```bash
$ docker-compose run --rm api rspec
```

### Executar Web
Executar os comandos abaixo
```bash
$ cd web
$ docker-compose build
$ docker-compose run --rm --service-ports web
```
Acessar o endereço [http://localhost:4200/](http://localhost:4200/)

## SMTP e acesso ao email
Foi utilizado o MailCatcher como servidor de SMTP e facilitar o acesso aos emails enviados.

Para visualizar os emails acessar o endereço [http://localhost:1080/](http://localhost:1080/)

## API

Criação do token
```
POST   /api/v1/auth/token

Request
email - Email para o envio do token
  type: String, required: true
permit_regenerate - Permite gerar novo token caso já tenha um token gerado
  type: Boolean, default: false, required: false

Response
sent_to - Email que o token foi enviado
  type: String
```

Validção do token
```
GET    /api/v1/auth/validate

Request
token - Token para validação
  type: String, required: true

Response
validated - Informa se o token foi validado
  type: Boolean
```

Remoção do token
```
DELETE /api/v1/auth/toke

Request Header
x-auth-token - Token validado
  type: String, required: true
```

Criação e envio da invoice
```
POST   /api/v1/invoices

Request Header
x-auth-token - Token validado
  type: String, required: true

Request
send_to - lista de emails que será enviado a invoice
  type: String[], required: true
invoice: {
  number - numero da invoice
    type: Integer, required: false

  date - data da invoice
    type: Date, required: true

  company_data - Dados da empresa que está emitindo a invoice
    type: String, required: true

  billing_for - Dados de quem está sendo cobrando a invoice
    type: String, required: true

  total_value_cents - Valor da invoice em centavos
    type: Integer, required: true
}

Response
emails - lista de emails que foi enviado a invoice
  type: String[]

invoice: {
  id - identificador
    type: Integer

  number - numero da invoice
    type: Integer

  date - data da invoice
    type: Date

  company_data - Dados da empresa que está emitindo a invoice
    type: String

  billing_for - Dados de quem está sendo cobrando a invoice
    type: String

  total_value_cents - Valor da invoice em centavos
    type: Integer

  created_at - data e hora de criação
    type: Time

  updated_at - data e hora de atualização
    type: Time
}
```

## Como foi feito

Foi utilizado as gems Rails, u-case (para as regras de negócio) e prawn (para geração de pdf), e para os testes foi utilizado as gems rspec, shoulda-matchers, factory_bot e pdf-inspector (para os testes de geração de pdf).

Para as regras de negocios foi utilizado o pattern use case, com a gem u-case, o principio da responsabilidade única, e também o princicio Open-Closed para a exportação da invoice.

Foi criado 2 modulos para separar os codigos Identity para a parte de identidade dos usuários, e Financial para a parte financeira.

Foi priorizado o desenvolvimento das features de login (criação do token, validação do token e remoção do token) e Criação e envio da invoice por ser as features com mais regras de negocio e as outras features seriam somente consultas e exibição dos dados.

Foi escolhido o uso do docker para simplificar a criação do ambiente de desenvolvimento e execução do código.

## O que poderia ser melhordo

Poderia ter sido utilizado o pattern repository para acesso ao banco de dados, onde teria uma melhor abstração da camada de persistencia e uso da inversão de controle para separar as camada de negocio da cama de persistencia.

Poderia ter separado os modulos em componentes de forma que cada modulo tivesse as suas proprias dependencias e os modulos só tivessem conhecimento dos modulos que fossem necessários.