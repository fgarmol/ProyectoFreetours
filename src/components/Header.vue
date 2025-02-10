<script setup>
import { ref } from 'vue';

const props = defineProps({
  title: String,
  usuarioAutenticado: Object
});
const emit = defineEmits(["sesionCerrada"]);

function cerrarSesion() {
  // Emitir el evento para notificar al componente padre que la sesión se ha cerrado
  emit('sesionCerrada', null);
}
</script>


<template>
  <header class="bg-dark text-white p-3">
    <div class="row">
      <h1 class="col-8">{{ title }}</h1>
      <div class="col-4">
        <div v-if="usuarioAutenticado.autenticado" class="container text-end">
          <span>Bienvenido, {{ usuarioAutenticado.usuario.nombre }} ({{ usuarioAutenticado.usuario.rol }})</span>
          <button @click.prevent="cerrarSesion" class="btn btn-danger">Cerrar Sesión</button>
        </div>
      </div>
    </div>
  </header>
</template>

<style scoped>
</style>
