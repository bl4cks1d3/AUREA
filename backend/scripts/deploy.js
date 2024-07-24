async function main() {
    // Obtenha os Signers disponíveis
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    // Obtenha o contrato Lock
    const Lock = await ethers.getContractFactory("Lock");

    // Defina o tempo de desbloqueio para o futuro (por exemplo, 1 hora a partir de agora)
    const unlockTime = Math.floor(Date.now() / 1000) + 10 * 60; // 1 hora a partir de agora

    // Implante o contrato
    const lock = await Lock.deploy(unlockTime);

    console.log("Lock contract deployed to:", lock.address);

    // Espera o contrato ser minerado
    await lock.deployTransaction.wait();
    console.log("Contract deployed and mined!");
}

// Captura e exibe erros
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
