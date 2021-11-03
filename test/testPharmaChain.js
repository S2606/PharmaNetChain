const PharmaChain = artifacts.require("PharmaChain");
const truffleAssert = require('truffle-assertions');

var accounts;

contract('PharmaChain', (accs) => {
    accounts = accs;
});

// Accounts
let acc_owner = accounts[0];	// Account of Owner
let acc_mnfr_0 = accounts[1];	// Account of Manufacturer 
let acc_iptr_0 = accounts[2];	// Account of Inspector 
let acc_dist_0 = accounts[3];	// Account of Distributor 
let acc_trpt_0 = accounts[4];	// Account of Transporter 
let acc_cons_0 = accounts[5];	// Account of Consumer

it('can the Manufacturer Develop the Medicine', async() => {
    instance = await PharmaChain.deployed();
    
    await instance.giveManufacturerRole(acc_mnfr_0, { from: acc_owner });
    await instance.giveInspectorRole(acc_iptr_0, { from: acc_owner });
    await instance.giveDistributorRole(acc_dist_0, { from: acc_owner });
    await instance.giveTransporterRole(acc_trpt_0, { from: acc_owner });
    await instance.giveConsumerRole(acc_cons_0, { from: acc_owner });

    let sku = 1;
    let productId = 1;
    let productName = "Random Drug";
    let productPrice = 20;
    let expiryDate = 1635389324;
    let state = 0;

    let medicine = await instance.developMedicine(
        sku,
        productId,
        productName,
        expiryDate,
        productPrice,
        {"from": acc_mnfr_0},
    );

    let res1 = await instance.fetchMedicine.call(productId);

    assert.equal(res1.sku, sku, 'Error: Invalid SKU');
    assert.equal(res1.developerID, acc_mnfr_0, 'Error: Invalid developerID');
    assert.equal(res1.name, productName, 'Error: Invalid productName');
    assert.equal(res1.productPrice, productPrice, 'Error: Invalid expiryDate');
    assert.equal(res1.state, state, 'Error: Invalid state');
    truffleAssert.eventEmitted(medicine, 'developedMedicine');
    
});

it('can the Inspector Certify the Medicine', async() => {
    let productId = 1;
    let certifyNotes = "Looks all right to me";
    let state = 1;

    let medicine = await instance.certifyMedicine(
        productId,
        certifyNotes,
        {"from": acc_iptr_0},
    );

    let res1 = await instance.fetchMedicine.call(productId);

    assert.equal(res1.certifyNotes, certifyNotes, 'Error: Invalid certifyNotes');
    assert.equal(res1.state, state, 'Error: Invalid state');
    truffleAssert.eventEmitted(medicine, 'certifiedMedicine');
    
});

it('can the Manufacturer manufacture the Medicines at scale', async() => {
    let productId = 1;
    let manufacturedDate = 1635389326;
    let state = 2;

    let medicine = await instance.manufactureMedicine(
        productId,
        manufacturedDate,
        {"from": acc_mnfr_0},
    );

    let res1 = await instance.fetchMedicine.call(productId);

    assert.equal(res1.manufacturedDate, manufacturedDate, 'Error: Invalid manufacturedDate');
    assert.equal(res1.manufacturerID, acc_mnfr_0, 'Error: Invalid manufacturerID');
    assert.equal(res1.state, state, 'Error: Invalid state');
    truffleAssert.eventEmitted(medicine, 'manufacturedMedicine');
    
});

it('can the Distributor create purchase order for the medicine', async() => {
    let productId = 1;
    let state = 3;

    let medicine = await instance.createPurchaseOrder(
        productId,
        {"from": acc_dist_0},
    );

    let res1 = await instance.fetchMedicine.call(productId);

    assert.equal(res1.distributorID, acc_dist_0, 'Error: Invalid distributorID');
    assert.equal(res1.state, state, 'Error: Invalid state');
    truffleAssert.eventEmitted(medicine, 'createdPurchaseOrder');
    
});

it('can the Transporter pick the medicine up for shipment', async() => {
    let productId = 1;
    let shipmentStatus = ['in-transist'];
    let state = 4;

    let medicine = await instance.createShipment(
        productId,
        acc_trpt_0,
        {"from": acc_mnfr_0},
    );

    let res1 = await instance.fetchMedicine.call(productId);

    assert.equal(res1.transporterID, acc_trpt_0, 'Error: Invalid transporterID');
    assert.equal(res1.shipmentStatus[0], shipmentStatus[0], 'Error: Invalid shipmentStatus');
    assert.equal(res1.state, state, 'Error: Invalid state');
    truffleAssert.eventEmitted(medicine, 'createdShipment');
    
});

it('can the Transporter deliver the medicine to desired location', async() => {
    let productId = 1;
    let shipmentStatus = ['in-transist', 'delivered'];
    let state = 5;

    let medicine = await instance.receiveShipment(
        productId,
        {"from": acc_trpt_0},
    );

    let res1 = await instance.fetchMedicine.call(productId);

    assert.equal(res1.transporterID, acc_trpt_0, 'Error: Invalid transporterID');
    assert.equal(res1.shipmentStatus[0], shipmentStatus[0], 'Error: Invalid shipmentStatus');
    assert.equal(res1.shipmentStatus[1], shipmentStatus[1], 'Error: Invalid shipmentStatus');
    assert.equal(res1.state, state, 'Error: Invalid state');
    truffleAssert.eventEmitted(medicine, 'receivedShipment');
    
});

it('can the Consumer purchase a medicine', async() => {
    let productId = 1;
    let owner = acc_owner;
    let state = 6;
    let res1 = await instance.fetchMedicine.call(productId);
    let medicine = await instance.purchaseMedicine(
        productId,
        {"from": owner, "value": res1.productPrice},
    );

    res1 = await instance.fetchMedicine.call(productId);

    assert.equal(res1.consumerID, acc_owner, 'Error: Invalid consumerID');
    assert.equal(res1.state, state, 'Error: Invalid state');
    truffleAssert.eventEmitted(medicine, 'purchasedMedicine');
    
});



