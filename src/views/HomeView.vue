<script setup>
defineProps({
  title: String,
  usuarioAutenticado: Object
});

</script>


<template>
    <h1 v-if="usuarioAutenticado">Bienvenido, {{ usuarioAutenticado.usuario }} ({{ usuarioAutenticado.rol }})</h1>
    <h1 v-else>Hola soy el index sin autenticar</h1>

</template>