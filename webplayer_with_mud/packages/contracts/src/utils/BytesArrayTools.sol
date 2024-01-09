pragma solidity >=0.8.21;


library BytesArrayTools {

    function findElementIndex(bytes32[] memory array, bytes32 target) private pure returns (uint256) {
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == target) {
                return i;
            }
        }
        return array.length;
    }

    function removeElementFromArray(bytes32[] memory array, bytes32 target) internal pure returns (bytes32[] memory) {
        uint256 index = findElementIndex(array, target);
        if (index >= array.length) {
            return array;
        }

        bytes32[] memory newArray = new bytes32[](array.length - 1);
        for (uint256 i = 0; i < array.length; i++) {
            if (i < index) {
                newArray[i] = array[i];
            } else if (i > index) {
                newArray[i - 1] = array[i];
            }
        }
        return newArray;
    }

    function Shuffle(bytes32[] memory array) internal view returns (bytes32[] memory) {
        uint256 arrSize = array.length;
        bytes32[] memory shuffled = new bytes32[](arrSize);

        // Copy the original deck to the shuffled deck array
        for (uint256 i = 0; i < arrSize; i++) {
            shuffled[i] = array[i];
        }

        // Shuffle the deck using Fisher-Yates algorithm
        for (uint256 i = arrSize - 1; i > 0; i--) {
            uint256 j = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, i))) % (i + 1);
            bytes32 temp = shuffled[i];
            shuffled[i] = shuffled[j];
            shuffled[j] = temp;
        }

        return shuffled;
    }
}