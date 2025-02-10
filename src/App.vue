<script setup>
import Content from './components/Content.vue';
import Card from './components/Card.vue';
import Header from './components/Header.vue';
import Footer from './components/Footer.vue';
import NavBar from './components/NavBar.vue';
import { ref } from 'vue';
import router from './router';

// Inicializar la sesión como un objeto vacío
const sesion = ref({ autenticado: false, usuario: null });

function actualizaDatosSesion(usuario) {
  if (usuario) {
    sesion.value = { autenticado: true, usuario: usuario };
  } else {
    sesion.value = { autenticado: false, usuario: null };
  }
}
</script>

<template>
  <div class="layout">
    <Header :usuarioAutenticado="sesion" @sesionCerrada="actualizaDatosSesion" title="Aplicacion Juana" />
    <NavBar :datos="sesion" />
    <RouterView :usuarioAutenticado="sesion" @sesionIniciada="actualizaDatosSesion"></RouterView>
    <Footer />
  </div>
</template>

<style scoped>
.layout {
  display: flex;
  flex-direction: column;
  height: 100vh;
}
</style>