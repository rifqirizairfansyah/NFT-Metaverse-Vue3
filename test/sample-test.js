describe("NFTMarket", function() {
  it("Should create and execute market sales", async function() {
    /* deploy the marketplace */
    const Market = await ethers.getContractFactory("NFTMarket")
    const market = await Market.deploy()
    await market.deployed()
    const marketAddress = market.address

    /* deploy the NFT contract */
    const NFT = await ethers.getContractFactory("NFT")
    const nft = await NFT.deploy(marketAddress)
    await nft.deployed()
    const nftContractAddress = nft.address

    let listingPrice = await market.getListingPrice()
    listingPrice = listingPrice.toString()

    const auctionPrice = ethers.utils.parseUnits('1', 'ether')

    /* create two tokens */
    await nft.createToken("https://www.mytokenlocation.com")
    await nft.createToken("https://www.mytokenlocation2.com")

    /* put both tokens for sale */
    await market.createMarketItem(nftContractAddress, 1, auctionPrice, 0, 2, { value: listingPrice })
    await market.createMarketItem(nftContractAddress, 2, auctionPrice, 1, 5, { value: listingPrice })

    const [_, buyerAddress] = await ethers.getSigners()

    // /* execute sale of token to another user */
    // await market.connect(buyerAddress).createMarketSale(nftContractAddress, 2, { value: auctionPrice})

    /* query for and return the unsold items */
    // items = await market.fetchItemsById(2)
    items = await market.fetchMarketItems()
    lands = await market.getLandLength()

    lands = await Promise.all(lands.map(async i => {
      // console.log(i)
      let item = {
        id: i.landId.toString(),
        x: i.x.toString(),
        y: i.y.toString()
      }
      return item
    }))

    console.log(lands)
    items = await Promise.all(items.map(async i => {
      // console.log(i)
      const tokenUri = await nft.tokenURI(i.tokenId)
      let item = {
        price: i.price.toString(),
        tokenId: i.tokenId.toString(),
        seller: i.seller,
        owner: i.owner,
        tokenUri,
        typeItems: i.typeItems.toString(),
        land: i.land
      }
      return item
    }))
    console.log('items: ', items)
  })
})