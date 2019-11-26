const SadamHuschain = artifacts.require("SadamHuschain")
const truffleAssert = require("truffle-assertions")

contract("Vote", () => {
    let houseFactoryInstance, houseId, createVoter

    before(async () => {
        sadamInstance = await SadamHuschain.deployed()
        await houseFactoryInstance.createUser("Ruben")
        createVoter = await houseFactoryInstance.createVoter("hervé")

        truffleAssert.eventEmitted(createVoter, "createVoter", async (ev) => {
            if (!ev.houseId) return false;
            houseId = ev.houseId;
            return true
        })
    });

    it("Should create one house and emit an 'NewHouse' event", async () => {
        const createHouse = await houseFactoryInstance.createHouse(55, "18 Rue Montparnasse", 62)

        truffleAssert.eventEmitted(createHouse, "NewHouse", (ev) => {
            return ev.postalAddress === "18 Rue Montparnasse"
        })
    });

    it("Should return one house created by user", async () => {
        const houses = await houseFactoryInstance.getHousesByUser.call()
        assert.equal(
            houses.length,
            2,
            "House is not found"
        )
    });


    it("Should return a house by ID", async () => {
            const house = await houseFactoryInstance.getHouse.call(houseId)
            assert.equal(
                house.id,
                houseId,
                "houseIds dont match"
            )
        }
    )
});