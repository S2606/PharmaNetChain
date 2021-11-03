
# PharmaChain Architecture - Build Ethereum Dapp for Tracking Items through Supply Chain

## Part 1: Plan the project with write-ups

### 1.1 Project write-up - UML

Definitions:

Choosen supply chain: Medicine

| UML entity  | Details |
|:-------:|:--------|
| Asset | Medicine |
| Attributes | Medicine:<br>- Product Id<br>- Name<br>- Manufacturer<br>- Manufacturing Date<br>- Expiry Date<br>- Owner<br>- Shipment<br>- Authenticity Third-party certifying body: CDSCO etc.<br> |
| Business Actions | R&D<br>Authenticity Certifying<br>Production<br>Distribution<br> |
| Role Permissions | Manufacturer<br>Inspector<br>Distributor<br>Retailer<br>Transporter<br>Buyer |

#### Activity Diagram

![Activity_Diagram](docs/activity_diagram.png)

#### Sequence Diagram

![Sequence_Diagram](docs/sequence_diagram.png)

#### State Diagram

![State_Diagram](docs/state_diagram.png)

#### Class Diagram

![Class_Diagram](docs/class_diagram.png)


### 1.2 Project write-up - Libraries

If libraries are used, the project write-up discusses why these libraries were adopted.

 - node v14.4.0
 - truffle v5.4.13
 - web3 v1.2.4

### 1.3 Project write-up - IPFS

`IPFS was not used`

### 1.4 Project write-up

`Note:- Distributor/Retailer roles are not considered separate roles since they are interchangeable in nature`

### “Contract Address” and “Transaction Hash” on the Rinkeby Network

- Contract Address :- `0x2E8Df59Ecd011E7e0A7Fb0f5DEbE3aa614AFE0df`
- Transaction Hash :- `0xa44d40c66f274772ccc7b270b3af32a23b9c0028e9c05b218cf629bfb2582e0c`

