// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import "./NFT.sol";

contract NFTMarket is ReentrancyGuard {
  using Counters for Counters.Counter;
  Counters.Counter private _itemIds;
  Counters.Counter private _itemsSold;

  address payable owner;
  uint256 listingPrice = 0.025 ether;
  enum TypeItems {Item, Land}

  constructor () {
      owner = payable(msg.sender);
  }

  struct MarketItem {
    uint itemId;
    address nftContract;
    uint256 tokenId;
    address payable creator;
    address payable seller;
    address payable owner;
    uint256 price;
    bool sold;
    TypeItems typeItems;
  }

  struct Land {
    uint landId;
    uint256 x;
    uint256 y;
  }

  Land[] lands;
  mapping (uint256 => Land) private idLandItem;
  mapping (uint256 => MarketItem) private idToMarketItem;
  mapping (uint256 => Land[]) private marketIdToLands;

  event MarketItemCreated (
    uint indexed itemId,
    address indexed nftContract,
    uint256 indexed tokenId,
    address payable creator,
    address payable seller,
    address payable owner,
    uint256 price,
    bool sold,
    TypeItems typeItems
  );

  modifier onlyItemOwner(uint256 id) {
    require(
        idToMarketItem[id].owner == msg.sender,
        "Only product owner can do this operation"
    );
    _;
  }

  event ProductListed(
    uint256 indexed itemId
  );

  function getListingPrice () public view returns (uint256) {
    return listingPrice;
  }

  function createMarketItem (
    address nftContract,
    uint256 tokenId,
    uint256 price,
    TypeItems typeItems,
    Land[] memory land
  ) public payable nonReentrant {
    require(price > 0, "Price must be more than 0");

    _itemIds.increment();
    uint256 itemId = _itemIds.current();

    for (uint j = 0; j < land.length; j++) {
        marketIdToLands[itemId].push(land[j]);
    }

    idToMarketItem[itemId] = MarketItem(
      itemId,
      nftContract,
      tokenId,
      payable(msg.sender),
      payable(msg.sender),
      payable(address(0)),
      price,
      false,
      typeItems
    );

    IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

    emit MarketItemCreated(itemId, nftContract, tokenId, payable(msg.sender), payable(msg.sender), payable(address(0)), price, false, typeItems);

  }
  function checkLand(uint256 itemId) public view returns (Land[] memory) {
      return marketIdToLands[itemId];
  }

  function getLandLength() public view returns (Land[] memory) {
    uint currentIndex = 0;

    Land[] memory items = new Land[] (2);
    for (uint i = 0; i < lands.length; i++) {
      if (idToMarketItem[i + 1].owner == address(0)) {
        uint currentId = idLandItem[i + 1].landId;
        Land storage currentItem = lands[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }

    return items;
  }
  
  function createMarketSale(
    address nftContract,
    uint256 itemId
  ) public payable nonReentrant {
    uint price = idToMarketItem[itemId].price;
    uint tokenId = idToMarketItem[itemId].tokenId;

    require(msg.value == price, "Please submit asking price");
    idToMarketItem[itemId].seller.transfer(msg.value);
    IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
    idToMarketItem[itemId].owner = payable(msg.sender);
    idToMarketItem[itemId].sold = true;
    _itemsSold.increment();
    payable(owner).transfer(listingPrice);
  }

  function putItemToResell(address nftContract, uint256 itemId, uint256 newPrice)
    public payable nonReentrant onlyItemOwner(itemId) {
      uint256 tokenId = idToMarketItem[itemId].tokenId;
      require(newPrice > 0, "Price must be at least 1 wei");
      require(
        msg.value == listingPrice,
        "Price must be equal to listing price"
    );
    //instantiate a NFT contract object with the matching type
    NFT tokenContract = NFT(nftContract);
    //call the custom transfer token method   
    tokenContract.transferToken(msg.sender, address(this), tokenId);

    address oldOwner = idToMarketItem[itemId].owner;
    idToMarketItem[itemId].owner = payable(address(0));
    idToMarketItem[itemId].seller = payable(oldOwner);
    idToMarketItem[itemId].price = newPrice;
    idToMarketItem[itemId].sold = false;
    _itemsSold.decrement();

    emit ProductListed(itemId);
  }

  function fetchMarketItems() public view returns (MarketItem[] memory) {
    uint itemCount = _itemIds.current();
    uint unsoldItemCount = _itemIds.current() - _itemsSold.current();
    uint currentIndex = 0;

    MarketItem[] memory items = new MarketItem[] (unsoldItemCount);
    for (uint i = 0; i < itemCount; i++) {
      if (idToMarketItem[i + 1].owner == address(0)) {
        uint currentId = idToMarketItem[i + 1].itemId;
        MarketItem storage currentItem = idToMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }
  
  function fetchItemsById(uint256 itemId) public view returns (MarketItem[] memory) {
    uint itemCount = _itemIds.current();
    uint unsoldItemCount = _itemIds.current() - _itemsSold.current();
    uint currentIndex = 0;

    MarketItem[] memory items = new MarketItem[] (unsoldItemCount);
    for (uint i = 0; i < itemCount; i++) {
      if (idToMarketItem[i + 1].owner == address(0)) {
          MarketItem storage currentItem = idToMarketItem[itemId];
          items[currentIndex] = currentItem;
          currentIndex += 1;
      }
    }
    return items;
  }

  function fetchMyNFTs() public view returns (MarketItem[] memory) {
    uint totalItemCount = _itemIds.current();
    uint itemCount = 0;
    uint currentIndex = 0;

    for (uint i = 0; i < totalItemCount; i++) {
      if (idToMarketItem[i + 1].owner == msg.sender) {
        itemCount += 1;
      }
    }
    
    MarketItem[] memory items = new MarketItem[] (itemCount);
    
    for (uint i = 0; i < totalItemCount; i++) {
      if (idToMarketItem[i + 1].owner == msg.sender) {
        uint currentId = idToMarketItem[i + 1].itemId;
        MarketItem storage currentItem = idToMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1; 
      }
    }
    return items;
  }

  function fetchItemsCreated() public view returns (MarketItem[] memory) {
    uint totalItemCount = _itemIds.current();
    uint itemCount = 0;
    uint currentIndex = 0;

    for (uint i = 0; i < totalItemCount; i++) {
      if (idToMarketItem[i + 1].seller == msg.sender) {
        itemCount += 1;
      }
    }

    MarketItem[] memory items = new MarketItem[] (itemCount);
    
    for (uint i = 0; i < totalItemCount; i++) {
      if (idToMarketItem[i + 1].seller == msg.sender) {
        uint currentId = idToMarketItem[i + 1].itemId;
        MarketItem storage currentItem = idToMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1; 
      }
    }
    return items;
  }
}
