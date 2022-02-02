<template>
  <div class="home">
    <input type="text" v-model="formInput.name">
    <input type="text" v-model="formInput.price">
    <input type="text" v-model="formInput.description">
    <input type="file" accept="file/*" @change="onChange($event)" id="file-input">
    <input type="submit" @click="createItem()">

  </div>
</template>

<script>
import { ethers } from 'ethers'
import ipfs from '@/middleware/ipfs'
import Market from '../../artifacts/contracts/NFTMarket.sol/NFTMarket.json'
import NFT from '../../artifacts/contracts/NFT.sol/NFT.json'
import Web3Modal from 'web3modal'
import { nftmarketaddress, nftaddress } from '../../config.js'

export default {
  name: 'Home',
  components: {
  },
  data () {
    return {
      fileUrl: null,
      setFileUrl: null,
      formInput: {
        price: '',
        name: '',
        description: ''
      },
      updateFormInput: {
        price: '',
        name: '',
        description: ''
      }
    }
  },
  methods: {
    async onChange (e) {
      const file = e.target.files[0]
      try {
        const added = await ipfs.add(file)
        console.log(added)
        const url = `https://ipfs.infura.io/ipfs/${added.path}`
        this.setFileUrl = url
      } catch (error) {
        console.log(error)
      }
    },
    async createItem () {
      const { name, description } = this.formInput
      const data = JSON.stringify({
        name, description, image: this.setFileUrl
      })
      try {
        const added = await ipfs.add(data)
        const url = `https://ipfs.infura.io/ipfs/${added.path}`
        this.createSale(url)
      } catch (e) {
        console.log(e)
      }
    },
    async createSale (url) {
      const web3modal = new Web3Modal()
      const connection = await web3modal.connect()
      const provider = new ethers.providers.Web3Provider(connection)
      const signer = provider.getSigner()

      let contract = new ethers.Contract(nftaddress, NFT.abi, signer)
      let transaction = await contract.createToken(url)
      const tx = await transaction.wait()
      const event = tx.events[0]
      const value = event.args[2]
      const tokenId = value.toNumber()
      const price = ethers.utils.parseUnits(this.formInput.price, 'ether')
      contract = new ethers.Contract(nftmarketaddress, Market.abi, signer)

      let listingPrice = await contract.getListingPrice()
      listingPrice = listingPrice.toString()

      transaction = await contract.createMarketItem(
        nftaddress, tokenId, price, { value: listingPrice }
      )
      console.log('wait 2')
      await transaction.wait()
      this.$router.push('/')
    }
  }
}
</script>
