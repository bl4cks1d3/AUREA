// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

interface ICONFEA {
    function processarProposta(string calldata proposta) external;
}

interface ICREA {
    function registrarAtualizacao(string calldata registro) external;
}

interface IRNP {
    function atualizarDadosPessoais(string calldata dados) external;
}

interface IMUTUA {
    function registrarInteracao(string calldata interacao) external;
}

interface IPagamento {
    function realizarPagamento(uint256 valor, address destinatario) external;
}


contract AUREA is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    // Mapeamentos para armazenar permissões de usuários e contratos especializados
    mapping(address => uint8) private permissao;
    address private contratoCONFEA;
    address private contratoCREA;
    address private contratoRNP;
    address private contratoMUTUA;
    address private contratoPagamento;
    
    // Set para rastrear eventos de usuários
    EnumerableSet.AddressSet private usuarios;
    constructor() Ownable(msg.sender) {}

    // Eventos
    event OperacaoLog(string descricao, address usuario);
    event Evento(string evento, address usuario);

    // Função para definir o contrato CONFEA
    function setContratoCONFEA(address _contrato) external onlyOwner {
        contratoCONFEA = _contrato;
    }

    // Função para definir o contrato CREA
    function setContratoCREA(address _contrato) external onlyOwner {
        contratoCREA = _contrato;
    }

    // Função para definir o contrato RNP
    function setContratoRNP(address _contrato) external onlyOwner {
        contratoRNP = _contrato;
    }

    // Função para definir o contrato MUTUA
    function setContratoMUTUA(address _contrato) external onlyOwner {
        contratoMUTUA = _contrato;
    }

    // Função para definir o contrato de Pagamento
    function setContratoPagamento(address _contrato) external onlyOwner {
        contratoPagamento = _contrato;
    }

    // Função para delegar operações para o contrato CONFEA
    function delegarParaCONFEA(string calldata proposta) external {
        require(permissao[msg.sender] >= 1, "Permissao insuficiente");
        require(contratoCONFEA != address(0), "Contrato CONFEA nao definido");
        ICONFEA(contratoCONFEA).processarProposta(proposta);
        emit Evento("Delegado para CONFEA", msg.sender);
    }

    // Função para delegar operações para o contrato CREA
    function delegarParaCREA(string calldata registro) external {
        require(permissao[msg.sender] >= 1, "Permissao insuficiente");
        require(contratoCREA != address(0), "Contrato CREA nao definido");
        ICREA(contratoCREA).registrarAtualizacao(registro);
        emit Evento("Delegado para CREA", msg.sender);
    }

    // Função para delegar operações para o contrato RNP
    function delegarParaRNP(string calldata dados) external {
        require(permissao[msg.sender] >= 1, "Permissao insuficiente");
        require(contratoRNP != address(0), "Contrato RNP nao definido");
        IRNP(contratoRNP).atualizarDadosPessoais(dados);
        emit Evento("Delegado para RNP", msg.sender);
    }

    // Função para delegar operações para o contrato MUTUA
    function delegarParaMUTUA(string calldata interacao) external {
        require(permissao[msg.sender] >= 1, "Permissao insuficiente");
        require(contratoMUTUA != address(0), "Contrato MUTUA nao definido");
        IMUTUA(contratoMUTUA).registrarInteracao(interacao);
        emit Evento("Delegado para MUTUA", msg.sender);
    }

    // Função para processar pagamentos
    function processarPagamento(uint256 valor, address destinatario) external onlyOwner {
        require(contratoPagamento != address(0), "Contrato de pagamento nao definido");
        IPagamento(contratoPagamento).realizarPagamento(valor, destinatario);
        emit Evento("Pagamento processado", destinatario);
    }

    // Função para consultar dados externos através de um oraculo
    function consultarOraculo(string memory consulta) external pure returns (string memory) {
        // Simula a consulta ao oraculo. Substitua com a lógica real se necessário.
        return string(abi.encodePacked("Consulta ao oraculo: ", consulta));
    }

    // Função para definir o Nivel de Permissao de um usuário
    function setNivelPermissao(address usuario, uint8 nivel) external onlyOwner {
        permissao[usuario] = nivel;
        if (!usuarios.contains(usuario)) {
            usuarios.add(usuario);
        }
        emit Evento("Nivel de Permissao definido", usuario);
    }

    // Função auxiliar para verificar a Permissao de um usuário
    function verificarPermissao(address usuario) external view returns (uint8) {
        return permissao[usuario];
    }

    // Função auxiliar para registrar uma operação
    function logOperacao(string memory descricao) external onlyOwner {
        emit OperacaoLog(descricao, msg.sender);
    }

    // Função auxiliar para emitir um evento
    function emitirEvento(string memory evento) external onlyOwner {
        emit Evento(evento, msg.sender);
    }
}
