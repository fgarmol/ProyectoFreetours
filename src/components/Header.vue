<script setup>
import {ref} from "vue"

defineProps({
  title: String,
  usuarioAutenticado: Object
});
const emit = defineEmits(["sesionCerrada"])
/* const form = ref({ usuario: '', password: '' }); */

/* const usuarioAutenticado = localStorage.getItem("sesion")?ref(JSON.parse(localStorage.getItem("sesion"))):ref(null); */
const error = ref('');


function cerrarSesion() {

  //Para quitar los datos de la sesion y que cuando se recargue la pagina se borre.
  localStorage.removeItem("sesion");
//TODO: HABRÍA QUE NOTIFICAR A APP.VUE CON UN EMIT PARA QUE SEPA QUE LA SESIÓN ESTÁ CERRADA
emit('sesionCerrada')

}
</script>


<template>
    <header class="bg-dark text-white  p-3">
      <div class="row">
        <h1 class="col-8">{{ title }}</h1>
        <div class="col-4">
        <div v-if="usuarioAutenticado" class="container text-end">
          <span>Bienvenido, {{ usuarioAutenticado.usuario }} ({{ usuarioAutenticado.rol }})</span>
          <button @click.prevent="cerrarSesion" class="btn btn-danger">Cerrar Sesión</button>
        </div>
      </div>
      </div>
  </header>
</template>
  
 
<style scoped>

</style>
  