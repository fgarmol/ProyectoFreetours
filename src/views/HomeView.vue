<script setup>
const props = defineProps({
  title: String,
  usuarioAutenticado: {
    type: Object,
    required: true
  }
});
</script>


<template>
    <h1 v-if="usuarioAutenticado.autenticado">Bienvenido, {{ usuarioAutenticado.usuario.nombre }} ({{ usuarioAutenticado.usuario.rol }})</h1>
    <h1 v-else>Hola soy el index sin autenticar</h1>

</template>