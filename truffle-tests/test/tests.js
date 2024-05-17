const { assert } = require("console");

const ProposelContract = artifacts.require("ProposelContract");
const AudienceEngagementTool = artifacts.require("AudienceEngagementTool");
contract("ProposelContract", async (accounts) => {
    let proposelContract;
    let audienceEngagementTool;
  

    beforeEach(async () => {
        proposelContract = await ProposelContract.new();
        audienceEngagementTool = await AudienceEngagementTool.new(proposelContract.address, { from: accounts[0] });
    });

    it("should add a new proposel", async () => {
        await audienceEngagementTool.setProposel("Name", "URL", { from: accounts[0] });
        const proposels = await proposelContract.listProposels();
        assert(proposels.length == 1, "Failed to add proposel");
        assert(proposels[proposels.length-1].name ==="Name", "name is not correct");
        assert(proposels[proposels.length-1].url === "URL", "url is not correct");
        assert(proposels[proposels.length-1].votes === 0, "votes is not correct");
    });

    it("should vote and unvote", async () => {
        await audienceEngagementTool.setProposel("Name", "URL", { from: accounts[0] });
        await audienceEngagementTool.vote(1, { from: accounts[1]});
        const proposels = await audienceEngagementTool.listProposels();
        const getVotes = await audienceEngagementTool.getVotes();
        assert(proposels[0].votes.toString() === "1", "voted failed");
        assert(getVotes.length === 1, "voted failed")
        await audienceEngagementTool.unvote({ from: accounts[1]});
        const proposels2 = await audienceEngagementTool.listProposels();
        const getVotes2 = await audienceEngagementTool.getVotes();

        assert(proposels2[0].votes.toString() === "0", "unvoted failed");
        assert(getVotes2.length === 0, "unvoted failed")

    });

    it("should get winning proposel", async () => {
        await audienceEngagementTool.setProposel("Name", "URL", { from: accounts[0] });
        await audienceEngagementTool.setProposel("Name1", "URL1", { from: accounts[0] });
        await audienceEngagementTool.vote(1, { from: accounts[1]});
        await audienceEngagementTool.vote(1, { from: accounts[0]});
        await audienceEngagementTool.vote(2, { from: accounts[2]});


        const winner = await audienceEngagementTool.getWinningProposel();
        assert(winner.votes.toString() === "2", "winner is not correct");
    });

    // it("sould make tarnsfer", async () => {
    //     let initValue = await web3.eth.getBalance(accounts[1]);
    //     audienceEngagementTool.makeTransfer(accounts[1], { from: accounts[0], value: 100});
    //     console.log(await web3.eth.getBalance(accounts[1]), initValue + 100)
    //     assert(await web3.eth.getBalance(accounts[1]) === initValue + 100, "transfer failed")
    // });

    it("should resetPeriod", async () => {
        await audienceEngagementTool.setProposel("Name", "URL", { from: accounts[0] });
        await audienceEngagementTool.setProposel("Name1", "URL1", { from: accounts[0] });
        await audienceEngagementTool.vote(1, { from: accounts[1]});
        await audienceEngagementTool.vote(1, { from: accounts[0]});
        await audienceEngagementTool.vote(2, { from: accounts[2]});
        await audienceEngagementTool.resetPeriod({from: accounts[0]});
        const proposels = await audienceEngagementTool.listProposels();
        assert(proposels[0].votes.toString() === "0", "reset votes failed");
        assert(proposels.length === 1, "reset length failed");
        let perriod = await audienceEngagementTool.getPeriodInterval();
        assert(perriod.periodStart< new Date().getTime() <perriod.periodEnd, "reset time failed");
    });

    it("should cahnge fee", async () => {
        await audienceEngagementTool.setFee(10, {from: accounts[0]});
        const fee = await audienceEngagementTool.getFee();
        assert(fee.toString() === "10", "fee is not correct");
    });
    
});