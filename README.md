# AUREA - Aplicação Unificada de Registros de Engenharia e Agronomia

A AUREA é uma solução que visa centralizar e simplificar a gestão de registros profissionais e a emissão de Anotações de Responsabilidade Técnica (ARTs) e Certidões de Acervo Técnico (CATs) para engenheiros, agrônomos e geocientistas no Brasil. Utilizando tecnologias como blockchain e inteligência artificial, a aplicação proporciona um cadastro único 
nacional, eliminando a necessidade de registros regionais adicionais e visto profissional. Além disso, integra os sistemas CREA e  Mútua ao sistema do CONFEA, 
oferecendo uma plataforma unificada para todos os serviços necessários aos profissionais.

## Visão Geral

### Justificativa
A mobilidade profissional é um recurso essencial para os engenheiros, agrônomos e geocientistas que frequentemente precisam trabalhar em diferentes estados do Brasil. 
No entanto, o sistema atual apresenta diversas barreiras:

- Registros Estaduais Separados e Vistos Adicionais: Cada profissional precisa registrar-se separadamente em cada estado onde pretende atuar, além de solicitar vistos adicionais. 
Esse processo é burocrático e demorado, limitando a flexibilidade e a capacidade dos profissionais de se deslocarem e atuarem em diversas regiões.

- Falta de Padronização: Cada CREA (Conselho Regional de Engenharia e Agronomia) possui requisitos e procedimentos diferentes para o registro e emissão de Anotações
de Responsabilidade Técnica (ARTs). Isso dificulta a conformidade dos profissionais e gera ineficiências, pois eles precisam se adaptar a diferentes normas e regulamentos em cada estado.

- Fragmentação dos Dados: Os dados dos profissionais estão dispersos em diferentes sistemas regionais, dificultando a gestão centralizada e a integração das informações. Isso impede a criação
de um perfil único e completo dos profissionais, dificultando a transparência e a eficiência no acompanhamento da carreira e das atividades dos profissionais.

- Processo Demorado: A obtenção de registros e vistos pode ser um processo demorado, atrasando a disponibilidade dos profissionais para assumir projetos e oportunidades em outros estados.
Esses atrasos resultam na perda de oportunidades de trabalho e prejudicam a resposta rápida às demandas do mercado, afetando a produtividade e o crescimento profissional.

- Burocracia Complexa e excessiva: A burocracia envolvida nos processos de registro e visto é complexa e varia de estado para estado, exigindo tempo e esforço consideráveis dos profissionais.
Isso gera frustração e desmotivação, além de consumir tempo que poderia ser dedicado à prática profissional e ao desenvolvimento de novos projetos.

### Principais Funcionalidades
- Emissão de registro profissional único 
- Emissão de ARTs em qualquer estado
- Emissão de CATs com histórico atualizado de ARTs de todo país
- Pagamento distribuído automaticamente para origem e destinos
- Parametrização de critérios conforme resoluções 
- Envio de propostas
- Votações
- Tradução de ARTs legadas com IA
- Pré-preenchimento de ARTs com IA baseado em padrões

### Benefícios
- Agilidade na atualização de informações
- Integração entre CONFEA, CREAs e Mútua
- Eliminação da necessidade de vistos
- Garantia dos pilares da Segurança da Informação
- Proteção contra fraudes
- Facilidade em atualização de regras conforme resoluções por meio de parâmetros
- Agilidade na excecução das regras definidas pelos conselhos através de Smart Contracts
- Redução do tempo de compensação dos pagamentos através da unificação


## Tecnologias Utilizadas

- **Frontend**
  - Yarn
  - Next.js
  - React.js
  - Tailwindcss

- **Backend**
  - Openzeppelin (contratos blockchain)
  - Apollo-server
  - Ethers
  - Graphql
  - NomicFoundation/Hardhat

- **Processamento de Linguagem Natural** (Futuro) 
  - Google Colab e Dialogflow

## Como Rodar o Projeto Localmente

1. Clone o repositório:
    ```bash
   https://github.com/bl4cks1d3/AUREA
    ```
2. Navegue até o diretório do projeto:
    ```bash
    cd AUREA
    ```
3. Instale as dependências do frontend:
    ```bash
    cd frontend
    yarn
    ```
4. Instale as dependências do backend:
    ```bash
    cd backend
    npm install
    npx hardhat compile
    npx hardhat node
    npx hardhat run scripts/deploy.js --network localhost
    ```
5. Inicie o servidor backend:
    ```bash
    node api/api.js(graph)
    ```
6. Inicie o servidor frontend:
    ```bash
    cd ../frontend
    yarn dev
    ```

## Equipe

- **Amanda Almeida** - Negócios & Design (https://www.linkedin.com/in/amanda16almeida/)
- **Bruno Lima** - Engenheiro Civil (https://www.linkedin.com/in/brunoalveslima/)
- **Jaqueline Queroz** - Negócios (https://www.linkedin.com/in/jaquelinequeroz/)
- **Wesley Cardoso** - Full Stack (https://www.linkedin.com/in/bl4cksidesystem/)

## CONFEA OPEN-DAY: 1º Hackathon do Sistema Confea/Crea e Mútua

Este projeto foi construído para o CONFEA OPEN-DAY

## Licença
Este projeto está licenciado sob a Licença MI. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

Esperamos que com a AUREA, possamos simplificar e transformar a gestão profissional na engenharia e agronomia, 
proporcionando um futuro mais eficiente, transparente e acessível para todos os profissionais da área.
