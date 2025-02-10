<script setup>
import { onMounted, ref } from 'vue';

const users = ref([]);
const showModalCrearUsuario = ref(false);
const mostrarModalCrearUsuario = () => {
    showModalCrearUsuario.value = true;
};
const cerrarModalCrearUsuario = () => {
    clearForm();
    showModalCrearUsuario.value = false;
};
const loading = ref(true);
const newUser = ref({
    nombre: '',
    email: '',
    contraseña: '',
    cuentaHabilitada: 'true'
});
const editingUser = ref(null);
//funcion para obtener todos los usuarios de la api  y mostrarlos en la tabla
function cargarUsuarios() {
    

    fetch("http://localhost/APIFreetours/api.php/usuarios")
        .then(response => {
          if (!response.ok) {
            throw new Error(`Error ${response.status}: ${response.statusText}`);
          }
          return response.json();
        })
        .then(data => {
            users.value = data;
            console.log(data);
            /* data.forEach(usuario => {
                console.log(usuario);
            

          }); */
        })
        .catch(error => showAlert(`Error al obtener usuarios: ${error.message}`));
   
}
onMounted(() => {
    cargarUsuarios();
});

/* async function crearUsuario */


</script>

<template>
  <div class="container layout">
    <h1>Usuarios</h1>
    <table class="table">
        <thead>
            <tr>
                <th>Nombre</th>
                <th>Email</th>
                <th>Contraseña</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="usuario in users" :key="usuario.id">
                <td>{{ usuario.nombre }}</td>
                <td>{{ usuario.email }}</td>
                <td>{{ usuario.contraseña }}</td>
                <td>
                    <button class="btn btn-primary">Editar</button>
                    <button class="btn btn-danger">Eliminar</button>
                </td>
            </tr>
        </tbody>
    </table>
  </div>

    
</template>

<style scoped>
footer{
 position:sticky;
}






</style>