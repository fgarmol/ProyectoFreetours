<script setup>
import { ref } from 'vue';
import router from '@/router';

const emit = defineEmits(['sesionIniciada']);

const form = ref({ usuario: '', password: '' });

function showAlert(message, isSuccess = false) {
    const alert = document.getElementById('alert');
    if (alert) {
        alert.textContent = message;
        alert.style.display = 'block';
        alert.className = isSuccess ? 'alert success' : 'alert';
    } else {
        console.error('Elemento con ID "alert" no encontrado');
    }
}

async function iniciarSesion() {
    const data = { email: form.value.usuario, contraseña: form.value.password };

    try {
        const response = await fetch("http://localhost/APIFreetours/api.php/usuarios?login", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
        });

        if (!response.ok) {
            throw new Error(`Error ${response.status}: ${response.statusText}`);
        }

        const responseData = await response.json();

        if (responseData.status === 'success') {
            emit('sesionIniciada', responseData.user);
            form.value.usuario = '';
            form.value.password = '';
            router.push("/");
        } else {
            showAlert(`Error al iniciar sesión: ${responseData.message}`, false);
        }
    } catch (error) {
        showAlert(`Error al iniciar sesión: ${error.message}`, false);
    }
}
</script>

<template>
    <form @submit.prevent="iniciarSesion" class="d-flex align-items-center gap-2 m-3">
        <label for="usuario">Mail</label>
        <input v-model="form.usuario" type="text" id="usuario" class="form-control" placeholder="Usuario" required />
        <label for="password">Contraseña</label>
        <input v-model="form.password" type="password" class="form-control" placeholder="Contraseña" required />
        <button type="submit" class="btn btn-success">Iniciar Sesión</button>
    </form>
    <div id="alert" style="display: none;"></div>
    <!-- boton para ir al registro si no tiene cuenta -->
     <label for="registrarse">No tienes cuenta?</label>
    <router-link to="/register" class="btn btn-primary m-5 mt-0" id="registrarse">Registrarse</router-link>
</template>
