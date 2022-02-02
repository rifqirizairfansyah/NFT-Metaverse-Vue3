<template>
  <div class="home">
    <div class="relative bg-white overflow-hidden">
    <div class="pt-16 pb-80 sm:pt-24 sm:pb-40 lg:pt-40 lg:pb-48">
      <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 sm:static">
        <div class="sm:max-w-lg">
          <h1 class="text-4xl font font-extrabold tracking-tight text-gray-900 sm:text-6xl">
            Summer styles are finally here
          </h1>
          <p class="mt-4 text-xl text-gray-500">This year, our new summer collection will shelter you from the harsh elements of a world that doesn't care if you live or die.</p>
        </div>
        <div>
          <div class="mt-10">
            <!-- Decorative image grid -->
            <div aria-hidden="true" class="pointer-events-none lg:absolute lg:inset-y-0 lg:max-w-7xl lg:mx-auto lg:w-full">
              <div class="absolute transform sm:left-1/2 sm:top-0 sm:translate-x-8 lg:left-1/2 lg:top-1/2 lg:-translate-y-1/2 lg:translate-x-8">
                <div class="flex items-center space-x-6 lg:space-x-8">
                  <div class="flex-shrink-0 grid grid-cols-1 gap-y-6 lg:gap-y-8">
                    <div class="w-44 h-64 rounded-lg overflow-hidden sm:opacity-0 lg:opacity-100">
                      <img src="https://tailwindui.com/img/ecommerce-images/home-page-03-hero-image-tile-01.jpg" alt="" class="w-full h-full object-center object-cover" />
                    </div>
                    <div class="w-44 h-64 rounded-lg overflow-hidden">
                      <img src="https://tailwindui.com/img/ecommerce-images/home-page-03-hero-image-tile-02.jpg" alt="" class="w-full h-full object-center object-cover" />
                    </div>
                  </div>
                  <div class="flex-shrink-0 grid grid-cols-1 gap-y-6 lg:gap-y-8">
                    <div class="w-44 h-64 rounded-lg overflow-hidden">
                      <img src="https://tailwindui.com/img/ecommerce-images/home-page-03-hero-image-tile-03.jpg" alt="" class="w-full h-full object-center object-cover" />
                    </div>
                    <div class="w-44 h-64 rounded-lg overflow-hidden">
                      <img src="https://tailwindui.com/img/ecommerce-images/home-page-03-hero-image-tile-04.jpg" alt="" class="w-full h-full object-center object-cover" />
                    </div>
                    <div class="w-44 h-64 rounded-lg overflow-hidden">
                      <img src="https://tailwindui.com/img/ecommerce-images/home-page-03-hero-image-tile-05.jpg" alt="" class="w-full h-full object-center object-cover" />
                    </div>
                  </div>
                  <div class="flex-shrink-0 grid grid-cols-1 gap-y-6 lg:gap-y-8">
                    <div class="w-44 h-64 rounded-lg overflow-hidden">
                      <img src="https://tailwindui.com/img/ecommerce-images/home-page-03-hero-image-tile-06.jpg" alt="" class="w-full h-full object-center object-cover" />
                    </div>
                    <div class="w-44 h-64 rounded-lg overflow-hidden">
                      <img src="https://tailwindui.com/img/ecommerce-images/home-page-03-hero-image-tile-07.jpg" alt="" class="w-full h-full object-center object-cover" />
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <a href="#" class="inline-block text-center bg-indigo-600 border border-transparent rounded-md py-3 px-8 font-medium text-white hover:bg-indigo-700">Shop Collection</a>
          </div>
        </div>
      </div>
    </div>
  </div>
    <div class="bg-white">
    <div class="max-w-2xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:max-w-7xl lg:px-8">
      <h2 class="text-2xl font-extrabold tracking-tight text-gray-900">Customers also purchased</h2>
      <div class="mt-6 grid grid-cols-1 gap-y-10 gap-x-6 sm:grid-cols-2 lg:grid-cols-4 xl:gap-x-8">
        <div class="group relative" v-for="item in setNfts" v-bind:key="item.tokenId">
          <div class="w-full min-h-80 bg-gray-200 aspect-w-1 aspect-h-1 rounded-md overflow-hidden group-hover:opacity-75 lg:h-80 lg:aspect-none">
            <img src="https://tailwindui.com/img/ecommerce-images/product-page-01-related-product-01.jpg" alt="Front of men&#039;s Basic Tee in black." class="w-full h-full object-center object-cover lg:w-full lg:h-full">
          </div>
          <div class="mt-4 flex justify-between">
            <div>
              <h3 class="text-sm text-gray-700">
                <router-link :to="`/product-review/${item.tokenId}`">
                  <span aria-hidden="true" class="absolute inset-0"></span>
                  {{item.name}}
                </router-link>
              </h3>
              <p class="mt-1 text-sm text-gray-500">{{item.description}}</p>
            </div>
            <p class="text-sm font-medium text-gray-900">{{item.price}} Matic</p>
          </div>
        </div>
      </div>
    </div>
  </div>
    {{setNfts}}
  </div>
</template>
<script>
import NFT from '../../artifacts/contracts/NFT.sol/NFT.json'
import Market from '../../artifacts/contracts/NFTMarket.sol/NFTMarket.json'
import { nftaddress, nftmarketaddress, rpcurl } from '../../config.js'
import { ethers } from 'ethers'
import axios from 'axios'
import Web3Modal from 'web3modal'
import * as THREE from 'three'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js'

export default {
  name: 'Home',
  components: {
  },
  data () {
    return {
      nfts: [],
      setNfts: []
    }
  },
  mounted () {
    this.loadNFTs()
    this.loadModel()
  },
  methods: {
    async loadModel () {
      const scene = new THREE.Scene()
      const loader = new GLTFLoader()
      let renderer = null
      let camera = null
      let mesh = null
      camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000)
      camera.position.z = 25
      camera.position.y = 15

      renderer = new THREE.WebGLRenderer()
      renderer.setSize(window.innerWidth, window.innerHeight)
      document.body.appendChild(renderer.domElement)
      renderer.setClearColor(0x00ffff, 1)
      renderer.gammaOutput = true
      renderer.gammaFactor = 2.2

      var light = new THREE.DirectionalLight('#c1582d', 1)
      var ambient = new THREE.AmbientLight('#85b2cd')
      light.position.set(0, -70, 100).normalize()
      scene.add(light)
      scene.add(ambient)

      // var light = new THREE.DirectionalLight('#c1582d', 1)
      // var ambient = new THREE.AmbientLight('#85b2cd')
      light.position.set(0, -70, 100).normalize()

      // var texture = new THREE.Texture()
      var manager = new THREE.LoadingManager()
      manager.onProgress = function (item, loaded, total) {
        console.log(item, loaded, total)
      }
      // var onProgress = function (xhr) {}
      // var onError = function (xhr) {}

      scene.add(light)
      scene.add(ambient)
      loader.load('https://ipfs.infura.io/ipfs/Qmcn7u9SVXktVtfB2yXMDh5XS8q333HsLyR6GosbEg1cZe?filename=TriLibSampleModel.glb', function (gltf) {
        mesh = gltf.scene
        mesh.scale.set(10, 10, 10)
        scene.add(mesh)
        // scene.add(gltf.scene)
        renderer.render(scene, camera)
      }, undefined, function (error) {
        console.error(error)
      })
    },
    async buyNFTs (nft) {
      const web3modal = new Web3Modal()
      const connection = await web3modal.connect()
      const provider = new ethers.providers.Web3Provider(connection)

      const signer = provider.getSigner()
      const contract = new ethers.Contract(nftmarketaddress, Market.abi, signer)

      const price = ethers.utils.parseUnits(nft.price.toString(), 'ether')
      const transaction = await contract.createMarketSale(nftaddress, nft.tokenId, {
        value: price
      })

      await transaction.wait()
      this.loadNFTs()
    },
    async loadNFTs () {
      const provider = new ethers.providers.JsonRpcProvider(rpcurl)
      const tokenContract = new ethers.Contract(nftaddress, NFT.abi, provider)
      const marketContract = new ethers.Contract(nftmarketaddress, Market.abi, provider)
      const data = await marketContract.fetchMarketItems()
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
    }
  }
}
</script>

<style scoped>
.card {
  box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
  transition: 0.3s;
  width: 40%;
}

.card:hover {
  box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);
}

.container {
  padding: 2px 16px;
}
</style>
