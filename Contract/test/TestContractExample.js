const SadamHuschain = artifacts.require("SadamHuschain");
const truffleAssert = require("truffle-assertions");



contract("Vote", (accounts) => {
    let sadamInstance, id, createVoter;

    before(async () => {
        sadamInstance = await SadamHuschain.deployed();
    });

    it("Should not start vote", async () => {

        try {
            await sadamInstance.startVote();
            throw null;
        }
        catch (error) {
            assert.equal(error, "Error: Returned error: VM Exception while processing transaction: revert");
        }
    });

    it("Should create sadam", async () => {
        var isSadam = await sadamInstance.isSadamInit.call({from:accounts[0]});
        await sadamInstance.createSadam();
        var isSadam2 = await sadamInstance.isSadamInit.call({from:accounts[0]});

        assert.equal(isSadam,false);
        assert.equal(isSadam2,true);
    });

    it("Should check if its sadam", async () => {
        var isSadam =await sadamInstance.isThisSadam.call({from:accounts[0]});

        assert.equal(isSadam,true);
    });

    it("Should create a Voter", async () => {
        var name = "herve";
        await sadamInstance.createVoter(name,{from:accounts[1]});
        var myVoter = await sadamInstance.getMyVoter.call({from:accounts[1]});
        assert.equal(myVoter['name'],name);
        assert.equal(myVoter['voted'],false);
    });

    it("Should check if its sadam", async () => {
        var isSadam =await sadamInstance.isThisSadam.call({from:accounts[1]});

        assert.equal(isSadam,false);
    });

    it("Should create a Well", async () => {
        var name = "Le puit de Kader";
        var localisation = "Une loc";
        var description = "Un puit incroyable";
        await sadamInstance.createWell(name,localisation,description,{from:accounts[0]});
        var myWell = await sadamInstance.getAWell.call(name);

        assert.equal(myWell['name'],name);
        assert.equal(myWell['description'],description);
        assert.equal(myWell['localisation'],localisation);
    });

    it("Should start vote", async () => {
        var isVoteStarted = await sadamInstance.isVoteStarted.call({from:accounts[0]});
        assert.equal(isVoteStarted,false);
        await sadamInstance.startVote();
        isVoteStarted = await sadamInstance.isVoteStarted.call({from:accounts[0]});
        assert.equal(isVoteStarted,true);
    });

    it("Should not vote", async () => {
        var vote = await sadamInstance.vote.call("Un nom random",10,{from:accounts[1]});
        assert.equal(vote,false);
    });

    it("Should vote", async () => {
        var name = "herve";
        var nameWell = "Le puit de Kader";
        await sadamInstance.createVoter(name,{from:accounts[1]});
        await sadamInstance.vote(nameWell,10,{from:accounts[1]});
        await sadamInstance.endVote({from:accounts[0]});
        var wells = await sadamInstance.getWellList.call();
        console.log(wells);
        assert.equal(wells[0].finalScore,10);
    });


});


contract("TestList", (accounts) => {
    let sadamInstance, id, createVoter;

    before(async () => {
        sadamInstance = await SadamHuschain.deployed();
    });

    it("Should return list", async () => {
        await sadamInstance.createSadam();
        var name = "Le puit de Kader";
        var localisation = "Une loc";
        var description = "Un puit incroyable";
        var name2 = "Le puit de Kader22222222";
        await sadamInstance.createWell(name,localisation,description,{from:accounts[0]});
        await sadamInstance.createWell(name2,localisation,description,{from:accounts[0]});
        var wells = await sadamInstance.getWellList.call();

        assert.equal(wells[0]['name'],name);
        assert.equal(wells[1]['name'],name2);
    });
});
