<template>
  <div class="home">
    {{setNfts}}
  </div>
</template>

<script>
import NFT from '../../artifacts/contracts/NFT.sol/NFT.json'
import Market from '../../artifacts/contracts/NFTMarket.sol/NFTMarket.json'
import { nftaddress, nftmarketaddress } from '../../config.js'
import { ethers } from 'ethers'
import axios from 'axios'
import Web3Modal from 'web3modal'
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader'

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
      scene.add(new THREE.AxesHelper(5))

      const light = new THREE.SpotLight()
      light.position.set(5, 5, 5)
      scene.add(light)

      const camera = new THREE.PerspectiveCamera(
        75,
        window.innerWidth / window.innerHeight,
        0.1,
        1000
      )
      camera.position.z = 2

      const renderer = new THREE.WebGLRenderer()
      // renderer.physicallyCorrectLights = true
      // renderer.shadowMap.enabled = true
      // renderer.outputEncoding = THREE.sRGBEncoding
      renderer.setSize(window.innerWidth, window.innerHeight)
      document.body.appendChild(renderer.domElement)

      const controls = new OrbitControls(camera, renderer.domElement)
      controls.enableDamping = true

      const loader = new GLTFLoader()
      loader.load(
        'models/monkey.glb',
        function (gltf) {
          scene.add(gltf.scene)
        },
        (xhr) => {
          console.log((xhr.loaded / xhr.total) * 100 + '% loaded')
        },
        (error) => {
          console.log(error)
        }
      )
    },
    async loadNFTs () {
      const web3modal = new Web3Modal()
      const connection = await web3modal.connect()
      const provider = new ethers.providers.Web3Provider(connection)
      const signer = provider.getSigner()

      const tokenContract = new ethers.Contract(nftaddress, NFT.abi, signer)
      const marketContract = new ethers.Contract(nftmarketaddress, Market.abi, signer)
      const data = await marketContract.fetchMyNFTs()

      const items = await Promise.all(data.map(async i => {
        const tokenUri = await tokenContract.tokenURI(i.tokenId)
        const meta = await axios.get(tokenUri)
        const price = ethers.utils.formatUnits(i.price.toString(), 'ether')
        const item = {
          price,
          tokenId: i.tokenId.toNumber(),
          seller: i.seller,
          owner: i.owner,
          image: meta.data.image,
          name: meta.data.name,
          description: meta.data.description
        }
        return item
      }))
      this.setNfts = items
      console.log(this.setNfts)
    }
  }
}
</script>
