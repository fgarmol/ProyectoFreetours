<script setup>
import { ref } from 'vue';
import router from '@/router';

const emit = defineEmits(['sesionIniciada'])


const form = ref({ usuario: '', password: '' });



async function iniciarSesion() {
    const data = { nombre: form.value.usuario, contraseña: form.value.password };

    fetch("http://localhost/APIFreetours/api.php/usuarios?login", {
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
            emit('sesionIniciada', responseData);
            // Limpiar el formulario, mostrar mensaje de redirigir al login
            form.value.usuario = '';
            form.value.password = '';

            setTimeout(() => {
                router.push("/")
            }, 2000);

        })
        .catch(error => showAlert(`Error al iniciar sesión: ${error.message}`, false));
   
}
</script>



<template>
    <form @submit.prevent="iniciarSesion" class="d-flex  align-items-center gap-2">
        <label for="usuario">Usuario</label>
        <input v-model="form.usuario" type="text" id="usuario" class="form-control " placeholder="Usuario" required />
        <label for="password">Contraseña</label>
        <input v-model="form.password" type="password" class="form-control " placeholder="Contraseña" required />
        <button type="submit" class="btn btn-success">Iniciar Sesión</button>
    </form>
    <!-- boton para ir al registro si no tiene cuenta -->
    <router-link to="/register" class="btn btn-primary">Registrarse</router-link>
</template>
