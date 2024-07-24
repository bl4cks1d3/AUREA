// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RNP is Ownable {
    struct InformacoesPessoais {
        string dscNac;
        string dscNat;
        string dtaExpIdt;
        string dtaNsc;
        string estCiv;
        string nme;
        string nroIdt;
        string orgExpIdt;
        string pisNac;
        string sisIdtPrfNroCpf;
        string tpoEndCor;
        string tpoFrh;
        string tpoNecEsp;
        string tpoNroImpCrt;
        string tpoReg;
        string tpoRnp;
        string tpoSex;
        string tpoSng;
        string ufNat;
    }

    struct Endereco {
        string tipo;
        string endereco;
    }

    struct Titulo {
        string titulo;
        string data;
    }
    constructor() Ownable(msg.sender) {}
    mapping(address => InformacoesPessoais) private informacoes;
    mapping(address => mapping(address => uint8)) private niveisAcesso;
    mapping(address => Endereco[]) private enderecos;
    mapping(address => Titulo[]) private titulos;
    mapping(address => string[]) private historico;

    event InformacoesPessoaisAdicionadas(address indexed profissional, InformacoesPessoais info);
    event EnderecoAdicionado(address indexed profissional, string tipo, string endereco);
    event TituloAdicionado(address indexed profissional, string titulo, string data);
    event NivelAcessoAtualizado(address indexed profissional, address indexed usuario, uint8 nivel);
    event InformacoesPessoaisValidadas(address indexed profissional);
    event HistoricoVerificado(address indexed profissional, string[] historico);

    modifier somenteComAcesso(address profissional) {
        require(niveisAcesso[profissional][msg.sender] > 0, "Voce nao tem acesso ao registro deste profissional.");
        _;
    }

    function adicionarInformacoesPessoaisParte1(
        address profissional,
        string memory dscNac,
        string memory dscNat,
        string memory dtaExpIdt,
        string memory dtaNsc,
        string memory estCiv,
        string memory nme,
        string memory nroIdt,
        string memory orgExpIdt,
        string memory pisNac
    ) public onlyOwner {
        InformacoesPessoais storage info = informacoes[profissional];
        info.dscNac = dscNac;
        info.dscNat = dscNat;
        info.dtaExpIdt = dtaExpIdt;
        info.dtaNsc = dtaNsc;
        info.estCiv = estCiv;
        info.nme = nme;
        info.nroIdt = nroIdt;
        info.orgExpIdt = orgExpIdt;
        info.pisNac = pisNac;
        emit InformacoesPessoaisAdicionadas(profissional, info);
    }

    function adicionarInformacoesPessoaisParte2(
        address profissional,
        string memory sisIdtPrfNroCpf,
        string memory tpoEndCor,
        string memory tpoFrh,
        string memory tpoNecEsp,
        string memory tpoNroImpCrt,
        string memory tpoReg,
        string memory tpoRnp,
        string memory tpoSex,
        string memory tpoSng,
        string memory ufNat
    ) public onlyOwner {
        InformacoesPessoais storage info = informacoes[profissional];
        info.sisIdtPrfNroCpf = sisIdtPrfNroCpf;
        info.tpoEndCor = tpoEndCor;
        info.tpoFrh = tpoFrh;
        info.tpoNecEsp = tpoNecEsp;
        info.tpoNroImpCrt = tpoNroImpCrt;
        info.tpoReg = tpoReg;
        info.tpoRnp = tpoRnp;
        info.tpoSex = tpoSex;
        info.tpoSng = tpoSng;
        info.ufNat = ufNat;
        emit InformacoesPessoaisAdicionadas(profissional, info);
    }

    function consultarInformacoesPessoais(address profissional)
        public
        view
        somenteComAcesso(profissional)
        returns (InformacoesPessoais memory)
    {
        return informacoes[profissional];
    }

    function adicionarEndereco(address profissional, string memory tipo, string memory endereco) public somenteComAcesso(profissional) {
        enderecos[profissional].push(Endereco({tipo: tipo, endereco: endereco}));
        emit EnderecoAdicionado(profissional, tipo, endereco);
    }

    function adicionarTitulo(address profissional, string memory titulo, string memory data) public somenteComAcesso(profissional) {
        titulos[profissional].push(Titulo({titulo: titulo, data: data}));
        emit TituloAdicionado(profissional, titulo, data);
    }

    function setNivelAcessoInformacoesPessoais(address profissional, address usuario, uint8 nivel) public onlyOwner {
        niveisAcesso[profissional][usuario] = nivel;
        emit NivelAcessoAtualizado(profissional, usuario, nivel);
    }

    function validarInformacoesPessoais(address profissional) public view returns (bool) {
        InformacoesPessoais memory info = informacoes[profissional];
        return bytes(info.nme).length > 0;
    }

    function verificarHistorico(address profissional) public view returns (string[] memory) {
        return historico[profissional];
    }

    function emitirEventoInformacoesPessoais(string memory evento, address profissional) internal {
        historico[profissional].push(evento);
        emit HistoricoVerificado(profissional, historico[profissional]);
    }
}
