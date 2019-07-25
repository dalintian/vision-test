import Vue from 'vue'
import Router from 'vue-router'
// import HelloWorld from '@/components/HelloWorld'
import UserInfo from '@/components/UserInfo.vue'
import ImageInfo from '@/components/ImageInfo.vue'
import DataStatic from '@/components/DataStatic.vue'
import TestSubmit from '@/components/TestSubmit.vue'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/image',
      name: 'ImageInfo',
      component: ImageInfo,
      props: (route) => ({
        name: route.query.name,
        age: route.query.age
      })
    },
    {
      path: '/',
      name: 'UserInfo',
      component: UserInfo
    },
    {
      path: '/data',
      name: 'DataStatic',
      component: DataStatic
    },
    {
      path: '/test',
      name: 'TestSubmit',
      component: TestSubmit
    }
  ]
})
