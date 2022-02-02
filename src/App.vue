<template>
  <div id="app">
    <div id="nav">
      <navigation-bar></navigation-bar>
    </div>
    <router-view/>
    <Footer />
  </div>
</template>
<script>
import NavigationBar from '@/components/NavigationBar'
import Footer from '@/components/Footer'
export default {
  name: 'App',
  components: {
    NavigationBar,
    Footer
  }
}
</script>
