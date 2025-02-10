<script setup>
import Content from './components/Content.vue';
import Card from './components/Card.vue';
import Header from './components/Header.vue';
import Footer from './components/Footer.vue';
import NavBar from './components/NavBar.vue';
import { ref } from 'vue';
import router from './router';

//Habría que controlar cuando se inicia sesión y se cierra con un emit desde el hijo y tener un dato
// de sesión reactivo para pasarlo a la barra de navegación como props
const sesion = ref(JSON.parse(localStorage.getItem("sesion")))

function actualizaDatosSesion(usuario) {
  sesion.value = usuario;
  if (usuario) {
    localStorage.setItem("sesion", JSON.stringify(usuario));
    /* router.push("/") */
  }
  else
    localStorage.removeItem("sesion")
}
</script>

<template>
  <div class="layout">

    <Header :usuarioAutenticado="sesion" @sesionCerrada="actualizaDatosSesion" title="Aplicacion Juana" />
    <!--HACER E INCLUIR COMPONENTE DE BARRA DE NAVEGACIÓN CON OPCIONES VISIBLES SEGÚN EL ROL DEL USUARIO-->
    <NavBar :datos="sesion" />

    <RouterView :usuarioAutenticado="sesion" :usuario="usuarios" @sesionIniciada="actualizaDatosSesion"></RouterView>
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