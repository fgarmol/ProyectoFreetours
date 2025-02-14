<script setup>
import { ref } from 'vue';
import router from '@/router';

const props = defineProps({
  title: String,
  usuarioAutenticado: Object
});
const emit = defineEmits(["sesionCerrada"]);

function cerrarSesion() {
  // Emitir el evento para notificar al componente padre que la sesión se ha cerrado
  emit('sesionCerrada', null);
  // Redirigir al usuario a la página de inicio
  router.push('/');
}
</script>

<template>
  <header class="header bg-dark text-white p-3">
    <div class="container d-flex justify-content-between align-items-center">
      <div class="logo">
        <h1>{{ title }}</h1>
      </div>
      <nav class="nav">
        <router-link to="/" class="nav-link">Inicio</router-link>
        <router-link to="/paises" class="nav-link">Países</router-link>
        <router-link to="/ciudades" class="nav-link">Ciudades</router-link>
      </nav>
      <div class="actions d-flex align-items-center">
        <select class="currency-selector form-select me-2">
          <option value="EUR">EUR</option>
          <option value="USD">USD</option>
          <option value="GBP">GBP</option>
        </select>
        <button class="btn btn-primary me-2">Convertirse en Guía</button>
        <router-link to="/login" class="btn btn-success me-2" v-if="!usuarioAutenticado.autenticado">Iniciar sesión</router-link>
        <div v-if="usuarioAutenticado.autenticado" class="d-flex align-items-center">
          <span class="me-2">Bienvenido, {{ usuarioAutenticado.usuario.nombre }} ({{ usuarioAutenticado.usuario.rol }})</span>
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

.nav {
  display: flex;
  gap: 1rem;
}

.actions {
  display: flex;
  gap: 1rem;
}

.currency-selector {
  margin-right: 1rem;
}
</style>