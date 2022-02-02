<template>
  <div class="mx-auto pt-6 px-4 sm:pt-24 sm:px-6 lg:max-w-7xl lg:px-8">
    <div class="lg:grid lg:grid-cols-8 lg:gap-x-8 lg:gap-y-10 xl:gap-x-16">
      <div class="lg:col-span-4">
        <div class="aspect-w-4 aspect-h-3 rounded-lg bg-gray-100 overflow-hidden">
          <img src="https://cdn.vox-cdn.com/thumbor/2xj1ySLIz1EZ49NvSsPzq8Itjyg=/1400x1050/filters:format(jpeg)/cdn.vox-cdn.com/uploads/chorus_asset/file/23084330/bored_ape_nft_accidental_.jpg" class="object-center object-cover" alt="">
          <Menu as="div" class="relative inline-block text-left">
            <div>
              <MenuButton class="inline-flex justify-center rounded-md border m-3 border-gray-300 shadow-sm px-4 py-2 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-100 focus:ring-indigo-500">
                Preview
                <ChevronDownIcon class="-mr-1 ml-2 h-5 w-5" aria-hidden="true" />
              </MenuButton>
            </div>

            <transition enter-active-class="transition ease-out duration-100" enter-from-class="transform opacity-0 scale-95" enter-to-class="transform opacity-100 scale-100" leave-active-class="transition ease-in duration-75" leave-from-class="transform opacity-100 scale-100" leave-to-class="transform opacity-0 scale-95">
              <MenuItems class="origin-top-right absolute left-0 m-3 mt-2 w-56 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 focus:outline-none">
                <div class="py-1">
                  <MenuItem v-slot="{ active }">
                    <a href="#" :class="[active ? 'bg-gray-100 text-gray-900' : 'text-gray-700', 'block px-4 py-2 text-sm']">Preview</a>
                  </MenuItem>
                  <MenuItem v-slot="{ active }">
                    <a href="#" :class="[active ? 'bg-gray-100 text-gray-900' : 'text-gray-700', 'block px-4 py-2 text-sm']">3D Viewer</a>
                  </MenuItem>
                </div>
              </MenuItems>
            </transition>
          </Menu>
        </div>
      </div>
      <div class="max-w-2x1 max-auto mt-14 sm:mt-16 lg:max-w-none lg:mt-0 lg:col-span-4">
        <div class="flex flex-col-reverse">
          <div>
            <h1 class="text-2xl font-extrabold tracking-tight text-gray-900 sm:text-3x1">
              Product Name
            </h1>
            <h2 class="sr-only">
              Product Information
            </h2>
            <p class="text-sm text-gray-500 mt-2">
              Owned By <a href="#"><span class="text-blue-500 font-bold hover:text-blue-700">User#434</span></a>
            </p>
          </div>
        </div>
        <p class="text-gray-500 mt-6">
         Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec gravida tellus tortor, Donec auctor, turpis nec pretium scelerisque, justo dolor venenatis purus, in suscipit sem nulla et arcu. Cras suscipit sem dui, fermentum egestas libero aliquet vel. Duis tincidunt vestibulum ante, tincidunt mattis tortor mattis et. Nulla sodales ex vel magna tempor, sit amet blandit nisl lacinia. Donec placerat rutrum ultrices. Nam vel scelerisque massa. Donec ornare nibh nec mattis hendrerit.
        </p>
        <div class="mt-10 grid grid-cols-1 gap-x-6 gap-y-4 sm:grid-cols-2">
          <button class="w-full bg-gray-900 border border-transparent rounded-md py-3 px-8 flex items-center justify-center text-base font-medium text-white hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-50 focus:ring-gray-500">
            Pay
          </button>

          <button class="w-full bg-white border rounded-md py-3 px-8 flex items-center justify-center text-base font-medium text-gray-900 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-50 focus:ring-gray-500">
            Preview
          </button>
        </div>

        <div class="border-t border-gray-200 mt-10 pt-10">
          <h3 class="text-sm font-medium text-gray-900">Lisence</h3>
          <p class="mt-4 text-sm text-gray-500">
            Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy
            <a href="#" class="font-medium text-gray-900 hover:text-gray-700">Read full lisence</a>
          </p>
        </div>
      </div>
    </div>

    <div class="max-w-21 mx-auto mt-24 sm:mt-32 lg:max-w-none">
      <div class="flex items-center justify-between space-x-4">
        <h2 class="text-lg font-medium text-gray-900">Customer Also View</h2>
        <a href="#" class="whitespace-nowrap text-sm font-medium text-gray-900 hover:text-gray-700">
          view all <span aria-hidden="true"></span>
        </a>
      </div>
    </div>
    <div class="mt-6 grid grid-cols-1 gap-x-8 gap-y-8 sm:grid-cols-2 sm:gap-y-10 lg:grid-cols-4">
      <div v-for="item in items" v-bind:key="item.key" class="relative group">
        <div class="aspect-w-4 aspect-h-3 rounded-lg overflow-hidden bg-gray-100">
          <img
            src="https://images.squarespace-cdn.com/content/v1/54e8b0b7e4b0b080e157fdeb/1630950384521-69GCDGGKQN1Z1MKFIINE/StephenTompkins_Typhon_lo.jpg"
            class="object-center object-cover group-hover:opacity-75">
        </div>
        <div class="mt-4 flex items-center justify-between text-base font-medium text-gray-900 space-x-8">
          <h3>
            <a href=""><span aria-hidden="true">Product Name</span></a>
          </h3>
          <p>price</p>
        </div>
        <p class="mt-1 text-sm text-gray-500">Tags</p>
        {{setNfts}}
      </div>
    </div>
  </div>
</template>
<script>
import NFT from '../../artifacts/contracts/NFT.sol/NFT.json'
import Market from '../../artifacts/contracts/NFTMarket.sol/NFTMarket.json'
import { nftaddress, nftmarketaddress, rpcurl } from '../../config.js'
import { ethers } from 'ethers'
import axios from 'axios'
import { Menu, MenuButton, MenuItem, MenuItems } from '@headlessui/vue'
import { ChevronDownIcon } from '@heroicons/vue/solid'
export default {
  data () {
    return {
      items: [1, 2, 3, 4],
      nfts: [],
      setNfts: []
    }
  },
  components: {
    Menu,
    MenuButton,
    MenuItem,
    MenuItems,
    ChevronDownIcon,
  },
  methods: {
    async loadNFTsById (nft) {
      const provider = new ethers.providers.JsonRpcProvider(rpcurl)
      const tokenContract = new ethers.Contract(nftaddress, NFT.abi, provider)
      const marketContract = new ethers.Contract(nftmarketaddress, Market.abi, provider)
      const data = await marketContract.fetchItemsById(nft)
      console.log(data)
      await Promise.all(data.map(async i => {
        const tokenUri = await tokenContract.tokenURI(i.tokenId)
        const meta = await axios.get(tokenUri)
        const price = ethers.utils.formatUnits(i.price.toString(), 'ether')
        const item = {
          price,
          tokenId: i.tokenId.toNumber(),
          seller: i.seller,
          owner: i.owner,
          creator: i.creator,
          image: meta.data.image,
          name: meta.data.name,
          description: meta.data.description
        }
        this.setNfts.push(item)
      }))
    },
  },
  mounted () {
    console.log()
    this.loadNFTsById(this.$route.params.id)
  }
}
</script>
