import Web3 from "web3";
import pharmaChainArtifact from "../../build/contracts/PharmaChain.json";

import './style.css';

const App = {
  web3: null,
  account: null,
  meta: null,

  start: async function() {
    const { web3 } = this;

    try {
      // get contract instance
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = pharmaChainArtifact.networks[networkId];
      this.meta = new web3.eth.Contract(
        pharmaChainArtifact.abi,
        deployedNetwork.address,
      );

      this.meta.events.allEvents(function(err, log){
        if (!err){
          const events = document.getElementById("ftc-events");
          events.append('<li>' + log.event + ' - ' + log.transactionHash + '</li>');
        }
      });

      // get accounts
      const accounts = await web3.eth.getAccounts();
      this.account = accounts[0];

    } catch (error) {
      console.error("Could not connect to contract or chain.");
    }
  },

  developMedicine: async function() {
    const { developMedicine } = this.meta.methods;
    const sku = document.getElementById("sku").value;
    const productId = document.getElementById("productId").value;
    const productName = document.getElementById("productName").value;
    const productPrice = document.getElementById("productPrice").value;
    const productExpiry = document.getElementById("productExpiry").value;
    const manufactureId = document.getElementById("manufacturerID").value;
    await developMedicine(sku, productId, productName, productExpiry, productPrice).send({from: manufactureId});
  },

  certifyMedicine: async function() {
    const { certifyMedicine } = this.meta.methods;
    const productId = document.getElementById("productId").value;
    const certifyNotes = document.getElementById("certifyNotes").value;
    const inspectorId = document.getElementById("inspectorID").value;
    await certifyMedicine(productId, certifyNotes).send({from: inspectorId});
  },

  manufactureMedicine: async function() {
    const { manufactureMedicine } = this.meta.methods;
    const productId = document.getElementById("productId").value;
    const manufacturedDate = document.getElementById("manufacturedDate").value;
    const manufactureId = document.getElementById("manufactureID").value;
    await manufactureMedicine(productId, new Date(manufacturedDate)).send({from: manufactureId});
  },

  makePurchaseOrder: async function() {
    const { createPurchaseOrder } = this.meta.methods;
    const productId = document.getElementById("productId").value;
    const distributorId = document.getElementById("distributorID").value;
    await createPurchaseOrder(productId).send({from: distributorId});
  },

  markShipped: async function() {
    const { createShipment } = this.meta.methods;
    const productId = document.getElementById("productId").value;
    const transporterId = document.getElementById("transporterID").value;
    const manufactureId = document.getElementById("manufactureID").value;
    await createShipment(productId, transporterId).send({from: manufactureId});
  },

  markReceived: async function() {
    const { receiveShipment } = this.meta.methods;
    const productId = document.getElementById("productId").value;
    const transporterId = document.getElementById("transporterID").value;
    await receiveShipment(productId).send({from: transporterId});
  },

  purchaseMedicine: async function() {
    const { purchaseMedicine } = this.meta.methods;
    const productId = document.getElementById("productId").value;
    const consumerId = document.getElementById("consumerID").value;
    await purchaseMedicine(productId).send({from: consumerId});
  },

};

window.App = App;

window.addEventListener("load", function() {
  if (window.ethereum) {
    // use MetaMask's provider
    App.web3 = new Web3(window.ethereum);
    window.ethereum.enable(); // get permission to access accounts
  } else {
    console.warn(
      "No web3 detected. Falling back to http://127.0.0.1:8545. You should remove this fallback when you deploy live",
    );
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    App.web3 = new Web3(
      new Web3.providers.HttpProvider("http://127.0.0.1:8545"),
    );
  }

  App.start();
});
