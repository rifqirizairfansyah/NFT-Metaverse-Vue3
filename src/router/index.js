import { createRouter, createWebHashHistory } from 'vue-router'
import Home from '../views/Home.vue'
import Upload from '../views/UploadNFT.vue'
import Creator from '../views/Creator-Dashboard.vue'
import Assets from '../views/My-Assets.vue'
import Product from '../views/Product-Review'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/upload',
    name: 'upload',
    component: Upload
  },
  {
    path: '/assets',
    name: 'assets',
    component: Assets
  },
  {
    path: '/creator',
    name: 'creator',
    component: Creator
  },
  {
    path: '/product-review/:id',
    name: 'product',
    component: Product
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
