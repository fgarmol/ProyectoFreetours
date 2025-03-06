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
  <header class="header">
    <div class="container d-flex align-items-center justify-content-between position-relative">
      <div class="logo-container d-flex align-items-center">
        <img src="@/assets/img/logo.png" alt="Logo" class="logo-image me-2" @click="router.push('/')" >
      </div>
      <h1 class="title mb-0">{{ title }}</h1>
      <div class="actions d-flex align-items-center">
        <router-link to="/login" class="btn btn-login ms-auto hover-shadow" v-if="!usuarioAutenticado.autenticado && $route.path !== '/login'">
          Iniciar sesión
        </router-link>

        <router-link to="/register" class="btn btn-success ms-2" v-if="!usuarioAutenticado.autenticado && $route.path === '/login'">
          Registrarse
        </router-link>

        <div v-if="usuarioAutenticado.autenticado" class="d-flex align-items-center justify-content-end">
          <span class="bienvenido-text me-3">Bienvenido, {{ usuarioAutenticado.usuario.nombre }} ({{ usuarioAutenticado.usuario.rol }})</span>
          <button @click.prevent="cerrarSesion" class="btn btn-danger">Cerrar Sesión</button>
        </div>
      </div>
    </div>
  </header>
</template>

<style scoped>

.header {
  padding: 15px 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: relative;
  box-shadow: inset 0 -1px 0 0 rgba(0, 0, 0, 0.1);
  background-color: white; /* Fondo blanco */
  color: black; /* Texto negro */
}

.logo-container {
  display: flex;
  align-items: center;
}

.logo-image {
  height: 70px; /* Ajustado a height: 70px */
  margin-right: 1rem;
  cursor: pointer;
  transition: transform 0.3s ease; /* Transición suave */
}

.logo-image:hover {
  transform: scale(1.1); /* Efecto de zoom al pasar el ratón */
}

.title {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  font-size: 1.5rem;
  font-weight: bold;
  color: black; /* Texto negro */
  white-space: nowrap; /* Evita que el título se divida en varias líneas */
}

.actions {
  display: flex;
  align-items: center;
}

.btn-login, .btn-success, .btn-danger {
  transition: background-color 0.3s ease, color 0.3s ease, opacity 0.3s ease;
  font-weight: bold;
  background-color: black; /* Fondo negro */
  color: white; /* Texto blanco */
  border: none; /* Sin borde */
}

.btn-login:hover, .btn-success:hover, .btn-danger:hover {
  opacity: 0.8;
  background-color: white; /* Fondo blanco al pasar el ratón */
  color: black; /* Texto negro al pasar el ratón */
  font-weight: bolder;
}

.btn-login:active, .btn-success:active, .btn-danger:active {
  background-color: black;
  color: white;
  box-shadow: inset 1px 1px 30px white;
}

.container {
  max-width: none !important;
  margin: 0;
  padding-bottom: 0;
}
@media (max-width: 1130px){
  .bienvenido-text{
    display: none;
  }
}
/* Media query para ajustar el diseño en pantallas pequeñas */
@media (max-width: 768px) {
  .header {
    flex-direction: column;
    align-items: flex-start;
  }

  .title {
    position: static;
    transform: none;
    margin-bottom: 10px;
  }

  .actions {
    width: 100%;
    justify-content: flex-end;
  }

  .bienvenido-text {
    display: none;
  }
}
</style>