const SadamHuschain = artifacts.require("SadamHuschain");
const truffleAssert = require("truffle-assertions");

contract("Vote", (accounts) => {
    let sadamInstance, id, createVoter;

    before(async () => {
        sadamInstance = await SadamHuschain.deployed();
    });

    it("Should create a Voter", async () => {
        var name = "herve";
        await sadamInstance.createVoter(name);

        var myVoter = await sadamInstance.getMyVoter.call();

        assert.equal(myVoter['name'],name);
        assert.equal(myVoter['voted'],false);

    });


    it("Should create a Well", async () => {
        var name = "Le puit de Kader";
        var localisation = "Une loc";
        var description = "Un puit incroyable";
        await sadamInstance.createWell(name,localisation,description);

        var myWell = await sadamInstance.getMyWell.call();
        assert.equal(myWell['name'],name);
        assert.equal(myWell['description'],description);
        assert.equal(myWell['localisation'],localisation);

    });




/*
    it("Should return one house created by user", async () => {
        const houses = await houseFactoryInstance.getHousesByUser.call();
        assert.equal(
            houses.length,
            2,
            "House is not found"
        )
    });*/
});

contract("Vote2", (accounts) => {
    let sadamInstance, id, createVoter;

    before(async () => {
        sadamInstance = await SadamHuschain.deployed();
    });

    it("Should return list", async () => {
        var name = "Le puit de Kader";
        var localisation = "Une loc";
        var description = "Un puit incroyable";
        var name2 = "Le puit de Kader22222222";
        await sadamInstance.createWell(name,localisation,description,{from:accounts[0]});
        await sadamInstance.createWell(name2,localisation,description,{from:accounts[1]});
        var wells = await sadamInstance.getWellList.call();
        assert.equal(wells[0]['name'],name);
        assert.equal(wells[1]['name'],name2);
    });

});