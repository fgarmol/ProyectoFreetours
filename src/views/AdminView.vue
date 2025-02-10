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


async function crearUsuario() {
    const data = { nombre: newUser.value.nombre, email: newUser.value.email, contraseña: newUser.value.contraseña, rol: 'usuario' };
    fetch("http://localhost/APIFreetours/api.php/usuarios", {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(`Error ${response.status}: ${response.statusText}`);
            }
            return response.json();
        })
        .then(responseData => {
            showAlert('Usuario creado exitosamente', true);
            newUser.value.nombre = '';
            newUser.value.email = '';
            newUser.value.contraseña = '';
            cargarUsuarios();
        })
        .catch(error => showAlert(`Error al crear el usuario: ${error.message}`, false));
}


</script>

<template>
  <div class="container layout">
    <h1>Usuarios</h1>
    <button class="btn btn-primary" @click="mostrarModalCrearUsuario">Crear Usuario</button>
    <table class="table">
        <thead>
            <tr>
                <th>Nombre</th>
                <th>Email</th>
                <th>Contraseña</th>
                <th>Rol</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="usuario in users" :key="usuario.id">
                <td>{{ usuario.nombre }}</td>
                <td>{{ usuario.email }}</td>
                <td>{{ usuario.contraseña }}</td>
                <td>{{ usuario.rol }}</td>
                <td>
                    <button class="btn btn-primary">Editar</button>
                    <button class="btn btn-danger">Eliminar</button>
                </td>
            </tr>
        </tbody>
    </table>
  </div>
  <div class="modal" :class="{ 'd-block': showModalCrearUsuario }" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Crear Usuario</h5>
                <button type="button" class="btn-close" @click="cerrarModalCrearUsuario"></button>
            </div>
            <div class="modal-body">
                <form @submit.prevent="crearUsuario">
                    <div class="mb-3">
                        <label for="nombre" class="form-label">Nombre</label>
                        <input type="text" id="nombre" v-model="newUser.nombre" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" id="email" v-model="newUser.email" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="contraseña" class="form-label">Contraseña</label>
                        <input type="password" id="contraseña" v-model="newUser.contraseña" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="rol" class="form-label">Rol</label>
                        <select id="rol" v-model="newUser.rol" class="form-select" required>
                            <option value="usuario">Usuario</option>
                            <option value="admin">Admin</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Crear</button>
                </form>
                


                   
                        

  </div>

  

    
</template>

<style scoped>
footer{
 position:sticky;
}






</style>