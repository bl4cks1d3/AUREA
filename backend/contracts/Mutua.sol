// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MUTUA is Ownable {
    struct Beneficio {
        string descricao;
        uint256 valor;
        uint256 data;
    }
    
    struct Seguro {
        uint256 valor;
        uint256 data;
    }

    struct Emprestimo {
        uint256 valor;
        uint256 dataEmprestimo;
        uint256 dataVencimento;
        bool pago;
    }

    mapping(address => Beneficio[]) private beneficios;
    mapping(address => Seguro[]) private seguros;
    mapping(address => Emprestimo[]) private emprestimos;
    mapping(address => mapping(address => uint8)) private niveisAcessoBeneficio;

    event BeneficioAdicionado(address indexed profissional, string descricao, uint256 valor, uint256 data);
    event SeguroProcessado(address indexed profissional, uint256 valor, uint256 data);
    event EmprestimoRegistrado(address indexed profissional, uint256 valor, uint256 dataEmprestimo, uint256 dataVencimento);
    event EmprestimoPago(address indexed profissional, uint256 valor, uint256 dataPagamento);
    event NivelAcessoBeneficioAtualizado(address indexed profissional, address indexed usuario, uint8 nivel);
    event EventoBeneficioEmitido(string evento, address indexed profissional);

    constructor() Ownable(msg.sender) {}

    modifier somenteComAcesso() {
        require(niveisAcessoBeneficio[msg.sender][msg.sender] > 0, "Voce nao tem acesso a esta funcao.");
        _;
    }

    // Benefícios
    function adicionarBeneficio(address profissional, string memory descricao, uint256 valor, uint256 data) public onlyOwner {
        Beneficio memory novoBeneficio = Beneficio({
            descricao: descricao,
            valor: valor,
            data: data
        });
        beneficios[profissional].push(novoBeneficio);
        
        emit BeneficioAdicionado(profissional, descricao, valor, data);
        emitirEventoBeneficio("Beneficio adicionado", profissional);
    }

    function consultarBeneficios(address profissional) public view somenteComAcesso returns (Beneficio[] memory) {
        return beneficios[profissional];
    }

    // Seguros
    function processarSeguro(address profissional, uint256 valor, uint256 data) public onlyOwner {
        Seguro memory novoSeguro = Seguro({
            valor: valor,
            data: data
        });
        seguros[profissional].push(novoSeguro);
        
        emit SeguroProcessado(profissional, valor, data);
    }

    function consultarSeguros(address profissional) public view somenteComAcesso returns (Seguro[] memory) {
        return seguros[profissional];
    }

    // Empréstimos
    function registrarEmprestimo(address profissional, uint256 valor, uint256 dataEmprestimo, uint256 dataVencimento) public onlyOwner {
        Emprestimo memory novoEmprestimo = Emprestimo({
            valor: valor,
            dataEmprestimo: dataEmprestimo,
            dataVencimento: dataVencimento,
            pago: false
        });
        emprestimos[profissional].push(novoEmprestimo);
        
        emit EmprestimoRegistrado(profissional, valor, dataEmprestimo, dataVencimento);
    }

    function pagarEmprestimo(address profissional, uint256 indexEmprestimo) public onlyOwner {
        require(indexEmprestimo < emprestimos[profissional].length, "Emprestimo nao encontrado.");
        Emprestimo storage emprestimo = emprestimos[profissional][indexEmprestimo];
        require(!emprestimo.pago, "Emprestimo ja pago.");
        emprestimo.pago = true;

        emit EmprestimoPago(profissional, emprestimo.valor, block.timestamp);
    }

    function consultarEmprestimos(address profissional) public view somenteComAcesso returns (Emprestimo[] memory) {
        return emprestimos[profissional];
    }

    // Controle de Acesso
    function setNivelAcessoBeneficio(address profissional, address usuario, uint8 nivel) public onlyOwner {
        niveisAcessoBeneficio[profissional][usuario] = nivel;
        emit NivelAcessoBeneficioAtualizado(profissional, usuario, nivel);
    }

    // Funções Auxiliares
    function validarBeneficio(address profissional, string memory descricao) public view somenteComAcesso returns (bool) {
        Beneficio[] storage beneficiosProfissional = beneficios[profissional];
        for (uint256 i = 0; i < beneficiosProfissional.length; i++) {
            if (keccak256(abi.encodePacked(beneficiosProfissional[i].descricao)) == keccak256(abi.encodePacked(descricao))) {
                return true;
            }
        }
        return false;
    }

    function verificarStatusSeguro(address profissional) public view somenteComAcesso returns (bool) {
        Seguro[] storage segurosProfissional = seguros[profissional];
        return segurosProfissional.length > 0;
    }

    function emitirEventoBeneficio(string memory evento, address profissional) internal {
        emit EventoBeneficioEmitido(evento, profissional);
    }
}
