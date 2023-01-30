pragma solidity >=0.7.0 <0.9.0;
contract firstcontract {
    uint saveData;
    function set(uint x) public {
        saveData = x;
    }
    function get() public view returns (uint x) {
        return saveData;
    }
}
