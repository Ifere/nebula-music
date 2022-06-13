const { deployments, network, ethers} = require("hardhat")
//const { ethers } = require("@nomiclabs/hardhat-ethers")

async function main() {
    // We get the contract to deploy
    const nft1 = await ethers.getContractFactory("MyToken");
    const nft2 = await ethers.getContractFactory("MyToken2");
    const batchSend = await ethers.getContractFactory("batchSend");
    const nft1Dep = await nft1.deploy();
    const nft2Dep = await nft2.deploy();
    const batchSender = await batchSend.deploy();

  
    await nft1Dep.deployed();
    await nft2Dep.deployed();
    await batchSender.deployed();
  
    console.log("nft1 deployed to:", nft1Dep.address);
    console.log("nft2 deployed to:", nft2Dep.address);
    console.log("batchSend deployed to:", batchSender.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });

// module.exports = async function(hre){
//     const{getNamedAccounts, deployments} = hre
//     const{deployer, receiver} = await getNamedAccounts()
//     const{deploy, log} = deployments

//     const nft1 = await deploy("nft1")
//     nft1Address = nft1.address
//     const tx = await nft1.safeMint(deployer)
//     //const txReceipt = await tx.wait(1)



//     const batchSend = await deploy("batchsend",{
//         from: deployer      
//     })

//     console.log(batchSend.address)
//     const tx2 = await batchSend.getNFTAuthority(batchSend.address, receiver, [nft1Address], [1])
//     tx2.wait(1)

//     log("success", tx2)
// }