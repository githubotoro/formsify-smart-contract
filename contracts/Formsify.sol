//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

import "hardhat/console.sol";

contract Formsify {
    // ===================
    // FORMSIFY PARAMETERS
    // ===================

    /**
     * @dev Track form owner
     */
    address public owner;

    /**
     * @dev Track total form fills
     */
    uint256 public fills;

    /**
     * @dev Track max form fills
     */
    uint256 public maxFills;

    /**
     * @dev Track form's start time
     */
    uint256 public startTime;

    /**
     * @dev Track form's end time
     */
    uint256 public endTime;

    /**
     * @dev Number of fills per address
     */
    uint256 public allowedTotalFills;

    /**
     * @dev Form head for form
     */
    string public formHead;

    /**
     * @dev Form fields for form
     */
    string public fields;

    // ===================
    // FORMSIFY PARAMETERS
    // ===================

    /**
     * @dev Get Formsify Parameters
     */
    function getParameters()
        public
        view
        returns (
            address,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            string memory,
            string memory
        )
    {
        return (
            owner,
            fills,
            maxFills,
            startTime,
            endTime,
            allowedTotalFills,
            formHead,
            fields
        );
    }

    // ====================
    // FORMSIFY CONSTRUCTOR
    // ====================

    /**
     * @dev Formsify constructor
     */
    constructor(
        uint256 _maxFills,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _allowedTotalFills,
        string memory _formHead,
        string memory _fields
    ) {
        owner = msg.sender;
        fills = 0;
        maxFills = _maxFills;
        startTime = _startTime;
        endTime = _endTime;
        allowedTotalFills = _allowedTotalFills;
        formHead = _formHead;
        fields = _fields;
    }

    // ====================
    // FORMSIFY CONSTRUCTOR
    // ====================

    // ===================================
    // FORMSIFY DATA STORAGE AND RETRIEVAL
    // ===================================

    /**
     * @dev Structure of form's filled record
     */
    struct filledRecord {
        uint256[] fillIds;
        uint256 totalFills;
    }

    /**
     * @dev Mapping to track filled records of addresses
     */
    mapping(address => filledRecord) filledRecords;

    /**
     * @dev Structure of form's record
     */
    struct record {
        uint256 fillId;
        uint256 fillTimestamp;
        address fillAddress;
        string fillData;
    }

    /**
     * @dev Array of form records
     */
    record[] public records;

    /**
     * @dev Add new data to form
     * @param _fillData New data to be added
     */
    function addRecord(string memory _fillData) public {
        require(fills < maxFills, "Form has reached max fills!");
        require(block.timestamp < endTime, "Form has expired!");
        require(block.timestamp >= startTime, "Form hasn't started yet!");

        require(
            filledRecords[msg.sender].totalFills < allowedTotalFills,
            "You cannot fill any more entries!"
        );

        record memory _record;

        _record.fillId = fills;
        _record.fillTimestamp = block.timestamp;
        _record.fillAddress = msg.sender;
        _record.fillData = _fillData;

        records.push(_record);

        filledRecords[msg.sender].fillIds.push(fills);
        filledRecords[msg.sender].totalFills++;

        fills++;
    }

    /**
     * @dev Get all form records
     */
    function getRecords() public view returns (record[] memory) {
        return records;
    }

    // ===================================
    // FORMSIFY DATA STORAGE AND RETRIEVAL
    // ===================================
}
