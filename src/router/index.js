import { createWebHistory, createRouter } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import LoginView from '../views/LoginView.vue'
import RegisterView from '@/views/RegisterView.vue'

import AdminView from '@/views/AdminView.vue'
import AdminRutas from '@/views/AdminRutasView.vue'
import AdminCreaRutasView from '@/views/AdminCreaRutasView.vue'
import AdminRutasView from '@/views/AdminRutasView.vue'
import RutasView from '@/views/RutasView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView
    },
    {
      path: '/register',
      name: 'Register',
      component: RegisterView
    },
    {
      path: '/admin',
      name: 'Admin',
      component: AdminView
    },
    {
      path: '/admin/rutas',
      name: 'AdminRutas',
      component: AdminRutasView

    },
    {
      path: '/admin/rutas/CrearRuta',
      name: 'CrearRuta',
      component: AdminCreaRutasView
    }, 
    {
      path: '/rutas/:id',
      name: 'ruta',
      component: RutasView 
    },
  ],
    
})

export default router
