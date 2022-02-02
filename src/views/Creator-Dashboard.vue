<template>
  <div class="home">
    {{setNfts}}
    {{setSold}}
  </div>
</template>

<script>
import NFT from '../../artifacts/contracts/NFT.sol/NFT.json'
import Market from '../../artifacts/contracts/NFTMarket.sol/NFTMarket.json'
import { nftaddress, nftmarketaddress } from '../../config.js'
import { ethers } from 'ethers'
import axios from 'axios'
import Web3Modal from 'web3modal'

export default {
  name: 'Home',
  components: {
  },
  data () {
    return {
      nfts: [],
      setNfts: [],
      sold: [],
      setSold: []
    }
  },
  mounted () {
    this.loadNFTs()
  },
  methods: {
    async loadNFTs () {
      const web3modal = new Web3Modal()
      const connection = await web3modal.connect()
      const provider = new ethers.providers.Web3Provider(connection)
      const signer = provider.getSigner()

      const marketContract = new ethers.Contract(nftmarketaddress, Market.abi, signer)
      const tokenContract = new ethers.Contract(nftaddress, NFT.abi, provider)
      const data = await marketContract.fetchItemsCreated()

      const items = await Promise.all(data.map(async i => {
        const tokenUri = await tokenContract.tokenURI(i.tokenId)
        const meta = await axios.get(tokenUri)
        const price = ethers.utils.formatUnits(i.price.toString(), 'ether')
        const item = {
          price,
          tokenId: i.tokenId.toNumber(),
          seller: i.seller,
          owner: i.owner,
          sold: i.sold,
          image: meta.data.image
        }
        return item
      }))
      /* create a filtered array of items that have been sold */
      const soldItems = items.filter(i => i.sold)
      this.setSold = soldItems
      this.setNfts = items
    }
  }
}
</script>
