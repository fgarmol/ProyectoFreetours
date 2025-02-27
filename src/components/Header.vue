<script setup>
import { ref } from 'vue';
import router from '@/router';

const props = defineProps({
  title: String,
  usuarioAutenticado: Object
});
const emit = defineEmits(["sesionCerrada"]);

function cerrarSesion() {
  emit('sesionCerrada', null);
  router.push('/');
}
</script>

<template>
  <header class="header bg-dark text-white">
    <div class="container d-flex align-items-center justify-content-between">
      <div class="logo d-flex align-items-center">
        <img src="@/assets/img/logo.png" alt="Logo" class="logo-image me-2" @click="router.push('/')" >
        <h1 class="mb-0">{{ title }}</h1>
      </div>
      <div class="actions d-flex align-items-center">
        <router-link to="/login" class="btn btn-success ms-auto" v-if="!usuarioAutenticado.autenticado && $route.path !== '/login'">
          Iniciar sesión
        </router-link>

        <router-link to="/register" class="btn btn-success ms-2" v-if="!usuarioAutenticado.autenticado && $route.path === '/login'">
          Registrarse
        </router-link>

        <div v-if="usuarioAutenticado.autenticado" class="d-flex align-items-center justify-content-end">
          <span class="me-3">Bienvenido, {{ usuarioAutenticado.usuario.nombre }} ({{ usuarioAutenticado.usuario.rol }})</span>
          <button @click.prevent="cerrarSesion" class="btn btn-danger">Cerrar Sesión</button>
        </div>
      </div>
    </div>
  </header>
</template>

<style scoped>
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  background-color: #f8f8f8;
}

.logo {
  font-size: 1.5rem;
  font-weight: bold;
}

.logo-image {
  width: 60px;
  height: auto;
  margin-right: 1rem;
}

.actions {
  display: flex;
  align-items: center;
}
.container {
  max-width: none !important;
  margin: 0 ;
  padding-bottom: 0;
}
</style>