# Arquitetura 

## 1. Contrato AUREA

- **Função Principal**: Servir como um contrato de alto nível que delega operações para outros contratos e oráculos.
- **Responsabilidades**:
  - **Delegar Operações**: Encaminhar solicitações para contratos especializados (CONFEA, CREA, RNP, etc.).
  - **Gerenciar Pagamentos**: Processar pagamentos e interagir com o contrato de pagamento.
  - **Coordenar Funções**: Facilitar a comunicação entre contratos e garantir a integridade dos dados.
  - **Gerenciar Níveis de Permissão**: Controlar o acesso aos diversos módulos e informações.
- **Funções**:
  - `delegarParaCONFEA()`: Encaminha propostas e governança para o contrato CONFEA.
  - `delegarParaCREA()`: Encaminha registros e atualizações para o contrato CREA.
  - `delegarParaRNP()`: Encaminha solicitações de dados pessoais para o contrato RNP.
  - `delegarParaMUTUA()`: Encaminha interações relacionadas à MUTUA.
  - `processarPagamento(uint256 valor, address destinatario)`: Processa pagamentos para serviços diversos.
  - `consultarOraculo(string consulta)`: Obtém dados externos validação de pagamentos.
  - `setNivelPermissao(address usuario, uint8 nivel)`: Define o nível de permissão de um usuário para acessar funções e dados.
  - **Funções Auxiliares**:
    - `verificarPermissao(address usuario)`: Verifica o nível de permissão de um usuário.
    - `logOperacao(string descricao)`: Registra uma operação realizada pelo contrato.
    - `emitirEvento(string evento, address usuario)`: Emite um evento para rastrear ações importantes.

## 2. Contrato CONFEA

- **Função Principal**: Gerenciar a governança e propostas dentro do sistema.
- **Responsabilidades**:
  - **Criar e Gerenciar Propostas**: Adicionar novas propostas e gerenciar o ciclo de vida delas.
  - **Armazenar Informações de Voto**: Guardar e consultar votos relacionados às propostas.
  - **Controlar Acesso a Propostas**: Gerenciar quem pode criar, visualizar ou votar em propostas.
- **Funções**:
  - `criarProposta(string descricao, address[] participantes)`: Adiciona uma nova proposta para discussão e votação.
  - `votar(uint256 propostaId, bool voto)`: Permite a votação em uma proposta específica.
  - `consultarPropostas()`: Consulta todas as propostas existentes e seus estados.
  - `consultarVotos(uint256 propostaId)`: Obtém o resultado da votação para uma proposta específica.
  - `setNivelAcessoProposta(uint256 propostaId, address usuario, uint8 nivel)`: Define níveis de acesso de usuários às propostas.
  - **Funções Auxiliares**:
    - `validarProposta(uint256 propostaId)`: Verifica se a proposta está válida para votação.
    - `verificarVoto(address usuario)`: Verifica se um usuário já votou em uma proposta.
    - `emitirEventoProposta(string evento, uint256 propostaId)`: Emite um evento para rastrear ações relacionadas a propostas.

## 3. Contrato CREA

- **Função Principal**: Gerenciar registros de profissionais e suas atualizações.
- **Responsabilidades**:
  - **Registrar Profissionais**: Adicionar novos registros de profissionais no sistema.
  - **Atualizar Registros**: Alterar informações existentes de profissionais.
  - **Gerenciar Registros Temporários e Permanentes**: Controlar status e validade dos registros.
  - **Controlar Acesso ao Registro**: Definir quem pode acessar ou modificar registros.
- **Funções**:
  - `registrarProfissional(address profissional, string nome, string[] documentos)`: Registra um novo profissional com detalhes básicos.
  - `atualizarRegistro(address profissional, string campo, string valor)`: Atualiza um campo específico no registro de um profissional.
  - `consultarRegistro(address profissional)`: Obtém informações detalhadas sobre um profissional.
  - `gerenciarRegistroTemporario(address profissional, bool status)`: Atualiza o status de registros temporários.
  - `setNivelAcessoRegistro(address profissional, address usuario, uint8 nivel)`: Define o nível de acesso para um usuário ao registro de um profissional.
  - **Funções Auxiliares**:
    - `validarRegistro(address profissional)`: Verifica se o registro do profissional está válido.
    - `verificarStatusRegistro(address profissional)`: Obtém o status atual do registro do profissional.
    - `emitirEventoRegistro(string evento, address profissional)`: Emite um evento para rastrear ações relacionadas a registros.

## 4. Contrato RNP (Registro Nacional de Profissional)

- **Função Principal**: Gerenciar informações detalhadas sobre o registro nacional dos profissionais.
- **Responsabilidades**:
  - **Armazenar Dados Pessoais**: Guardar e atualizar informações pessoais dos profissionais.
  - **Gerenciar Documentos e Histórico**: Manter registros de documentos e alterações.
  - **Controlar Acesso às Informações**: Definir quem pode acessar ou alterar as informações detalhadas.
- **Funções**:
  - `adicionarInformacoesPessoais(address profissional, string dscNac, string dscNat, string dtaExpIdt, string dtaNsc, string estCiv, string nme, string nroIdt, string orgExpIdt, string pisNac, string sisIdtPrfNroCpf, string tpoEndCor, string tpoFrh, string tpoNecEsp, string tpoNroImpCrt, string tpoReg, string tpoRnp, string tpoSex, string tpoSng, string ufNat)`: Adiciona ou atualiza informações pessoais detalhadas do profissional.
  - `consultarInformacoesPessoais(address profissional)`: Obtém as informações pessoais detalhadas do profissional.
  - `adicionarEndereco(address profissional, string tipo, string endereco)`: Adiciona um endereço ao registro do profissional.
  - `adicionarTitulo(address profissional, string titulo, string data)`: Adiciona um título ou certificação ao profissional.
  - `setNivelAcessoInformacoesPessoais(address profissional, address usuario, uint8 nivel)`: Define o nível de acesso de um usuário às informações pessoais.
  - **Funções Auxiliares**:
    - `validarInformacoesPessoais(address profissional)`: Verifica a validade das informações pessoais do profissional.
    - `verificarHistorico(address profissional)`: Obtém o histórico de alterações do registro.
    - `emitirEventoInformacoesPessoais(string evento, address profissional)`: Emite um evento para rastrear ações relacionadas a informações pessoais.

## 5. Contrato Anuidade

- **Função Principal**: Gerenciar as anuidades pagas pelos profissionais.
- **Responsabilidades**:
  - **Adicionar e Consultar Anuidades**: Manter registros das anuidades e suas informações.
  - **Gerenciar Pagamentos de Anuidade**: Controlar o status de pagamentos.
- **Funções**:
  - `adicionarAnuidade(address profissional, uint256 valor, uint256 dataPagamento)`: Registra o pagamento de uma anuidade.
  - `consultarAnuidades(address profissional)`: Consulta a lista de anuidades associadas a um profissional.
  - `verificarStatusAnuidade(address profissional)`: Verifica se a anuidade está paga ou pendente.
  - `setNivelAcessoAnuidade(address profissional, address usuario, uint8 nivel)`: Define o nível de acesso às informações de anuidade.
  - **Funções Auxiliares**:
    - `validarPagamentoAnuidade(address profissional)`: Verifica a validade do pagamento da anuidade.
    - `consultarHistoricoAnuidade(address profissional)`: Obtém o histórico de pagamentos de anuidade.
    - `emitirEventoAnuidade(string evento, address profissional)`: Emite um evento para rastrear ações relacionadas a anuidades.

## 6. Contrato Titulo

- **Função Principal**: Gerenciar títulos e certificações dos profissionais.
- **Responsabilidades**:
  - **Adicionar e Consultar Títulos**: Manter registros de títulos e certificações.
  - **Remover Títulos**: Gerenciar a exclusão de títulos.
- **Funções**:
  - `adicionarTitulo(address profissional, string titulo, string descricao, uint256 dataEmissao)`: Adiciona um título ou certificação ao profissional.
  - `consultarTitulos(address profissional)`: Obtém a lista de títulos e certificações do profissional.
  - `removerTitulo(address profissional, string titulo)`: Remove um título ou certificação do registro do profissional.
  - `setNivelAcessoTitulo(address profissional, address usuario, uint8 nivel)`: Define o nível de acesso a títulos e certificações.
  - **Funções Auxiliares**:
    - `validarTitulo(address profissional, string titulo)`: Verifica a validade de um título específico.
    - `consultarHistoricoTitulos(address profissional)`: Obtém o histórico de títulos e certificações.
    - `emitirEventoTitulo(string evento, address profissional)`: Emite um evento para rastrear ações relacionadas a títulos.

## 7. Contrato Pagamento

- **Função Principal**: Gerenciar pagamentos e transações financeiras.
- **Responsabilidades**:
  - **Processar Pagamentos**: Realizar transações para serviços diversos.
  - **Consultar Informações sobre Transações**: Obter detalhes sobre pagamentos realizados.
- **Funções**:
  - `processarPagamento(address destinatario, uint256 valor)`: Realiza um pagamento para um destinatário específico.
  - `consultarTransacoes(address profissional)`: Obtém um histórico das transações realizadas pelo profissional.
  - `setNivelAcessoPagamento(address usuario, uint8 nivel)`: Define o nível de acesso a informações de pagamentos.
  - **Funções Auxiliares**:
    - `validarTransacao(address destinatario, uint256 valor)`: Verifica a validade de uma transação.
    - `consultarHistoricoPagamentos(address profissional)`: Obtém o histórico completo de pagamentos realizados.
    - `emitirEventoPagamento(string evento, address destinatario)`: Emite um evento para rastrear ações relacionadas a pagamentos.

## 8. Contrato ART

- **Função Principal**: Gerenciar Anotações de Responsabilidade Técnica (ARTs).
- **Responsabilidades**:
  - **Adicionar e Consultar ARTs**: Manter registros de ARTs associadas a profissionais.
  - **Controlar Acesso às ARTs**: Definir quem pode visualizar ou modificar ARTs.
- **Funções**:
  - `adicionarART(address profissional, string descricao, uint256 data)`: Adiciona uma nova ART ao registro do profissional.
  - `consultarART(address profissional)`: Obtém a lista de ARTs associadas ao profissional.
  - `setNivelAcessoART(address profissional, address usuario, uint8 nivel)`: Define o nível de acesso às ARTs.
  - **Funções Auxiliares**:
    - `validarART(address profissional, string descricao)`: Verifica a validade de uma ART específica.
    - `consultarHistoricoART(address profissional)`: Obtém o histórico de ARTs.
    - `emitirEventoART(string evento, address profissional)`: Emite um evento para rastrear ações relacionadas a ARTs.

## 9. Contrato CAT

- **Função Principal**: Gerenciar Comunicações de Acidente de Trabalho (CATs).
- **Responsabilidades**:
  - **Adicionar e Consultar CATs**: Manter registros de CATs associadas a profissionais.
  - **Controlar Acesso às CATs**: Definir quem pode visualizar ou modificar CATs.
- **Funções**:
  - `adicionarCAT(address profissional, string descricao, uint256 data)`: Adiciona uma nova CAT ao registro do profissional.
  - `consultarCAT(address profissional)`: Obtém a lista de CATs associadas ao profissional.
  - `setNivelAcessoCAT(address profissional, address usuario, uint8 nivel)`: Define o nível de acesso às CATs.
  - **Funções Auxiliares**:
    - `validarCAT(address profissional, string descricao)`: Verifica a validade de uma CAT específica.
    - `consultarHistoricoCAT(address profissional)`: Obtém o histórico de CATs.
    - `emitirEventoCAT(string evento, address profissional)`: Emite um evento para rastrear ações relacionadas a CATs.

## 10. Contrato Oráculo de Pagamento

- **Função Principal**: Fornecer informações externas necessárias para realizar pagamentos.
- **Responsabilidades**:
  - **Consultar Dados Externos**: Fornecer dados como taxas de câmbio e preços de serviços.
  - **Definir Nível de Acesso**: Controlar quem pode acessar as informações fornecidas pelo oráculo.
- **Funções**:
  - `consultarTaxaCambio(string moeda)`: Obtém a taxa de câmbio para uma moeda específica.
  - `consultarPrecoServico(string servico)`: Obtém o preço atual de um serviço específico.
  - `fornecerDados(string consulta)`: Fornece dados externos com base em uma consulta específica.
  - `setNivelAcessoOraculo(address usuario, uint8 nivel)`: Define o nível de acesso de um usuário às informações fornecidas pelo oráculo.
  - **Funções Auxiliares**:
    - `validarConsulta(string consulta)`: Verifica a validade da consulta feita ao oráculo.
    - `consultarHistoricoDados(string consulta)`: Obtém o histórico de dados fornecidos pelo oráculo.
    - `emitirEventoOraculo(string evento, address usuario)`: Emite um evento para rastrear ações relacionadas aos dados do oráculo.

## 11. Contrato MUTUA

- **Função Principal**: Gerenciar interações com a MUTUA, que pode incluir aspectos como seguros, assistências e benefícios.
- **Responsabilidades**:
  - **Gerenciar Benefícios**: Registrar e atualizar informações sobre benefícios concedidos pela MUTUA.
  - **Processar Seguros**: Controlar informações e pagamentos relacionados a seguros oferecidos.
  - **Controlar Acesso a Benefícios**: Definir quem pode acessar ou alterar informações sobre benefícios e seguros.
- **Funções**:
  - `adicionarBeneficio(address profissional, string descricao, uint256 valor, uint256 data)`: Adiciona um benefício ao registro de um profissional.
  - `consultarBeneficios(address profissional)`: Obtém a lista de benefícios disponíveis para um profissional.
  - `processarSeguro(address profissional, uint256 valor, uint256 data)`: Registra o processamento de um seguro.
  - `consultarSeguros(address profissional)`: Obtém informações sobre seguros contratados.
  - `setNivelAcessoBeneficio(address profissional, address usuario, uint8 nivel)`: Define o nível de acesso às informações sobre benefícios e seguros.
  - **Funções Auxiliares**:
    - `validarBeneficio(address profissional, string descricao)`: Verifica a validade de um benefício específico.
    - `verificarStatusSeguro(address profissional)`: Verifica o status atual dos seguros contratados.
    - `emitirEventoBeneficio(string evento, address profissional)`: Emite um evento para rastrear ações relacionadas a benefícios e seguros.

