<script setup>
import Content from './components/Content.vue';
import Card from './components/Card.vue';
import Header from './components/Header.vue';
import Footer from './components/Footer.vue';
import NavBar from './components/NavBar.vue';
import { ref } from 'vue';
import router from './router';



const sesion = ref({ autenticado: false, usuario: null });
if (localStorage.getItem('sesion')) {
  sesion.value = JSON.parse(localStorage.getItem('sesion'));
}



// Función para actualizar los datos de la sesión
function actualizaDatosSesion(usuario) {
  if (usuario) {
    sesion.value = { autenticado: true, usuario: usuario };
    localStorage.setItem('sesion', JSON.stringify(sesion.value));
  } else {
    sesion.value = { autenticado: false, usuario: null };
    localStorage.removeItem('sesion');
  }
}
</script>

<template>
  <div class="layout">
    <Header :usuarioAutenticado="sesion" @sesionCerrada="actualizaDatosSesion" title="HERMES" />
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