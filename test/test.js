const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("batchsend", function () {
  let owner;
  let alice;
  let chilly;
  let moore;
  let batch;
  let nft;
  let nftt;

  beforeEach(async () => {
    let batchSend = await ethers.getContractFactory("batchSend");
    let nft1 = await ethers.getContractFactory("MyToken");
    let nft2 = await ethers.getContractFactory("MyToken2");
    [owner, alice, chilly, moore] = await ethers.getSigners();

    batch = await batchSend.deploy();
    nft = await nft1.deploy();
    nftt = await nft2.deploy();
    await nft.deployed();
    await nftt.deployed();
    await nft.safeMint(owner.address);
    await nftt.safeMint(owner.address);
    await batch.deployed();
    console.log(
       `The contract at ${batch.address} is called, it is symbolized by: ${nft.address}, it is  also symbolized by: ${nftt.address}`
     );
    await nft.setApprovalForAll(batch.address, true);
    await nftt.setApprovalForAll(batch.address, true);
  });

  describe("check send cluster", function () {
    it("cluster send successful", async function () {
      console.log("here we go")
        const name = await nft.balanceOf(owner.address);
        const named = await nftt.balanceOf(owner.address);
       console.log(Number(name), Number(named))

       console.log(batch.address, alice.address, [nft.address, nftt.address])
        tx = await batch.sendCluster(alice.address, [0,20], [nft.address, nftt.address],{
          from: owner.address
       })
      // wait until the transaction is mined
       await tx.wait();
       console.log(Number(tx.gasPrice))
       const transferr = await nft.balanceOf(alice.address);
       const transferrd = await nftt.balanceOf(alice.address);
       expect(Number(transferr)).to.equal(1);
        expect(Number(transferrd)).to.equal(1);

      // console.log(alienzTx);
    });
  });
})