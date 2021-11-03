pragma solidity >=0.7.0;

import "./Owner.sol";
import "./Consumer.sol";
import "./Distributor.sol";
import "./Transporter.sol";
import "./Manufacturer.sol";
import "./Inspector.sol";

contract PharmaChain is
    Owner,
    Consumer,
    Distributor,
    Transporter,
    Manufacturer,
    Inspector
{
    uint256 sku_count;

    mapping(uint256 => Medicine) medicines;

    enum MedicineState {
        Developed,
        Certified,
        Manufactured,
        POCreated,
        ShipmentCreated,
        ShipmentReceived,
        Purchased
    }
    MedicineState constant defaultMedicineState = MedicineState.Developed;

    struct Medicine {
        uint256 sku; // Stock Keeping Unit (SKU)
        uint256 productID;
        string name;
        address developerID;
        address manufacturerID;
        address transporterID;
        address distributorID;
        address consumerID;
        uint256 manufacturedDate;
        uint256 expiryDate;
        uint256 productPrice;
        string certifyNotes;
        string[2] shipmentStatus;
        MedicineState state; // Product State as represented in the enum above
    }

    event developedMedicine(uint256 productID);
    event certifiedMedicine(uint256 productID);
    event manufacturedMedicine(uint256 productID);
    event createdPurchaseOrder(uint256 productID);
    event createdShipment(uint256 productID);
    event receivedShipment(uint256 productID);
    event purchasedMedicine(uint256 productID);

    modifier sufficientBalance(uint256 _price) {
        require(msg.value >= _price, "sufficientBalance");
        _;
    }

    modifier paymentChecks(uint256 _productId){
        _;
        uint256 _price = medicines[_productId].productPrice;
        uint256 amountToReturn = msg.value - _price;
        payable(medicines[_productId].consumerID).transfer(amountToReturn);
    }

    modifier isDeveloped(uint256 _productId) {
        require(medicines[_productId].state == MedicineState.Developed, "not Developed");
        _;
    }

    modifier isCertified(uint256 _productId) {
        require(medicines[_productId].state == MedicineState.Certified, "not Certified");
        _;
    }

    modifier isManufactured(uint256 _productId) {
        require(medicines[_productId].state == MedicineState.Manufactured, "not Manufactured");
        _;
    }

    modifier isPurchaseable(uint256 _productId) {
        require(medicines[_productId].state == MedicineState.POCreated, "not Purchaseable");
        _;
    }

    modifier isInTransist(uint256 _productId) {
        require(medicines[_productId].state == MedicineState.ShipmentCreated, "not yet Shipped");
        _;
    }

    modifier isReadyToBeSold(uint256 _productId) {
        require(medicines[_productId].state == MedicineState.ShipmentReceived 
                && 
                keccak256(bytes(medicines[_productId].shipmentStatus[0])) == keccak256("in-transist"), "not Sellable");
        _;
    }


    constructor() payable {
        sku_count = 1;
    }

    function kill() public checkOwner {
        selfdestruct(payable(owner()));
    }

    function developMedicine(
        uint256 _sku, 
        uint256 _productID, 
        string calldata _productName, 
        uint _expiryDate,
        uint256 _productPrice) public checkManufacturer {
        
        medicines[_productID].sku = _sku;
        medicines[_productID].developerID = msg.sender;
        medicines[_productID].name = _productName;
        medicines[_productID].expiryDate = _expiryDate;
        medicines[_productID].productPrice = _productPrice;

        medicines[_productID].state = MedicineState.Developed;
        sku_count = sku_count + 1;
        
        emit developedMedicine(_productID);
    }

    function certifyMedicine(
         uint256 _productID, 
         string calldata _certifyNotes
    ) public checkInspector isDeveloped(_productID){

        medicines[_productID].certifyNotes = _certifyNotes;
        medicines[_productID].state = MedicineState.Certified;

        emit certifiedMedicine(_productID);
    }

    function manufactureMedicine(
         uint256 _productID, 
         uint _manufacturedDate
    ) public checkManufacturer isCertified(_productID){

        medicines[_productID].manufacturedDate = _manufacturedDate;
        medicines[_productID].manufacturerID = msg.sender;
        medicines[_productID].state = MedicineState.Manufactured;

        emit manufacturedMedicine(_productID);
    }

    function createPurchaseOrder(
         uint256 _productID
    ) public checkDistributor isManufactured(_productID){

        medicines[_productID].distributorID = msg.sender;
        
        medicines[_productID].state = MedicineState.POCreated;

        emit createdPurchaseOrder(_productID);
    }


    function createShipment(
         uint256 _productID,
         address _transporterID
    ) public checkManufacturer isPurchaseable(_productID){

        medicines[_productID].transporterID = _transporterID;
        medicines[_productID].shipmentStatus = ['in-transist'];
        medicines[_productID].state = MedicineState.ShipmentCreated;

        emit createdShipment(_productID);
    }

    function receiveShipment(
         uint256 _productID
    ) public checkTransporter isInTransist(_productID){

        medicines[_productID].shipmentStatus = ['in-transist', 'delivered'];
        medicines[_productID].state = MedicineState.ShipmentReceived;

        emit receivedShipment(_productID);
    }

    function purchaseMedicine(
        uint256 _productID
    ) public payable 
             checkConsumer 
             isReadyToBeSold(_productID) 
             sufficientBalance(medicines[_productID].productPrice)
             paymentChecks(_productID) {
        medicines[_productID].consumerID = msg.sender;
        medicines[_productID].state = MedicineState.Purchased;
        uint256 price = medicines[_productID].productPrice;
        payable(medicines[_productID].developerID).transfer(price);
        emit purchasedMedicine(_productID);
    }

    function fetchMedicine(uint256 _productID)
        external
        view
        returns (
			uint256 sku,
			string memory name,
            address developerID,
            address manufacturerID,
            address transporterID,
            address distributorID,
            address consumerID,
            uint256 manufacturedDate,
            uint256 productPrice,
            string memory certifyNotes,
            string[2] memory shipmentStatus,
            uint256 state
        )
    {
			sku	= medicines[_productID].sku;
            name		= medicines[_productID].name;
			developerID		= medicines[_productID].developerID;
			manufacturerID	= medicines[_productID].manufacturerID;
			transporterID	= medicines[_productID].transporterID;
			distributorID	= medicines[_productID].distributorID;
			consumerID		= medicines[_productID].consumerID;
			manufacturedDate = medicines[_productID].manufacturedDate;
            productPrice	= medicines[_productID].productPrice;
            certifyNotes	= medicines[_productID].certifyNotes;
            shipmentStatus	= medicines[_productID].shipmentStatus;
			state		= uint256(medicines[_productID].state);
        return (
			sku,
			name,
            developerID,
            manufacturerID,
            transporterID,
            distributorID,
            consumerID,
            manufacturedDate,
            productPrice,
            certifyNotes,
            shipmentStatus,
            state
        );
    }

}

