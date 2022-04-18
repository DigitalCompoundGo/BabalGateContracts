const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {
  it("should not mint 4 kinds of tokens", async function () {
    const Greeter = await ethers.getContractFactory("AddTo0");
    const greeter = await Greeter.deploy("");
    await greeter.deployed();
    const tx0 = await greeter.mintBatch(
      "0x6e10884FD7a640BC181b496C33EB2f3d722376ab",
      [0, 1, 2],
      [1, 1, 1],
      []
    );

    // wait until the transaction is mined
    await tx0.wait();
    console.log("aaa");
    await expect(
      greeter.mint("0x6e10884FD7a640BC181b496C33EB2f3d722376ab", 3, 1, [])
    ).to.be.reverted;
  });
});
